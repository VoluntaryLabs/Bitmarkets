//
//  MKAttachmentView.m
//  BitMarkets
//
//  Created by Steve Dekorte on 5/20/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKAttachmentView.h"

@implementation MKAttachmentView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [NSColor colorWithCalibratedWhite:.96 alpha:1.0];
        //self.backgroundColor = [NSColor clearColor];
        //self.backgroundColor = [NSColor whiteColor];
        
        [self setAutoresizesSubviews:NO];
        [self setAutoresizingMask:NSViewHeightSizable | NSViewWidthSizable];
        
        {
            _dragWell = [[MKDragFileWell alloc] initWithFrame:NSMakeRect(0, 0, self.width, self.height)];
            [self addSubview:_dragWell];
            _dragWell.canDrop = YES;
            _dragWell.canDrag = NO;
            _dragWell.delegate = self;
            _dragWell.resizeImageUntilLessThanKb = 120;
        }
        
        {
            _instructions = [[NavTextView alloc] initWithFrame:NSMakeRect(0, 0, 500, 20)];
            [self addSubview:_instructions];
            [_instructions setEditable:NO];
            [_instructions setSelectable:NO];
            _instructions.string = @"Drag in image to attach (image meta data will be removed)";
            [_instructions setThemePath:@"sell/draginstructions"];
        }
        
        {
            _closeButton = [[NSButton alloc] initWithFrame:NSMakeRect(0, 0, 16, 16)];
            [_closeButton setButtonType:NSMomentaryChangeButton];
            [_closeButton setBordered:NO];
            [_closeButton setAutoresizingMask: NSViewMinXMargin | NSViewMaxYMargin];
            [_closeButton setTarget:self];
            [_closeButton setAction:@selector(hitCloseButton:)];
            
            NSString *imageName = [NSString stringWithFormat:@"%@_active", @"delete"];
            NSImage *image = [NSImage imageNamed:imageName];
            [_closeButton setImage:image];
            [self addSubview:_closeButton];
        }
        
        [self layout];
    }
    
    return self;
}

- (void)setEditable:(BOOL)editable
{
    _editable = editable;
    [self layout];
}

- (void)adjustHeightTo:(CGFloat)newHeight
{
    CGFloat newY = self.y + self.height - newHeight;
    [self setHeight:newHeight];
    [self setY:newY];
}

- (void)layout
{
    [_dragWell setCanDrop:_editable];

    if (self.dragWell.image)
    {
        [self adjustHeightTo:300];
        self.backgroundColor = [NSColor whiteColor];
        [_instructions setHidden:YES];
        [_closeButton setHidden:NO];
        [_closeButton setEnabled:YES];
    }
    else
    {
        [self adjustHeightTo:20];
        self.backgroundColor = [NSColor colorWithCalibratedWhite:.96 alpha:1.0];
        [_instructions setHidden:NO];
        [_closeButton setHidden:YES];
        [_closeButton setEnabled:NO];
    }
    
    if (!_editable)
    {
        [_closeButton setHidden:YES];
        [_closeButton setEnabled:NO];
        self.backgroundColor = [NSColor whiteColor];
        [_instructions setHidden:YES];
    }

    [_dragWell setFrame:NSMakeRect(0, 0, self.width, self.height)];
    
    CGFloat m = 10;
    [_closeButton setX:self.width - _closeButton.width - m];
    [_closeButton setY:self.height - _closeButton.height - m];

    [_instructions setWidth:self.width*.8];
    [_instructions centerXInSuperview];
    [_instructions centerYInSuperview];
}

- (void)setFrame:(NSRect)frameRect
{
    [super setFrame:frameRect];
    [self layout];
}

// drop

- (BOOL)acceptsDrop:sender
{
    NSString *path = [[_dragWell filePaths] firstObject];
    NSImage *image = [[NSImage alloc] initWithContentsOfFile:path];
    return image != nil;
}

- (void)setImage:(NSImage *)image
{
    [_dragWell setImage:image];
    [self layout];
    [self setNeedsDisplay:YES];
}

- (NSImage *)image
{
    return [_dragWell image];
}

- (NSString *)imagePath
{
    return [[_dragWell filePaths] firstObject];
}

- (void)droppedInWell:sender
{
    NSString *path = [[_dragWell filePaths] firstObject];
    NSImage *image = [[NSImage alloc] initWithContentsOfFile:path];
    
    if (image)
    {
        [self setImage:image];
    }
}

// close

- (void)hitCloseButton:sender
{
    [self setImage:nil];
}

@end