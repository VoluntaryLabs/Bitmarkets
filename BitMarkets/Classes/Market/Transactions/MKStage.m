//
//  MKStep.m
//  BitMarkets
//
//  Created by Steve Dekorte on 6/13/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKStage.h"
#import "MKTransaction.h"
#import <FoundationCategoriesKit/FoundationCategoriesKit.h>

@implementation MKStage

- (BOOL)isActive
{
    [NSException raise:@"subclasses must override" format:nil];
    return YES;
}

- (BOOL)isComplete
{
    [NSException raise:@"subclasses must override" format:nil];
    return NO;
}

- (MKTransaction *)transaction
{
    return (MKTransaction *)self.nodeParent;
}

- (MKStage *)nextStage
{
    return [self.transaction.stages objectAfter:self];
}

- (MKStage *)previousStage
{
    return [self.transaction.stages objectBefore:self];
}

- (BOOL)canDelete
{
    return YES;
}

- (void)prepareToDelete
{
}

@end
