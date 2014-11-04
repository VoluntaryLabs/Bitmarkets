//
//  BNWalletView.m
//  BitMarkets
//
//  Created by Steve Dekorte on 6/26/14.
//  Copyright (c) 2014 voluntary.net. All rights reserved.
//

#import "BNWalletView.h"
#import "MKPanelManager.h"
#import <BitnashKit/BitnashKit.h>
#import <objc/runtime.h>
#import "MKTextFieldCell.h"
#import "MKCurrency.h"


@interface NSTableColumn (tags)

- (void)setWidthPercentage:(NSNumber *)aNumber;
- (NSNumber *)widthPercentage;

- (void)setAlignment:(NSTextAlignment)aNumber;
- (NSTextAlignment)alignment;

@end

@implementation NSTableColumn (tags)

- (void)setWidthPercentage:(NSNumber *)aNumber
{
    objc_setAssociatedObject(self, @"widthPercentage", aNumber, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)widthPercentage
{
    return objc_getAssociatedObject(self, @"widthPercentage");
}

- (void)setAlignment:(NSTextAlignment)anAlignment
{
    [self.headerCell setAlignment:anAlignment];
/*
    NSNumber *num = [NSNumber numberWithInteger:anAlignment];
    objc_setAssociatedObject(self, @"alignment", num, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
 */
}

- (NSTextAlignment)alignment
{
    return ((NSCell *)self.headerCell).alignment;
    /*
    NSNumber *num = objc_getAssociatedObject(self, @"alignment");
    
    if (num)
    {
        return (NSTextAlignment)[num integerValue];
    }
    
    return NSLeftTextAlignment;
    */
}

@end

@implementation BNWallet (UI)

/*
- (NSString *)nodeTitle
{
    if (self.usesTestNet)
    {
        return @"Bitcoin Testnet Balance";
    }
    
    return @"Balance";
}
*/

- (NSString *)nodeSubtitleDetailed
{
    if (self.isRunning)
    {
        MKCurrency *currency = [[MKCurrency alloc] init];
        currency.btcAmount = self.balance.satoshiToBtc;
        NSString *s = currency.formattedPriceSetString;
        return s;
    }
    
    return @"starting...";
}


@end

@implementation BNTx (table)

- (NSString *)tableConfirmsString
{
    return [NSString stringWithFormat:@"%@", self.confirmations];
}

- (NSString *)tableAmount
{
    return [NSString stringWithFormat:@"%@ BTC", [self.netValue.satoshiToBtc asFormattedStringWithFractionalDigits:4]];
}

- (NSString *)tableHashString
{
    return [NSString stringWithFormat:@"%@", self.txHash];
}

/*
- (NSString *)tableDescriptionString
{
    return [NSString stringWithFormat:@"%@ of %@ BTC with %@ confirmations",
            self.txTypeString, self.netValue.satoshiToBtc, self.confirmations];
}
*/

@end

@implementation BNWalletView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setAutoresizesSubviews:YES];
        [self setAutoresizingMask:NSViewHeightSizable | NSViewWidthSizable];
        
        _statusView = [[MKStatusView alloc] initWithFrame:NSMakeRect(0, 0, self.width, 60*2)];
        _statusView.title = @"Balance";
        _statusView.autoresizingMask = NSViewMaxXMargin;
        [self addSubview:_statusView];
        [_statusView setThemePath:@"sell/price"];
        _statusView.subtitleSelector = @selector(nodeSubtitleDetailed);
        
        _scrollView = [[NSScrollView alloc] initWithFrame:NSMakeRect(0, 0, self.width, 60*2)];
        [self addSubview:_scrollView];
        
        _tableView = [[NSTableView alloc] initWithFrame:NSMakeRect(0, 0, self.width, 60*2)];
        _tableView.autoresizingMask = NSViewMinYMargin | NSViewMaxXMargin;
        //_tableView.backgroundColor = [NSColor colorWithCalibratedWhite:0.9 alpha:1.0];
        [_tableView setSelectionHighlightStyle:NSTableViewSelectionHighlightStyleNone];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_scrollView setDocumentView:_tableView];
        [_scrollView setHasVerticalScroller:YES];
        
        /*
        [NSNotificationCenter.defaultCenter
            addObserver:self
            selector:@selector(tableSelectionChanged:)
            name:NSTableViewSelectionDidChangeNotification
            object:_tableView];
        */

        //[_scrollView setBackgroundColor:[NSColor whiteColor]];
        
        [_tableView setIntercellSpacing:NSMakeSize(0, 0)];
        [_tableView setAutoresizesSubviews:YES];
        [_tableView setAutoresizingMask:NSViewHeightSizable];
        _tableView.rowHeight = 44; //33;
        [_tableView setAllowsColumnResizing:NO];
        //_tableView.cellClass = NSTextCell.class;
        
        _standinText = [[NavTextView alloc] init];
        [_standinText setSelectable:NO];
        [self addSubview:_standinText];
        [_standinText setThemePath:@"wallet/info"];
    }
    
    return self;
}

