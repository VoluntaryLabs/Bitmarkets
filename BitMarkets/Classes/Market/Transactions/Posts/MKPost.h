//
//  MKPost.h
//  BitMarkets
//
//  Created by Steve Dekorte on 5/1/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKGroup.h"

@class MKPostMsg;

@interface MKPost : MKGroup

@property (strong, nonatomic) NSDate *date;

@property (strong, nonatomic) NSString *status;

// msg properties

@property (strong, nonatomic) NSString *uuid;

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSNumber *price;
@property (strong, nonatomic) NSString *description;

@property (strong, nonatomic) NSArray  *regionPath;
@property (strong, nonatomic) NSArray  *categoryPath;
@property (strong, nonatomic) NSString *sellerAddress;

- (BOOL)isEditable;
- (BOOL)canBuy;

- (void)setFromPostMsg:(MKPostMsg *)postMsg;

- (BOOL)placeInMarketsPath;
- (void)post;

- (void)copy:(MKPost *)aPost;

- (NSString *)titleOrDefault;

@end
