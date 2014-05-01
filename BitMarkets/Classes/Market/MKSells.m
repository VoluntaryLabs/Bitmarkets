//
//  MKSells.m
//  Bitmessage
//
//  Created by Steve Dekorte on 3/13/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import <BitmessageKit/BitmessageKit.h>
#import "MKSells.h"
#import "MKSell.h"
#import "MKMessage.h"

@implementation MKSells

- (id)init
{
    self = [super init];
    self.shouldUseCountForNodeNote = YES;
    [self performSelector:@selector(update) withObject:nil afterDelay:0.0];
    return self;
}

- (NSString *)nodeTitle
{
    return @"Sells";
}

- (NSString *)nodeNote
{
    if (self.children.count > 0)
    {
        return [NSString stringWithFormat:@"%i", (int)self.children.count];
    }
    
    return nil;
}


- (BOOL)canSearch
{
    return self.children.count > 0;
}

- (MKSell *)justAdd
{
    MKSell *sell = [[MKSell alloc] init];
    sell.isLocal = YES;
    [self addChild:sell];
    return sell;
}

- (void)add
{
    [self justAdd];
}

// dict

- (void)setDict:(NSDictionary *)aDict
{
    
}

- (NSDictionary *)dict
{
    return nil;
}

- (void)update
{
    NSArray *inboxMessages = BMClient.sharedBMClient.messages.received.children;
    
    for (BMMessage *bmMessage in inboxMessages)
    {
        MKMessage *mkMessage = [MKMessage withBMMessage:bmMessage];
        
        //[MKMessage instance];
        
        // delete  messages which are invalid or have no matching buy/sell
        //
    }
    
    [self performSelector:@selector(update) withObject:nil afterDelay:10.0];
}


@end
