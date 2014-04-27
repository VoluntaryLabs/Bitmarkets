//
//  MKSell.h
//  Bitmessage
//
//  Created by Steve Dekorte on 3/21/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import <BitMessageKit/BitMessageKit.h>

/*
 {
     header:
     {
         service: "bitmarket",
         version: "1.0",
         type: "Sell"
     },
     
     body:
     {
         uuid: "XXX",
         region: ["country"],
         category: ["pathComponent0", "pathComponent1", ...],
         title: "",
         description: "",
         quantity: { number: 0.0 , unit: "[n/a, length, area, volume, mass]" },
         price: { number: 0.0, unit: "BTC" },
         shippingFrom: ["CountryCode1", "CountryCode2"],
         shippingToCountries: ["CountryCode1", "CountryCode2"],
         expirationDate: "...",
     }
 }
 */

@interface MKSell : BMNode

@property (strong, nonatomic) NSDate *date;

@property (strong, nonatomic) NSString *uuid;
@property (strong, nonatomic) NSString *status;

// dict properties

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSNumber *price;
@property (strong, nonatomic) NSString *description;

@property (strong, nonatomic) NSArray *regionPath;
@property (strong, nonatomic) NSArray  *categoryPath;
@property (strong, nonatomic) NSString *sellerAddress;

- (void)setDict:(NSDictionary *)aDict;
- (NSDictionary *)dict;

- (void)post;

- (void)placeInMarketsPath;

- (void)findStatus;
- (BOOL)isDraft;

@end
