//
//  MKMsgGroup.m
//  BitMarkets
//
//  Created by Steve Dekorte on 5/19/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKMsgGroup.h"
#import "MKMsg.h"

@implementation MKMsgGroup

- (BOOL)handleMsg:(MKMsg *)mkMsg // put in parent class of Buys and Sells
{
    for (MKMsgGroup *child in self.children)
    {
        if ([child respondsToSelector:@selector(handleMsg:)])
        {
            BOOL didHandle = [child handleMsg:mkMsg];
            
            if (didHandle)
            {
                return YES;
            }
        }
    }
    
    return NO;
}

@end
