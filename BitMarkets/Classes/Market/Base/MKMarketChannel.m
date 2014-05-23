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
    self.passphrase = @"bitmarkets demo 3";    
    return self;
}

- (CGFloat)nodeSuggestedWidth
{
    return 250;
}

- (BMChannel *)channel
{
    if (!_channel)
    {
        _channel = [BMClient.sharedBMClient.channels channelWithPassphraseJoinIfNeeded:self.passphrase];
    }
    
    return _channel;
}

- (void)fetch
{
    // just make sure this is in the fetch chain from BMClient?
    //[[[BMClient sharedBMClient] channels] fetch];

    NSArray *messages = self.channel.children.copy;
    NSMutableArray *newChildren = [NSMutableArray array];
    
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
                
                if (couldPlace)
                {
                    //NSLog(@"placing post '%@'", mkPost.title);
                    [newChildren addObject:mkPost];
                }
                else
                {
                    [bmMsg delete];
                }
            }
            else if ([msg isKindOfClass:MKClosePostMsg.class])
            {
                [closeMsgs addObject:msg];
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
    
    [self fetchDirectMessages];
    
    [self performSelector:@selector(fetch) withObject:self afterDelay:5.0];
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
            NSLog(@"can't place msg '%@' for thread '%@'", msg.className, msg.postUuid);
            [bmMessage delete];
        }
        else
        {
            [bmMessage delete];
            //NSLog(@"placed msg '%@' for thread '%@'", msg.className, msg.postUuid);
        }
    }
}

@end
