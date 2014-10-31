//
//  MKCategory.m
//  Bitmessage
//
//  Created by Steve Dekorte on 3/23/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "MKCategory.h"
#import <BitMessageKit/BitMessageKit.h>
#import <FoundationCategoriesKit/FoundationCategoriesKit.h>
#import <NavKit/NavKit.h>
#import "MKMarkets.h"
#import "MKRootNode.h"
#import "MKAppDelegate.h"


@implementation MKCategory

- (id)init
{
    self = [super init];
    self.shouldSortChildren = YES;
    //self.sortChildrenKey = @"date";
    self.nodeSuggestedWidth = 150;
    return self;
}

- (JSONDB *)db
{
    JSONDB *db = [super db];
    db.name = @"categories.json";
    db.location = JSONDB_IN_APP_WRAPPER;
    return db;
}

- (BOOL)shouldSortChildren
{
    return !self.isLeafCategory;
}

- (BOOL)isLeafCategory
{
    if (self.children.count == 0)
    {
        return YES;
    }
    
    NSObject *firstChild = self.children.firstObject;
    
    if (![firstChild isKindOfClass:MKCategory.class])
    {
        return YES;
    }
    
    return NO;
}

- (NSInteger)countOfLeafChildren
{
    if (self.isLeafCategory)
    {
        return self.children.count;
    }
    
    return [super countOfLeafChildren];
}

- (NSArray *)actions
{
    NSMutableArray *actions = [NSMutableArray arrayWithArray:[super actions]];
    
    if (self.isLeafCategory)
    {
        [actions addObject:@"add"];
    }

    return actions;
}

- (CGFloat)nodeSuggestedWidth
{
    if (self.isLeafCategory)
    {
        return 250;
    }
    
    return super.nodeSuggestedWidth;
}

- (NavView *)navView
{
    MKAppDelegate *app = (MKAppDelegate *)[[NSApplication sharedApplication] delegate];
    return app.navWindow.navView;
}

// these path methods are a hack
// change later to backtrack to region to separate paths instead

- (NSArray *)regionPath
{
    NSArray *path = [self pathOfClass:MKRegion.class];    
    path = [path sansFirstObject];
    return  [path map:@selector(nodeTitle)];
/*
    NSMutableArray *path = [NSMutableArray arrayWithArray:self.groupNamePath];
    [path removeFirstObject]; // remove "Regions"
    [path removeLastObject];
    return path;
 */
}

- (NSArray *)categoryPath
{
    NSArray *path = [self pathOfClass:MKCategory.class];
    return [path map:@selector(nodeTitle)];
    
    //return [NSArray arrayWithObject:self.groupNamePath.lastObject];
}

- (void)add
{
    // move to UI layer category
    
    MKRootNode *root   = [MKRootNode sharedMKRootNode];
    MKMarkets *markets = [root markets];
    MKSells *sells     = [markets sells];
    MKSell *sell       = [sells addSell];
    
    MKPost *mkPost = sell.mkPost;
    
    NSLog(@"self.regionPath = %@", self.regionPath);
    mkPost.regionPath   = self.regionPath;
    mkPost.categoryPath = self.categoryPath;
    
    [self.navView selectNodePath:mkPost.nodePathArray];

    
    //NSArray *nodes = [NSArray arrayWithObjects:root, markets, sells, sell, nil];
    //NSArray *nodes = [NSArray arrayWithObjects:root, sells, sell, nil];
    //[self.navView selectNodePath:nodes];
}

- (BOOL)addChild:(NavNode *)child
{
    BOOL result = [super addChild:child];
    
    if (result)
    {
        //if (self.nodeParent.shouldUseCountForNodeNote)
        {
            [self postParentChainChanged]; 
        }
    }
    
    return result;
}

// search

- (BOOL)canSearch
{
    return YES;
    //return self.isLeafCategory && (self.children.count > 0);
}

- (BOOL)nodeMatchesSearch:(NSString *)aString
{
    for (id child in self.children)
    {
        if ([child nodeMatchesSearch:aString])
        {
            return YES;
        }
    }
    
    return NO;
}

@end
