//
//  MKWalletAddress.m
//  BitMarkets
//
//  Created by Steve Dekorte on 4/29/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKWalletAddress.h"
#import "MKRootNode.h"

@implementation MKWalletAddress

- (id)init
{
    self = [super init];
    return self;
}

- (NSString *)nodeTitle
{
    return self.bnKey.address;
}

- (NSString *)nodeSubtitle
{
    //NSDate *date = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)self.bnKey.creationTime.doubleValue];

    //return [NSString stringWithFormat:@"created %@ (%@)", [date itemDateString], self.bnKey.creationTime];

    /*
    return [self.bnKey.creationDate
            descriptionWithCalendarFormat:@"%I:%M:%S %p  %b %d %Y" timeZone:nil
            locale:[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]];
    */
    
    return [self.bnKey.creationDate
            descriptionWithCalendarFormat:@"%Y %b %d %l:%M:%S %p" timeZone:nil
            locale:[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]];
}

- (void)generate
{
    self.bnKey = self.wallet.bnWallet.createKey;
}

- (MKWallet *)wallet
{
    return MKRootNode.sharedMKRootNode.wallet;
}

@end
