//
//  MKBitcoinExchangeRate.h
//  BitMarkets
//
//  Created by Adam Thorsen on 4/27/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MKBitcoinExchangeRate : NSObject
    @property (strong, nonatomic) NSMutableData *responseData;
    @property (strong, nonatomic) NSMutableDictionary *rates;
    @property (strong, nonatomic) NSMutableDictionary *ratesFetchedAt;
    @property int cacheTtl;

    - (NSNumber *) btcPerSymbol: (NSString *) symbol;

+ (MKBitcoinExchangeRate *)shared;

@end
