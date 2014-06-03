//
//  MKMarketChannel.m
//  Bitmessage
//
//  Created by Steve Dekorte on 3/13/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "MKMarketChannel.h"
#import <BitMessageKit/BitMessageKit.h>
#import "MKMsg.h"
#import "MKSell.h"
#import "MKMarkets.h"
#import "MKRootNode.h"
#import "MKClosePostMsg.h"

@implementation MKMarketChannel

- (NSString *)nodeTitle
{
    return @"Channel";
}

- (id)init
{
    self = [super init];
    self.passphrase = @"bitmarkets demo 23";
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(channelChanged:)
                                                 name:nil
                                                 //name:@"NavNodeAddedChild"
                                               object:self.channel];
      
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedMessagesChanged:)
                                                 //name:@"NavNodeAddedChild"
                                                 name:nil
                                               object:BMClient.sharedBMClient.messages.received];
    
    self.needsFetch = YES;
    return self;
}

- (void)channelChanged:(NSNotification *)note
{
    //[self fetchChannelMessages];
    self.needsFetch = YES;
}

- (void)receivedMessagesChanged:(NSNotification *)note
{
    self.needsFetch = YES;
//    [self fetchDirectMessages];
}


- (CGFloat)nodeSuggestedWidth
{
    return 250;
}

- (BMChannel *)channel
{
    if (!_channel)
    {
        BMChannels *channels = BMClient.sharedBMClient.channels;

        if (![channels channelWithPassphrase:self.passphrase])
        {
            [channels leaveAllChannels];
        }
        
        _channel = [channels channelWithPassphraseJoinIfNeeded:self.passphrase];
    }
    
    return _channel;
}

- (void)fetch
{
    // just make sure this is in the fetch chain from BMClient?
    //[[[BMClient sharedBMClient] channels] fetch];
    //[BMClient.sharedBMClient refresh];
    
    if (self.needsFetch)
    {
        [self fetchChannelMessages];
        [self fetchDirectMessages];
        self.needsFetch = NO;
    }
    
    [self performSelector:@selector(fetch) withObject:self afterDelay:5.0];
}

- (void)fetchChannelMessages
{
    NSArray *messages = self.channel.children.copy;
    
    NSMutableArray *closeMsgs = [NSMutableArray array];
    
    for (BMReceivedMessage *bmMsg in messages)
    {
        MKMsg *msg = [MKMsg withBMMessage:bmMsg];
        
        //[bmMsg delete]; continue;
        
        if (msg)
        {
            if ([msg isKindOfClass:MKPostMsg.class])
            {
                MKPostMsg *postMsg = (MKPostMsg *)msg;
                MKPost *mkPost = [postMsg mkPost];
                [mkPost addChild:postMsg];
                
                BOOL couldPlace = [mkPost placeInMarketsPath]; // deals with merging?
                
                if (!couldPlace)
                {
                    [bmMsg delete];
                }
            }
            else if ([msg isKindOfClass:MKClosePostMsg.class])
            {
                [closeMsgs addObject:msg];
            }
            else
            {
                [bmMsg delete];
            }
        }
        else
        {
            // it wasn't a valid bitmarkets message, so delete it
            [bmMsg delete];
        }
    }
    
    // process this after others in case it's before msg
    // should probably keep around a 2.5 day database of these deletes to be safe
    
    for (MKClosePostMsg *closeMsg in closeMsgs)
    {
        MKRegion *rootRegion = MKRootNode.sharedMKRootNode.markets.rootRegion;
        
        [rootRegion handleMsg:closeMsg];
        
        NSTimeInterval ttlSeconds = 60*60*24*2.5;
        if (closeMsg.bmMessage.ageInSeconds > ttlSeconds)
        {
            [closeMsg.bmMessage delete];
        }
    }
}

- (void)fetchDirectMessages
{
    NSArray *inboxMessages = BMClient.sharedBMClient.messages.received.children.copy;
    [self handleBMMessages:inboxMessages];
}

- (void)handleBMMessages:(NSArray *)bmMessages
{
    NSArray *inboxMessages = BMClient.sharedBMClient.messages.received.children.copy;
    MKMarkets *markets = MKRootNode.sharedMKRootNode.markets;
    
    for (BMMessage *bmMessage in inboxMessages)
    {
        MKMsg *msg = [MKMsg withBMMessage:bmMessage];
        
        if (!msg)
        {
            NSLog(@"invalid message");
            continue;
        }
        
        BOOL didHandle = [markets handleMsg:msg];
        
        if (!didHandle)
        {
            [markets handleMsg:msg];
            
            if (![bmMessage.toAddress isEqualToString:self.channel.address])
            {
                [bmMessage delete];
            }
            else
            {
                NSLog(@"channel address %@", _channel.address);
                
                NSLog(@"can't place msg '%@' for thread '%@' to %@ from %@",
                      msg.className, msg.postUuid, bmMessage.toAddress, bmMessage.fromAddress);
            }
        }
        else
        {
            [bmMessage delete];
            //NSLog(@"placed msg '%@' for thread '%@'", msg.className, msg.postUuid);
        }
    }
}

@end
