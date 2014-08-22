//
//  MKSell.m
//  Bitmessage
//
//  Created by Steve Dekorte on 3/21/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "MKSell.h"
#import "MKMsg.h"

#import <NavKit/NavKit.h>
#import <BitmessageKit/BitmessageKit.h>
#import <FoundationCategoriesKit/FoundationCategoriesKit.h>

#import "MKRootNode.h"
#import "MKExchangeRate.h"
#import "MKPostMsg.h"

@implementation MKSell

- (id)init
{
    self = [super init];
    self.nodeSuggestedWidth = 300;

    self.bids = [[MKSellBids alloc] init];
    [self addChild:self.bids];

    self.lockEscrow = [[MKSellLockEscrow alloc] init];
    [self addChild:self.lockEscrow];

    self.delivery = [[MKSellDelivery alloc] init];
    [self addChild:self.delivery];

    self.releaseEscrow = [[MKSellReleaseEscrow alloc] init];
    [self addChild:self.releaseEscrow];

    self.complete = [[MKSellComplete alloc] init];
    [self addChild:self.complete];
    
    self.nodeViewClass = MKTransactionProgressView.class;

    return self;
}

- (MKStage *)currentStage
{
    MKStage *stage = [super currentStage];
    //NSLog(@"%@ currentStage %@", self.className, stage.className);
    return stage;
}

- (BOOL)isCanceled
{
    return self.lockEscrow.isCancelConfirmed;
}

- (MKSells *)sells
{
    return (MKSells *)self.nodeParent;
}

- (NSString *)nodeNote
{
    if (self.releaseEscrow.isComplete)
    {
        return @"✓";
    }
    
    if (self.isCanceled)
    {
        return @"✗";
    }
    
    return @"●";
}

- (NSString *)nodeSubtitle
{
    NSString *subtitle = [super nodeSubtitle];
    NSString *status = self.releaseEscrow.shortStatus;
    
    if (self.isCanceled)
    {
        status = @"canceled";
    }
    
    if (status)
    {
        subtitle = [NSString stringWithFormat:@"%@ %@", subtitle, status];
    }
    
    return subtitle;
}

- (CGFloat)nodeSuggestedWidth
{
    return 250.0;
}

- (NSString *)verifyActionMessage:(NSString *)aString
{
    if ([aString isEqualToString:@"delete"])
    {
        return @"Are you sure you want to delete this Sell? If the sale is in progress, you may loose your escrow.";
    }
    
    return nil;
}

// ------------------

- (void)setDict:(NSDictionary *)dict
{
    [super setDict:dict];
    
    self.bids          = [self.children firstObjectOfClass:MKSellBids.class];
    self.lockEscrow    = [self.children firstObjectOfClass:MKSellLockEscrow.class];
    self.delivery      = [self.children firstObjectOfClass:MKSellDelivery.class];
    self.releaseEscrow = [self.children firstObjectOfClass:MKSellReleaseEscrow.class];
}


// updating the post title while editing ----------------------

- (void)setMkPost:(MKPost *)mkPost
{
    [NSNotificationCenter.defaultCenter removeObserver:self name:nil object:self.mkPost];
    
    [super setMkPost:mkPost];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                             selector:@selector(changedPost:)
                                                 name:nil
                                               object:self.mkPost];
}

- (void)dealloc
{
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)changedPost:(NSNotification *)note
{
    //NSLog(@"changedPost");
    [self postParentChanged];
}

// ---------------------------

- (MKBidMsg *)acceptedBidMsg
{
    return self.bids.acceptedBid.bidMsg;
}

- (BOOL)handleMsg:(MKMsg *)msg
{
    //NSLog(@"%@ handleMsg: %@", self.className, msg.postUuid);
    
    if ([self.mkPost.postUuid isEqualToString:msg.postUuid])
    {
        for (id child in self.children)
        {
            if ([child respondsToSelector:@selector(handleMsg:)])
            {
                BOOL didHandle = [child handleMsg:msg];
                
                if (didHandle)
                {
                    return YES;
                }
            }
        }
    }
    
    return NO;
}

// -----------------------

- (BOOL)isBuy
{
    return NO;
}


@end
