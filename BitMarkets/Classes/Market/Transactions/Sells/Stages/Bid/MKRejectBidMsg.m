//
//  MKRejectBidMsg.m
//  BitMarkets
//
//  Created by Steve Dekorte on 5/6/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKRejectBidMsg.h"

@implementation MKRejectBidMsg

- (NSString *)nodeTitle
{
    //if (self.isInBuy)
    return @"Bid Rejected";
}

- (BOOL)send
{
    return [self sendToBuyer];
}

@end
