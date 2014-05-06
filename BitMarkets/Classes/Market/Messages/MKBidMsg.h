//
//  MKBidMsg.h
//  BitMarkets
//
//  Created by Steve Dekorte on 5/2/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKMsg.h"
#import "MKPost.h"

@interface MKBidMsg : MKMsg

- (void)setupForPost:(MKPost *)mkPost;

@end
