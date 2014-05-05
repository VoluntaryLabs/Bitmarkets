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
    //[self addChild:_markets];
    
    {
        //_markets.rootRegion.nodeTitle = @"Markets";
        [self addChild:_markets.rootRegion];
        [self addChild:_markets.buys];
        [self addChild:_markets.sells];
        [self addChild:_markets.mkChannel];
    }

    if (NO)
    {
        _wallet  = [[BNWallet alloc] init];
        _wallet.refreshInterval = 5.0;
        _wallet.deepRefreshes = YES;
        _wallet.server.logsStderr = YES;
        NSString *dataPath = [[[NSFileManager defaultManager] applicationSupportDirectory] stringByAppendingPathComponent:@"wallet"];
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:&error];
        [_wallet setPath:dataPath];
        [self addChild:_wallet];
    }
    
    
    _bmClient = [BMClient sharedBMClient];
    [[_bmClient identities] createFirstIdentityIfAbsent];
    
    [self addAbout];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willShutdown)
                                                 name:NSApplicationWillTerminateNotification
                                               object:nil];
    
    return self;
}

- (void)willShutdown
{
    [self.markets.sells write];
    [self.markets.buys write];
}

- (void)setupChannel
{
    
}

- (void)addAbout
{
    NavInfoNode *about = [[NavInfoNode alloc] init];
    about.shouldSortChildren = NO;
    [(BMNode *)self addChild:about];
    about.nodeTitle = @"About";
    about.nodeSuggestedWidth = 150;
    
    {
        NavInfoNode *contributors = [[NavInfoNode alloc] init];
        [about addChild:contributors];
        contributors.nodeTitle = @"Contributors";
        contributors.nodeSuggestedWidth = 200;
        contributors.shouldSortChildren = NO;

        {
            NavInfoNode *contributor = [[NavInfoNode alloc] init];
            contributor.nodeTitle = @"Steve Dekorte";
            contributor.nodeSubtitle = @"Lead";
            [contributors addChild:contributor];
        }
        
        {
            NavInfoNode *contributor = [[NavInfoNode alloc] init];
            contributor.nodeTitle = @"Rich Collins";
            contributor.nodeSubtitle = @"Bitcoin";
            [contributors addChild:contributor];
        }
        
        {
            NavInfoNode *contributor = [[NavInfoNode alloc] init];
            contributor.nodeTitle = @"Chris Robinson";
            contributor.nodeSubtitle = @"Design";
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
            contributor.nodeSubtitle = @"Unix";
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
