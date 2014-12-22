//
//  ItemStore.h
//  Homepwner
//
//  Created by Ricky Pattillo on 12/20/14.
//  Copyright (c) 2014 Ricky Pattillo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Item;

@interface ItemStore : NSObject

@property (nonatomic, readonly) NSArray *allItems;
@property (nonatomic, readonly) NSArray *expensiveItems;
@property (nonatomic, readonly) NSArray *inexpensiveItems;

+ (instancetype)sharedStore;
- (Item *)createItem;

@end
