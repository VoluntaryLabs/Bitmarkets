//
//  MKPostMsg.m
//  BitMarkets
//
//  Created by Steve Dekorte on 5/2/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import <BitmessageKit/BitmessageKit.h>
#import <FoundationCategoriesKit/FoundationCategoriesKit.h>
#import "MKPostMsg.h"
#import "MKRootNode.h"

@implementation MKPostMsg

- (id)init
{
    self = [super init];
    [self.dictPropertyNames addObjectsFromArray:@[
                                                  @"uuid",
                                                  @"title",
                                                  @"price",
                                                  @"description",
                                                  @"regionPath",
                                                  @"categoryPath"]
     ];
    return self;
}


- (NSString *)sellUuid
{
    return [self.dict objectForKey:@"sellUuid"];
}

- (NSUInteger)hash
{
    return self.sellUuid.hash;
}

- (BOOL)isEqual:(MKPostMsg *)object
{
    if (![object isKindOfClass:MKPostMsg.class])
    {
        return NO;
    }
    
    return [self.sellUuid isEqualToString:object.sellUuid];
}

- (void)sendPost:(MKPost *)aPost
{
    //NSString *myAddress = MKRootNode.sharedMKRootNode.bmClient.identities.firstIdentity.address;

    [self.dict setObject:self.classNameSansPrefix forKey:@"_type"];
    [self.dict setObject:aPost.uuid forKey:@"sellUuid"];
    [self.dict setObject:aPost.sellerAddress forKey:@"sellerAddress"];
    //[self.dict setObject:myAddress forKey:@"buyerAddress"];
    [self.dict setObject:aPost.title forKey:@"title"];
    [self.dict setObject:aPost.price forKey:@"price"];
    [self.dict setObject:aPost.description forKey:@"description"];
    [self.dict setObject:aPost.regionPath forKey:@"regionPath"];
    [self.dict setObject:aPost.categoryPath forKey:@"categoryPath"];

    NSString *channelAddress = MKRootNode.sharedMKRootNode.markets.mkChannel.channel.address;
    NSString *sellerAddress = aPost.sellerAddress;
    NSString *subject = [NSString stringWithFormat:@"%@ post", [aPost.uuid substringToIndex:5]];
    NSString *message = self.dict.asJsonString;
    
    BMMessage *m = [[BMMessage alloc] init];
    [m setFromAddress:sellerAddress];
    [m setToAddress:channelAddress];
    [m setSubject:subject];
    [m setMessage:message];
    [m send];
}

- (MKPost *)mkPost
{
    MKPost *mkPost = [[MKPost alloc] init];
    [mkPost setPropertiesDict:self.dict];
    return mkPost;
}


@end
