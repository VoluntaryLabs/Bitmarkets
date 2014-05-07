//
//  MKMsg.h
//  BitMarkets
//
//  Created by Steve Dekorte on 5/2/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKGroup.h"
#import <BitmessageKit/BitmessageKit.h>

@interface MKMsg : MKGroup

@property (strong, nonatomic) NSMutableDictionary *dict;
@property (strong, nonatomic) BMMessage *bmMessage;
@property (strong, nonatomic) NSString *msgid;

+ (MKMsg *)withBMMessage:(BMMessage *)bmMessage;


// valid

- (BOOL)hasValidPostUuid;
- (BOOL)hasValidSellerAddress;
- (BOOL)isValid;

- (NSString *)myAddress;

- (NSString *)classNameSansPrefix;

- (NSString *)subject;
- (NSString *)postUuid;
- (NSString *)sellerAddress;
- (NSString *)buyerAddress;

- (BOOL)send;

@end
