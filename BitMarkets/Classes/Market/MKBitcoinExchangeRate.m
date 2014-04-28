//
//  MKBitcoinExchangeRate.m
//  BitMarkets
//
//  Created by Adam Thorsen on 4/27/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKBitcoinExchangeRate.h"

@implementation MKBitcoinExchangeRate
- (id) init
{
    if ( self = [super init] ) {
        self.responseData = [[NSMutableData alloc] init];
        self.rates = [[NSMutableDictionary alloc] init];
        self.ratesFetchedAt = [[NSMutableDictionary alloc] init];
        self.cacheTtl = 10 * 60;
    }
    return self;
}

- (void)dealloc {

}

// Accepts a currency symbol as a string.
// Returns an NSNumber indicating the exchange rate in BTC.
// The list of acceptable symbols can be found here:
// https://blockchain.info/api/exchange_rates_api

- (NSNumber *) btcPerSymbol:(NSString *) symbol
{
    NSNumber *rate = [_rates objectForKey: symbol];
    NSDate * currentDate = [NSDate date];
    NSDate *rateFetchedAt = [_ratesFetchedAt objectForKey: symbol];
    if ((nil == rateFetchedAt) ||
        ([currentDate timeIntervalSinceDate: rateFetchedAt] > _cacheTtl)) {
        
        // Update last fetch date
        
        [self.ratesFetchedAt setValue:currentDate forKey:symbol];

        // Create the url we will use to ping the blockchain.info API
        
        NSString *url =
        [NSString stringWithFormat:@"https://blockchain.info/tobtc?currency=%@&value=1", symbol];
        
        NSURLRequest *request =
        [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        
        // Declare an empty response NSURLConnectoin needs to fill in the actual response
        // Send synchronous http request
        
        NSURLResponse *response = nil;
        NSData *data =
        [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
        
        // Convert response NSData into string
        
        NSString *rateString =
        [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        // Convert response to float and store in cache.
        
        rate = [NSNumber numberWithFloat:[rateString floatValue]];
        [self.rates setValue:rate forKey:symbol];
        
        return rate;
    }
    else {
        return rate;
    }
    
}
@end