- (void)dealloc
{
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (BOOL)selectionShouldChangeInTableView:(NSTableView *)aTableView
{
    return YES;
}

/*
 // this doesn't seem to get called
 
- (void)tableViewSelectionDidChange:(NSNotification *)aNote
{
    NSInteger rowIndex = [_tableView selectedRow];
    
    if (rowIndex > 0)
    {
        BNTx *tx = [self.headerAndRows objectAtIndex:rowIndex];
        [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:tx.webUrl]];
    }
}
*/

- (BOOL)tableView:(NSTableView *)aTableView shouldSelectRow:(NSInteger)rowIndex
{
    if (rowIndex > 0)
    {
        [self openUrlAlert];
    }
    
    return YES;
}

- (void)inspectRow
{
    NSInteger rowIndex = [_tableView selectedRow];
    
    if (rowIndex > 0)
    {
        BNTx *tx = [self.headerAndRows objectAtIndex:rowIndex];
        [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:tx.webUrl]];
    }
}

- (void)openUrlAlert
{
    NSAlert *msgBox = [[NSAlert alloc] init];
    [msgBox setMessageText: @"Inspect transaction on blockchain.info?\n\nWARNING:\nTHIS MAY ALLOW A PASSIVE OBSERVER TO CONNECT YOUR TRANSACTIONS TO YOUR LOCATION"];
    [msgBox addButtonWithTitle: @"Inspect"];
    [msgBox addButtonWithTitle: @"Cancel"];

    [msgBox beginSheetModalForWindow:self.window
                       modalDelegate:self
                      didEndSelector:@selector(urlAlertDidEnd:returnCode:contextInfo:)
                         contextInfo:nil];
}

- (void)urlAlertDidEnd:(NSAlert *)alert
            returnCode:(NSInteger)returnCode
           contextInfo:(void *)contextInfo
{
    if (returnCode == 1000)
    {
        [self inspectRow];
    }
    
    [_tableView deselectAll:nil];
}

/*
 - (BOOL)tableView:(NSTableView *)aTableView shouldEditTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
 {
 return YES;
 }
 */

// ----------------------------------------------

- (void)setNode:(NavNode *)node
{
    [super setNode:node];
    
    [self setupTableColumns];
}

- (NSTableColumn *)newColumnWithIdentifier:(NSString *)name
{
    NSTableColumn *column = [[NSTableColumn alloc] init];
    [column setIdentifier:name];
    [column setEditable:NO];

    [column setDataCell:[[MKTextFieldCell alloc] init]];
    NSTableHeaderCell *header = [[NSTableHeaderCell alloc] init];
    [header setStringValue:name];
    [header setTextColor:[NSColor blackColor]];
    [column setHeaderCell:header];
    [column setEditable:NO];

    
    [_tableView addTableColumn:column];
    
    return column;
}

