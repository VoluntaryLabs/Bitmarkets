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
#import "MKUpdateMessage.h"

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
    
    self.updatesAddress = @"BM-2cXCTDAitr8PidWfVDiSLdnAADhmSk29iG";
    self.shownMessages = [NSMutableDictionary dictionary];
    
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

- (NSString *)currentVersion
{
    NSDictionary *info = [NSBundle bundleForClass:[self class]].infoDictionary;
    NSString *versionString = [info objectForKey:@"CFBundleVersion"];
    return versionString;
}

- (NSArray *)updateMessagesNewestVersionFirst
{
    NSMutableArray *updateMessages = [NSMutableArray array];
    
    NSArray *bmMessages = self.subscription.children.copy;
    
    for (BMReceivedMessage *bmMessage in bmMessages)
    {
        NSMutableDictionary *updateDict;
        
        @try
        {
            updateDict = [NSMutableDictionary dictionaryWithJsonString:bmMessage.messageString];
        }
        @catch (NSException *exception)
        {
            NSLog(@"error reading update message %@", exception);
            [bmMessage delete];
            continue;
        }

        MKUpdateMessage *message = [[MKUpdateMessage alloc] init];
        [message setDict:updateDict];
        [message setBmMessage:bmMessage];
        [updateMessages addObject:message];
    }

    return [updateMessages sortedArrayUsingSelector:@selector(compare:)];
}

- (void)fetch
{
    // need to get them all and sort them to avoid showing
    // the user old update messages
    
    self.needsToFetch = NO;
    
    NSArray *messages = [self updateMessagesNewestVersionFirst];
    
    MKUpdateMessage *topMessage = messages.firstObject;
    
    if (topMessage && topMessage.isNewer)
    {
        if (![self.shownMessages objectForKey:topMessage.version])
        {
            [topMessage showAlert];
            [self.shownMessages setObject:topMessage forKey:topMessage.version];
        }
    }
    
    for (MKUpdateMessage *message in messages)
    {
        [message deleteIfOlder];
    }
}

@end
