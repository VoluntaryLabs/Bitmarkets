//
//  MKDraftPostView.m
//  Bitmessage
//
//  Created by Steve Dekorte on 2/21/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "MKPostView.h"
#import <NavKit/NavKit.h>
#import <BitmessageKit/BitmessageKit.h>
#import <FoundationCategoriesKit/FoundationCategoriesKit.h>
#import "MKRootNode.h"


@implementation MKPostView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setAutoresizesSubviews:YES];
        [self setAutoresizingMask:NSViewHeightSizable | NSViewWidthSizable];

        
        // scrolling

        _documentView = [[NavColoredView alloc] initWithFrame:NSMakeRect(0, 0, self.width, self.height)];
        [_documentView setAutoresizesSubviews:NO];
        [_documentView setAutoresizingMask:NSViewHeightSizable | NSViewWidthSizable];

        
        _documentView.backgroundColor = nil;
        _scrollView = [[NSScrollView alloc] initWithFrame:NSMakeRect(0, 0, self.width, self.height)];
        [self addSubview:_scrollView];
        [_scrollView setAutoresizesSubviews:YES];
        [_scrollView setAutoresizingMask:NSViewHeightSizable | NSViewWidthSizable];
        [_scrollView setDocumentView:_documentView];
        [_scrollView setHasVerticalScroller:YES];
        
        // content
        
        
        _title = [[NavAdvTextView alloc] initWithFrame:NSMakeRect(0, 0, 650, 24)];
        [_title setAutoresizingMask:NSViewNotSizable];
        _title.uneditedTextString = @"Enter title";
        [_documentView addSubview:_title];
        [_title setEditedThemePath:@"sell/title"];
        [_title setDelegate:self];
        _title.endsOnReturn = YES;
        _title.maxStringLength = @40;
        //@property (strong) IBOutlet NSTextView *quantity;
        
        _price = [[NavAdvTextView alloc] initWithFrame:NSMakeRect(0, 0, 550, 24)];
        [_price setAutoresizingMask:NSViewNotSizable];
        [_price setAutoresizesSubviews:NO];
        //_price.autoresizingMask = NSViewMinYMargin | NSViewMaxXMargin;
        [_price setString:@"0"];
        [_documentView addSubview:_price];
        _price.uneditedTextString = @"Enter price in BTC";
        //_price.suffix = @"BTC";
        [_price setDelegate:self];
        [_price setEditedThemePath:@"sell/price"];
        _price.endsOnReturn = YES;
        
        _title.nextKeyView = _price;
        
        _errorText = [[NavAdvTextView alloc] initWithFrame:NSMakeRect(0, 0, 550, 24)];
        _errorText.autoresizingMask = NSViewMinYMargin | NSViewMaxXMargin;
        [_documentView addSubview:_errorText];
        _errorText.string = @"";
        [_errorText setEditable:NO];
        [_errorText setEditedThemePath:@"sell/error"];
        

        
        _separator = [[NavColoredView alloc] initWithFrame:NSMakeRect(0, 0, self.width, 1)];
        [_separator setThemePath:@"sell/separator"];
        [_documentView addSubview:_separator];
        
        _postDescription = [[NavAdvTextView alloc] initWithFrame:NSMakeRect(0, 0, 500, 100)];
        _postDescription.uneditedTextString = @"Enter description";
        [_postDescription setDelegate:self];
        //self.description.string = @"I've had this TOA amp in the closet for a while waiting to setup in my shop space but I need the space so my loss is your gain. Works fine and is in mostly decent condition with a few dings on the corners. I'm available during the day near 7th and Folsom but I can also meet up in the evening in the Mission.";
        [self.postDescription setEditedThemePath:@"sell/description"];
        [_documentView addSubview:_postDescription];
 
        _price.nextKeyView = _postDescription;

        // region
        
        _regionIcon = [[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, 16, 16)];
        [_regionIcon setImage:[NSImage imageNamed:@"location_active.png"]];
        [_documentView addSubview:_regionIcon];
 
        _region = [[NavTextView alloc] initWithFrame:NSMakeRect(0, 0, 500, 24)];
        [_region setEditable:NO];
        //[_region setSuffix:@" Shipping"];
        [_region setThemePath:@"sell/label"];
        [_documentView addSubview:_region];
        
        // category
        
        _categoryIcon = [[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, 16, 16)];
        [_categoryIcon setImage:[NSImage imageNamed:@"right_active.png"]];
        [_documentView addSubview:_categoryIcon];
        
        _category = [[NavTextView alloc] initWithFrame:NSMakeRect(0, 0, 500, 24)];
        //self.category.string = @"Electronics";
        [_category setEditable:NO];
        [_category setThemePath:@"sell/label"];
        [_documentView addSubview:_category];
        
        // fromAddress
        
        _fromAddressIcon = [[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, 16, 16)];
        [_fromAddressIcon setImage:[NSImage imageNamed:@"profile_active.png"]];
        [_documentView addSubview:_fromAddressIcon];
        
        _fromAddress = [[NavTextView alloc] initWithFrame:NSMakeRect(0, 0, 500, 24)];
        [_fromAddress setEditable:NO];
        [_fromAddress setThemePath:@"sell/address"];
        [_documentView addSubview:_fromAddress];

        // attachment
        
        _attachmentView = [[MKAttachmentView alloc] initWithFrame:NSMakeRect(0, 0, 500, 24)];
        [_attachmentView setAutoresizesSubviews:NO];
        [_documentView addSubview:_attachmentView];
        
        _postOrBuyButton = [[NavRoundButtonView alloc] initWithFrame:NSMakeRect(0, 0, 120, 32)];
        //_postOrBuyButton.title = @"Buy Now";
        _postOrBuyButton.title = @"Post";
        //[_postOrBuyButton setThemePath:@"sell/button"];
        [_postOrBuyButton setTitleAttributes:[NavTheme.sharedNavTheme attributesDictForPath:@"sell/button"]];
        [_documentView addSubview:_postOrBuyButton];
        [_postOrBuyButton setTarget:self];
        [_postOrBuyButton setAction:@selector(post)];
        
        // exchange rate calculator
        
        self.exchangeRate = [MKExchangeRate shared];
        
        [NSNotificationCenter.defaultCenter addObserver:self
                                                 selector:@selector(updatePriceSuffix)
                                                     name:@"ExchangeRatesFetched"
                                                   object:nil];

        [NSNotificationCenter.defaultCenter addObserver:self
                                               selector:@selector(updateButton)
                                                   name:BNWalletStartedNotification
                                                 object:nil];
    }
        
    return self;
}

