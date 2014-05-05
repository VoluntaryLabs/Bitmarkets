//
//  MKMessages.m
//  BitMarkets
//
//  Created by Steve Dekorte on 5/3/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKMessages.h"

@implementation MKMessages

- (id)init
{
    self = [super init];
    return self;
}

- (NSString *)nodeTitle
{
    return @"Messages";
}

- (MKPostMsg *)postMsg
{
    return [self.children firstObjectOfClass:MKPost.class];
}

@end
