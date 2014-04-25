//
//  BMKAppDelegate.m
//  BitMarkets
//
//  Created by Steve Dekorte on 4/15/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKAppDelegate.h"
#import "MKRootNode.h"

@implementation MKAppDelegate

- (void)applicationDidFinishLaunching: (NSNotification *)aNote
{
    [super applicationDidFinishLaunching:aNote];
    
    [self setNavTitle:@"launching bitmessage and wallet servers..."];
    [self setRootNode:[MKRootNode sharedMKRootNode]];
    [self setNavTitle:@""];
}

@end
