//
//  MKExchangeRate.h
//  BitMarkets
//
//  Created by Adam Thorsen on 4/27/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MKExchangeRate : NSObject

@property (strong, nonatomic) NSURLConnection *connection;
@property (strong, nonatomic) NSMutableData *responseData;
@property (strong, nonatomic) NSMutableDictionary *rates;
@property (strong, nonatomic) NSTimer *repeatingTimer;

- (NSNumber *)btcPerSymbol:(NSString *)symbol;
- (void)startRepeatingTimer;
- (void)update;

+ (MKExchangeRate *)shared;

//- (NSString *)formattedPriceForSymbol:(NSString *)aSymbol;

@end
