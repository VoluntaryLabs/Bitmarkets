//
//  MKBuy.h
//  Bitmessage
//
//  Created by Steve Dekorte on 3/17/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import <BitmessageKit/BitMessageKit.h>
#import "MKSell.h"
#import "MKGroup.h"

@interface MKBuy : MKGroup

@property (strong, nonatomic) MKSell *sell;
@property (strong, nonatomic) NSString *status;

@property (strong, nonatomic) NSString *sellUuid;
@property (strong, nonatomic) NSString *buyerAddress;
@property (strong, nonatomic) NSString *sellerAddress;

- (void)setDict:(NSMutableDictionary *)aDict;
- (NSMutableDictionary *)dict;

- (MKBuy *)justAdd;
- (void)post;

@end
