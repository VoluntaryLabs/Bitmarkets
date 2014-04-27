//
//  MKSellView.m
//  Bitmessage
//
//  Created by Steve Dekorte on 2/21/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "MKSellView.h"
#import <NavKit/NavKit.h>
#import "MKRootNode.h"


@implementation MKSellView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setAutoresizesSubviews:YES];
        [self setAutoresizingMask:NSViewHeightSizable | NSViewWidthSizable];

        _title = [[MKTextView alloc] initWithFrame:NSMakeRect(0, 0, 500, 24)];
        _title.uneditedTextString = @"Enter title";
        [self addSubview:_title];
        [_title setEditedThemePath:@"sell/title"];
        [_title setDelegate:self];
        _title.endsOnReturn = YES;
        //@property (strong) IBOutlet NSTextView *quantity;
        
        _price = [[MKTextView alloc] initWithFrame:NSMakeRect(0, 0, 500, 24)];
        _price.autoresizingMask = NSViewMinYMargin | NSViewMaxXMargin;
        [self addSubview:self.price];
        _price.uneditedTextString = @"Enter price in BTC";
        //_price.suffix = @"BTC";
        [_price setDelegate:self];
        [_price setEditedThemePath:@"sell/price"];
        _price.endsOnReturn = YES;
        
        _title.nextKeyView = _price;
        
        _postOrBuyButton = [[NavRoundButtonView alloc] initWithFrame:NSMakeRect(0, 0, 120, 32)];
        //_postOrBuyButton.title = @"Buy Now";
        _postOrBuyButton.title = @"Post";
        //[_postOrBuyButton setThemePath:@"sell/button"];
        [_postOrBuyButton setTitleAttributes:[NavTheme.sharedNavTheme attributesDictForPath:@"sell/button"]];
        [self addSubview:_postOrBuyButton];
        [_postOrBuyButton setTarget:self];
        [_postOrBuyButton setAction:@selector(post)];
        
        self.separator = [[NavColoredView alloc] initWithFrame:NSMakeRect(0, 0, self.width, 1)];
        [self.separator setThemePath:@"sell/separator"];
        [self addSubview:self.separator];
        
        _description = [[MKTextView alloc] initWithFrame:NSMakeRect(0, 0, 500, 24)];
        _description.uneditedTextString = @"Enter description";
        [_description setDelegate:self];
        //self.description.string = @"I've had this TOA amp in the closet for a while waiting to setup in my shop space but I need the space so my loss is your gain. Works fine and is in mostly decent condition with a few dings on the corners. I'm available during the day near 7th and Folsom but I can also meet up in the evening in the Mission.";
        [self.description setEditedThemePath:@"sell/description"];
        [self addSubview:_description];
 
        _price.nextKeyView = _description;

        // region
        
        self.regionIcon = [[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, 16, 16)];
        [_regionIcon setImage:[NSImage imageNamed:@"location_active.png"]];
        [self addSubview:self.regionIcon];
 
        self.region = [[NavTextView alloc] initWithFrame:NSMakeRect(0, 0, 500, 24)];
        [self.region setEditable:NO];
        //self.region.string = @"United States";
        [self.region setThemePath:@"sell/label"];
        [self addSubview:self.region];
        
        // category
        
        self.categoryIcon = [[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, 16, 16)];
        [_categoryIcon setImage:[NSImage imageNamed:@"right_active.png"]];
        [self addSubview:self.categoryIcon];
        
        self.category = [[NavTextView alloc] initWithFrame:NSMakeRect(0, 0, 500, 24)];
        //self.category.string = @"Electronics";
        [self.category setEditable:NO];
        [self.category setThemePath:@"sell/label"];
        [self addSubview:self.category];
        
        // fromAddress
        
        self.fromAddressIcon = [[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, 16, 16)];
        [_fromAddressIcon setImage:[NSImage imageNamed:@"profile_active.png"]];
        [self addSubview:self.fromAddressIcon];
        
        self.fromAddress = [[NavTextView alloc] initWithFrame:NSMakeRect(0, 0, 500, 24)];
        [self.fromAddress setEditable:NO];
        //self.fromAddress.string = @"fromAddress";
        [self.fromAddress setThemePath:@"sell/address"];
        [self addSubview:self.fromAddress];

        // attachment

        self.attachedImage = [[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, 500, 24)];
        [self addSubview:self.attachedImage];
    }
    
    return self;
}

- (void)setEditable:(BOOL)isEditable
{
    [_description setEditable:isEditable];
    [_title setEditable:isEditable];
    [_price setEditable:isEditable];
}


- (void)layout
{
    CGFloat leftMargin = 30;
    
    [_title setX:leftMargin];
    [_title placeInTopOfSuperviewWithMargin:leftMargin];
    
    [_price setX:leftMargin];
    [_price placeYBelow:_title margin:0];

    [_postOrBuyButton setWidth:84];
    [_postOrBuyButton setX:self.width - _postOrBuyButton.width - leftMargin];
    [_postOrBuyButton placeInTopOfSuperviewWithMargin:40];
    
    [_separator setX:0];
    [_separator setWidth:self.width];
    [_separator placeYBelow:_price margin:20];
    
    [_description setX:leftMargin];
    [_description setWidth:self.width - leftMargin*2];
    [_description setHeight:100];
    [_description placeYBelow:_separator margin:30];

    
    CGFloat iconMargin = 5;
    
    [_regionIcon setX:leftMargin];
    [_regionIcon placeYBelow:_description margin:iconMargin];
    [_region placeYBelow:_description margin:iconMargin];
    [_region placeXRightOf:_regionIcon margin:iconMargin];
    
    [_categoryIcon setX:leftMargin];
    [_categoryIcon placeYBelow:_regionIcon margin:iconMargin];
    [_category placeYBelow:_regionIcon margin:iconMargin];
    [_category placeXRightOf:_categoryIcon margin:iconMargin];
    
    [_fromAddressIcon setX:leftMargin];
    [_fromAddressIcon placeYBelow:_categoryIcon margin:iconMargin];
    [_fromAddress placeYBelow:_categoryIcon margin:iconMargin];
    [_fromAddress placeXRightOf:_fromAddressIcon margin:iconMargin];
}

