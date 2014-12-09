//
//  MKUpdatesSubscription.m
//  Bitmessage
//
//  Created by Steve Dekorte on 3/13/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKUpdatesSubscription.h"
#import <BitMessageKit/BitMessageKit.h>
#import "MKMsg.h"
#import "MKMarkets.h"
#import "MKRootNode.h"

@implementation MKUpdatesSubscription

- (NSString *)nodeTitle
{
    return @"UpdateChannel";
}

- (CGFloat)nodeSuggestedWidth
{
    return 250;
}

- (id)init
{
    self = [super init];
    
    self.updatesAddress = @"";
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                             selector:@selector(subscriptionChanged:)
                                                 name:nil
                                                 //name:NavNodeAddedChildNotification
                                               object:self.subscription];

    self.needsToFetch = YES;
    return self;
}

- (void)dealloc
{
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)subscriptionChanged:(NSNotification *)note
{
    if (!self.needsToFetch)
    {
        self.needsToFetch = YES;
        [self performSelector:@selector(fetch) withObject:self afterDelay:0.0];
    }
}

- (BMSubscription *)subscription
{
    if (!_subscription)
    {
        BMSubscriptions *subscriptions = BMClient.sharedBMClient.subscriptions;
        _subscription = [subscriptions subscriptionWithAddressAddIfNeeded:self.updatesAddress];
    }
    
    return _subscription;
}

- (void)fetch
{
    self.needsToFetch = NO;
    
    NSArray *messages = self.subscription.children.copy;
    
    for (BMReceivedMessage *bmMsg in messages)
    {
        MKMsg *msg = [MKMsg withBMMessage:bmMsg];
        
        /*
        if (msg)
        {
            if ([msg isKindOfClass:MKUpdateMsg.class])
            {
                [MKUpdateMsg handle]; // this will delete it if it's an older version
            }
        }
        */
    }
  
    //NSWindow *window = NSApplication.sharedApplication.mainWindow;
}

@end
