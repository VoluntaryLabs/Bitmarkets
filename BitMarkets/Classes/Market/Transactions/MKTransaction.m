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
    
    self.messages = [[MKMessages alloc] init];
    [self addChild:self.messages];
    

    return self;
}

- (void)setMkPost:(MKPost *)mkPost
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:nil object:self.mkPost];

    _mkPost = mkPost;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changedPost:)
                                                 name:nil
                                               object:self.mkPost];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)changedPost:(NSNotification *)note
{
    NSLog(@"changedPost");
    [self postParentChanged];
}

// -------------------------

- (void)setDict:(NSDictionary *)dict
{
    [super setDict:dict];
    
    self.mkPost   = [self.children firstObjectOfClass:MKPost.class];
    self.messages = [self.children firstObjectOfClass:MKMessages.class];
}

- (NSArray *)modelActions
{
    return [NSArray arrayWithObjects:@"delete", nil];
}

- (NSString *)nodeTitle
{
    return self.mkPost.titleOrDefault;
}

- (NSString *)nodeSubtitle
{
    MKMsg *msg = self.messages.children.lastObject;
    return msg.nodeTitle;
    //return [NSString stringWithFormat:@"last message:", msg.nodeTitle];
}

@end
