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

    return self;
}


- (NSUInteger)hash
{
    return self.postUuid.hash;
}

- (BOOL)isEqual:(MKPostMsg *)object
{
    if (![object isKindOfClass:MKPostMsg.class])
    {
        return NO;
    }
    
    return [self.postUuid isEqualToString:object.postUuid];
}

- (void)sendPost:(MKPost *)mkPost
{
    /*
     NSArray *msgProperties = @[
        @"postUuid",
        @"title",
        @"price",
        @"description",
        @"regionPath",
        @"categoryPath",
        @"sellerAddress"];
    */
    
    [self.dict removeAllObjects];
    [self.dict setObject:self.classNameSansPrefix forKey:@"_type"];
    [self.dict addEntriesFromDictionary:mkPost.propertiesDict];
    [self.dict removeObjectForKey:@"status"];

    [self send];
}

- (NSString *)channelAddress
{
    return MKRootNode.sharedMKRootNode.markets.mkChannel.channel.address;
}

- (BOOL)send
{
    BMMessage *m = [[BMMessage alloc] init];
    [m setFromAddress:self.sellerAddress];
    [m setToAddress:self.channelAddress];
    [m setSubject:self.subject];
    [m setMessage:self.dict.asJsonString];
    [m send];
    return YES;
}

- (MKPost *)mkPost
{
    MKPost *mkPost = [[MKPost alloc] init];
    [mkPost setPropertiesDict:self.dict];
    return mkPost;
}

@end