- (void)setEditable:(BOOL)isEditable
{
    _editable = isEditable;
    
    [_postDescription setEditable:isEditable];
    [_title setEditable:isEditable];
    [_price setEditable:isEditable];
    [_attachmentView setEditable:isEditable];
}

- (BOOL)isOpaque
{
    return NO;
}

+ (CGFloat)leftMargin
{
    return 30.0;
}

- (void)layout
{
    [_scrollView setX:0];
    [_scrollView setY:0];
    [_scrollView setWidth:self.width];
    [_scrollView setHeight:self.height];
    
    [_documentView setX:0];
    [_documentView setY:0];
    [_documentView setWidth:self.width];
    [_documentView setHeight:self.height];
    
    [self layoutSubviewsBottomToTop];
    
    // resize height in a way that maintains the maxY of the documentView
    CGFloat maxY = _documentView.maxY;
    CGFloat newHeight = _title.maxY + 20;
    
    if (self.height > newHeight)
    {
        newHeight = self.height;
        [_documentView setHeight:newHeight];
        [_documentView setMaxY:maxY];
        [_documentView adjustSubviewsY:self.height - (_title.maxY + 20)];
    }
    else
    {
        [_documentView setHeight:newHeight];
        [_documentView setMaxY:maxY];
    }
    
    [_price updateSuffixView];
}

