//
//  MKDeliveryAddress.h
//  BitMarkets
//
//  Created by Steve Dekorte on 5/7/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKGroup.h"
#import "MKBuyerAddressMsg.h"

@interface MKDeliveryAddress : MKGroup

@property (strong, nonatomic) NSMutableDictionary *addressDict;
@property (assign, nonatomic) BOOL isEditable;

// name

- (void)setName:(NSString *)aString;
- (NSString *)name;

// address1

- (void)setAddress1:(NSString *)aString;
- (NSString *)address1;

// address2

- (void)setAddress2:(NSString *)aString;
- (NSString *)address2;

// country

- (void)setCountry:(NSString *)aString;
- (NSString *)country;

// checks

- (BOOL)isFilled;
- (BOOL)canSend;

@end
