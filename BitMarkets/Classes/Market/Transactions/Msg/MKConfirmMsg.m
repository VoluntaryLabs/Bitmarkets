//
//  MKConfirmMsg.m
//  BitMarkets
//
//  Created by Steve Dekorte on 5/30/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKConfirmMsg.h"

@implementation MKConfirmMsg

- (id)init
{
    self = [super init];
    [self.dictPropertyNames addObject:@"tx"];
    return self;
}

- (void)setTx:(NSDictionary *)txDict
{
    [self.dict setObject:txDict forKey:@"tx"];
}

- (NSDictionary *)tx
{
    return [self.dict objectForKey:@"tx"];
}

- (NSString *)nodeTitle
{
    return [NSString stringWithFormat:@"Transaction %@", [self.tx objectForKey:@"txid"]];
}

- (NSString *)nodeSubtitle
{
    return [NSString stringWithFormat:@"Confirmed %@", self.dateString];
}

@end