- (void)layoutSubviewsBottomToTop
{
    CGFloat leftMargin = self.class.leftMargin;
    CGFloat bottomMargin = 20;
    CGFloat descriptionMargin = 30;
    CGFloat iconMargin = 5;
    
    [_attachmentView setX:leftMargin+2];
    [_attachmentView setWidth:_documentView.width - _attachmentView.x*2];
    [_attachmentView setHeight:300];
    [_attachmentView setY:bottomMargin];

    [_categoryIcon setX:leftMargin+2];
    [_categoryIcon placeYAbove:_attachmentView margin:descriptionMargin];
    [_category placeXRightOf:_categoryIcon margin:iconMargin];
    [_category setY:_categoryIcon.y-5];

    
    [_fromAddressIcon setX:leftMargin+2];
    [_fromAddressIcon placeYAbove:_categoryIcon margin:iconMargin];
    [_fromAddress placeXRightOf:_fromAddressIcon margin:iconMargin];
    [_fromAddress setY:_fromAddressIcon.y-5];
    
    [_regionIcon setX:leftMargin+2];
    [_regionIcon placeYAbove:_fromAddressIcon margin:iconMargin];
    [_region placeXRightOf:_regionIcon margin:iconMargin];
    [_region setY:_regionIcon.y-5];
    

    // add code to adjust _postDescription height to fit text?
    
    [_postDescription setX:leftMargin];
    [_postDescription setWidth:_documentView.width - leftMargin*2];
    [_postDescription placeYAbove:_regionIcon margin:descriptionMargin];
    
    //NSLog(@"_postDescription.height = %i", (int)_postDescription.height);

    [_separator setX:0];
    [_separator setWidth:_documentView.width];
//    [_separator setY:_documentView.height-60*2];
    [_separator placeYAbove:_postDescription margin:descriptionMargin];
    
    
    [_postOrBuyButton setWidth:84];
    [_postOrBuyButton setX:_documentView.width - _postOrBuyButton.width - leftMargin];
    [_postOrBuyButton placeYAbove:_separator margin:30];
    
    
    [_errorText setX:leftMargin];
    [_errorText placeYAbove:_separator margin:5];
    
    
    [_price setX:leftMargin];
    //[_price placeYBelow:_title margin:0];
    [_price placeYAbove:_errorText margin:0];
    //[_price setWidth:_documentView.width*.7];
    
    [_title setX:leftMargin];
    [_title placeYAbove:_price margin:0];
}

- (void)dealloc
{
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)setFrame:(NSRect)frameRect
{
    [super setFrame:frameRect];
    [self layout];
}

- (void)setNode:(NavNode *)node
{
    _node = node;
    
    [self syncFromNode];
}

- (MKPost *)mkPost
{
    return (MKPost *)self.node;
}

- (void)syncFromNode
{
    [self setEditable:self.mkPost.isEditable];

    _title.string = self.mkPost.title;
    [_title textDidChange];
    [_title useUneditedTextStringIfNeeded];
    
    NSString *priceString = [self.mkPost.priceInBtc asFormattedStringWithFractionalDigits:4];
    _price.string = priceString;
    if ([_price.string isEqualToString:@"0"])
    {
        _price.string = @"";
    }
    
    [_price setSuffix:@"BTC"];
    [_price textDidChange];
    [_price useUneditedTextStringIfNeeded];
    
    self.postDescription.string = self.mkPost.postDescription;
    [self.postDescription textDidChange];
    [self.postDescription useUneditedTextStringIfNeeded];

    _region.string = self.mkPost.regionPath.lastObject ? self.mkPost.regionPath.lastObject : @"MISSING REGION ERROR";
    
    _region.string = [@"Shipping within " stringByAppendingString:_region.string];
    NSString *cPath = [self.mkPost.categoryPath componentsJoinedByString:@" / "];
    _category.string    = cPath;
    _fromAddress.string = self.mkPost.sellerAddress;
    [self setAttachments:self.mkPost.attachments];
    
    [self updateButton];
    [self updatePriceSuffix];
}

- (NSNumber *)priceInBtc
{
    return [self.priceFormatter numberFromString:_price.stringSansUneditedString];
}

- (void)syncToNode
{
    //NSDate *date = [NSDate date];
    
    self.mkPost.title = _title.stringSansUneditedString;

    self.mkPost.priceInBtc = self.priceInBtc;
    self.mkPost.postDescription = self.postDescription.stringSansUneditedString;
    self.mkPost.isDirty = YES;
    
    self.mkPost.attachments = self.attachments;
    [self.mkPost postSelfChanged];
    
    //NSLog(@"==== syncToNode dt = %f", [date timeIntervalSinceNow]);
    [self updateButton];
}

