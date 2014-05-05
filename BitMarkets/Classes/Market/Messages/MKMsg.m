//
//  MKMsg.m
//  BitMarkets
//
//  Created by Steve Dekorte on 5/2/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKMsg.h"
#import "MKRootNode.h"

@implementation MKMsg

+ (MKMsg *)withBMMessage:(BMMessage *)bmMessage
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithJsonString:bmMessage.messageString];
    
    NSString *typeName = [dict objectForKey:@"_type"];
    if (!typeName)
    {
        return nil;
    }
    
    NSString *className = [@"MK" stringByAppendingString:typeName];
    Class class = NSClassFromString(className);
    if (!class)
    {
        return nil;
    }
    
    MKMsg *msg = [[class alloc] init];
    msg.dict = dict;
    msg.bmMessage = bmMessage;
    msg.msgid = bmMessage.msgid;
    
    if (!msg.isValid)
    {
        return nil;
    }
    
    return msg;
}

- (NSString *)classNameSansPrefix
{
    return [self.className sansPrefix:@"MK"];
}


- (id)init
{
    self = [super init];
    self.dict = [NSMutableDictionary dictionary];
    return self;
}


- (BOOL)isValid
{
    return YES;
}


- (NSUInteger)hash
{
    return self.hash;
}

- (BOOL)isEqual:(id)object
{
    return self == object;
}

/*
- (void)setDict:(NSMutableDictionary *)aDict
{
    //if ([[aDict objectForKey:@"_type"] isEqualToString:@"Buy"])
    self.sellUuid      = [aDict objectForKey:@"sellUuid"];
    self.sellerAddress = [aDict objectForKey:@"sellerAddress"];
    self.buyerAddress  = [aDict objectForKey:@"buyerAddress"];
    [super setDict:aDict];
}

- (NSMutableDictionary *)dict
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"Buy" forKey:@"_type"];
    [dict setObject:self.sellUuid      forKey:@"sellUuid"];
    [dict setObject:self.buyerAddress  forKey:@"buyerAddress"];
    [dict setObject:self.sellerAddress forKey:@"sellerAddress"];
    return dict;
}
*/

@end
