//
//  MKBuyReleaseEscrow.m
//  BitMarkets
//
//  Created by Steve Dekorte on 5/6/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKBuyReleaseEscrow.h"

@implementation MKBuyReleaseEscrow

- (id)init
{
    self = [super init];
    return self;
}

- (NSString *)nodeTitle
{
    return @"Release Escrow";
}

- (NSArray *)modelActions
{
    return @[@"requestRefund", @"makePayment"];
}

- (void)update
{
        
}

- (void)requestRefund
{
    
}

- (void)makePayment
{
    
}

@end
