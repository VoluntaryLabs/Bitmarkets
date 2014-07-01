//
//  MKTextFieldCell.m
//  BitMarkets
//
//  Created by Steve Dekorte on 7/1/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKTextFieldCell.h"

@implementation MKTextFieldCell

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.marginLeft = 10.0;
        self.marginRight = 10.0;
    }
    
    return self;
}

- (NSRect)drawingRectForBounds:(NSRect)rect
{
    NSRect rectInset = NSMakeRect(
                                  rect.origin.x + self.marginLeft,
                                  rect.origin.y + _marginBottom,
                                  rect.size.width - self.marginLeft - self.marginRight,
                                  rect.size.height - self.marginBottom - self.marginTop);
    
    return [super drawingRectForBounds:rectInset];
}

@end
