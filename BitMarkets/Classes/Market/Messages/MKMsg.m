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

// equality

- (NSString *)uniqueName
{
    return [NSString stringWithFormat:@"%@ %@",
            self.postUuid,
            NSStringFromClass(self.class)];
}

- (NSUInteger)hash
{
    return self.uniqueName.hash;
}

- (BOOL)isEqual:(id)object
{
    if ([object respondsToSelector:@selector(uniqueName)])
    {
        BOOL isEqual = [self.uniqueName isEqualToString:((MKMsg *)object).uniqueName];
        return isEqual;
    }
    
    return YES;
}

// node

- (NSString *)nodeTitle
{
    return self.uniqueName;
}

- (NSString *)nodeSubtitle
{
    //return self.date.description;
    return nil;
}

- (BOOL)isValid
{
    return YES;
}

- (NSString *)myAddress
{
    return MKRootNode.sharedMKRootNode.bmClient.identities.firstIdentity.address;
}

/*
- (void)setDict:(NSMutableDictionary *)aDict
{
    //if ([[aDict objectForKey:@"_type"] isEqualToString:@"Buy"])
    self.postUuid      = [aDict objectForKey:@"postUuid"];
    self.sellerAddress = [aDict objectForKey:@"sellerAddress"];
    self.buyerAddress  = [aDict objectForKey:@"buyerAddress"];
    [super setDict:aDict];
}

- (NSMutableDictionary *)dict
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"Buy" forKey:@"_type"];
    [dict setObject:self.postUuid      forKey:@"postUuid"];
    [dict setObject:self.buyerAddress  forKey:@"buyerAddress"];
    [dict setObject:self.sellerAddress forKey:@"sellerAddress"];
    return dict;
}
*/

- (NSString *)subject
{
    return [NSString stringWithFormat:@"%@ on %@",
            self.classNameSansPrefix,
            self.postUuid];
}

- (NSString *)postUuid
{
    return [self.dict objectForKey:@"postUuid"];
}

- (NSString *)sellerAddress
{
    return [self.dict objectForKey:@"sellerAddress"];
}

- (NSString *)buyerAddress
{
    return [self.dict objectForKey:@"buyerAddress"];
}

- (BOOL)send
{
    [NSException raise:@"Error" format:@"MKMsg subclasses should override send method"];
    return NO;
}

@end
