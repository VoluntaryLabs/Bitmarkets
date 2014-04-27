//
//  MKMarketChannel.m
//  Bitmessage
//
//  Created by Steve Dekorte on 3/13/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "MKMarketChannel.h"
#import <BitMessageKit/BitMessageKit.h>
#import "MKMessage.h"
#import "MKSell.h"

@implementation MKMarketChannel

- (NSString *)nodeTitle
{
    return @"Channel";
}

- (id)init
{
    self = [super init];
    self.passphrase = @"bitmarkets";
    self.allAsks = [[NavInfoNode alloc] init];
    self.allAsks.nodeSuggestedWidth = 250;
    [self.allAsks setNodeTitle:@"Sells"];
    [self addChild:self.allAsks];
    
    self.validMessages = [[NavInfoNode alloc] init];
    [self.validMessages setNodeTitle:@"Messages"];
    self.validMessages.nodeSuggestedWidth = 250;
    [self addChild:self.validMessages];
    
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
    //
    // 1. run through messages
    //
    // 2. turn valid ones to children as MKMessage objects
    //    (need to add persisted user initiated sells?)
    //
    // 3. add asks to appropriate categories (hand to markets?)
    //
    // 4. add non-asks under their asks
    //

    NSArray *messages = self.channel.children;
    
    for (BMReceivedMessage *bmMessage in messages)
    {
        MKMessage *mkMessage = [MKMessage withBMMessage:bmMessage];
        
        if (mkMessage)
        {
            [self.validMessages addChild:bmMessage];
        }
        
        MKSell *instance = [mkMessage instance];
        if ([instance isKindOfClass:MKSell.class])
        {
            [self.allAsks addChild:instance];
        }
    }
    
    for (MKSell *sell in self.allAsks.children)
    {
        [sell findStatus];
        [sell placeInMarketsPath];
    }
}


@end
