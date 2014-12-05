//
//  MKPost.m
//  BitMarkets
//
//  Created by Steve Dekorte on 5/1/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKPost.h"
#import "MKPostMsg.h"
#import "MKBidMsg.h"
#import "MKSell.h"
#import "MKRootNode.h"
#import <BitnashKit/BitnashKit.h>
#import "MKClosePostMsg.h"

@implementation MKPost

- (id)init
{
    self = [super init];
    self.date = [NSDate date];
    
    self.nodeMinWidth = 800;
    self.postUuid = [[NSUUID UUID] UUIDString];
    
    self.title = @"";
    self.priceInSatoshi = @0;
    self.postDescription = @"";
    
    self.regionPath = @[];
    self.categoryPath = @[];
    self.sellerAddress = BMClient.sharedBMClient.identities.firstIdentity.address; // make this tx specific later
    
    self.shouldSortChildren = NO;
    
    self.nodeSuggestedWidth = 665;
    self.attachments = [NSArray array];
    
    [self.dictPropertyNames addObjectsFromArray:self.postMessagePropertyNames];

    /*
    [self addPropertyName:@"firstPostDateNumber"];
    [self addPropertyName:@"lastPostDateNumber"];
    */
    
    return self;
}

- (NSArray *)postMessagePropertyNames
{
    return @[
          @"postUuid",
          @"title",
          @"priceInSatoshi",
          @"description",
          @"regionPath",
          @"categoryPath",
          @"sellerAddress",
          @"attachments"
      ];
}

- (NSString *)description
{
    return self.postDescription;
}

- (void)setDescription:(NSString *)aString
{
    _postDescription = aString;
}


- (BOOL)isInSell
{
    return self.nodeParent.class == MKSell.class;
}

- (BOOL)isActive
{
    if (self.isInSell)
    {
        if(self.postMsg)
        {
            if (self.postMsg.wasSent)
            {
                return NO;
            }
        }
        
        return YES;
    }
    
    return NO;
}

- (NSString *)nodeNote
{
    if (self.isActive)
    {
        return @"●";
    }
    
    if (!self.isEditable && !self.canBuy)
    {
        return @"✓";
    }
    
    return nil;
}

// equality

- (NSUInteger)hash
{
    return self.postUuid.hash;
}

- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:self.class])
    {
        MKPost *otherPost = object;
        BOOL isEqual = [self.postUuid isEqualToString:otherPost.postUuid];
        return isEqual;
    }
    
    return YES;
}

- (BOOL)isEditable
{
    return self.isInSell && !self.isComplete;
}

- (BOOL)canBuy
{
    NavNode *parent = self.nodeParent;
    
    if ([parent isKindOfClass:MKCategory.class])
    {
        return YES;
    }
    
    return NO;
}

- (NSString *)nodeTitle
{
    if (self.canBuy)
    {
        return self.titleOrDefault;
    }
    
    return @"Listed";
}

- (NSString *)nodeSubtitle
{
    if (self.canBuy)
    {
        if (!self.priceInBtc)
        {
            return @"";
        }
        
        return [NSString stringWithFormat:@"%@BTC",
                [self.priceInBtc asFormattedStringWithFractionalDigits:4]];
    }
    
    if (self.postMsg)
    {
        if (self.postMsg.wasSent)
        {
            return @"listing message sent";
        }
        
        //NSNumber *secs = self.bmMessage.estimatedSecondsForPow;
        
        return [NSString stringWithFormat:@"Preparing post (%@)...",
                self.postMsg.sentMessage.getHumanReadbleStatus];
    }
    
    return @"Complete your listing below";
}

- (void)setPriceInBtc:(NSNumber *)btcNumber
{
    self.priceInSatoshi = [btcNumber btcToSatoshi];
}

- (NSNumber *)priceInBtc
{
    return [self.priceInSatoshi satoshiToBtc];
}

- (NSNumber *)minimumPriceInBtc
{
    // too small to be worth shipping
    return @0.039;
}

