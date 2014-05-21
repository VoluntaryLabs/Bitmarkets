//
//  MKAboutNode.m
//  BitMarkets
//
//  Created by Steve Dekorte on 5/21/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKAboutNode.h"

@implementation MKAboutNode


- (id)init
{
    self = [super init];
    
    self.shouldSortChildren = NO;
    self.nodeTitle = @"About";
    self.nodeSuggestedWidth = 150;
    
    [self addAbout];
    
    return self;
}

- (void)addAbout
{
    NavInfoNode *about = self;
    
    {
        NavInfoNode *contributors = [[NavInfoNode alloc] init];
        [about addChild:contributors];
        contributors.nodeTitle = @"Contributors";
        contributors.nodeSuggestedWidth = 200;
        contributors.shouldSortChildren = NO;
        
        {
            NavInfoNode *contributor = [[NavInfoNode alloc] init];
            contributor.nodeTitle = @"Steve Dekorte";
            contributor.nodeSubtitle = @"Lead Developer";
            [contributors addChild:contributor];
            
            //NavMirror *navMirror = contributor.navMirror;
            //NavSlot *slot = [navMirror newDataSlotWithName:@"name"];
            
        }
        
        {
            NavInfoNode *contributor = [[NavInfoNode alloc] init];
            contributor.nodeTitle = @"Rich Collins";
            contributor.nodeSubtitle = @"Bitcoin Integration";
            [contributors addChild:contributor];
        }
        
        {
            NavInfoNode *contributor = [[NavInfoNode alloc] init];
            contributor.nodeTitle = @"Chris Robinson";
            contributor.nodeSubtitle = @"Designer";
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
    
    {
        NavInfoNode *howto = [[NavInfoNode alloc] init];
        [about addChild:howto];
        howto.nodeTitle = @"How to";
        howto.nodeSuggestedWidth = 200;
        howto.shouldSortChildren = NO;
        
        {
            NavInfoNode *item = [[NavInfoNode alloc] init];
            item.nodeTitle = @"Post a sale";
            [howto addChild:item];
        }
        
        {
            NavInfoNode *item = [[NavInfoNode alloc] init];
            item.nodeTitle = @"Buy an item";
            [howto addChild:item];
        }
    }
}

@end
