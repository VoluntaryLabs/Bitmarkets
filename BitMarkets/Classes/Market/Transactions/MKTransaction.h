//
//  MKTransaction.h
//  BitMarkets
//
//  Created by Steve Dekorte on 5/3/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import <BitmessageKit/BitMessageKit.h>
#import "MKMessages.h"
#import "MKMsgGroup.h"
#import "MKPost.h"

@interface MKTransaction : MKMsgGroup

@property (strong, nonatomic) MKPost *mkPost;
@property (strong, nonatomic) NSString *error;

- (NSArray *)visibleStages;
- (MKStage *)currentStage;
- (NSArray *)stages;


- (NSString *)statusTitle;
- (NSString *)nodeSubtitleDetailed;

- (void)update;

@end