- (void)prepareToDisplay
{
    [self layout];
    [self layout];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setFrame:(NSRect)frameRect
{
    [super setFrame:frameRect];
    [self layout];
}

- (void)setNode:(NavNode *)node
{
    _node = node;
    
    [self setEditable:self.mkSell.isDraft];
    
    if (self.mkSell.isDraft)
    {
        [self.postOrBuyButton setTitle:@"Post"];
        [self.postOrBuyButton setAction:@selector(post)];
    }
    else
    {
        [self.postOrBuyButton setTitle:@"Buy"];
        [self.postOrBuyButton setAction:@selector(buy)];
    }
    
    [self syncFromNode];
}

- (MKSell *)mkSell
{
    return (MKSell *)self.node;
}

- (void)syncFromNode
{
    _title.string = self.mkSell.title;
    [_title textDidChange];
    [_title useUneditedTextStringIfNeeded];
    
    NSString *priceString = [NSString stringWithFormat:@"%@", self.mkSell.price].strip;
    _price.string = priceString;
    if ([_price.string isEqualToString:@"0"])
    {
        _price.string = @"";
    }
    
    [_price setSuffix:@"BTC"];
    [_price textDidChange];
    [_price useUneditedTextStringIfNeeded];
    
    self.description.string = self.mkSell.description;
    [_description textDidChange];
    [_description useUneditedTextStringIfNeeded];

    _region.string      = self.mkSell.regionPath.lastObject;
    _category.string    = self.mkSell.categoryPath.lastObject;
    _fromAddress.string = self.mkSell.sellerAddress;
    
    [self updateButton];
}

- (void)syncToNode
{
    self.mkSell.title = _title.stringSansUneditedString;
    self.mkSell.price = [NSNumber numberWithDouble:_price.stringSansUneditedString.doubleValue];
    self.mkSell.description = _description.stringSansUneditedString;
    [self.mkSell postParentChanged];
}

/*
- (NSNumber *)priceNumber
{
    return [NSNumber numberWithDouble:self.price.string.doubleValue];
}
*/

- (BOOL)readyToPost
{
    BOOL hasTitle = self.title.isReady;
    BOOL hasPrice = self.price.string.doubleValue > 0.0;
    BOOL hasDescription = self.description.isReady;
    
    return hasTitle && hasPrice && hasDescription;
}

- (void)updateButton
{
    [_postOrBuyButton setHidden:NO];
    
    if (self.readyToPost && [self.mkSell isDraft])
    {
        [_postOrBuyButton setTitleAttributes:[NavTheme.sharedNavTheme attributesDictForPath:@"sell/button"]];
    }
    else if (self.readyToPost && ![self.mkSell isDraft] && self.mkSell.isLocal)
    {
        [_postOrBuyButton setHidden:YES];
    }
    else
    {
        //_postOrBuyButton.backgroundColor = [NSColor colorWithCalibratedWhite:0.9 alpha:1.0];
        [_postOrBuyButton setTitleAttributes:[NavTheme.sharedNavTheme attributesDictForPath:@"sell/button-disabled"]];
    }
    
    [_postOrBuyButton setNeedsDisplay:YES];
}

- (MKSell *)sell
{
    return (MKSell *)self.node;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
    [[NSColor whiteColor] set];
    NSRectFill(dirtyRect);
}

/*
- (void)updateAddressColor
{
    if (self.hasValidAddress)
    {
        self.addressField.textColor = [Theme.sharedTheme formText2Color];
    }
    else
    {
        self.addressField.textColor = [Theme.sharedTheme formTextErrorColor];
    }
}
*/

- (void)textDidChange:(NSNotification *)aNotification
{
    NSTextView *aTextView = [aNotification object];
    
    if ([aTextView respondsToSelector:@selector(textDidChange)])
    {
        [(MKTextView *)aTextView textDidChange];
    }
    
    if (aTextView == self.price)
    {
        NSLog(@"price change");
        [self.price setSuffix:@"BTC    ?USD    ?EUR"];
    }
    
    [self updateButton];
    [self syncToNode]; // to show on table cell
}

- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)aTextView
{
    if ([aTextView respondsToSelector:@selector(textDidBeginEditing)])
    {
        [(MKTextView *)aTextView textShouldBeginEditing];
    }
    
    return YES;
}

- (void)textDidBeginEditing:(NSText *)aTextView
{
    if ([aTextView respondsToSelector:@selector(textDidBeginEditing)])
    {
        [(MKTextView *)aTextView textDidBeginEditing];
    }
}

- (void)textDidEndEditing:(NSNotification *)aNotification
{
    NSTextView *aTextView = [aNotification object];
    
    if ([aTextView respondsToSelector:@selector(textDidEndEditing)])
    {
        [(MKTextView *)aTextView textDidEndEditing];
    }
    
    [[aNotification object] endEditing];
    [self saveChanges];
    [self updateButton];
}

- (void)saveChanges
{

}

// -- sync ----

- (void)selectFirstResponder
{
    //[self.window makeFirstResponder:self.labelField];
    //[self.labelField selectAll:nil];
    //[labelField becomeFirstResponder];
}

// actions

- (void)post
{
    if (!self.readyToPost)
    {
        return;
    }
    
    [self.mkSell post];
    [self updateButton];
}

- (void)buy
{
    //[self.mkSell post];
}

@end
