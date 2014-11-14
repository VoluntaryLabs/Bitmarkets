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

- nodeAbout
{
    return [[MKAboutNode alloc] init];
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
    
    [self addChild:[[NavAppAbout alloc] init]];
    
    if (YES)
    {
        //[self [BMClient sharedBMClient]];
    }
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                             selector:@selector(willShutdown)
                                                 name:NSApplicationWillTerminateNotification
                                               object:nil];
    
    [self.appDelegate setNavTitle:@""];
}

- (void)setupBMClient
{
    _bmClient = [BMClient sharedBMClient];
    
    if (!self.bitmarketsUserIdentity)
    {
        [_bmClient.identities createRandomAddressWithLabel:self.bitmarketsIdentityLabel];
    }
}

- (NSString *)bitmarketsIdentityLabel
{
    return @"bitmarkets user indentity";
}

- (BMIdentity *)bitmarketsUserIdentity
{
    BMIdentity *identity = [_bmClient.identities identityWithLabel:self.bitmarketsIdentityLabel];
    return identity;
}

- (void)setupWallet
{
    if (YES)
    {
        _wallet  = [[BNWallet alloc] init];
        
        _wallet.usesTestNet = NO;
        _wallet.refreshInterval = 5.0;
        _wallet.deepRefreshes = YES;
        
        NSString *walletName = @"BitnashKit/mainnet";
        
        if (_wallet.usesTestNet)
        {
            walletName = @"BitnashKit/testnet";
        }
        
        NSString *dataPath = [[[NSFileManager defaultManager] applicationSupportDirectory] stringByAppendingPathComponent:walletName];
        
        NSError *error;
        
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:&error];
        
        [_wallet setPath:dataPath];
        
        NSString *checkpointsName = @"checkpoints-mainnet";
        
        if (_wallet.usesTestNet)
        {
            checkpointsName = @"checkpoints-testnet";
        }
        
        [_wallet setCheckpointsPath:[[NSBundle bundleForClass:[BNWallet class]] pathForResource:checkpointsName ofType:nil]];
        
        [BNMetaDataDb shared].path = [[[NSFileManager defaultManager] applicationSupportDirectory] stringByAppendingPathComponent:@"wallet/meta-data"];
        
        //_wallet.requiredConfirmations = @0; //This will start server
        
        [NSNotificationCenter.defaultCenter addObserver:self
                                                 selector:@selector(walletChanged:)
                                                     name:nil
                                                   object:_wallet];
    }
}

- (void)dealloc
{
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)walletChanged:(NSNotification *)aNote
{
    [NSNotificationCenter.defaultCenter postNotificationName:@"WalletChanged" object:nil];
}

- (void)willShutdown
{
    [self.markets.sells write];
    [self.markets.buys write];
}

@end
