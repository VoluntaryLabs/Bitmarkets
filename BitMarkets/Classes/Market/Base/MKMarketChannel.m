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

@implementation MKMarketChannel

- (NSString *)nodeTitle
{
    return @"Channel";
}

- (id)init
{
    self = [super init];
    self.passphrase = @"bitmarkets";
    
    /*
    self.validMessages = [[NavInfoNode alloc] init];
    [self.validMessages setNodeTitle:@"Messages"];
    self.validMessages.nodeSuggestedWidth = 250;
    [self addChild:self.validMessages];
    */
    
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
    
    for (BMReceivedMessage *bmMsg in messages)
    {
        MKPostMsg *msg = (MKPostMsg *)[MKMsg withBMMessage:bmMsg];
        
        //[bmMsg delete]; continue;
        
        if (msg && [msg isKindOfClass:MKPostMsg.class])
        {
            MKPost *mkPost = [msg mkPost];
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
        else
        {
            //[bmMsg delete];
            continue;
        }
    }
    
    [self fetchDirectMessages];
    
    [self performSelector:@selector(fetch) withObject:self afterDelay:5.0];
}

- (void)fetchDirectMessages
{
    NSArray *inboxMessages = BMClient.sharedBMClient.messages.received.children.copy;
    [self handleBMMessages:inboxMessages];
    
    NSArray *sentMessages = BMClient.sharedBMClient.messages.sent.children.copy;
    [self handleBMMessages:sentMessages];
}

- (void)handleBMMessages:(NSArray *)bmMessages
{
    NSArray *inboxMessages = BMClient.sharedBMClient.messages.received.children.copy;
    MKMarkets *markets = MKRootNode.sharedMKRootNode.markets;
    
    for (BMMessage *bmMessage in inboxMessages)
    {
        MKMsg *msg = [MKMsg withBMMessage:bmMessage];
        BOOL didHandle = [markets handleMsg:msg];
        
        if (!didHandle)
        {
            NSLog(@"can't place msg '%@' for thread '%@'", msg.className, msg.postUuid);
            [bmMessage delete];
        }
        else
        {
            //NSLog(@"placed msg '%@' for thread '%@'", msg.className, msg.postUuid);
        }
    }
}

@end
