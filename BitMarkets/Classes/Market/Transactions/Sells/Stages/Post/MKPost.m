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
    
    self.postUuid = [[NSUUID UUID] UUIDString];
    
    self.title = @"";
    self.priceInSatoshi = @0;
    self.description = @"";
    
    self.regionPath = @[];
    self.categoryPath = @[];
    self.sellerAddress = BMClient.sharedBMClient.identities.firstIdentity.address; // make this tx specific later
    
    self.status = @"draft";
    self.shouldSortChildren = NO;
    
    self.nodeSuggestedWidth = 150;
    self.attachments = [NSArray array];
    
    [self.dictPropertyNames addObjectsFromArray:@[
     @"postUuid",
     @"status",
     @"title",
     @"priceInSatoshi",
     @"description",
     @"regionPath",
     @"categoryPath",
     @"sellerAddress",
     @"attachments"
     ]
     ];
    
    return self;
}

- (BOOL)isInSell
{
    return self.nodeParent.class == MKSell.class;
}

- (BOOL)isActive
{
    if (self.isInSell)
    {
        return !self.postMsg;
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
    return [self.status isEqualToString:@"draft"];
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
    
    return @"Post";
}

- (NSString *)nodeSubtitle
{
    if (self.canBuy)
    {
        return [NSString stringWithFormat:@"%@BTC", self.priceInBtc];
    }
    
    return self.postMsg.nodeSubtitle;
    //return nil;
}

- (void)setPriceInBtc:(NSNumber *)btcNumber
{
    self.priceInSatoshi = [btcNumber btcToSatoshi];
}

- (NSNumber *)priceInBtc
{
    return [self.priceInSatoshi satoshiToBtc];
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

- (void)setPropertiesDict:(NSDictionary *)dict
{
    [super setPropertiesDict:dict];
    NSLog(@"");
}

- (NSDictionary *)propertiesDict
{
    return [super propertiesDict];
}

- (NSArray *)fullPath
{
    NSMutableArray *path = [NSMutableArray array];
    [path addObjectsFromArray:self.regionPath];
    [path addObjectsFromArray:self.categoryPath];
    return path;
}

- (BOOL)placeInMarketsPath
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
        //NSLog(@"placing sell in path '%@'", self.fullPath);
        MKCategory *cat = nodePath.lastObject;
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

- (BOOL)isPosted
{
    return self.postMsg != nil;
}

// actions

- (MKPostMsg *)sendPostMsg
{
    MKPostMsg *postMsg = [[MKPostMsg alloc] init];
    [postMsg sendPost:self];
    [self addChild:postMsg];
    
    [self setStatus:@"posted"];
    [self postParentChanged];
    return postMsg;
}

- (MKBidMsg *)sendBidMsg
{
    MKBidMsg *bidMsg = [[MKBidMsg alloc] init];
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
            
            [msg.bmMessage delete];
        }
    }
    
    return NO;
}

- (void)close
{
    [self removeFromParent];
}

@end
