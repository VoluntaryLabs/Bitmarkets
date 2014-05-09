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
    
    [msg setDate:bmMessage.date];
    
    return msg;
}

- (BOOL)bmSenderIsBuyer // only works when first received
{
    return [self.bmMessage.fromAddress isEqualToString:self.buyerAddress];
}

- (BOOL)bmSenderIsSeller // only works when first received
{
    return [self.bmMessage.fromAddress isEqualToString:self.sellerAddress];
}

- (NSString *)classNameSansPrefix
{
    return [self.className sansPrefix:@"MK"];
}

- (id)init
{
    self = [super init];
    self.dict = [NSMutableDictionary dictionary];
    [self.dict setObject:self.classNameSansPrefix forKey:@"_type"];
    return self;
}

// equality

- (NSString *)uniqueName
{
    return [NSString stringWithFormat:@"%@ %@",
            NSStringFromClass(self.class), self.postUuid];
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

- (void)addDate
{
    [self setDate:[NSDate date]];
}

- (void)setDate:(NSDate *)aDate
{
    NSNumber *d = [NSNumber numberWithDouble:[aDate timeIntervalSince1970]];
    NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)d.doubleValue];
    assert([aDate.description isEqualToString:newDate.description]);
    
    [self.dict setObject:d forKey:@"date"];
}


- (NSDate *)date
{
    NSNumber *d = [self.dict objectForKey:@"date"];
    
    if (d)
    {
        return [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)d.doubleValue];
    }
    
    return nil;
}

- (NSString *)dateString
{
    NSDate *date = self.date;
    
    if (date)
    {
        return [self.date itemDateTimeString];
    }
    
    return @"[Date missing]";
}


- (NSString *)nodeTitle
{
    return self.uniqueName;
}

- (NSString *)nodeSubtitle
{
    return self.dateString;
}

- (BOOL)hasValidPostUuid
{
    return (self.postUuid && self.postUuid.length > 10);
}

- (BOOL)hasValidSellerAddress
{
    return [BMAddress isValidAddress:self.sellerAddress];
}

- (BOOL)isValid
{
    // subclasses should override and add validation
    // that checks appropriate bmSenderIsSeller/bmSenderIsBuyer method
    
    BOOL validUuid   = self.hasValidPostUuid;
    BOOL validSeller = self.hasValidSellerAddress;
    BOOL validBuyer  = self.hasValidSellerAddress;
    
    return validUuid && validSeller && validBuyer;
}

- (NSString *)myAddress
{
    return MKRootNode.sharedMKRootNode.bmClient.identities.firstIdentity.address;
}

- (NSString *)subject
{
    return [NSString stringWithFormat:@"%@ on %@",
            self.classNameSansPrefix,
            self.postUuid];
}

// postUuid

- (void)setPostUuid:(NSString *)postUuid
{
    [self.dict setObject:postUuid forKey:@"postUuid"];
}

- (NSString *)postUuid
{
    return [self.dict objectForKey:@"postUuid"];
}

// seller

- (void)setSellerAddress:(NSString *)sellerAddress
{
    [self.dict setObject:sellerAddress forKey:@"sellerAddress"];
}

- (NSString *)sellerAddress
{
    return [self.dict objectForKey:@"sellerAddress"];
}

// buyer

- (void)setBuyerAddress:(NSString *)buyerAddress
{
    [self.dict setObject:buyerAddress forKey:@"buyerAddress"];
}

- (NSString *)buyerAddress
{
    return [self.dict objectForKey:@"buyerAddress"];
}

// copy

- (void)copyFrom:(MKMsg *)msg
{
    self.sellerAddress = msg.sellerAddress;
    self.buyerAddress  = msg.buyerAddress;
    self.postUuid      = msg.postUuid;
}

// ------------------------

- (BOOL)send
{
    [NSException raise:@"subclasses should override send" format:nil];
    return NO;
}

- (BOOL)sendToBuyer
{
    BMMessage *m = [[BMMessage alloc] init];
    [m setFromAddress:self.sellerAddress];
    [m setToAddress:self.buyerAddress];
    [m setSubject:self.subject];
    [m setMessage:self.dict.asJsonString];
    [m send];

    NSLog(@"[m date] = %@", [m date].description);
    [self addDate];

    //[MKRootNode.sharedMKRootNode.markets handleMsg:self];
    return YES;
}

- (BOOL)sendToSeller
{
    BMMessage *m = [[BMMessage alloc] init];
    [m setFromAddress:self.sellerAddress];
    [m setToAddress:self.buyerAddress];
    [m setSubject:self.subject];
    [m setMessage:self.dict.asJsonString];
    [m send];
    
    NSLog(@"[m date] = %@", [m date].description);
    [self addDate];

    //[MKRootNode.sharedMKRootNode.markets handleMsg:self];
    return YES;
}


@end
