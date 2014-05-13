//
//  MKEscrowMsg.m
//  BitMarkets
//
//  Created by Steve Dekorte on 5/7/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKEscrowMsg.h"
#import "MKBuyLockEscrow.h"

@implementation MKEscrowMsg

- (id)init
{
    self = [super init];
    [self.dictPropertyNames addObject:@"payload"];
    return self;
}

- (void)setPayload:(NSDictionary *)payload
{
    [self.dict setObject:payload forKey:@"payload"];
}

- (NSDictionary *)payload
{
    return [self.dict objectForKey:@"payload"];
}

@end
