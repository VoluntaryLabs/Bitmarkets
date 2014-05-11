//
//  MKBuyerAddressMsg.m
//  BitMarkets
//
//  Created by Steve Dekorte on 5/10/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKBuyerAddressMsg.h"

@implementation MKBuyerAddressMsg

- (BOOL)isInBuy
{
    return [[self.nodeParent className] containsString:@"Buy"];
}

- (NSString *)nodeTitle
{
    if (self.isInBuy)
    {
        return @"Sent Address";
    }
    
    return @"Received Address";
}

- (BOOL)send
{
    return [super sendToSeller];
}

@end
