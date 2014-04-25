//
//  MKMessage.h
//  Bitmessage
//
//  Created by Steve Dekorte on 3/17/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import <BitmessageKit/BitmessageKit.h>

@interface MKMessage : NavNode

+ (NSMutableDictionary *)standardHeader;

+ (MKMessage *)withBMMessage:(BMMessage *)bmMessage;


@property (strong, nonatomic) NSMutableDictionary *dict;

- (void)setHeaderDict:(NSDictionary *)aDict;
- (NSDictionary *)headerDict;

- (void)setBodyDict:(NSDictionary *)aDict;
- (NSDictionary *)bodyDict;

- (id)instance;
- (void)setInstance:anObject;

// json

- (NSString *)jsonString;

@end
