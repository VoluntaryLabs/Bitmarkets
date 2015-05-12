//
//  MKTransactions.m
//  BitMarkets
//
//  Created by Steve Dekorte on 5/12/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKTransactions.h"

@implementation MKTransactions

- (id)init
{
    self = [super init];
    self.nodeShouldUseCountForNodeNote = @YES;
    self.nodeSuggestedWidth = @350;
    return self;
}

- (NSString *)nodeNote
{
    if (self.children.count > 0)
    {
        return [NSString stringWithFormat:@"%i", (int)self.children.count];
    }
    
    return nil;
}

- (JSONDB *)db
{
    JSONDB *db = [super db];
    db.name = NSStringFromClass(self.class);
    db.location = JSONDB_IN_APP_SUPPORT_FOLDER;
    return db;
}

- (void)write
{
    [super write];
}

- (void)read
{
    [super read];
    [self update];
    [self postParentChainChanged];
}

- (void)removeChild:(id)aChild
{
    [super removeChild:aChild];
    [self write];
}

- (BOOL)canSearch
{
    return self.children.count > 0;
}

/*
- (NSString *)verifyActionMessage:(NSString *)aString
{
    if ([aString isEqualToString:@"delete"])
    {
        return @"Are you sure you want to delete this? If the sale is in progress, you may loose your escrow.";
    }
    
    return nil;
}
*/

- (void)update
{
    for (id child in self.children)
    {
        if ([child respondsToSelector:@selector(update)])
        {
            [child update];
        }
    }
    
    [self writeIfNeeded];
}

- (void)writeIfNeeded
{
    if ([self isDirtyRecursive])
    {
        [self write];
        [self setCleanRecursive];
    }
}

- (void)notifyChainDirty
{
    NSLog(@"%@ notifyChainDirty", NSStringFromClass(self.class));
    //[self write];
}


@end
