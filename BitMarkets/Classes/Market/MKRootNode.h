//
//  MKRootNode.h
//  BitMarkets
//
//  Created by Steve Dekorte on 4/15/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <NavKit/NavKit.h>
#import <BitmessageKit/BitmessageKit.h>

#import "MKMarkets.h"
#import "MKWallet.h"

#import "MKSells.h"
#import "MKBuys.h"

@interface MKRootNode : NavInfoNode

@property (strong, nonatomic) BMClient  *bmClient;
@property (strong, nonatomic) MKMarkets *markets;
@property (strong, nonatomic) MKWallet  *wallet;

+ (MKRootNode *)sharedMKRootNode;

@end
