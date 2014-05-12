//
//  MKDeliveryAddress.m
//  BitMarkets
//
//  Created by Steve Dekorte on 5/7/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKDeliveryAddress.h"
#import "MKBuyerAddressMsg.h"
#import "MKBuyDelivery.h"
#import "MKBuy.h"

@implementation MKDeliveryAddress

- (id)init
{
    self = [super init];
    self.addressDict = [NSMutableDictionary dictionary];
    [self.dictPropertyNames addObject:@"addressDict"];
    return self;
}

- (BOOL)isFilled
{
    for (NSString *key in self.addressDict)
    {
        NSString *value = [self.addressDict objectForKey:key];
        if (!value || [value isEqualToString:@""])
        {
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)canSend
{
    return NO;
}

@end
