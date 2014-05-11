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
#import "MKBuy.h"
#import "MKBuyLockEscrow.h"

@implementation MKBuyBid

- (id)init
{
    self = [super init];
    //[self.dictPropertyNames addObject:@"msg"];
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
    if (self.wasAccepted)
    {
        return @"✓";
    }
    
    if (self.wasRejected)
    {
        return @"✗";
    }
    
    return nil;
}

- (void)sortChildren
{
    [super sortChildrenWithKey:@"date"];
}

// messages

- (MKBidMsg *)bidMsg
{
    return [self.children firstObjectOfClass:MKBidMsg.class];
}

- (MKAcceptBidMsg *)acceptMsg
{
    return [self.children firstObjectOfClass:MKAcceptBidMsg.class];
}

- (MKRejectBidMsg *)rejectMsg
{
    return [self.children firstObjectOfClass:MKRejectBidMsg.class];
}

- (BOOL)wasSent
{
    return self.bidMsg != nil;
}

- (BOOL)wasAccepted
{
    return self.acceptMsg != nil;
}

- (BOOL)wasRejected
{
    return self.rejectMsg != nil;
}

// --- status -------------

- (MKBuy *)buy
{
    return (MKBuy *)self.nodeParent;
}

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
    /*
    if ([msg isKindOfClass:MKBidMsg.class])
    {
        [self addChild:msg];
        return YES;
    }
    */
    
    if ([msg isKindOfClass:MKAcceptBidMsg.class])
    {
        if ([self addChild:msg])
        {
            [self.buy update];
        }
        
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
