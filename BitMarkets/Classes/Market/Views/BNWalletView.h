//
//  BNWalletView.h
//  BitMarkets
//
//  Created by Steve Dekorte on 6/26/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKNodeView.h"
#import "MKStatusView.h"

@interface BNWalletView : MKNodeView <NSTableViewDataSource, NSTableViewDelegate>

@property (assign, nonatomic) NavView *navView;

@property (strong, nonatomic) MKStatusView *statusView;
@property (strong, nonatomic) NSScrollView *scrollView;
@property (strong, nonatomic) NSTableView *tableView;
@property (strong, nonatomic) NSTextView *standinText;

@end
