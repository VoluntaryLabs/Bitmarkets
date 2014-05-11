//
//  MKAcceptBidMsg.m
//  BitMarkets
//
//  Created by Steve Dekorte on 5/2/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKAcceptBidMsg.h"

@implementation MKAcceptBidMsg

- (NSString *)nodeTitle
{
    return @"Bid Accepted";
}

- (BOOL)send
{
    return [self sendToBuyer];
}

@end
