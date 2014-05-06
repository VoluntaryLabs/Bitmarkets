//
//  MKBidMsg.m
//  BitMarkets
//
//  Created by Steve Dekorte on 5/2/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import <FoundationCategoriesKit/FoundationCategoriesKit.h>
#import "MKBidMsg.h"

@implementation MKBidMsg

- (void)setupForPost:(MKPost *)mkPost
{
    [self.dict removeAllObjects];
    [self.dict addEntriesFromDictionary:mkPost.propertiesDict];
    
    [self.dict setObject:self.classNameSansPrefix forKey:@"_type"];
    [self.dict setObject:mkPost.postUuid forKey:@"postUuid"];
    [self.dict setObject:mkPost.sellerAddress forKey:@"sellerAddress"];
    [self.dict setObject:self.myAddress forKey:@"buyerAddress"];
}

- (BOOL)send
{
    NSString *message = self.dict.asJsonString;
    
    BMMessage *m = [[BMMessage alloc] init];
    [m setFromAddress:[self myAddress]];
    [m setToAddress:[self.dict objectForKey:@"sellerAddress"]];
    [m setSubject:self.subject];
    [m setMessage:message];
    [m send];
    
    return YES;
}

@end
