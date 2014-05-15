//
//  MKTransaction.h
//  BitMarkets
//
//  Created by Steve Dekorte on 5/3/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import <BitmessageKit/BitMessageKit.h>
#import "MKMessages.h"
#import "MKGroup.h"
#import "MKPost.h"
//#import "MKMsg.h"

@interface MKTransaction : MKGroup

@property (strong, nonatomic) MKPost *mkPost;

//- (MKMsg *)msgInstanceOfClass:(Class)aClass;

- (BOOL)handleMsg:(MKMsg *)mkMsg;

- (void)update;

@end
