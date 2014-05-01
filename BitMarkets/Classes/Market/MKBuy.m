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
    return self.sell.nodeTitle;
}

- (NSString *)nodeSubtitle
{
    return self.status;
}

- (void)setDict:(NSMutableDictionary *)aDict
{
    /*
    NSMutableArray *children = [NSMutableArray array];
    
    for (NSString *k in aDict.allKeys)
    {
        NSMutableDictionary *messageDict = [aDict objectForKey:k];
        MKMessage *msg = [MKMessage withDict:messageDict];
        [children addObject:msg];
    }
    
    [self setChildren:children];
    */
}

- (NSMutableDictionary *)dict
{
    
    return nil;
}

- (MKBuy *)justAdd
{
    MKBuy *buy = [[MKBuy alloc] init];
    [self addChild:buy];
    return buy;
}

- (NSString *)myAddress
{
    return MKRootNode.sharedMKRootNode.bmClient.identities.firstIdentity.address;
}

- (NSDictionary *)messageDict
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:@"Buy" forKey:@"_type"];
    [dict setObject:self.sell.uuid forKey:@"sellUuid"];
    return dict;
}

- (void)post
{
    [self setStatus:@"post"];
    [self postParentChanged];

    NSString *myAddress = self.myAddress;
    NSString *sellerAddress = self.sell.sellerAddress;
    NSString *subject = [NSString stringWithFormat:@"%@ bid", [self.sell.uuid substringToIndex:5]];
    NSString *message = self.messageDict.asJsonString;
    
    BMMessage *m = [[BMMessage alloc] init];
    [m setFromAddress:myAddress];
    [m setToAddress:sellerAddress];
    [m setSubject:subject];
    [m setMessage:message];
    [m send];
    
    self.status = @"bid sent";
    [self postParentChanged];
}

@end
