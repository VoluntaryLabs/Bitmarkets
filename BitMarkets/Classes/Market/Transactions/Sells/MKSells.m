//
//  MKSells.m
//  Bitmessage
//
//  Created by Steve Dekorte on 3/13/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import <BitmessageKit/BitmessageKit.h>
#import "MKSells.h"
#import "MKSell.h"
#import "MKMsg.h"

@implementation MKSells

- (id)init
{
    self = [super init];
    self.shouldUseCountForNodeNote = YES;
    return self;
}

- (JSONDB *)db
{
    JSONDB *db = [super db];
    db.name = @"sells";
    db.location = JSONDB_IN_APP_SUPPORT_FOLDER;
    return db;
}

- (void)read
{
    [super read];
    [self update];
}

- (NSString *)nodeTitle
{
    return @"Sells";
}

- (NSString *)nodeNote
{
    if (self.children.count > 0)
    {
        return [NSString stringWithFormat:@"%i", (int)self.children.count];
    }
    
    return nil;
}


- (BOOL)canSearch
{
    return self.children.count > 0;
}

- (MKSell *)justAdd
{
    MKSell *sell = [[MKSell alloc] init];
    [self addChild:sell];
    return sell;
}

- (void)add
{
    [self justAdd];
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
