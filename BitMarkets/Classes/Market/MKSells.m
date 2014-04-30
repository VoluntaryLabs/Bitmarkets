//
//  MKSells.m
//  Bitmessage
//
//  Created by Steve Dekorte on 3/13/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "MKSells.h"
#import "MKSell.h"

@implementation MKSells

- (id)init
{
    self = [super init];
    //[self add];
    return self;
}

- (NSString *)nodeTitle
{
    return @"Sells";
}

- (BOOL)canSearch
{
    return self.children.count > 0;
}

- (MKSell *)justAdd
{
    MKSell *sell = [[MKSell alloc] init];
    sell.isLocal = YES;
    [self addChild:sell];
    return sell;
}

- (void)add
{
    [self justAdd];
}

// dict

- (void)setDict:(NSDictionary *)aDict
{
    
}

- (NSDictionary *)dict
{
    return nil;
}


@end
