//
//  MKAttachmentView.h
//  BitMarkets
//
//  Created by Steve Dekorte on 5/20/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <NavKit/NavKit.h>
#import "MKDragFileWell.h"

@protocol MKAttachmentViewProtocol
- (void)changedAttachment:sender;
@end

@interface MKAttachmentView : NavColoredView

@property (assign, nonatomic) id delegate;

@property (strong, nonatomic) MKDragFileWell *dragWell;
@property (strong, nonatomic) NavTextView *instructions;
@property (strong, nonatomic) NSButton *closeButton;
@property (assign, nonatomic) BOOL editable;

- (void)setImage:(NSImage *)image;
- (NSImage *)image;
- (NSData *)jpegImageData;

@end
