//
//  MKRegion.m
//  Bitmessage
//
//  Created by Steve Dekorte on 3/24/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "MKRegion.h"
#import "MKCategory.h"

@implementation MKRegion

- (id)init
{
    self = [super init];
    //[self setCanPost:NO];
    self.nodeSuggestedWidth = 170;
    self.shouldSortChildren = NO;
    return self;
}

- (JSONDB *)db
{
    JSONDB *db = [super db];
    db.name = @"regions.json";
    db.location = JSONDB_IN_APP_WRAPPER;
    return db;
}

/*
- (NSArray *)modelActions
{
    
}
*/

- (void)setDict:(NSDictionary *)dict
{
    [super setDict:dict];
    
    if (self.children.count == 0)
    {
        //[self addChild:[MKCategory rootInstance]];
        [self setChildren:[MKCategory rootInstance].children];
    }
}

// search

- (BOOL)canSearch
{
    return NO;
    //return YES;
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
