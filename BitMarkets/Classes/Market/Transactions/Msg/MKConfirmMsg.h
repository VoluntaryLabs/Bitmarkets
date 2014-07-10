//
//  MKConfirmMsg.h
//  BitMarkets
//
//  Created by Steve Dekorte on 5/30/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKMsg.h"

@interface MKConfirmMsg : MKMsg

@property (strong, nonatomic) NSDictionary *tx;

@end
