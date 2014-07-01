//
//  MKTextFieldCell.h
//  BitMarkets
//
//  Created by Steve Dekorte on 7/1/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MKTextFieldCell : NSTextFieldCell

@property (assign, nonatomic) CGFloat marginLeft;
@property (assign, nonatomic) CGFloat marginRight;
@property (assign, nonatomic) CGFloat marginTop;
@property (assign, nonatomic) CGFloat marginBottom;

@end
