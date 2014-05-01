//
//  MKBuy.m
//  Bitmessage
//
//  Created by Steve Dekorte on 3/17/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "MKBuy.h"
#import "MKMessage.h"
#import "MKRootNode.h"

@implementation MKBuy

- (NSString *)nodeTitle
{
    return [self.sellUuid substringToIndex:8];
}

- (NSString *)nodeSubtitle
{
    return self.status;
}

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

- (MKBuy *)justAdd
{
    MKBuy *buy = [[MKBuy alloc] init];
    [self addChild:buy];
    return buy;
}

/*
- (NSString *)myAddress
{
    return MKRootNode.sharedMKRootNode.bmClient.identities.firstIdentity.address;
}
*/

- (NSDictionary *)composeMessageDict
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"Buy" forKey:@"_type"];
    [dict setObject:self.sellUuid forKey:@"sellUuid"];
    [dict setObject:self.buyerAddress forKey:@"buyerAddress"];
    [dict setObject:self.sellerAddress forKey:@"sellerAddress"];
    return dict;
}

- (void)post
{
    [self setStatus:@"post"];
    [self postParentChanged];

    //NSString *myAddress = self.myAddress;
    NSString *subject = [NSString stringWithFormat:@"%@ bid", [self.sell.uuid substringToIndex:5]];
    NSString *message = self.composeMessageDict.asJsonString;
    
    BMMessage *m = [[BMMessage alloc] init];
    [m setFromAddress:self.buyerAddress];
    [m setToAddress:self.sellerAddress];
    [m setSubject:subject];
    [m setMessage:message];
    [m send];
    
    self.status = @"bid sent";
    [self postParentChanged];
}

@end
