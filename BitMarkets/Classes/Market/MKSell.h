//
//  MKSell.h
//  Bitmessage
//
//  Created by Steve Dekorte on 3/21/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import <BitMessageKit/BitMessageKit.h>
#import "MKAskMessage.h"

@interface MKSell : BMNode

@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) MKAskMessage *askMessage;

@property (strong, nonatomic) NSString *uuid;
@property (strong, nonatomic) NSString *status;

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSNumber *price;
@property (strong, nonatomic) NSString *description;

@property (strong, nonatomic) NSArray *regionPath;
@property (strong, nonatomic) NSArray  *categoryPath;
@property (strong, nonatomic) NSString *sellerAddress;

- (NSDictionary *)dict;

@end
