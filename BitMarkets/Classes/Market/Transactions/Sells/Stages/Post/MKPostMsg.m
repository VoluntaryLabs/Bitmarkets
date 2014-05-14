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

/*
- (NSString *)nodeNote
{
    return self.bmStatus;
}
 */

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
    // clean this up
    
    [self.dict removeAllObjects];
    [self.dict setObject:self.classNameSansPrefix forKey:@"_type"];
    [self.dict addEntriesFromDictionary:mkPost.propertiesDict];
    [self.dict removeObjectForKey:@"status"];

    [self send];
}

- (BOOL)isValid
{
    BOOL validUuid   = self.hasValidPostUuid;
    BOOL validSeller = self.hasValidSellerAddress;
    return validUuid && validSeller;
}

- (BOOL)send
{
    return [self sendFromSellerToChannel];
}

- (MKPost *)mkPost
{
    MKPost *mkPost = [[MKPost alloc] init];
    [mkPost setPropertiesDict:self.dict];
    return mkPost;
}

@end
