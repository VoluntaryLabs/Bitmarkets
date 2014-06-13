//
//  MKStepView.m
//  BitMarkets
//
//  Created by Steve Dekorte on 6/12/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKStepView.h"

@implementation MKStepView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        // Initialization code here.
    }
    
    return self;
}

- (void)setNode:(NavNode *)node
{
    _node = node;
    [self syncToNode];
}

- (void)syncToNode
{
    
}

- (NSDictionary *)titleAttributes
{
    /*
    CGFloat fontSize = 14.0;
    NSFont *font = [NSFont fontWithName:[self fontName] size:fontSize];
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [self textColor], NSForegroundColorAttributeName,
            font, NSFontAttributeName,
            nil];
    */
    return [[NavTheme sharedNavTheme] attributesDictForPath:@"steps/step"];
}


- (void)drawRect:(NSRect)dirtyRect
{
    NSString *title = self.node.nodeTitle;
    
    [super drawRect:dirtyRect];
    
    NSDictionary *att = [self titleAttributes];
    CGFloat fontSize = [(NSFont *)[att objectForKey:NSFontAttributeName] pointSize];
    
    CGFloat titleWidth = [[[NSAttributedString alloc] initWithString:title attributes:att] size].width;
    
    [title drawAtPoint:NSMakePoint(self.bounds.origin.x + self.bounds.size.width/2.0 - titleWidth/2.0,
                                   self.bounds.origin.y + self.bounds.size.height/2.0 - fontSize/2.0 - 5)
        withAttributes:att];
}

@end
