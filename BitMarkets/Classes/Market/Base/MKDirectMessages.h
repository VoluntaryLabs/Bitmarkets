//
//  MKDirectMessages.h
//  Bitmarkets
//
//  Created by Steve Dekorte on 12/8/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MKDirectMessages : NSObject

@property (assign, nonatomic) BOOL needsToFetch;

- (void)fetch;

@end
