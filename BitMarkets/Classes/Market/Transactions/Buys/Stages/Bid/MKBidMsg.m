//
//  MKBidMsg.m
//  BitMarkets
//
//  Created by Steve Dekorte on 5/2/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import <FoundationCategoriesKit/FoundationCategoriesKit.h>
#import "MKBidMsg.h"
#import "MKRootNode.h"

@implementation MKBidMsg

- (NSString *)nodeTitle
{    
    if (self.isInBuy)
    {
        return @"Bid Sent";
    }
    
    return [NSString stringWithFormat:@"Bid received from %@", self.sellerAddress];
    
    //return @"Bid Received";
}

- (NSString *)nodeSubtitle
{
    return self.dateString;
    
    /*
    if (self.isInBuy)
    {
        return self.dateString;
    }
    
    return [NSString stringWithFormat:@"From %@", self.sellerAddress];
     */
}

- (void)setupForPost:(MKPost *)mkPost
{
    //[self.dict addEntriesFromDictionary:mkPost.propertiesDict];
    
    self.postUuid = mkPost.postUuid;
    self.sellerAddress = mkPost.sellerAddress;
    self.buyerAddress = self.myAddress;
}

- (BOOL)send
{
    self.debug = YES;
    return [self sendToSeller];
}


@end
