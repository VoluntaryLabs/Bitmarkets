//
//  BNKeysNode+BM.m
//  BitMarkets
//
//  Created by Rich Collins on 5/2/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "BNKeysNode+BM.h"

@implementation BNKeysNode (BM)

- (NSArray *)uiActions
{
    NSArray *uiActions = [NSMutableArray arrayWithObjects:@"add", nil];
    return  [uiActions arrayByAddingObjectsFromArray:super.uiActions];
}

- (void)add
{
    BNKey *key = [((BNWallet *)self.nodeParent) createKey];
    [self addChild:key];
    
    NavAppController *conntroller = [[NSApplication sharedApplication] delegate];
    [conntroller.navWindow.navView selectNodePath:[key nodePathArray]];
}

@end
