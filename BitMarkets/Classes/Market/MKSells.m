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

- (JSONDB *)db
{
    JSONDB *db = [super db];
    db.name = @"sells";
    db.location = JSONDB_IN_APP_SUPPORT_FOLDER;
    return db;
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
    [self write];
    return sell;
}

- (void)add
{
    [self justAdd];
}

// dict

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
