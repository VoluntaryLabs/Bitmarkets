//
//  MKPostMsg.h
//  BitMarkets
//
//  Created by Steve Dekorte on 5/2/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKMsg.h"

@class MKPost;

@interface MKPostMsg : MKMsg

- (void)sendPost:(MKPost *)aPost;
- (MKPost *)mkPost;

@end
