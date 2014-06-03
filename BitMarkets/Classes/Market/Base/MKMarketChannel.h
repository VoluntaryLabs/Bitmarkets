//
//  MKMarketChannel.h
//  Bitmessage
//
//  Created by Steve Dekorte on 3/13/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//
// This object reads messages from the bitmarkets channel,
// creates objects for each as a child to the appropriate
// MKCategory
//

#import <BitMessageKit/BitMessageKit.h>
#import <NavKit/NavKit.h>

@interface MKMarketChannel : NavNode

@property (strong, nonatomic) NSString *passphrase;
@property (strong, nonatomic) BMChannel *channel;

@property (assign, nonatomic) BOOL needsToFetchChannelMessages;
@property (assign, nonatomic) BOOL needsToFetchDirectMessages;

- (void)fetch;

@end
