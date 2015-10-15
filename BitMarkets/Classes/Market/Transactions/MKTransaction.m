//
//  MKTransaction.m
//  BitMarkets
//
//  Created by Steve Dekorte on 5/3/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKTransaction.h"

@implementation MKTransaction

- (id)init
{
    self = [super init];
    self.nodeShouldSortChildren = @NO;

    self.mkPost = [[MKPost alloc] init];
    [self addChild:self.mkPost];
    
    {
         NavActionSlot *slot = [self.navMirror newActionSlotWithName:@"delete"];
         [slot setVisibleName:@"delete"];
         NSString *typeOfTx = [self.className after:@"MK"];
         [slot setVerifyMessage:[NSString stringWithFormat:@"Are you sure you want to delete this %@?", typeOfTx]];
    }
    
    self.nodeDoesRememberChildPath = @YES;
    self.nodeSuggestedWidth = @900;
    
    return self;
}

- (NSArray *)visibleStages
{
    return self.children;
}

- (MKStage *)currentStage
{
    MKStage *stage = nil;
    
    for (stage in self.children)
    {
        if (stage.isActive)
        {
            return stage;
        }
    }
    
    return self.children.lastObject;
}

- (NSArray *)stages
{
    return self.children;
}

- (NSString *)statusTitle
{
    NavNode *node = self.currentStage;
    
    if (node)
    {
        return node.nodeTitle;
    }
    
    return @"-";
}

- (NSString *)nodeSubtitleDetailed
{
    if (self.error)
    {
        return self.error;
    }
    
    NavNode *node = self.currentStage;
    
    if (node)
    {
        return node.nodeSubtitle;
    }
    
    return @"-";
}

- (NSString *)nodeTitle
{
    return self.mkPost.titleOrDefault;
}

- (NSString *)nodeSubtitle
{
    if (self.error)
    {
        return self.error;
    }
    
    if (self.mkPost.priceInBtc)
    {
        NSString *amount = [self.mkPost.priceInBtc asFormattedStringWithFractionalDigits:4];
        return [NSString stringWithFormat:@"%@BTC", amount];
    }
    
    return @"";
}

- (NSString *)nodeNote
{
    if (self.error || self.didFail)
    {
        return @"✗";
    }
    
    if (self.isActive)
    {
        return @"●";
    }
    
    if (self.isComplete)
    {
        return @"✓";
    }
    
    return nil;
}


- (void)setDict:(NSDictionary *)dict
{
    [super setDict:dict];
    
    self.mkPost = [self.children firstObjectOfClass:MKPost.class];
}

// -------------------------

- (void)updateActions
{
    NavActionSlot *slot = [self.navMirror newActionSlotWithName:@"delete"];
    [slot setIsActive:self.canDelete];
}

// -------------------------

/*
- (MKMsg *)msgInstanceOfClass:(Class)aClass
{
    
}
*/
 

- (BOOL)handleMsg:(MKMsg *)msg
{    
    if ([self.mkPost.postUuid isEqualToString:msg.postUuid])
    {
        [super handleMsg:msg];
    }
    
    return NO;
}

// -------------------

- (void)update
{
    self.error = nil;
    
    for (NavNode *child in self.children)
    {
        if ([child respondsToSelector:@selector(update)])
        {
            @try
            {
                [(id)child update];
            }
            @catch (NSException *exception)
            {
                self.error = [exception description];
                //[self showError];
                [BNErrorReport.sharedBNErrorReport reportException:exception];
            }
        }
    }
    
    [self updateActions];
    [self postSelfChanged];
}

- (void)showError
{
        NSAlert *msgBox = [[NSAlert alloc] init];
        NSString *m = [NSString stringWithFormat:@"Exception while updating %@ '%@': %@",
                       self.isBuy ? @"Buy" : @"Sell",
                       self.nodeTitle,
                       self.error
                       ];
        [msgBox setMessageText:m];
        [msgBox addButtonWithTitle: @"OK"];
        
        [msgBox beginSheetModalForWindow:NSApplication.sharedApplication.mainWindow
                           modalDelegate:self
                          didEndSelector:@selector(errorAlertDidEnd:returnCode:contextInfo:)
                             contextInfo:nil];
}
    
- (void)errorAlertDidEnd:(NSAlert *)alert
    returnCode:(NSInteger)returnCode
    contextInfo:(void *)contextInfo
{
}

- (BOOL)isActive
{
    return [self.children firstTrueForSelector:@selector(isComplete)] != nil;
}

- (BOOL)isComplete
{
    return [self.children allTrueForSelector:@selector(isComplete)];
}

- (BOOL)didFail
{
    return NO;
}

- (BOOL)isBuy
{
    [NSException raise:@"Subclasses should override" format:@""];
    return NO;
}

- (NSString *)description
{
    if (self.isBuy)
    {
        return [@"Buying: "  stringByAppendingString:self.mkPost.title];
    }
    else
    {
        return [@"Selling: "  stringByAppendingString:self.mkPost.title];
    }
}

- (BOOL)canDelete
{
    for (MKStage *stage in self.stages)
    {
        if (!stage.canDelete)
        {
            return NO;
        }
    }
    
    return YES;
}

- (void)delete
{
    for (MKStage *stage in self.stages)
    {
        [stage prepareToDelete]; // these raise exception on error
    }
    
    [super delete];
}

@end
