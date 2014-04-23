//
//  BMKAppDelegate.m
//  BitMarkets
//
//  Created by Steve Dekorte on 4/15/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKAppDelegate.h"
#import "MKMarkets.h"

@implementation MKAppDelegate


- (void)applicationDidFinishLaunching: (NSNotification *)aNote
{
    [super applicationDidFinishLaunching:aNote];
    
    NavInfoNode *root = [[NavInfoNode alloc] init];
    root.shouldSortChildren = NO;
    root.nodeTitle = @"BitMarkets";
    root.nodeSuggestedWidth = 150;
    
    // market
    
    MKMarkets *markets = [[MKMarkets alloc] init];
    [root addChild:markets];
    
    
    [self setNavTitle:@"launching server..."];

    self.bmClient = [BMClient sharedBMClient];
    
    
    [self setRootNode:root];
    [self setNavTitle:@""];
    
    [self addAbout];
    
    [[[BMClient sharedBMClient] identities] createFirstIdentityIfAbsent];
}

- (void)addAbout
{
    NavInfoNode *about = [[NavInfoNode alloc] init];
    [(BMNode *)self.rootNode addChild:about];
    about.nodeTitle = @"About";
    about.nodeSuggestedWidth = 150;
    
    NavInfoNode *contributors = [[NavInfoNode alloc] init];
    [about addChild:contributors];
    contributors.nodeTitle = @"Contributors";
    contributors.nodeSuggestedWidth = 200;
    
    {
        NavInfoNode *contributor = [[NavInfoNode alloc] init];
        contributor.nodeTitle = @"Chris Robinson";
        contributor.nodeSubtitle = @"Designer";
        [contributors addChild:contributor];
    }
    
    {
        NavInfoNode *contributor = [[NavInfoNode alloc] init];
        contributor.nodeTitle = @"Rich Collins";
        contributor.nodeSubtitle = @"Bitcoin integration";
        [contributors addChild:contributor];
    }
    
    {
        NavInfoNode *contributor = [[NavInfoNode alloc] init];
        contributor.nodeTitle = @"Steve Dekorte";
        contributor.nodeSubtitle = @"Lead and UI Development";
        [contributors addChild:contributor];
    }
    
    {
        NavInfoNode *contributor = [[NavInfoNode alloc] init];
        contributor.nodeTitle = @"Adam Thorsen";
        contributor.nodeSubtitle = @"Generalist";
        [contributors addChild:contributor];
    }
    
    {
        NavInfoNode *contributor = [[NavInfoNode alloc] init];
        contributor.nodeTitle = @"Dru Nelson";
        contributor.nodeSubtitle = @"Unix Guru";
        [contributors addChild:contributor];
    }
}

@end