- (void)setupTableColumns
{
    {
        NSTableColumn *column = [self newColumnWithIdentifier:@"updateTimeDescription"];
        [column.headerCell setStringValue:@"Time"];
        [column setWidthPercentage:@20];
        [column setAlignment:NSLeftTextAlignment];
    }
    
    {
        NSTableColumn *column = [self newColumnWithIdentifier:@"confirmations"];
        [column.headerCell setStringValue:@"Confirms"];
        [column setWidthPercentage:@15];
        [column setAlignment:NSLeftTextAlignment];
    }
    
    {
        /*
        NSTableColumn *column = [self newColumnWithIdentifier:@"tableHashString"];
        [column.headerCell setStringValue:@"Address"];
        [column setWidthPercentage:@50];
         */
    }
    
    {
        NSTableColumn *column = [self newColumnWithIdentifier:@"txType"];
        [column.headerCell setStringValue:@"Type"];
        [column setWidthPercentage:@15];
        [column setAlignment:NSLeftTextAlignment];
    }
    
    {
        NSTableColumn *column = [self newColumnWithIdentifier:@"description"];
        [column.headerCell setStringValue:@"Description"];
        [column setWidthPercentage:@30];
        [column setAlignment:NSLeftTextAlignment];
    }
    
    {
        NSTableColumn *column = [self newColumnWithIdentifier:@"tableAmount"];
        [column.headerCell setStringValue:@"Amount"];
        [column setWidthPercentage:@20];
        [column setAlignment:NSRightTextAlignment];
    }
    
    //column = [self newColumnWithIdentifier:@"tableConfirmsString"];
    //[column setWidthPercentage:@10];
    
    [self.tableView setHeaderView:nil];
    [self.tableView setFocusRingType:NSFocusRingTypeNone];
}

- (void)layoutColumns
{
    if (_tableView.tableColumns.count)
    {
        NSInteger sum = 0;
        NSInteger tableWidth = _tableView.width;
        
        for (NSTableColumn *column in _tableView.tableColumns)
        {
            if (column == _tableView.tableColumns.lastObject)
            {
                [column setWidth:tableWidth - sum];
            }
            else
            {
                NSInteger w = tableWidth *([column widthPercentage].floatValue/100.0);
                [column setWidth:w];
            }
            
            sum += column.width;
        }
        
        assert(sum == tableWidth);
        
        [_tableView setNeedsDisplay];
    }
}

- (void)layout
{
    /*
    for (id view in self.subviews)
    {
        [view layout];
    }
    */
    
    [_statusView setX:0];
    [_statusView setY:self.height - _statusView.height];
    [_statusView setWidth:self.width];
    [_statusView layout];
    
    CGFloat margin = 30;
    
    [_scrollView setHeight:_statusView.y-margin*2];
    //[_scrollView setHeight:_tableView.rowHeight*(self.transactions.count + 1)];
    [_scrollView placeYBelow:_statusView margin:margin];
    [_scrollView setX:margin];
    [_scrollView setWidth:self.width - margin*2];
    

    [_tableView setWidth:_scrollView.width];
    
    CGFloat th = _tableView.rowHeight * (self.headerAndRows.count + 1);
    [_tableView setHeight:th];
    
    [_standinText setWidth:self.width];
    [_standinText setX:0];
    [_standinText setY:_scrollView.y + _scrollView.height/2 - _standinText.height/2];
    
    
    if (self.transactions.count)
    {
        [_scrollView setHidden:NO];
        [_standinText setHidden:YES];
    }
    else
    {
        [_scrollView setHidden:YES];
        [_standinText setHidden:NO];
    }

    [self layoutColumns];
}

- (void)syncFromNode
{
    [_statusView setNode:self.node];
    [_statusView syncFromNode];
    [self layout];
    [_tableView reloadData];
    
    if (self.wallet.usesTestNet)
    {
        _statusView.title = @"Bitcoin Testnet Balance";
    }
    
    if (self.transactions.count == 0)
    {
        [_standinText setString:@"no transactions"];
    }
    
    if (self.wallet.isRunning == NO)
    {
        [_standinText setString:@"waiting for wallet to start..."];
    }
}

