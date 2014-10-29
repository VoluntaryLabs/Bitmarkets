//
//  Bitmarkets.m
//  Bitmarkets
//
//  Created by Steve Dekorte on 10/28/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "Bitmarkets.h"
#import "MKRootNode.h"

@implementation Bitmarkets

+ nodeRoot
{
    return MKRootNode.sharedMKRootNode;
}

@end
