#import "MKDragFileWell.h"
#import <NavKit/NavKit.h>

@implementation MKDragFileWell

- (id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    [self setAutoresizingMask:NSViewNotSizable];
    [self setAutoresizesSubviews:NO];
    //[self setImageFrameStyle:NSImageFrameGrayBezel];
    [self setImageFrameStyle:NSImageFrameNone];
    [self setImageScaling:NSScaleToFit]; //NSScaleProportionally]; //NSScaleNone];
    [self setImageScaling:NSScaleProportionally]; //NSScaleNone];
    
    _canDrag = YES;
    _canDrop = YES;
    
    return self;
}

- (void)dealloc
{
}

- (void)awakeFromNib
{
    [self registerForDraggedTypes:[NSArray arrayWithObjects:NSFilenamesPboardType, nil]];
}

- (void)filePaths:(NSArray *)array
{
    _filePaths = array;
}

- (NSArray *)filePaths
{
    return _filePaths;
}

- (void)setImage:(NSImage *)image
{
    if (self.resizeImageUntilLessThanKb != 0)
    {
        NSData *data = [image jpegImageDataUnderKb:self.resizeImageUntilLessThanKb];
        image = [[NSImage alloc] initWithData:data];
    }
    
    
    [super setImage:image];
}

- (void)concludeDragOperation:sender
{
    
}

/*
 - (NSImage *)image
 {
 return [[NSWorkspace sharedWorkspace] iconForFiles:filePaths];
 }
 */

// -- dragging

- (unsigned int)draggingEntered:(id <NSDraggingInfo>)sender
{
    NSPasteboard *dragPasteboard = [sender draggingPasteboard];
    NSArray *types = [dragPasteboard types];
    //printf("draggingEntered:\n");
    
    if (!_canDrop)
    {
        return NSDragOperationNone;
    }
    
    if ([types containsObject:NSFilenamesPboardType])
    {
        NSArray *paths = [dragPasteboard propertyListForType:NSFilenamesPboardType];
        //printf("draggingEntered2\n");
        [self filePaths:paths];
        
        if ([_delegate respondsToSelector:@selector(acceptsDrop:)])
        {
            if (![_delegate acceptsDrop:self])
            {
                return NSDragOperationNone;
            }
            //printf("accepts drop\n");
        }
        
        if (_filePaths)
        {
            [self setImage:[[NSWorkspace sharedWorkspace] iconForFiles:_filePaths]];
        }
        else
        {
            [self setImage:nil];
        }
        //printf("accepts drop2\n");
        return NSDragOperationCopy;
    }
    
    
    return NSDragOperationNone;
}

- (BOOL)draggingUpdated:(id <NSDraggingInfo>)sender
{
    NSPasteboard *dragPasteboard = [sender draggingPasteboard];
    NSArray *types = [dragPasteboard types];
    
    if (!_canDrop)
    {
        return NO;
    }
    
    if ([_delegate respondsToSelector:@selector(acceptsDrop:)])
    {
        if (![_delegate acceptsDrop:self])
        {
            return NO;
        }
        //printf("accepts drop 2\n");
    }
    
    //printf("draggingUpdated:\n");
    return [types containsObject:NSFilenamesPboardType];
}

- (void)draggingExited:(id <NSDraggingInfo>)sender
{
    if (!_canDrop)
    {
        return;
    }
    //[self setImage:[self image]];
    //printf("draggingExited:\n");
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
    NSPasteboard *dragPasteboard = [sender draggingPasteboard];
    NSArray *types = [dragPasteboard types];
    
    if (!_canDrop)
    {
        return NO;
    }
    
    //printf("performDragOperation:\n");
    if ([types containsObject:NSFilenamesPboardType])
    {
        NSArray *paths = [dragPasteboard propertyListForType:NSFilenamesPboardType];
        [self filePaths:paths];
        
        if ([_delegate respondsToSelector:@selector(droppedInWell:)])
        {
            [_delegate droppedInWell:self];
        }
        
        //slideDraggedImageTo:
        return YES;
    }
    
    return NO;
}

// Dragging Source Methods

- (void)mouseDown:(NSEvent *)theEvent
{
    //NSSize dragOffset = NSMakeSize(0.0, 0.0);
    NSPasteboard *pboard = [NSPasteboard pasteboardWithName:NSDragPboard];
    NSPoint locationInWindow = [theEvent locationInWindow];
    NSPoint imageLocation;
    id image = [self image];
    [image setSize:[self frame].size];
    
    if (!_canDrag)
    {
        return;
    }
    
    imageLocation.x = locationInWindow.x - [self frame].origin.x;
    imageLocation.y = locationInWindow.y - [self frame].origin.y;
    
    [pboard declareTypes:[NSArray arrayWithObject:NSFilenamesPboardType] owner:self];
    [pboard setPropertyList:_filePaths forType:NSFilenamesPboardType];
    //[pboard setData:[[self image] TIFFRepresentation] forType:NSTIFFPboardType];
    [self dragImage:[self image] at:imageLocation
             offset:NSMakeSize(0, 0) event:theEvent pasteboard:pboard source:self slideBack:YES];
}

// --

- (void)draggedImage:(NSImage *)anImage beganAt:(NSPoint)aPoint
{
}

- (void)draggedImage:(NSImage *)anImage
             endedAt:(NSPoint)aPoint
           operation:(NSDragOperation)operation
{
    //[self filePaths:nil];
    //[self setImage:nil];
    //if ([delegate respondsToSelector:@selector(droppedInWell:)])
    //{ [delegate draggedFromWell:self]; }
    //NSLog(@"%@", [filePaths description]);
}

- (void)draggedImage:(NSImage *)draggedImage
             movedTo:(NSPoint)screenPoint
{
}

- (NSDragOperation)draggingSourceOperationMaskForLocal:(BOOL)flag
{
    if ((!_canDrag) || flag)
    {
        return NSDragOperationNone;
    }
    
    return NSDragOperationCopy; //Generic;
}

- (BOOL)ignoreModifierKeysWhileDragging
{
    return YES;
}

// -----------

- (void)copy:sender
{
    NSImage *image = [self image];
    
    if (image)
    {
        NSPasteboard *pboard = [NSPasteboard pasteboardWithName:NSGeneralPboard];
        [pboard declareTypes:[NSArray arrayWithObject:NSTIFFPboardType] owner:self];
        [pboard setData:[image TIFFRepresentation] forType:NSTIFFPboardType];
    }
}

/*
- (void)drawRect:(NSRect)dirtyRect
{
    if (self.image)
    {
        [super drawRect:dirtyRect];
    }
}
*/

@end
