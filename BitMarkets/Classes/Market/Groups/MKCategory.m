//
//  MKCategory.m
//  Bitmessage
//
//  Created by Steve Dekorte on 3/23/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKCategory.h"
#import <BitMessageKit/BitMessageKit.h>
#import <FoundationCategoriesKit/FoundationCategoriesKit.h>
#import <NavKit/NavKit.h>
#import "MKMarkets.h"
#import "MKRootNode.h"
#import "MKAppDelegate.h"
#import <sys/utsname.h>


@implementation MKCategory

- (id)init
{
    self = [super init];
    self.nodeShouldSortChildren = @YES;
    //self.nodeSortChildrenKey = @"date";
    self.nodeSuggestedWidth = @150;
    
    {
        NavActionSlot *slot = [self.navMirror newActionSlotWithName:@"add"];
        [slot setVisibleName:@"add"];
        [slot setIsActive:NO];
    }
    
    return self;
}

- (JSONDB *)db
{
    JSONDB *db = [super db];
    db.name = @"categories.json";
    db.location = JSONDB_IN_APP_WRAPPER;
    return db;
}

- (NSNumber *)nodeShouldSortChildren
{
    return [NSNumber numberWithBool:!self.isLeafCategory];
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

- (void)setDict:(NSDictionary *)dict
{
    [super setDict:dict];
    [self updateActions];
}

- (void)updateActions
{
    NavActionSlot *slot = [self.navMirror newActionSlotWithName:@"add"];
    slot.isActive = self.isLeafCategory;
}

- (NSNumber *)nodeSuggestedWidth
{
    if (self.isLeafCategory)
    {
        return @250;
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
    NSArray *path = [self nodePathOfClass:MKRegion.class];    
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
    NSArray *path = [self nodePathOfClass:MKCategory.class];
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
    
    //NSLog(@"self.regionPath = %@", self.regionPath);
    mkPost.regionPath   = self.regionPath;
    mkPost.categoryPath = self.categoryPath;
    
    //[self.navView selectNodePath:mkPost.nodePathArray];
    [self.navView selectNodePath:sell.nodePathArray];
}

- (BOOL)addChild:(NavNode *)child
{
    BOOL result = [super addChild:child];
    
    if (result)
    {
        //if (self.nodeParent.nodeShouldUseCountForNodeNote.boolValue)
        {
            [self postParentChainChanged]; 
        }
    }
    
    return result;
}

// search

- (BOOL)canSearch
{
    NavNode *firstChild = [self.children firstObject];
    
    if (firstChild
        && ![firstChild isKindOfClass:self.class]
        && self.children.count > 1)
    {
        return YES;
    }
    
    return NO;
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
