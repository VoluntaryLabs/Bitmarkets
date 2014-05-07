//
//  MKBuyBid.m
//  BitMarkets
//
//  Created by Steve Dekorte on 5/6/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKBuyBid.h"
#import "MKMsg.h"
#import "MKBidMsg.h"
#import "MKAcceptBidMsg.h"
#import "MKRejectBidMsg.h"

@implementation MKBuyBid

- (id)init
{
    self = [super init];
    return self;
}

// --- titles -------------

- (CGFloat)nodeSuggestedWidth
{
    return 350;
}

- (NSString *)nodeTitle
{
    return @"Bid";
}

- (NSString *)nodeSubtitle
{
    return self.status;
}

- (NSString *)nodeNote
{
    if (self.children.count > 0)
    {
        return @"✓";
    }
    
    return nil;
}

- (BOOL)wasSent
{
    return [self.children firstObjectOfClass:MKBidMsg.class] != nil;
}

- (BOOL)wasAccepted
{
    return [self.children firstObjectOfClass:MKAcceptBidMsg.class] != nil;
}

- (BOOL)wasRejected
{
    return [self.children firstObjectOfClass:MKAcceptBidMsg.class] != nil;
}

// --- status -------------

- (NSString *)status
{
    if (self.children.count == 0)
    {
        return @"no bid sent";
    }
    
    if (self.children.count == 1)
    {
        return @"sent - awaiting reply";
    }
    
    if (self.wasAccepted)
    {
        return @"bid accepted";
    }
    
    if (self.wasRejected)
    {
        return @"bid rejected";
    }
    
    // add timeout check
    
    return nil;
}

// --- messages -------------

- (BOOL)handleMsg:(MKMsg *)msg
{
    if ([msg isKindOfClass:MKBidMsg.class])
    {
        [self addChild:msg];
        return YES;
    }
    
    if ([msg isKindOfClass:MKAcceptBidMsg.class])
    {
        [self addChild:msg];
        return YES;
    }
    
    if ([msg isKindOfClass:MKRejectBidMsg.class])
    {
        [self addChild:msg];
        return YES;
    }
    
    return NO;
}

@end
