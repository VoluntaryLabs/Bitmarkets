//
//  MKBuyerLockEscrowMsg.m
//  BitMarkets
//
//  Created by Steve Dekorte on 5/6/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKBuyerLockEscrowMsg.h"

@implementation MKBuyerLockEscrowMsg

- (NSString *)nodeTitle
{
    if (self.isInBuy)
    {
        return @"Buyer Lock Sent";
    }
    
    return @"Buyer Lock Received";
}

@end
