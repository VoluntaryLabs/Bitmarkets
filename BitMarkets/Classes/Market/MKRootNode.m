//
//  MKRootNode.m
//  BitMarkets
//
//  Created by Steve Dekorte on 4/15/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKRootNode.h"

@implementation MKRootNode

static MKRootNode *sharedMKRootNode = nil;

+ (MKRootNode *)sharedMKRootNode
{
    if (sharedMKRootNode == nil)
    {
        sharedMKRootNode = [[self class] alloc];
        sharedMKRootNode = [sharedMKRootNode init];
    }
    
    return sharedMKRootNode;
}

- (id)init
{
    self = [super init];
    
    self.shouldSortChildren = NO;
    self.nodeTitle = @"BitMarkets";
    self.nodeSuggestedWidth = 150;
    
    _markets = [[MKMarkets alloc] init];
    [self addChild:_markets];

    _wallet  = [[MKWallet alloc] init];
    [self addChild:_wallet];
    
    //_bmClient = [BMClient sharedBMClient];
    
    [self addAbout];
    
    [[[BMClient sharedBMClient] identities] createFirstIdentityIfAbsent];
    
    return self;
}

- (void)setupChannel
{
    
}

- (void)addAbout
{
    NavInfoNode *about = [[NavInfoNode alloc] init];
    [(BMNode *)self addChild:about];
    about.nodeTitle = @"About";
    about.nodeSuggestedWidth = 150;
    
    NavInfoNode *contributors = [[NavInfoNode alloc] init];
    [about addChild:contributors];
    contributors.nodeTitle = @"Contributors";
    contributors.nodeSuggestedWidth = 200;
    
    {
        NavInfoNode *contributor = [[NavInfoNode alloc] init];
        contributor.nodeTitle = @"Chris Robinson";
        contributor.nodeSubtitle = @"Designer";
        [contributors addChild:contributor];
    }
    
    {
        NavInfoNode *contributor = [[NavInfoNode alloc] init];
        contributor.nodeTitle = @"Rich Collins";
        contributor.nodeSubtitle = @"Bitcoin integration";
        [contributors addChild:contributor];
    }
    
    {
        NavInfoNode *contributor = [[NavInfoNode alloc] init];
        contributor.nodeTitle = @"Steve Dekorte";
        contributor.nodeSubtitle = @"Lead & UI Dev";
        [contributors addChild:contributor];
    }
    
    {
        NavInfoNode *contributor = [[NavInfoNode alloc] init];
        contributor.nodeTitle = @"Adam Thorsen";
        contributor.nodeSubtitle = @"Generalist";
        [contributors addChild:contributor];
    }
    
    {
        NavInfoNode *contributor = [[NavInfoNode alloc] init];
        contributor.nodeTitle = @"Dru Nelson";
        contributor.nodeSubtitle = @"Unix Guru";
        [contributors addChild:contributor];
    }
}

@end
