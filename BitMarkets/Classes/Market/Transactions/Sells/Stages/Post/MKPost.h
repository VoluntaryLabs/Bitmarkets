//
//  MKPost.h
//  BitMarkets
//
//  Created by Steve Dekorte on 5/1/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKStage.h"
#import "MKPostMsg.h"
#import "MKBidMsg.h"
#import <BitmessageKit/BitmessageKit.h>

//@class MKPostMsg;
//@class MKBidMsg;

@interface MKPost : MKStage

@property (strong, nonatomic) NSDate *date;

// msg properties

@property (strong, nonatomic) NSString *postUuid;

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSNumber *priceInSatoshi;
@property (strong, nonatomic) NSString *description;

@property (strong, nonatomic) NSArray  *regionPath;
@property (strong, nonatomic) NSArray  *categoryPath;
@property (strong, nonatomic) NSString *sellerAddress;
@property (strong, nonatomic) NSArray  *attachments;
@property (strong, nonatomic) BMMessage *bmMessage;

- (BOOL)isEditable;
- (BOOL)canBuy;

- (void)setPriceInBtc:(NSNumber *)btcNumber;
- (NSNumber *)priceInBtc;

- (BOOL)placeInMarketsPath;

- (void)copy:(MKPost *)aPost;
- (NSString *)titleOrDefault;

// messages

- (MKPostMsg *)postMsg;

- (MKPostMsg *)sendPostMsg;
- (MKBidMsg *)sendBidMsg;

- (BOOL)isComplete;

// equality

- (NSUInteger)hash;
- (BOOL)isEqual:(id)object;

- (NSNumber *)priceInSatoshi;

- (void)close;


@end
