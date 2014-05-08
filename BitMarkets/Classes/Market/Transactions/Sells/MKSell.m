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
    
    //[self.dictPropertyNames addObjectsFromArray:
     //       @[@"mkPost", @"bids", @"lockEscrow", @"delivery", @"releaseEscrow"]];
    
    return self;
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:nil object:self.mkPost];
    
    [super setMkPost:mkPost];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changedPost:)
                                                 name:nil
                                               object:self.mkPost];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)changedPost:(NSNotification *)note
{
    NSLog(@"changedPost");
    [self postParentChanged];
}

// ---------------------------


// -------------------

- (BOOL)handleMsg:(MKMsg *)msg
{
    //NSLog(@"%@ handleMsg: %@", self.className, msg.postUuid);
    
    if ([self.mkPost.postUuid isEqualToString:msg.postUuid])
    {
        for (id child in self.children)
        {
            if ([child respondsToSelector:@selector(handleMsg:)])
            {
                [child handleMsg:msg];
            }
        }
    }
    
    return NO;
}

// -----------------------


@end