- (void)drawRect:(NSRect)dirtyRect
{
    [[MKPanelManager sharedPanelManager] setPanelReceiver:self];
    
    [super drawRect:dirtyRect];
}

- (BNWallet *)wallet
{
    return (BNWallet *)self.node;
}

- (NSArray *)transactions
{
    return self.wallet.transactionsNode.children;
}

- (NSArray *)headerNames
{
    NSMutableArray *names = [NSMutableArray array];
    
    for (NSTableColumn *column in self.tableView.tableColumns)
    {
        NSCell *headerCell = column.headerCell;
        [names addObject:headerCell.stringValue];
    }
    
    return names;
}

- (NSArray *)headerAndRows
{
    return [@[self.headerNames] arrayByAddingObjectsFromArray:self.transactions];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
    return self.headerAndRows.count;
}

- (id)tableView:(NSTableView *)aTableView
        objectValueForTableColumn:(NSTableColumn *)aTableColumn
                            row:(NSInteger)rowIndex
{
    id obj = [self.headerAndRows objectAtIndex:rowIndex];
    
    if (rowIndex == 0)
    {
        NSInteger columnIndex = [aTableView.tableColumns indexOfObject:aTableColumn];
        NSArray *headerNames = obj;
        return [headerNames objectAtIndex:columnIndex];
    }
    
    BNTx *tx = obj;
    
    NSString *columnName = aTableColumn.identifier;
    
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    id result = [tx performSelector:NSSelectorFromString(columnName)];
    #pragma clang diagnostic pop
    
    return result;
}

- (void)tableView:(NSTableView *)aTableView
  willDisplayCell:(id)aCell
   forTableColumn:(NSTableColumn *)aTableColumn
              row:(NSInteger)rowIndex
{
    MKTextFieldCell *cell = aCell;
    [cell setSelectable:YES];
    
    //BOOL isRowSelected = [aTableView selectedRow] == rowIndex;
    //[cell setHighlighted:isRowSelected];

    /*
     cell.backgroundColor = [NSColor whiteColor];
    cell.textColor = [NSColor colorWithCalibratedWhite:.6 alpha:1.0];
    cell.alignment = NSLeftTextAlignment;
    */
    
    [cell setThemePath:@"table/cell"];
    
    //cell->_cFlags.vCentered = NSCenterTextAlignment;
    //NSLog(@"cell %@", cell.className);
    
    //if (aTableColumn == aTableView.tableColumns.lastObject)
    {
        //cell.alignment = NSRightTextAlignment;
        //[cell setThemePath:@"table/cell-right"];
        [cell setAlignment:[aTableColumn alignment]];
    }
    
    if (rowIndex == 0)
    {
        [cell setThemePath:@"table/header"];
    }
    
    /*
    if (aTableColumn == aTableView.tableColumns.lastObject)
    {
        [cell setAlignment:NSRightTextAlignment];
    }
     */
    
    //[cell setBackgroundColor:[NSColor whiteColor]];
    //[cell setDrawsBackground:YES];
    
    BOOL isLastRow = (rowIndex == self.headerAndRows.count - 1);
    [cell setBottomLineWidth:isLastRow ? 0 : .5];
    cell.lineColor = [NSColor colorWithCalibratedWhite:.9 alpha:1.0];
}

// actions

- (void)openPanelForView:(NSView *)aView
{
    MKPanelView *panel = [[MKPanelManager sharedPanelManager] openNewPanel];
    [panel setInnerView:aView];
    [self addSubview:panel];
    [panel layout];
}

- (void)openDepositView
{
    [self openPanelForView:self.wallet.depositKey.nodeView];
}

- (void)openWithdrawlView
{
    [self openPanelForView:self.wallet.withdralNode.nodeView];
}

@end
