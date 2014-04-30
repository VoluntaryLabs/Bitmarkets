//
//  MKGroup.m
//  Bitmessage
//
//  Created by Steve Dekorte on 3/24/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "MKGroup.h"
#import <BitmessageKit/BitmessageKit.h>
#import "MKCategory.h"

@implementation MKGroup

+ (MKGroup *)rootInstance
{
    MKGroup *group = [[self.class alloc] init];
    [group read];
    return group;
}

- (id)init
{
    self = [super init];
    //self.actions = [NSMutableArray arrayWithObjects:@"add", nil];
    //self.count = 0;
    return self;
}

- (NSString *)dbName
{
    [NSException raise:@"Missing method" format:@"subsclasses should implement this method"];
    return nil;
}

- (NSString *)nodeTitle
{
    return self.name;
}

/*
- (NSString *)nodeNote
{
    if (self.count)
    {
        return [NSString stringWithFormat:@"%i", (int)self.count];
    }
    
    return nil;
}
*/

- (JSONDB *)db
{
    JSONDB *db = [[JSONDB alloc] init];
    [db setName:self.dbName];
    db.location = JSONDB_IN_APP_WRAPPER;
    return db;
}

- (void)read
{
    JSONDB *db = self.db;
    [db read];
    [self setDict:db.dict];
}

- (void)write
{
    //
}

- (void)setCanPost:(BOOL)aBool
{
    //BOOL hasAdd = [self.actions containsObject:@"add"];
    
    /*
    if (aBool)
    {
        if (!hasAdd)
        {
            [self.actions addObject:@"add"];
        }
    }
    else
    {
        if (hasAdd)
        {
            [self.actions removeObject:@"add"];
        }
    }
    */
}

+ (MKGroup *)withDict:(NSDictionary *)dict
{
    MKGroup *obj = [[self alloc] init];
    [obj setDict:dict];
    return obj;
}

/*
- (NSString *)name
{
    return self.nodeTitle;
}
*/

- (void)setDict:(NSDictionary *)dict
{
    self.name = [dict objectForKey:@"name"];
    self.nodeTitle = self.name;
    NSArray *childrenDicts = [dict objectForKey:@"children"];
    
    if (childrenDicts)
    {
        self.childClass = self.class; 
        
        NSMutableArray *children = [NSMutableArray array];
        
        for (NSDictionary *childDict in childrenDicts)
        {
            Class childClass = self.childClass ? self.childClass : self.class;
            NSString *childType = [dict objectForKey:@"_type"];
            
            if (childType)
            {
                childClass = NSClassFromString([childType withPrefix:@"MK"]);
            }

            [children addObject:[childClass withDict:childDict]];
        }
        
        [self setChildren:children];
    }
    
    //[self sortChildren];
}

- (NSDictionary *)dict
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSStringFromClass(self.class) sansPrefix:@"MK"] forKey:@"_type"];
    [dict setObject:self.name forKey:@"name"];
    NSMutableArray *childrenDicts = [NSMutableArray array];
    
    for (MKGroup *child in self.children)
    {
        [childrenDicts addObject:[child dict]];
    }
    
    [dict setObject:childrenDicts forKey:@"children"];
    return dict;
}

- (CGFloat)nodeSuggestedWidth
{
    return 180;
}

- (NSArray *)groupPath
{
   // if ([self.nodeParent isKindOfClass:self.class])
    if ([self.nodeParent respondsToSelector:@selector(groupPath)])
    {
        MKGroup *parentCat = (MKGroup *)self.nodeParent;
        return [[parentCat groupPath] arrayByAddingObject:self.name];
    }
    
    return [NSArray arrayWithObject:self.name];
}

- (NSArray *)groupSubpaths
{
    NSMutableArray *paths = [NSMutableArray array];
    
    for (MKGroup *cat in self.children)
    {
        if ([cat isKindOfClass:self.class])
        {
            [paths addObject:cat.groupPath];
        }
    }
    
    return paths;
}

- (void)updateCounts
{
    /*
    self.count = 0;
    //self.count = self.children.count;
    
    for (MKGroup *group in self.children)
    {
        if ([group isKindOfClass:[MKGroup class]])
        {
            [group updateCounts];
            
            if ([group count])
            {
                NSLog(@"--------> %@ %i", group.nodeTitle, (int)group.count);
            }
            
            self.count += group.count;
        }
        else if ([group respondsToSelector:@selector(count)])
        {
            self.count += group.count;
        }
    }
    */
}

// node note

- (NSString *)nodeNote
{
    //if ([self isKindOfClass:MKCategory.class])
    if ([self.nodeTitle isEqualToString:@"Antiques"])
    {
        NSLog(@"%@ nodeNote", NSStringFromClass(self.class));
    }
    
    if (self.countOfLeafChildren > 0)
    {
        return [NSString stringWithFormat:@"%i", (int)self.countOfLeafChildren];
    }
    
    return nil;
}

- (NSInteger)countOfLeafChildren
{
    NSInteger count = 0;
    
    for (MKGroup *childGroup in self.children)
    {
        if ([childGroup respondsToSelector:@selector(countOfLeafChildren)])
        {
            count += childGroup.countOfLeafChildren;
        }
    }
    
    return count;
}

// persistence

/*
- (JSONDB *)appSupportDb
{
    JSONDB *db = [[JSONDB alloc] init];
    db.isInAppWrapper = YES;
    db.name = @"Sells";
    return db;
}

- (void)read
{
    JSONDB *db = self.appSupportDb;
    [db read];
    
    if (db.dict)
    {
        [self setDict:db.dict];
    }
}

- (void)write
{
    JSONDB *db = self.appSupportDb;
    [db setDict:[NSMutableDictionary dictionaryWithDictionary:self.dict]];
    [db write];
}
*/

@end