- (NSNumber *)minimumTestPriceInBtc
{
    // too small to be worth shipping
    return @0.004;
}

- (BOOL)hasPriceWithinMinMaxRange
{
    return [self.priceInSatoshi isGreaterThan:self.minimumTestPriceInBtc.btcToSatoshi];
}

- (NSString *)titleOrDefault
{
    if (self.title && self.title.length)
    {
        return self.title;
    }
    
    return @"Untitled Post";
}

// ----------

- (NSArray *)fullPath
{
    NSMutableArray *path = [NSMutableArray array];
    [path addObjectsFromArray:self.regionPath];
    [path addObjectsFromArray:self.categoryPath];
    return path;
}

- (MKCategory *)categoryForPath
{
    NavNode *root = MKRootNode.sharedMKRootNode.markets.rootRegion;
    NSArray *fullPath = self.fullPath;
    //NSLog(@"fullPath = '%@'", fullPath);
    
    if (fullPath.count == 0)
    {
        NSLog(@"Warning: empty full path for post");
        return NO;
    }
    
    NSArray *nodePath = [root nodeTitlePath:fullPath];
    
    if (nodePath)
    {
        return nodePath.lastObject;
    }
    
    return nil;
}

- (BOOL)isAlreadyInMarketsPath
{
    MKCategory *cat = self.categoryForPath;
    
    if (cat)
    {
        return [cat.children containsObject:self];
    }

    return NO;
}

- (BOOL)placeInMarketsPath
{
    MKCategory *cat = self.categoryForPath;
    
    if (cat)
    {
        //NSLog(@"placing sell in path '%@'", self.fullPath);
        [cat addChild:self];
        return YES;
    }
    else
    {
        NSLog(@"---- unable to find node for path '%@'", self.fullPath);
        return NO;
    }
}

// -----------------------------

- (void)copy:(MKPost *)aPost
{
    [self setPropertiesDict:aPost.propertiesDict];
}

- (NSView *)nodeView
{
    return [super nodeView];
}

- (MKPostMsg *)postMsg
{
    return [self.children firstObjectOfClass:MKPostMsg.class];
}

- (BOOL)isComplete
{
    return self.postMsg && self.postMsg.wasSent;
}

- (MKSell *)sell
{
    return [self firstInParentChainOfClass:MKSell.class];
}

// actions

- (MKPostMsg *)sendPostMsg
{
    MKPostMsg *postMsg = [[MKPostMsg alloc] init];
    [postMsg sendPost:self];
    
    if (postMsg.ackData)
    {
        [self addChild:postMsg];
        [self postParentChanged];
        [self.sell write];
    }
    else
    {
        NSBeep();
        NSLog(@"unable to post msg - no ack?");
    }
    
    return postMsg;
}

- (MKBidMsg *)sendBidMsg
{
    MKBidMsg *bidMsg = [[MKBidMsg alloc] init];
    bidMsg.debug = YES;
    [bidMsg setupForPost:self];
    [bidMsg send];
    return bidMsg;
}

// msgs

- (BOOL)handleMsg:(MKMsg *)msg // put in parent class of Buys and Sells
{
    if ([msg isKindOfClass:MKClosePostMsg.class])
    {
        NSString *postUuid = [msg.dict objectForKey:@"postUuid"];

        // close is for this message
        if ([self.postUuid isEqualToString:postUuid])
        {
            // sender of close post msg matches seller
            if ([msg.bmMessage.fromAddress isEqualToString:self.sellerAddress])
            {
                [self close];
            }
            else
            {
                // this message was an unauthorized attempt to delete a post
                NSLog(@"Warning: %@ attempted unauthorized request to delete a post %@",
                      msg.bmMessage.fromAddress, postUuid);
            }

            //[msg.bmMessage delete]; 
            return YES;
        }
    }
    
    return NO;
}

- (void)close
{
    if (self.bmMessage)
    {
        [self.bmMessage delete];
    }
    
    [self postParentChainChanged];
    [self removeFromParent];
}

@end
