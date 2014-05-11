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

    self.mkPost     = [[MKPost alloc] init];
    [self addChild:self.mkPost];
    
    
    return self;
}

- (NSString *)nodeTitle
{
    return self.mkPost.titleOrDefault;
}

- (NSString *)nodeSubtitle
{
    return [NSString stringWithFormat:@"%@BTC", self.mkPost.price];
}

- (void)setDict:(NSDictionary *)dict
{
    [super setDict:dict];
    
    self.mkPost   = [self.children firstObjectOfClass:MKPost.class];
}

// -------------------------

- (NSArray *)modelActions
{
    return [NSArray arrayWithObjects:@"delete", nil];
}

// -------------------------


- (BOOL)handleMsg:(MKMsg *)msg
{
    //NSLog(@"%@ handleMsg: %@", self.className, msg.postUuid);
    
    if ([self.mkPost.postUuid isEqualToString:msg.postUuid])
    {
        for (id child in self.children)
        {
            if ([child respondsToSelector:@selector(handleMsg:)])
            {
                [child handleMsg:msg];
            }
        }
    }
    
    return NO;
}

// -------------------

- (void)update
{
    for (NavNode *child in self.children)
    {
        if ([child respondsToSelector:@selector(update)])
        {
            [(id)child update];
        }
    }
}

@end
