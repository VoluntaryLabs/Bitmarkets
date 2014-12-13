//
//  MKAboutNode.m
//  BitMarkets
//
//  Created by Steve Dekorte on 5/21/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKAboutNode.h"
#import <BitmessageKit/BitmessageKit.h>

@implementation MKAboutNode


- (id)init
{
    self = [super init];
    
    self.shouldSortChildren = NO;
    self.nodeTitle = @"Bitmarkets";
    self.nodeSubtitle = self.versionString;
    self.nodeSuggestedWidth = 150;
    self.shouldSortChildren = NO;
    
    [self addAbout];
    
    return self;
}

- (id)nodeRoot
{
    return nil;
}

- (id)nodeAbout
{
    return nil;
}

- (NSArray *)aboutNodes
{
    NSArray *allBundles = [NSBundle.allBundles arrayByAddingObjectsFromArray:NSBundle.allFrameworks];
    NSMutableArray *results = [NSMutableArray array];
    
    for (NSBundle *bundle in allBundles)
    {
        NSLog(@"bundle: '%@'", bundle.bundleIdentifier);
        NSString *bundleClassName = [bundle.bundleIdentifier componentsSeparatedByString:@"."].lastObject;
        Class bundleClass = NSClassFromString(bundleClassName);
        
        if (bundleClass && [bundleClass respondsToSelector:@selector(nodeRoot)])
        {
            id bundleNode = [bundleClass nodeRoot];
            if ([bundleNode respondsToSelector:@selector(nodeAbout)])
            {
                [results addObject:[bundleNode nodeAbout]];
            }
        }
        
    }
    
    return results;
}

- (NSString *)versionString
{
    NSDictionary *info = [NSBundle bundleForClass:[self class]].infoDictionary;
    NSString *versionString = [info objectForKey:@"CFBundleVersion"];
    return [NSString stringWithFormat:@"version %@", versionString];
}

- (void)addAbout
{
    NavInfoNode *root = self;
    
    /*
    NavInfoNode *root = [[NavInfoNode alloc] init];
    root.nodeTitle = @"Bitmarkets";
    root.nodeSubtitle = self.versionString;
    root.shouldSortChildren = NO;
    [self addChild:root];
    [self addChild:BMClient.sharedBMClient.aboutNode];
     */
    
    {
        /*
        NavInfoNode *version = [[NavInfoNode alloc] init];
        version.nodeTitle = @"Version";
        version.nodeSubtitle = self.versionString;
        [root addChild:version];
        */
        
        /*
        NavInfoNode *legal = [[NavInfoNode alloc] init];
        [root addChild:legal];
        legal.nodeTitle = @"Legal";
        legal.nodeSuggestedWidth = 200;
        legal.shouldSortChildren = NO;
        */
        
        NavInfoNode *contributors = [[NavInfoNode alloc] init];
        [root addChild:contributors];
        contributors.nodeTitle = @"Credits";
        contributors.nodeSuggestedWidth = 200;
        contributors.shouldSortChildren = NO;
        
        
        /*
        NavInfoNode *voluntary = [[NavInfoNode alloc] init];
        voluntary.nodeTitle = @"Voluntary.net";
        voluntary.nodeSubtitle = nil;
        [contributors addChild:voluntary];
        */
        
        {
            NavInfoNode *contributor = [[NavInfoNode alloc] init];
            contributor.nodeTitle = @"Steve Dekorte";
            contributor.nodeSubtitle = @"Lead & UI Developer";
            [contributors addChild:contributor];
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
 
        
        NavInfoNode *others = [[NavInfoNode alloc] init];
        [contributors addChild:others];
        others.nodeTitle = @"3rd Party";
        others.nodeSuggestedWidth = 200;
        others.shouldSortChildren = NO;
        
        {
            NavInfoNode *package = [[NavInfoNode alloc] init];
            package.nodeTitle = @"BitcoinJ";
            package.nodeSubtitle = @"github.com/bitcoinj";
            package.nodeResourceName = @"licenses/bitcoinj_license.txt";

            [others addChild:package];
        }
 
        {
            NavInfoNode *package = [[NavInfoNode alloc] init];
            package.nodeTitle = @"Open Sans";
            package.nodeSubtitle = @"Steve Matteson, Google fonts";
            package.nodeResourceName = @"licenses/opensans_license.txt";
            [others addChild:package];
        }
        
    }
    
    /*
    {
        NavInfoNode *howto = [[NavInfoNode alloc] init];
        [root addChild:howto];
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
    */
}

@end