- (void)setAttachments:(NSArray *)attachments
{
    if (attachments)
    {
        NSString *uuString = [attachments firstObject];
        NSImage *image = nil;
        
        if (uuString)
        {
            NSData *data = [uuString decodedBase64Data];
            image = [[NSImage alloc] initWithData:data];
        }
        
        [_attachmentView setImage:image];
    }
}

- (NSArray *)attachments
{
    NSMutableArray *attachments = [NSMutableArray array];
    
    NSData *imageData = [_attachmentView.image jpegImageData];
    
    NSString *uuString = [imageData encodedBase64String];
    
    if (uuString)
    {
        //NSLog(@"imageData length = %iKB", (int)imageData.length/1024);
        //NSLog(@"uuString length = %iKB", (int)uuString.length/1024);
        [attachments addObject:uuString];
    }
    
    return attachments;
}

// --- error text ---

- (NSNumber *)minimumPriceInBtc
{
    // too small to be worth shipping
    return self.mkPost.minimumPriceInBtc;
}

- (BOOL)priceIsLargeEnough
{
    return self.price.string.floatValue > self.minimumPriceInBtc.floatValue;
}

- (BNWallet *)wallet
{
    return MKRootNode.sharedMKRootNode.wallet;
}

- (NSNumber *)escrowInBtc
{
    NSNumber *escrowInBtc = self.mkPost.priceInBtc;
    
    if ([self.mkPost canBuy])
    {
        escrowInBtc = [escrowInBtc multipliedBy:@2];
    }
    
    return escrowInBtc;
}

- (BOOL)hasFundsForEscrow
{
    if (self.wallet.isRunning)
    {
        NSNumber *balanceInSatoshi = self.wallet.cachedBalanceInSatoshi;

        
        if ([balanceInSatoshi isGreaterThan:self.escrowInBtc.btcToSatoshi])
        {
            return YES;
        }
    }
    
    return NO;
}

- (void)updateErrorText
{
    self.errorText.string = @"";
    
    if (!self.wallet.isRunning)
    {
        self.errorText.string = @"waiting for wallet...";
    }
    else if ([self.wallet.cachedBalanceInSatoshi.satoshiToBtc isLessThan:self.minimumPriceInBtc])
    {
        self.errorText.string = [NSString stringWithFormat:
                                 @"insufficient funds in wallet for minimum price of %@BTC",
                                 self.minimumPriceInBtc];
    }
    else if (!self.priceIsLargeEnough)
    {
        self.errorText.string = [NSString stringWithFormat:
                                 @"price must be above %@BTC",
                                 self.minimumPriceInBtc];
    }
    else if (!self.hasFundsForEscrow)
    {
        self.errorText.string = [NSString stringWithFormat:
                                 @"insufficient funds in wallet for escrow of %@BTC",
                                 self.escrowInBtc];
    }

    [self.errorText setNeedsDisplay:YES];
}

- (BOOL)hasValidPrice
{
    return self.hasFundsForEscrow && self.priceIsLargeEnough;
}

- (BOOL)readyToPost
{
    BOOL hasTitle = self.title.isReady;
    BOOL hasDescription = self.postDescription.isReady;
    BOOL hasValidPrice = self.hasValidPrice;
    
    if (self.mkPost.isEditable)
    {
        [_price setIsValid:hasValidPrice];
    }
    
    return hasTitle && hasValidPrice && hasDescription;
}

