//
//  MKBuys.m
//  Bitmessage
//
//  Created by Steve Dekorte on 3/13/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "MKBuys.h"
#import "MKBuy.h"

@implementation MKBuys

- (id)init
{
    self = [super init];
    self.childClass = MKBuy.class;
    self.shouldUseCountForNodeNote = YES;
    
    [self read];
    return self;
}

- (JSONDB *)db
{
    JSONDB *db = [super db];
    db.name = @"buys";
    db.location = JSONDB_IN_APP_SUPPORT_FOLDER;
    return db;
}

- (void)read
{
    [super read];
    [self update];
}

- (BOOL)canSearch
{
    return self.children.count > 0;
}

- (NSString *)nodeTitle
{
    return @"Buys";
}

- (NSString *)nodeNote
{
    if (self.children.count > 0)
    {
        return [NSString stringWithFormat:@"%i", (int)self.children.count];
    }
    
    return nil;
}

 - (MKBuy *)addBuy;
{
    MKBuy *buy = [[MKBuy alloc] init];
    [self addChild:buy];
    [self postParentChanged];
    //[self write];
    return buy;
}

- (void)removeChild:(id)aChild
{
    [super removeChild:aChild];
    [self write];
}

- (BOOL)handleMsg:(MKMsg *)mkMsg // put in parent class of Buys and Sells
{
    for (MKTransaction *child in self.children)
    {
        if ([child handleMsg:mkMsg])
        {
            return YES;
        }
    }
    
    return NO;
}

- (void)update
{
    for (id child in self.children)
    {
        if ([child respondsToSelector:@selector(update)])
        {
            [child update];
        }
    }
}

@end
