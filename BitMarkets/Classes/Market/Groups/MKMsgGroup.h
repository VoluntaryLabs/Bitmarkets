//
//  MKMsgGroup.h
//  BitMarkets
//
//  Created by Steve Dekorte on 5/19/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKGroup.h"
#import "MKMsg.h"

@interface MKMsgGroup : MKGroup

- (BOOL)handleMsg:(MKMsg *)mkMsg;

@end
