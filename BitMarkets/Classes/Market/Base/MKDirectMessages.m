//
//  MKDirectMessages.m
//  Bitmarkets
//
//  Created by Steve Dekorte on 12/8/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKDirectMessages.h"

#import <BitMessageKit/BitMessageKit.h>
#import "MKMsg.h"
#import "MKSell.h"
#import "MKMarkets.h"
#import "MKRootNode.h"
#import "MKClosePostMsg.h"

@implementation MKDirectMessages

- (NSString *)nodeTitle
{
    return @"Direct Messages";
}

- (CGFloat)nodeSuggestedWidth
{
    return 250;
}


- (id)init
{
    self = [super init];
    
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(receivedMessagesChanged:)
     //name:NavNodeAddedChildNotification
                                               name:nil
                                             object:BMClient.sharedBMClient.messages.received];
    
    self.needsToFetch = YES;
    return self;
}

- (void)dealloc
{
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)receivedMessagesChanged:(NSNotification *)note
{
    if (!self.needsToFetch)
    {
        self.needsToFetch = YES;
        [self performSelector:@selector(fetchDirectMessages) withObject:self afterDelay:0.0];
    }
}

- (void)fetch
{
    [self fetchDirectMessages];
    [self expireDirectMessages]; // really only need to do this once daily
}

- (void)fetchDirectMessages
{
    self.needsToFetch = NO;
    
    NSArray *inboxMessages = BMClient.sharedBMClient.messages.received.children.copy;
    [self handleBMMessages:inboxMessages];
}

- (void)expireDirectMessages
{
    NSUInteger daysTillExpire = 356;
    NSArray *messages = BMClient.sharedBMClient.messages.received.children.copy;
    
    for (BMReceivedMessage *bmMsg in messages)
    {
        NSTimeInterval ttlSeconds = 60*60*24*daysTillExpire;
        
        if (bmMsg.ageInSeconds > ttlSeconds)
        {
            [bmMsg delete];
        }
    }
}

- (void)handleBMMessages:(NSArray *)bmMessages
{
    NSArray *inboxMessages = BMClient.sharedBMClient.messages.received.children.copy;
    MKMarkets *markets = MKRootNode.sharedMKRootNode.markets;
    
    for (BMMessage *bmMessage in inboxMessages)
    {
        //if (!bmMessage.isRead) // causes problem with msgs to self (eg buy own item for testing)
        {
            MKMsg *msg = [MKMsg withBMMessage:bmMessage];
            
            if (!msg)
            {
                NSLog(@"invalid message '%@'", bmMessage.subjectString);
                [bmMessage delete];
                continue;
            }
            
            BOOL didHandle = [markets handleMsg:msg];
            
            if (didHandle)
            {
                //[bmMessage delete];
            }
            else
            {
                NSLog(@"unable to handle direct message '%@'", bmMessage.subjectString);
                [bmMessage delete];
            }
            
            [bmMessage markAsRead];
        }
    }
}

@end