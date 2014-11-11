//
//  MKExchangeRate.m
//  BitMarkets
//
//  Created by Adam Thorsen on 4/27/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKExchangeRate.h"

@implementation MKExchangeRate

static MKExchangeRate *shared;

+ (MKExchangeRate *)shared
{
    if (!shared)
    {
        shared = [[self alloc] init];
    }
    
    return shared;
}

- (void)startRepeatingTimer
{
    if(nil != self.repeatingTimer)
    {
        // Cancel a preexisting timer.
        [self.repeatingTimer invalidate];
    }
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:(60 * 1)
                                                      target:self
                                                    selector:@selector(update)
                                                    userInfo:nil
                                                     repeats:YES];
    self.repeatingTimer = timer;
}

- (NSString *)urlString
{
    return @"https://blockchain.info/ticker";
}

- (void)update
{
    //NSLog(@"Updating BTC Exchange rate");

    NSString *url =
    [NSString stringWithFormat:self.urlString];
    
    NSURLRequest *request =
    [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (!self.connection)
    {
        self.responseData = nil;
    }

}

- (id) init
{
    if (self = [super init])
    {
        self.responseData = [[NSMutableData alloc] init];
        self.rates = [[NSMutableDictionary alloc] init];
        self.repeatingTimer = nil;
        [self update];
        [self startRepeatingTimer];
    }
    
    return self;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // Release the connection and the data object
    // by setting the properties (declared elsewhere)
    // to nil.  Note that a real-world app usually
    // requires the delegate to manage more than one
    // connection at a time, so these lines would
    // typically be replaced by code to iterate through
    // whatever data structures you are using.
    
    self.connection = nil;
    self.responseData = nil;
    
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if ([self.responseData length] > 0)
    {
        // NSLog(@"Succeeded! Received %d bytes of data",[self.responseData length]);
        
        NSError *error;
        
        id jsonObject = [NSJSONSerialization
                         JSONObjectWithData:self.responseData
                         options:NSJSONReadingMutableContainers
                         error:&error];
        
        if (error)
        {
            NSString *responseString = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
            
            NSLog(@"JSON Parse Error: \n%@\nurl:%@\nresponse: '%@'",
                  [[error userInfo] objectForKey:@"NSDebugDescription"],
                  self.urlString,
                  responseString);
            
            [NSException raise:@"JSON Parse Error" format:@""];
        }
        else
        {
            self.rates = (NSMutableDictionary *)jsonObject;
            [NSNotificationCenter.defaultCenter postNotificationName:@"ExchangeRatesFetched" object: self];
        }
    }
    else
    {
        // NSLog(@"Faild! Blockchain.info probably timed out.");
    }

    

    
    self.connection = nil;
    self.responseData = nil;
}

- (void)dealloc
{
    [self.repeatingTimer invalidate];
    
    self.repeatingTimer = nil;
    self.connection = nil;
    self.responseData = nil;

}

// Accepts a currency symbol as a string.
// Returns an NSNumber indicating the exchange rate in BTC.
// The list of acceptable symbols can be found here:
// https://blockchain.info/api/exchange_rates_api

- (NSNumber *)btcPerSymbol:(NSString *) symbol
{
    NSNumber * rate = nil;
    NSDictionary *currencyData = [self.rates objectForKey:symbol];
    
    if (nil != currencyData)
    {
        NSString *rateString = [currencyData objectForKey:@"last"];
        rate = [NSNumber numberWithFloat:[rateString floatValue]];
    }
    
    return rate;
}


// ---------------------------------------------------

/*
- (NSNumberFormatter *)priceFormatter
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    //[formatter setLocalizesFormat:NO];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setPartialStringValidationEnabled:YES];
    [formatter setMinimum:0];
    [formatter setMaximumFractionDigits:6];
    [formatter setMaximumIntegerDigits:3];
    return formatter;
}
*/

@end
