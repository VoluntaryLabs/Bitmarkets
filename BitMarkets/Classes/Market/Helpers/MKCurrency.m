//
//  MKCurrency.m
//  BitMarkets
//
//  Created by Steve Dekorte on 8/11/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKCurrency.h"
#import "MKExchangeRate.h"
#import <FoundationCategoriesKit/FoundationCategoriesKit.h>
#import <BitNashKit/BitNashKit.h>

@implementation MKCurrency

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

- (NSString *)formattedPriceForSymbol:(NSString *)aSymbol
{
    NSNumber *rateForSymbol = @1.0;
    
    if ([aSymbol isEqualToString:@"BTC"] || [aSymbol isEqualToString:@"XBT"])
    {
        rateForSymbol = @1.0;
    }
    else
    {
        MKExchangeRate *rate = [MKExchangeRate shared];
        rateForSymbol = [rate btcPerSymbol:aSymbol];
    }
    
    if (rateForSymbol == nil)
    {
        return nil;
    }
    
    NSNumber *priceForSymbol = @(self.btcAmount.floatValue * rateForSymbol.floatValue);
    NSString *formattedPrice = [priceForSymbol asFormattedStringWithFractionalDigits:1];
    return formattedPrice;
}

- (NSArray *)defaultSymbols
{
    return @[@"BTC", @"USD", @"EUR"];
}

- (NSString *)formattedPriceSetString
{
    NSString *outputString = @"";
    NSString *separator = @"  ";
    
    for (NSString *symbol in self.defaultSymbols)
    {
        NSString *price = [self formattedPriceForSymbol:symbol];
        
        if (price)
        {
            if (outputString.length)
            {
                outputString = [outputString stringByAppendingString:separator];
            }
            
            outputString = [outputString stringByAppendingString:price];
            //outputString = [outputString stringByAppendingString:@" "];
            outputString = [outputString stringByAppendingString:symbol];
        }
    }
    
//    /NSLog(@"outputString '%@'", outputString);
    return outputString;
}

@end