- (void)updateButton
{
    NSDictionary *enabledAttributes = [NavTheme.sharedNavTheme attributesDictForPath:@"sell/button"];
    NSDictionary *disabledAttributes = [NavTheme.sharedNavTheme attributesDictForPath:@"sell/button-disabled"];

    [_postOrBuyButton setHidden:NO];
    [_postOrBuyButton setEnabled:YES];

    if (self.mkPost.isEditable)
    {
        [self.postOrBuyButton setTitle:@"Post"];
        [self.postOrBuyButton setAction:@selector(post)];
        
        if (self.readyToPost)
        {
            [_postOrBuyButton setTitleAttributes:enabledAttributes];
        }
        else
        {
            [_postOrBuyButton setTitleAttributes:disabledAttributes];
            [_postOrBuyButton setEnabled:NO];
        }
    }
    else
    {
        if ([self.mkPost canBuy])
        {
            [self.postOrBuyButton setTitle:@"Buy"];
            [self.postOrBuyButton setAction:@selector(buy)];
            [_postOrBuyButton setTitleAttributes:[NavTheme.sharedNavTheme attributesDictForPath:@"sell/button"]];
            
            if (!self.hasValidPrice)
            {
                [_postOrBuyButton setTitleAttributes:[NavTheme.sharedNavTheme attributesDictForPath:@"sell/button-disabled"]];
                [_postOrBuyButton setEnabled:YES];
            }
        }
        else
        {
            [_postOrBuyButton setHidden:YES];
            [_postOrBuyButton setEnabled:NO];
        }
    }
    
    [self updateErrorText];
    
    [_postOrBuyButton setNeedsDisplay:YES];
    
    // price

    /*
    if (self.mkPost.isEditable)
    {
        [_price setIsValid:self.hasValidPrice];
    }
    */
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

// --- editing ---------------------------------------------------

- (void)textDidChange:(NSNotification *)aNotification
{
    //NSDate *date = [NSDate date];
    //NSLog(@"textDidChange price = %@", self.price.string);
    
    NSTextView *aTextView = [aNotification object];
    
    if ([aTextView respondsToSelector:@selector(textDidChange)])
    {
        [(NavAdvTextView *)aTextView textDidChange];
    }
    
    if (aTextView == self.price)
    {
        [self updatePriceSuffix];
    }
    
    [self.postDescription setNeedsDisplay:YES];
    [self setNeedsDisplay:YES];
    
    [self syncToNode]; // to show on table cell
    [self layout];
    
    //NSLog(@"==== textDidChange dt = %f", [date timeIntervalSinceNow]);
}

- (void)updatePriceSuffix
{
    float btc = 0;
    
    //if (self.price.textStorage.string.length)
    {
        NSNumber *formattedNumber = [self.priceFormatter numberFromString:_price.string];
        btc = [formattedNumber floatValue];
    }
    
    
    {
        MKExchangeRate *rate = [MKExchangeRate shared];

        NSNumber *usdRate = [rate btcPerSymbol:@"USD"];
        NSNumber *eurRate = [rate btcPerSymbol:@"EUR"];
        
        if(nil != usdRate && nil != eurRate)
        {
            NSNumber *usd = @(btc * [usdRate floatValue]);
            NSNumber *eur = @(btc * [eurRate floatValue]);
            
            NSString *usdString = [usd asFormattedStringWithFractionalDigits:1];
            NSString *eurString = [eur asFormattedStringWithFractionalDigits:1];
            
            [self.price setSuffix:[NSString stringWithFormat:@"BTC    %@USD    %@EUR", usdString, eurString]];
            //[self.price setSuffix:[NSString stringWithFormat:@"BTC    %1.2f USD    %1.2f EUR", usd, eur]];
        }
        else
        {
            [self.price setSuffix:@"BTC"];
        }
    }
}

- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)aTextView
{
    if ([aTextView respondsToSelector:@selector(textDidBeginEditing)])
    {
        [(NavAdvTextView *)aTextView textShouldBeginEditing];
    }
    
    return YES;
}

- (void)textDidBeginEditing:(NSText *)aTextView
{
    if ([aTextView respondsToSelector:@selector(textDidBeginEditing)])
    {
        [(NavAdvTextView *)aTextView textDidBeginEditing];
    }
}

- (NSNumberFormatter *)priceFormatter
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    //[formatter setLocalizesFormat:NO];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setPartialStringValidationEnabled:YES];
    [formatter setMinimum:@0.0]; // dust fee 0.0001
    [formatter setMaximumFractionDigits:6];
    [formatter setMaximumIntegerDigits:3];
    return formatter;
}

