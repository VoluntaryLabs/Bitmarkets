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
    //self.shouldSortChildren = YES;
    return self;
}

- (NSString *)dbName
{
    return @"categories.json";
}

- (BOOL)isLeafCategory
{
    return ![self.childClass isSubclassOfClass:MKCategory.class];
}

- (NSArray *)uiActions
{
    if (self.isLeafCategory)
    {
        NSArray *uiActions = [NSMutableArray arrayWithObjects:@"add", nil];
        return  [uiActions arrayByAddingObjectsFromArray:super.uiActions];
    }
    else
    {
        return super.uiActions;
    }
}

- (CGFloat)nodeSuggestedWidth
{
    if (self.isLeafCategory)
    {
        return 250;
    }
    
    return 250;
}

- (BOOL)canSearch
{
    return self.isLeafCategory && (self.children.count > 0);
}

- (NSInteger)count
{
    if (self.isLeafCategory)
    {
        return self.children.count;
    }
    
    return [super count];
}

- (void)setDict:(NSDictionary *)dict
{
    [super setDict:dict];
    
    if (self.children.count == 0)
    {
        [self setCanPost:YES];
    }
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
    NSMutableArray *path = [NSMutableArray arrayWithArray:self.groupPath];
    [path removeFirstObject]; // remove "Regions"
    [path removeLastObject];
    return path;
}

- (NSArray *)categoryPath
{
    return [NSArray arrayWithObject:self.groupPath.lastObject];
}

- (void)add
{
    // move to UI layer category
    
    MKRootNode *root   = [MKRootNode sharedMKRootNode];
    MKMarkets *markets = [root markets];
    MKSells *sells     = [markets sells];
    MKSell *sell       = [sells justAdd];
    
    //NSLog(@"%@", self.groupPath);

    sell.regionPath = self.regionPath;
    sell.categoryPath = self.categoryPath;
    
    NSArray *nodes = [NSArray arrayWithObjects:root, markets, sells, sell, nil];
    
    
    [self.navView selectNodePath:nodes];
}

@end
