//
//  MKUpdateMessage.h
//  Bitmarkets
//
//  Created by Steve Dekorte on 12/8/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BitMessageKit/BitMessageKit.h>

@interface MKUpdateMessage : NSObject

@property (strong, nonatomic) NSDictionary *dict;
@property (strong, nonatomic) BMMessage *bmMessage;

- (NSString *)version;
- (BOOL)isNewer;
- (void)deleteIfOlder;
- (void)showAlert;

@end
