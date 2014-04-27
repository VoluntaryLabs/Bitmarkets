//
//  MKSell.m
//  Bitmessage
//
//  Created by Steve Dekorte on 3/21/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "MKSell.h"
#import "MKMessage.h"

#import <NavKit/NavKit.h>
#import <BitmessageKit/BitmessageKit.h>
#import <FoundationCategoriesKit/FoundationCategoriesKit.h>
#import "MKRootNode.h"

@implementation MKSell

- (id)init
{
    self = [super init];
    self.date = [NSDate date];
    
    self.uuid = [NSUUID UUID];
    
    self.title = @"";
    self.price = @0;
    self.description = @"";
    
    self.regionPath = @[@"North America", @"United States"];
    self.categoryPath = @[@"Electronics"];
    self.sellerAddress = BMClient.sharedBMClient.identities.firstIdentity.address; // make this tx specific later
    
    self.status = @"draft";
    return self;
}

- (NSArray *)modelActions
{
    return [NSArray arrayWithObjects:@"delete", nil];
}

- (NSString *)nodeTitle
{
    return self.title;
}

- (NSString *)nodeSubtitle
{
    return self.status;
}

- (NSString *)nodeNote
{
    return self.date.itemDateString;
}

- (CGFloat)nodeSuggestedWidth
{
    return 0;
}

- (void)delete
{
    [self.nodeParent removeChild:self];
}

- (void)setDict:(NSDictionary *)aDict
{
    self.uuid = [aDict objectForKey:@"uuid"];
    self.title = [aDict objectForKey:@"title"];
    self.price = [aDict objectForKey:@"price"];
    NSLog(@"price = %@", NSStringFromClass(self.price.class));
    
    self.description = [aDict objectForKey:@"description"];
    self.regionPath = [aDict objectForKey:@"regionPath"];
    self.categoryPath = [aDict objectForKey:@"categoryPath"];
    
    self.title = self.title.strip;
    //self.price = self.price.strip;
    self.description = self.description.strip;
}

- (NSDictionary *)dict
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:self.uuid forKey:@"uuid"];
    [dict setObject:self.title forKey:@"title"];
    [dict setObject:self.price forKey:@"price"];
    [dict setObject:@"BTC" forKey:@"currency"];
    [dict setObject:self.description forKey:@"description"];
    [dict setObject:self.regionPath forKey:@"regionPath"];
    [dict setObject:self.categoryPath forKey:@"categoryPath"];
    [dict setObject:self.sellerAddress forKey:@"sellerAddress"]; // Bitmessage address?
    
    return dict;
}

- (NSString *)jsonString
{
    MKMessage *m = [[MKMessage alloc] init];
    [m setInstance:self];
    return [m jsonString];
}

- (void)post
{
    NSString *channelAddress = MKRootNode.sharedMKRootNode.markets.mkChannel.channel.address;
    NSString *sellerAddress = self.sellerAddress;
    NSString *subject = @"bitmarkets"; // self.title
    NSString *message = self.jsonString;
    
    BMMessage *m = [[BMMessage alloc] init];
    [m setFromAddress:sellerAddress];
    [m setToAddress:channelAddress];
    [m setSubject:subject];
    [m setMessage:message];
    [m send];
}

- (NSArray *)fullPath
{
    NSMutableArray *path = [NSMutableArray array];
    [path addObjectsFromArray:self.regionPath];
    [path addObjectsFromArray:self.categoryPath];
    return path;
}

- (void)placeInMarketsPath
{
    NavNode *root = MKRootNode.sharedMKRootNode.markets.rootRegion;
    NSArray *nodePath = [root nodeTitlePath:self.fullPath];
    
    if (nodePath)
    {
        MKCategory *cat = nodePath.lastObject;
        [cat addChild:self];
    }
}

- (BOOL)isDraft
{
    return [self.status isEqualToString:@"draft"];
}

- (void)findStatus
{
    // add code to look through followup posts
    [self setStatus:@"posted"];
}

@end
