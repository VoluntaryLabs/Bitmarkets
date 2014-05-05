//
//  MKSells.h
//  Bitmessage
//
//  Created by Steve Dekorte on 3/13/14.
//  Copyright (c) 2014 Bitmarkets.org. All rights reserved.
//

#import <BitmessageKit/BMNode.h>
#import "MKSell.h"
#import "MKGroup.h"

@interface MKSells : MKGroup

- (MKSell *)justAdd;

/*
- (void)load;
- (void)save;
*/

@end
