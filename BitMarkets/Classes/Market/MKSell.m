//
//  MKSell.m
//  Bitmessage
//
//  Created by Steve Dekorte on 3/21/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import "MKSell.h"
#import <NavKit/NavKit.h>

@implementation MKSell

- (id)init
{
    self = [super init];
    self.date = [NSDate date];
    return self;
}

- (NSArray *)modelActions
{
    return [NSArray arrayWithObjects:@"delete", nil];
}

- (NSString *)nodeTitle
{
    return @"(Draft)";
}

- (NSString *)nodeSubtitle
{
    //return @"Draft";
    return nil;
}

- (NSString *)nodeNote
{
    return self.date.itemDateString;
}

- (CGFloat)nodeSuggestedWidth
{
    return 150;
}

- (void)delete
{
    [self.nodeParent removeChild:self];
}

- (NSArray *)properties
{
    NSMutableArray *p = [NSMutableArray array];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"category" forKey:@"name"];
    [dict setObject:@"category" forKey:@"choices"];
    [p addObject:dict];
    
    
    return p;
}


@end
