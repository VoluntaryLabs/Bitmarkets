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


@interface NSTableColumn (tags)
- (void)setWidthPercentage:(NSNumber *)aNumber;
- (NSNumber *)widthPercentage;
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

@end

@implementation BNTx (table)

- (NSString *)tableConfirmsString
{
    return [NSString stringWithFormat:@"%@ confirms    ", self.confirmations];
}

- (NSString *)tableDescriptionString
{
    return [NSString stringWithFormat:@"%@ of %@ BTC with %@ confirmations",
            self.txTypeString, self.netValue.satoshiToBtc, self.confirmations];
}

- (NSString *)tableHashString
{
    return [NSString stringWithFormat:@"    %@",
            self.txHash];
}

@end

@implementation BNWalletView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setAutoresizesSubviews:NO];
        [self setAutoresizingMask:NSViewHeightSizable | NSViewWidthSizable];
        
        _statusView = [[MKStatusView alloc] initWithFrame:NSMakeRect(0, 0, self.width, 60*2)];
        _statusView.title = @"Balance";
        _statusView.autoresizingMask = NSViewMaxXMargin;
        [self addSubview:_statusView];
        [_statusView setThemePath:@"sell/price"];
        
        _scrollView = [[NSScrollView alloc] initWithFrame:NSMakeRect(0, 0, self.width, 60*2)];
        [self addSubview:_scrollView];
        
        _tableView = [[NSTableView alloc] initWithFrame:NSMakeRect(0, 0, self.width, 60*2)];
        _tableView.autoresizingMask = NSViewMinYMargin | NSViewMaxXMargin;
        _tableView.backgroundColor = [NSColor colorWithCalibratedWhite:.95 alpha:1.0];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_scrollView setDocumentView:_tableView];
        
        
        [_tableView setIntercellSpacing:NSMakeSize(0, 0)];
        [_tableView setAutoresizesSubviews:YES];
        [_tableView setAutoresizingMask:NSViewHeightSizable];
        _tableView.rowHeight = 30;
        [_tableView setAllowsColumnResizing:NO];
        //_tableView.cellClass = NSTextCell.class;
    }
    
    return self;
}

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
    [column setHeaderCell:[[NSTableHeaderCell alloc] init]];
    
    [_tableView addTableColumn:column];
    
    
    return column;
}

- (void)setupTableColumns
{
    NSTableColumn *column = [self newColumnWithIdentifier:@"txHash"];
    [column setWidthPercentage:@60];
    
    column = [self newColumnWithIdentifier:@"tableDescriptionString"];
    [column setWidthPercentage:@40];
    
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
    [_tableView setHeight:_tableView.rowHeight*(self.transactions.count + 1)];
   
    [self layoutColumns];
}

- (void)syncFromNode
{
    [_statusView setNode:self.node];
    [_statusView syncFromNode];
    [self layout];
    [_tableView reloadData];
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

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
    return self.transactions.count;
}

- (id)tableView:(NSTableView *)aTableView
        objectValueForTableColumn:(NSTableColumn *)aTableColumn
                            row:(NSInteger)rowIndex
{
    BNTx *tx = [self.transactions objectAtIndex:rowIndex];
    NSString *columnName = aTableColumn.identifier;
    id result = [tx performSelector:NSSelectorFromString(columnName) withObject:nil];
    return result;
}

- (void)tableView:(NSTableView *)aTableView
  willDisplayCell:(id)aCell
   forTableColumn:(NSTableColumn *)aTableColumn
              row:(NSInteger)rowIndex
{
    NSTextFieldCell *cell = aCell;
    [cell setSelectable:YES];
    /*
     cell.backgroundColor = [NSColor whiteColor];
    cell.textColor = [NSColor colorWithCalibratedWhite:.6 alpha:1.0];
    cell.alignment = NSLeftTextAlignment;
    */
    
    [cell setThemePath:@"table/cell"];
    
    //cell->_cFlags.vCentered = NSCenterTextAlignment;
    //NSLog(@"cell %@", cell.className);
    
    if (aTableColumn == aTableView.tableColumns.lastObject)
    {
        //cell.alignment = NSRightTextAlignment;
        [cell setThemePath:@"table/cell-right"];
    }
}

- (BOOL)tableView:(NSTableView *)aTableView shouldSelectRow:(NSInteger)rowIndex
{
    return NO;
}

@end
