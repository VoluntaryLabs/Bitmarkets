//
//  MKSellBid.m
//  BitMarkets
//
//  Created by Steve Dekorte on 5/6/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKSellBid.h"
#import "MKSell.h"
#import "MKAcceptBidMsg.h"
#import "MKRejectBidMsg.h"

@implementation MKSellBid

- (id)init
{
    self = [super init];
    
    [self.dictPropertyNames addObject:@"status"];
    
    return self;
}

// --- equality ---

- (MKBidMsg *)bidMsg
{
    return self.children.firstObject;
}
   
- (NSUInteger)hash
{
    return self.bidMsg.hash;
}

- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:MKSellBid.class])
    {
        MKSellBid *otherSellBid = object;
        BOOL isEqual = [self.bidMsg isEqual:otherSellBid.bidMsg];
        return isEqual;
    }
    
    return YES;
}

// --- UI ------------------------------

- (NSArray *)modelActions
{
    //if (!self.wasAccepted && !self.wasRejected)
    {
        return @[@"accept"];
    }
    
    return @[];
}

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

// --- status --------------------

- (BOOL)wasAccepted
{
    return [self.status isEqualToString:@"accepted"];
}

- (BOOL)wasRejected
{
    return [self.status isEqualToString:@"rejected"];
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

- (MKSellBids *)sellBids
{
    return (MKSellBids *)self.nodeParent;
}

- (void)accept
{
    MKAcceptBidMsg *msg = [[MKAcceptBidMsg alloc] init];
    [msg copyFrom:self.bidMsg];
    [msg send];
    [self addChild:msg];
    
    [self.sellBids setAcceptedBid:self];
    [self postSelfChanged];
}

- (void)reject
{
    MKRejectBidMsg *msg = [[MKRejectBidMsg alloc] init];
    [msg copyFrom:self.bidMsg];
    [msg send];
    
    [self setStatus:@"rejected"];
}

- (BOOL)nodeShouldIndent
{
    return NO;
}

@end
