//
//  MKRootNode.m
//  BitMarkets
//
//  Created by Steve Dekorte on 4/15/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKRootNode.h"
#import "MKAppDelegate.h"

@implementation MKRootNode

static MKRootNode *sharedMKRootNode = nil;

+ (MKRootNode *)sharedMKRootNode
{
    if (sharedMKRootNode == nil)
    {
        sharedMKRootNode = [[self class] alloc];
        sharedMKRootNode = [sharedMKRootNode init]; // not safe
    }
    
    return sharedMKRootNode;
}

- (MKAppDelegate *)appDelegate
{
    return [[NSApplication sharedApplication] delegate];
}

- (id)init
{
    self = [super init];
    
    self.shouldSortChildren = NO;
    self.nodeTitle = @"BitMarkets";
    self.nodeSuggestedWidth = 150;
    
    
    [self.appDelegate setNavTitle:@"launching bitmessage server..."];
    [self setupBMClient];

    [self.appDelegate setNavTitle:@"launching bitcoin wallet server..."];
    [self setupWallet];
    
    [self setupMarkets];
    
    return self;
}

- (void)setupMarkets
{
    [self.appDelegate setNavTitle:@"setting up markets..."];

    _markets = [[MKMarkets alloc] init];
    [_markets read];
    //[self addChild:_markets];
    
    {
        [self addChild:_markets.rootRegion];
        [self addChild:_markets.sells];
        [self addChild:_markets.buys];
    }

    if (_wallet)
    {
        [self addChild:_wallet];
    }
    
    [self addAbout];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willShutdown)
                                                 name:NSApplicationWillTerminateNotification
                                               object:nil];
    
    [self.appDelegate setNavTitle:@""];
}

- (void)setupBMClient
{
    _bmClient = [BMClient sharedBMClient];
    [[_bmClient identities] createFirstIdentityIfAbsent];
}

- (void)setupWallet
{
    if (YES)
    {
        _wallet  = [[BNWallet alloc] init];
        
        /*
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(walletChanged:)
                                                     name:nil
                                                   object:_wallet];
        */
        _wallet.refreshInterval = 5.0;
        _wallet.deepRefreshes = NO;
        _wallet.server.logsStderr = YES;
        NSString *dataPath = [[[NSFileManager defaultManager] applicationSupportDirectory] stringByAppendingPathComponent:@"wallet"];
        NSError *error;
        
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:&error];
        [_wallet setPath:dataPath];
        [_wallet setCheckpointsPath:[[NSBundle bundleForClass:[BNWallet class]] pathForResource:@"checkpoints-testnet" ofType:nil]];
        //[_wallet.server start];

        
    }
}

/*
- (void)walletChanged:(NSNotificationCenter *)aNote
{
    if ([_wallet isRunning] && _markets == nil)
    {
        [self setupMarkets];
    }
}
*/

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
            contributor.nodeSubtitle = @"Lead Developer";
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
