//
//  MKWalletAddresses.m
//  BitMarkets
//
//  Created by Steve Dekorte on 4/29/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKWalletAddresses.h"
#import "MKWalletAddress.h"


@implementation MKWalletAddresses

- (id)init
{
    self = [super init];
    self.nodeTitle = @"Addresses";
    self.childClass = MKWalletAddress.class;
    self.nodeSuggestedWidth = 325;
    return self;
}

- (NSArray *)uiActions
{
    NSArray *uiActions = [NSMutableArray arrayWithObjects:@"add", nil];
    return  [uiActions arrayByAddingObjectsFromArray:super.uiActions];
}

- (NSString *)nodeNote
{
    if (self.children.count > 0)
    {
        return [NSString stringWithFormat:@"%i", (int)self.children.count];
    }
    
    return nil;
}




@end
