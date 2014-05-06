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

- (BOOL)handleMsg:(MKMsg *)mkMsg
{

    return NO;
}

@end
