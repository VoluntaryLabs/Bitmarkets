//
//  MKCurrency.h
//  BitMarkets
//
//  Created by Steve Dekorte on 8/11/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MKCurrency : NSObject

@property (strong, nonatomic) NSNumber *btcAmount;

//- (NSNumberFormatter *)priceFormatter;
- (NSString *)formattedPriceSetString;

@end
