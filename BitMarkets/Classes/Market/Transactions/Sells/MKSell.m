//
//  MKSell.m
//  Bitmessage
//
//  Created by Steve Dekorte on 3/21/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "MKSell.h"
#import "MKMsg.h"

#import <NavKit/NavKit.h>
#import <BitmessageKit/BitmessageKit.h>
#import <FoundationCategoriesKit/FoundationCategoriesKit.h>

#import "MKRootNode.h"
#import "MKExchangeRate.h"
#import "MKPostMsg.h"

@implementation MKSell

- (id)init
{
    self = [super init];
    self.nodeSuggestedWidth = 300;
    return self;
}

- (NSString *)nodeSubtitle
{
    return self.mkPost.status;
}


@end
