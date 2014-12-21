//
//  MKGroup.m
//  Bitmessage
//
//  Created by Steve Dekorte on 3/24/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKGroup.h"
#import <BitmessageKit/BitmessageKit.h>
#import <FoundationCategoriesKit/FoundationCategoriesKit.h>
#import "MKCategory.h"
#import "MKRootNode.h"

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
    self.nodeSuggestedWidth = 180;
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

- (void)setName:(NSString *)name
{
    _name = name;
    self.nodeTitle = name;
}

- (void)setDict:(NSDictionary *)dict
{
    for (NSString *key in dict.allKeys)
    {
        // need to generalize children/type properties
        
        if (![key isEqualToString:@"children"] && ![key isEqualToString:@"_type"])
        {
            id value = [dict objectForKey:key];

            //if ([self respondsToSelector:key.asSetterString])
            {
                [self callSetter:key withValue:value];
            }
        }
    }
    
    
    
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
            else
            {
                [NSException raise:@"Missing _type slot in persisted dictionary" format:nil];

            }

            if (childClass)
            {
                self.childClass = childClass;
            }
            else
            {
                [NSException raise:@"Error unserializing dictionary" format:@"Can't find _type class '%@'", className];
            }
            
            NavNode *child = [childClass withDict:childDict];
            [children addObject:child];
            [child setNodeParent:self];
            //NSLog(@"read child %@ %@", NSStringFromClass(child.class), child.nodeTitle);
        }
        
        [self setChildren:children];
        
        if (self.nodeShouldSortChildren.boolValue)
        {
            [self sortChildren];
        }
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
        NSDictionary *dict = [child dict];
        if (dict == nil)
        {
            NSLog(@"nill child dict");
            [child dict];
        }
        [childrenDicts addObject:dict];
    }
    
    return childrenDicts;
}

// properties

- (void)addPropertyName:(NSString *)aName
{
    [self.dictPropertyNames addObject:aName];
}

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
        [self noWarningPerformSelector:setterSelector withObject:aValue];
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
        id value = [self idNoWarningPerformSelector:getterSelector];
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


- (NSArray *)groupNamePath
{
   // if ([self.nodeParent isKindOfClass:self.class])
    if ([self.nodeParent respondsToSelector:@selector(groupNamePath)])
    {
        MKGroup *parentCat = (MKGroup *)self.nodeParent;
        return [[parentCat groupNamePath] arrayByAddingObject:self.name];
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
            [paths addObject:cat.groupNamePath];
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

- (BNWallet *)runningWallet
{
    BNWallet *wallet = MKRootNode.sharedMKRootNode.wallet;
    
    if (wallet.isRunning)
    {
        return wallet;
    }
    
    return nil;
}

@end
