//
//  MKTableView
//  BitMarkets
//
//  Created by Steve Dekorte on 6/28/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MKTableView : NSView

@property (strong, nonatomic) NSMutableArray *columnNames;

@property (strong, nonatomic) NSMutableArray *rows;
@property (strong, nonatomic) id delegate;

@end
