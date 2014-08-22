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
        NavInfoNode *version = [[NavInfoNode alloc] init];
        version.nodeTitle = @"Version";
        version.nodeSubtitle = @"0.8 beta";
        [about addChild:version];
        
        NavInfoNode *contributors = [[NavInfoNode alloc] init];
        [about addChild:contributors];
        contributors.nodeTitle = @"Credits";
        contributors.nodeSuggestedWidth = 200;
        contributors.shouldSortChildren = NO;
        
        NavInfoNode *legal = [[NavInfoNode alloc] init];
        [about addChild:legal];
        legal.nodeTitle = @"Legal";
        legal.nodeSuggestedWidth = 200;
        legal.shouldSortChildren = NO;
        
        NavInfoNode *voluntary = [[NavInfoNode alloc] init];
        voluntary.nodeTitle = @"Voluntary.net";
        voluntary.nodeSubtitle = nil;
        [contributors addChild:voluntary];
        
        {
            NavInfoNode *contributor = [[NavInfoNode alloc] init];
            contributor.nodeTitle = @"Steve Dekorte";
            contributor.nodeSubtitle = @"Lead & UI Developer";
            [voluntary addChild:contributor];
        }
        
        {
            NavInfoNode *contributor = [[NavInfoNode alloc] init];
            contributor.nodeTitle = @"Rich Collins";
            contributor.nodeSubtitle = @"Bitcoin Integration";
            [voluntary addChild:contributor];
        }
        
        {
            NavInfoNode *contributor = [[NavInfoNode alloc] init];
            contributor.nodeTitle = @"Chris Robinson";
            contributor.nodeSubtitle = @"UI/UX Designer";
            [voluntary addChild:contributor];
        }
        
        {
            NavInfoNode *contributor = [[NavInfoNode alloc] init];
            contributor.nodeTitle = @"Adam Thorsen";
            contributor.nodeSubtitle = @"Tor, Bitmessage integration";
            [voluntary addChild:contributor];
        }
        
        {
            NavInfoNode *contributor = [[NavInfoNode alloc] init];
            contributor.nodeTitle = @"Dru Nelson";
            contributor.nodeSubtitle = @"Unix Guru";
            [voluntary addChild:contributor];
        }
 
        
        NavInfoNode *others = [[NavInfoNode alloc] init];
        [contributors addChild:others];
        others.nodeTitle = @"3rd Party";
        others.nodeSuggestedWidth = 200;
        others.shouldSortChildren = NO;
        
        {
            NavInfoNode *package = [[NavInfoNode alloc] init];
            package.nodeTitle = @"BitcoinJ";
            package.nodeSubtitle = @"github.com/bitcoinj";
            [others addChild:package];
        }
        
        {
            NavInfoNode *package = [[NavInfoNode alloc] init];
            package.nodeTitle = @"Bitmessage";
            package.nodeSubtitle = @"bitmessage.org";
            [others addChild:package];
        }
 
        {
            NavInfoNode *package = [[NavInfoNode alloc] init];
            package.nodeTitle = @"Open Sans";
            package.nodeSubtitle = @"Steve Matteson, Google fonts";
            [others addChild:package];
        }
        
        {
            NavInfoNode *package = [[NavInfoNode alloc] init];
            package.nodeTitle = @"Python";
            package.nodeSubtitle = @"python.org";
            [others addChild:package];
        }
        
        {
            NavInfoNode *package = [[NavInfoNode alloc] init];
            package.nodeTitle = @"Tor";
            package.nodeSubtitle = @"torproject.org";
            [others addChild:package];
        }

        {
            NavInfoNode *package = [[NavInfoNode alloc] init];
            package.nodeTitle = @"XmlPRC";
            package.nodeSubtitle = @"Eric Czarny";
            [others addChild:package];
        }
        
        {
            NavInfoNode *package = [[NavInfoNode alloc] init];
            package.nodeTitle = @"ZipKit";
            package.nodeSubtitle = @"Karl Moskowski";
            [others addChild:package];
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
