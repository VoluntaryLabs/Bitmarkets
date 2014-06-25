//
//  MKSellDeliveryAddress.m
//  BitMarkets
//
//  Created by Steve Dekorte on 5/11/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKSellDeliveryAddress.h"

@implementation MKSellDeliveryAddress

- (id)init
{
    self = [super init];
    self.isEditable = NO;
    self.nodeViewClass = NavMirrorView.class;
    return self;
}

- (NSString *)nodeTitle
{
    return @"Buyer's Address";
}

- (NSString *)nodeSubtitle
{
    if (self.isFilled)
    {
        return @"received ";
    }
    
    return @"awaiting from buyer";
}


@end
