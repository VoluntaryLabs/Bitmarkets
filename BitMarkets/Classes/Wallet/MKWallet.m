//
//  MKWallet.m
//  Bitmessage
//
//  Created by Steve Dekorte on 3/13/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "MKWallet.h"
#import <NavKit/NavKit.h>
#import "MKWalletAddress.h"
#import "MKWalletTx.h"

@implementation MKWallet

- (id)init
{
    self = [super init];
    
    self.nodeTitle = @"Wallet";
    self.nodeSuggestedWidth = 200;

    [self performSelector:@selector(open) withObject:nil afterDelay:0.0];
    return self;
}

- (void)open
{
    _bnWallet = [[BNWallet alloc] init];
    //_bnWallet.server.logsStderr = YES;
    
    NSString *dataPath = [[[NSFileManager defaultManager] applicationSupportDirectory] stringByAppendingPathComponent:@"wallet"];
    
    NSError *error;
    [[NSFileManager defaultManager] createDirectoryAtPath:dataPath
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:&error];
    
    [_bnWallet setPath:dataPath];
    
    [_bnWallet.server start];
    [self update];
}

- (void)addChildren
{
    self.shouldSortChildren = NO;
    
    /*
    {
        _balance = [[NavInfoNode alloc] init];
        //[self addChild:_balance];
        _balance.nodeTitle = @"Balance";
        _balance.nodeSubtitle = @"(unavailable)";
        _balance.nodeSuggestedWidth = 200;
    }
    */
    
    {
        _transactions = [[NavInfoNode alloc] init];
        [self addChild:_transactions];
        _transactions.nodeTitle = @"Transactions";
        _transactions.nodeSuggestedWidth = 480;
        _transactions.shouldUseCountForNodeNote = YES;
        
        for (BNTx *bnTx in _bnWallet.transactions)
        {
            NSLog(@"tx %@", bnTx);

            MKWalletTx *mkTx = [[MKWalletTx alloc] init];
            mkTx.bnTx = bnTx;
            [_transactions addChild:mkTx];
        }
    }

    NSLog(@" wallet transactions %@ ", _bnWallet.transactions);
    
    {
        _addresses = [[MKWalletAddresses alloc] init];
        [self addChild:_addresses];
        //NSLog(@" wallet addresses %@ ", _bnWallet.addresses);
        
        for (BNKey *key in _bnWallet.keys)
        {
            MKWalletAddress *mkAddress = [[MKWalletAddress alloc] init];
            mkAddress.bnKey = key;
            [_addresses addChild:mkAddress];
        }
    }
}

/*
- (NSArray *)uiActions
{
    if (self.isStarted)
    {
        NSArray *uiActions = [NSMutableArray arrayWithObjects:@"deposit", @"withdrawl", nil];
        return  [uiActions arrayByAddingObjectsFromArray:super.uiActions];
    }
    else
    {
        return super.uiActions;
    }
}
*/


- (BOOL)isStarted
{
    NSString *status = _bnWallet.server.status;
    return [status isEqualToString:@"started"];
}

- (void)update
{
    BOOL isStarted = self.isStarted;
    
    if (isStarted && !_isOpen)
    {
        _isOpen = YES;
        [self addChildren];
    }
    
    NSString *balanceSubtitle = nil;
    
    if (isStarted)
    {
        float balanceValue = self.bnWallet.balance.floatValue;
        balanceSubtitle = [NSString stringWithFormat:@"%.4f BTC", balanceValue*0.00000001];
    }
    else
    {
        balanceSubtitle = @"starting...";
    }

    //_balance.nodeSubtitle = balanceSubtitle;
    //[_balance postParentChanged];
    
    self.nodeSubtitle = balanceSubtitle;
    [self postParentChanged];

    NSTimeInterval updateDelay = isStarted ? 60.0 : 1.0;
    [self performSelector:@selector(update) withObject:nil afterDelay:updateDelay];
}

/*
- (void)deposit
{
    NSString *address = [_bnWallet createAddress];
    _imageView.image = [QRCodeGenerator qrImageForString:address imageSize:256.0];
    
    [_textField setStringValue:[NSString stringWithFormat:@"Insufficient Value.  Please send %@ to %@", amount, address]];
}

- (void)withdrawl
{
    
}
*/

@end