- (BOOL)textView:(NSTextView *)aTextView
    shouldChangeTextInRange:(NSRange)affectedCharRange
    replacementString:(NSString *)replacementString
{
    if (aTextView == _price)
    {
        NSString *newString = [_price.string stringByReplacingCharactersInRange:affectedCharRange
                                                                     withString:replacementString];

        if ([newString isEqualToString:@"."])
        {
            newString = @"0.";
        }
        
        NSNumber *formattedNumber = [self.priceFormatter numberFromString:newString];
        BOOL isValid = formattedNumber != nil || newString.length == 0;
        
        if (!isValid)
        {
            NSBeep();
        }
        
        return isValid;
    }
    
    return YES;
}

- (void)removeFromSuperview
{
    [super removeFromSuperview];
}
/*
- (void)controlTextDidChange:(NSNotification *)aNotification
{
    NSTextView *aTextView = [aNotification object];
    
    if (aTextView == _price)
    {
        [_price setIsValid:self.formattedPrice != nil];
    }
}
*/

- (void)textDidEndEditing:(NSNotification *)aNotification
{
    NSTextView *aTextView = [aNotification object];
    
    if ([aTextView respondsToSelector:@selector(textDidEndEditing)])
    {
        [(NavAdvTextView *)aTextView textDidEndEditing];
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
    
    [self showConfirmPostAlert];
}
    
- (void)confirmedPost
{
    [self syncToNode];
    
    [self.mkPost sendPostMsg];
    [self setEditable:NO];
    [self updateButton];
}

- (void)showConfirmPostAlert
{
    NSAlert *msgBox = [[NSAlert alloc] init];
    
    [msgBox setMessageText:@"All communications are done with Bitmessage over Tor, but if your post requires full anonymity you will need to:\n- post from a public wifi network\n- without your cellphone with you\n- where there are no surveilence cameras\n- not use credit cards around the same location and time\n- not use a ride service attached to your identity to travel to or from the location\n- not use bitcoins that have a recorded association with your identity"];
    
    [msgBox addButtonWithTitle: @"Post Now"];
    [msgBox addButtonWithTitle: @"Don't Post Now"];
    
    [msgBox beginSheetModalForWindow:self.window
                       modalDelegate:self
                      didEndSelector:@selector(postAlertDidEnd:returnCode:contextInfo:)
                         contextInfo:nil];
}

- (void)postAlertDidEnd:(NSAlert *)alert
             returnCode:(NSInteger)returnCode
            contextInfo:(void *)contextInfo
{
    if (returnCode == 1000) // 2nd choice
    {
        [self confirmedPost];
    }
}

// --- buy ---

- (void)buy
{
    [self showConfirmBuyAlert];
}

- (void)showConfirmBuyAlert
{
    NSAlert *msgBox = [[NSAlert alloc] init];
    
    [msgBox setMessageText:@"A Bitmarkets transaction requires the buyer to lock 2x the amount of the item and the seller to lock 1x the amount of the item in escrow. This ensures both parties are incentivized to faithfully complete the transaction.\n\nThese bitcoins cannot be spent by either party until both parties agree to release them either for payment or refund."];

    [msgBox addButtonWithTitle: @"Buy"];
    [msgBox addButtonWithTitle: @"Cancel"];
    
    [msgBox beginSheetModalForWindow:self.window
                       modalDelegate:self
                      didEndSelector:@selector(buyAlertDidEnd:returnCode:contextInfo:)
                         contextInfo:nil];
}

- (void)buyAlertDidEnd:(NSAlert *)alert
            returnCode:(NSInteger)returnCode
           contextInfo:(void *)contextInfo
{    
    if (returnCode == 1000) // 2nd choice
    {
        [self confirmedBuy];
    }
}

- (void)confirmedBuy
{
    // reorg this
    
    MKBuy *buy = MKRootNode.sharedMKRootNode.markets.buys.addBuy;
    [buy.mkPost copy:self.mkPost];
    MKBidMsg *bidMsg = [buy.mkPost sendBidMsg];
    [buy.bid addChild:bidMsg];
    
    [self.navView selectNodePath:buy.nodePathArray];

    [MKRootNode.sharedMKRootNode.markets.buys write];
        
    [self.mkPost close];
}

@end
