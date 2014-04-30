//
//  MKGroup.h
//  Bitmessage
//
//  Created by Steve Dekorte on 3/24/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

//#import <BitmessageKit/BitmessageKit.h>
#import <NavKit/NavKit.h>

@interface MKGroup : NavInfoNode

@property (strong, nonatomic) NSString *name;
//@property (assign, nonatomic) NSInteger count;

+ (MKGroup *)rootInstance;

- (void)setDict:(NSDictionary *)dict;

- (void)setCanPost:(BOOL)aBool;

- (void)read;
- (void)write;

- (NSArray *)groupSubpaths;
- (NSArray *)groupPath;

- (void)updateCounts;
- (NSInteger)countOfLeafChildren;

@end
