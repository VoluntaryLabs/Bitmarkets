//
//  MKBuy.h
//  Bitmessage
//
//  Created by Steve Dekorte on 3/17/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import <BitmessageKit/BitMessageKit.h>
#import "MKSell.h"

@interface MKBuy : BMNode

@property (strong, nonatomic) MKSell *sell;
@property (strong, nonatomic) NSString *status;

- (void)setDict:(NSMutableDictionary *)aDict;
- (NSMutableDictionary *)dict;

- (MKBuy *)justAdd;
- (void)post;

@end
