//
//  MKRootNode.m
//  BitMarkets
//
//  Created by Steve Dekorte on 4/15/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKRootNode.h"
#import "MKAppDelegate.h"
#import "MKAboutNode.h"

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
    
    [self addChild:[[MKAboutNode alloc] init]];
    
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
        
        _wallet.refreshInterval = 5.0;
        _wallet.deepRefreshes = YES;
        //_wallet.server.logs = YES;
        
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

- (void)willShutdown
{
    [self.markets.sells write];
    [self.markets.buys write];
}

@end
