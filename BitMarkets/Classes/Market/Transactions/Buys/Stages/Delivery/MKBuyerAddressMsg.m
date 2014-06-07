//
//  MKBuyerAddressMsg.m
//  BitMarkets
//
//  Created by Steve Dekorte on 5/10/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKBuyerAddressMsg.h"

@implementation MKBuyerAddressMsg

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

- (NSDictionary *)addressDict
{
    return self.payload;
}

- (void)setAddressDict:(NSDictionary *)aDict
{
    [self setPayload:aDict];
}

- (id)descriptionJSONObject
{
    return [super descriptionJSONObject];
}

@end
