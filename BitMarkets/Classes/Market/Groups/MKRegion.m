//
//  MKRegion.m
//  Bitmessage
//
//  Created by Steve Dekorte on 3/24/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKRegion.h"
#import "MKCategory.h"

@implementation MKRegion

- (id)init
{
    self = [super init];
    self.nodeSuggestedWidth = 150;
    self.nodeShouldSortChildren = @YES;
    return self;
}

- (JSONDB *)db
{
    JSONDB *db = [super db];
    db.name = @"regions.json";
    db.location = JSONDB_IN_APP_WRAPPER;
    return db;
}

- (void)setDict:(NSDictionary *)dict
{
    [super setDict:dict];
    
    if (self.children.count == 0)
    {
        [self setChildren:[MKCategory rootInstance].children];
    }
}

// search

- (BOOL)canSearch
{
    NavNode *firstChild = [self.children firstObject];
    
    if (firstChild && [firstChild isKindOfClass:self.class])
    {
        return YES;
    }
    
    return NO;
}

- (BOOL)nodeMatchesSearch:(NSString *)aString
{
    for (NSString *word in [self.nodeTitle componentsSeparatedByString:@" "])
    {
        if ([word hasPrefix:aString])
        {
            return YES;
        }
    }
    
    return NO;
}

/*
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
*/

@end
