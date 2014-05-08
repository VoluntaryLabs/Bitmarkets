//
//  MKEscrowMsg.h
//  BitMarkets
//
//  Created by Steve Dekorte on 5/7/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKMsg.h"

@interface MKEscrowMsg : MKMsg

- (BOOL)isInBuy;

- (void)setPayload:(NSString *)payload;
- (NSString *)payload;

@end
