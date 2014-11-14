//
//  MKSells.m
//  Bitmessage
//
//  Created by Steve Dekorte on 3/13/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import <BitmessageKit/BitmessageKit.h>
#import "MKSells.h"
#import "MKSell.h"
#import "MKMsg.h"

@implementation MKSells

- (id)init
{
    self = [super init];
    self.childClass = MKSell.class;
    return self;
}

- (NSString *)nodeTitle
{
    return @"Sells";
}

- (MKSell *)addSell
{
    MKSell *sell = [super addChild];
    [self write];
    return sell;
}

// test

- (void)write
{
    [super write];
}

- (void)read
{
    [super read];
}

- (void)delete
{
    return;
}


@end
