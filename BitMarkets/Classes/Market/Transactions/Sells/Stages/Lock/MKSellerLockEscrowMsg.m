//
//  MKSellerLockEscrowMsg.m
//  BitMarkets
//
//  Created by Steve Dekorte on 5/7/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKSellerLockEscrowMsg.h"

@implementation MKSellerLockEscrowMsg

- (NSString *)nodeTitle
{
    if (self.isInBuy)
    {
        return @"Seller Lock Received";
    }
    
    return @"Seller Lock Sent";
}

@end
