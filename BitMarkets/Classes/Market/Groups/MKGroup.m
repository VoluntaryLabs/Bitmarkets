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
    self.dictPropertyNames = [NSMutableArray array];
    //self.actions = [NSMutableArray arrayWithObjects:@"add", nil];
    //self.count = 0;
    return self;
}

- (NSString *)nodeTitle
{
    return self.name;
}

- (JSONDB *)db
{
    if (!_db)
    {
        _db = [[JSONDB alloc] init];
        _db.location = JSONDB_IN_APP_WRAPPER;
    }
    
    return _db;
}

- (void)read
{
    JSONDB *db = self.db;
    [db read];
    [self setDict:db.dict];
}

- (void)write
{
    JSONDB *db = self.db;
    db.dict = [NSMutableDictionary dictionaryWithDictionary:self.dict];
    [db write];
}

+ (MKGroup *)withDict:(NSDictionary *)dict
{
    MKGroup *obj = [[self alloc] init];
    [obj setDict:dict];
    return obj;
}

// dict


- (void)setDict:(NSDictionary *)dict
{
    self.name = [dict objectForKey:@"name"];
    self.nodeTitle = self.name;
    NSArray *childrenDicts = [dict objectForKey:@"children"];
    
    if (childrenDicts)
    {
        NSMutableArray *children = [NSMutableArray array];
        
        for (NSDictionary *childDict in childrenDicts)
        {
            Class childClass = nil;
            NSString *childType = [childDict objectForKey:@"_type"];
            NSString *className = nil;
            
            if (childType)
            {
                className = [childType withPrefix:@"MK"];
                childClass = NSClassFromString(className);
            }

            if (childClass)
            {
                self.childClass = childClass;
            }
            else
            {
                [NSException raise:@"No child class" format:@"missing _type slot in persisted dictionary"];
            }
            
            NavNode *child = [childClass withDict:childDict];
            [children addObject:child];
            //NSLog(@"read child %@ %@", NSStringFromClass(child.class), child.nodeTitle);
        }
        
        [self setChildren:children];
    }
    
    [self setPropertiesDict:dict];
    
    //[self sortChildren];
}

- (NSDictionary *)dict
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict addEntriesFromDictionary:self.propertiesDict];
    
    [dict setObject:[NSStringFromClass(self.class) sansPrefix:@"MK"] forKey:@"_type"];
    if (self.name)
    {
        [dict setObject:self.name forKey:@"name"];
    }
    
    NSArray *childrenDicts = self.childrenDicts;
    
    if (childrenDicts && childrenDicts.count)
    {
        [dict setObject:childrenDicts forKey:@"children"];
    }
    
    return dict;
}

- (NSArray *)childrenDicts
{
    NSMutableArray *childrenDicts = [NSMutableArray array];
    
    for (MKGroup *child in self.children)
    {
        [childrenDicts addObject:[child dict]];
    }
    
    return childrenDicts;
}

// properties


- (void)setPropertiesDict:(NSDictionary *)dict
{
    for (NSString *name in self.dictPropertyNames)
    {
        id value = [dict objectForKey:name];
        [self setPropertyNamed:name to:value];
    }
}

- (void)setPropertyNamed:(NSString *)aName to:aValue
{
    NSString *setterName = [NSString stringWithFormat:@"set%@:", aName.capitalisedFirstCharacterString];
    SEL setterSelector = NSSelectorFromString(setterName);

    if ([self respondsToSelector:setterSelector])
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:setterSelector withObject:aValue];
#pragma clang diagnostic pop
    }
    else
    {
        NSLog(@"no setter %@ found", setterName);
    }
    
}

- getPropertyNamed:(NSString *)aName
{
    SEL getterSelector = NSSelectorFromString(aName);
    
    if ([self respondsToSelector:getterSelector])
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        id value = [self performSelector:getterSelector withObject:nil];
#pragma clang diagnostic pop
        return value;
    }
    else
    {
        NSLog(@"no getter %@ found", aName);
    }
    
    return nil;
}

- (NSDictionary *)propertiesDict
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    for (NSString *name in self.dictPropertyNames)
    {
        id value = [self getPropertyNamed:name];
        
        
        if (value)
        {
            [dict setObject:value forKey:name];
        }
    }
    
    return dict;
}

// ------------------------

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

@end
