//
//  MKTransaction.m
//  BitMarkets
//
//  Created by Steve Dekorte on 5/3/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKTransaction.h"

@implementation MKTransaction

- (id)init
{
    self = [super init];
    self.shouldSortChildren = NO;

    self.mkPost = [[MKPost alloc] init];
    [self addChild:self.mkPost];
    
    return self;
}

- (NSArray *)visibleStages
{
    return self.children;
}

- (MKStage *)currentStage
{
    MKStage *stage = nil;
    
    for (stage in self.children)
    {
        if (stage.isActive)
        {
            return stage;
        }
    }
    
    return stage;
}

- (NSArray *)stages
{
    return self.children;
}

- (NSString *)statusTitle
{
    NavNode *node = self.currentStage;
    
    if (node)
    {
        return node.nodeTitle;
    }
    
    return @"-";
}

- (NSString *)nodeSubtitleDetailed
{
    NavNode *node = self.currentStage;
    
    if (node)
    {
        return node.nodeSubtitle;
    }
    
    return @"-";
}

- (NSString *)nodeTitle
{
    return self.mkPost.titleOrDefault;
}

- (NSString *)nodeSubtitle
{
    if (self.error)
    {
        return self.error;
    }
    
    return [NSString stringWithFormat:@"%@BTC", self.mkPost.priceInBtc];
}

- (NSString *)nodeNote
{
    if (self.error || self.didFail)
    {
        return @"✗";
    }
    
    if (self.isActive)
    {
        return @"●";
    }
    
    if (self.isComplete)
    {
        return @"✓";
    }
    
    return nil;
}


- (void)setDict:(NSDictionary *)dict
{
    [super setDict:dict];
    
    self.mkPost = [self.children firstObjectOfClass:MKPost.class];
}

// -------------------------

- (NSArray *)modelActions
{
    return [NSArray arrayWithObjects:@"delete", nil];
}

// -------------------------

/*
- (MKMsg *)msgInstanceOfClass:(Class)aClass
{
    
}
*/
 

- (BOOL)handleMsg:(MKMsg *)msg
{    
    if ([self.mkPost.postUuid isEqualToString:msg.postUuid])
    {
        [super handleMsg:msg];
    }
    
    return NO;
}

// -------------------

- (void)update
{
    self.error = nil;
    
    for (NavNode *child in self.children)
    {
        if ([child respondsToSelector:@selector(update)])
        {
            @try
            {
                [(id)child update];
            }
            @catch (NSException *exception)
            {
                self.error = @"update error";
            }

        }
    }
    
    [self postSelfChanged];
}

- (BOOL)isActive
{
    for (id child in self.children)
    {
        if ([child respondsToSelector:@selector(isActive)])
        {
            if ([child isActive])
            {
                return YES;
            }
        }
    }
    
    return NO;
}

- (BOOL)isComplete
{
    for (id child in self.children)
    {
        if ([child respondsToSelector:@selector(isComplete)])
        {
            if (![child isComplete])
            {
                return NO;
            }
        }
    }
    
    return YES;
}

- (BOOL)didFail
{
    return NO;
}

@end
