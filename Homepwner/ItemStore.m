//
//  ItemStore.m
//  Homepwner
//
//  Created by Ricky Pattillo on 12/20/14.
//  Copyright (c) 2014 Ricky Pattillo. All rights reserved.
//

#import "ItemStore.h"
#import "Item.h"

@interface ItemStore ()

@property (nonatomic, strong) NSMutableArray *privateItems;

@end


@implementation ItemStore

#pragma mark - Initializers

+ (instancetype)sharedStore
{
   static ItemStore *sharedStore = nil;
   
   if (!sharedStore) {
      sharedStore = [[self alloc] initPrivate];
   }
   
   return sharedStore;
}


- (instancetype)init
{
   @throw [NSException exceptionWithName:@"Singleton"
                                  reason:@"use +[ItemStore sharedStore]"
                                userInfo:nil];
   return nil;
}


- (instancetype)initPrivate
{
   self = [super init];
   if ( self ) {
      _privateItems = [[NSMutableArray alloc] init];
   }
   
   return self;
}


#pragma mark - Accessors

- (NSArray *)allItems
{
   return self.privateItems;
}


#pragma mark - Store Management

- (Item *)createItem
{
   Item *item = [Item randomItem];
   [self.privateItems addObject:item];
   
   return item;
}


- (void)removeItem:(Item *)item
{
   [self.privateItems removeObjectIdenticalTo:item];
}


@end
