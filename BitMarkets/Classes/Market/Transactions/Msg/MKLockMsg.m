//
//  MKTxMsg.m
//  BitMarkets
//
//  Created by Rich Collins on 7/8/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKLockMsg.h"
#import "MKLock.h"

@implementation MKLockMsg

- (MKLock *)lockNode
{
    return (MKLock *)[self nodeParent];
}

@end
