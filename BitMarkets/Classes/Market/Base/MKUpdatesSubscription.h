//
//  MKUpdatesSubscription.h
//  Bitmessage
//
//  Created by Steve Dekorte on 3/13/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//
// This object reads messages from the bitmarkets channel,
// creates objects for each as a child to the appropriate
// MKCategory
//

#import <BitMessageKit/BitMessageKit.h>
#import <NavKit/NavKit.h>

@interface MKUpdatesSubscription : NavNode

@property (strong, nonatomic) NSString *updatesAddress;
@property (strong, nonatomic) BMSubscription *subscription;

@property (assign) BOOL needsToFetch;

@property (strong, nonatomic) NSMutableDictionary *shownMessages;

- (void)fetch;

@end
