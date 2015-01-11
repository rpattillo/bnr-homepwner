//
//  ItemStore.m
//  Homepwner
//
//  Created by Ricky Pattillo on 12/20/14.
//  Copyright (c) 2014 Ricky Pattillo. All rights reserved.
//

#import "ItemStore.h"
#import "Item.h"
#import "ImageStore.h"

@interface ItemStore ()

@property (nonatomic, strong) NSMutableArray *privateItems;

@end


@implementation ItemStore

#pragma mark - Initializers

+ (instancetype)sharedStore
{
   static ItemStore *sharedStore = nil;
   
   static dispatch_once_t onceToken;
   dispatch_once(&onceToken, ^{
      sharedStore = [[self alloc] initPrivate];
   });
   
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
      NSString *path = [self itemArchivePath];
      _privateItems = [NSKeyedUnarchiver unarchiveObjectWithFile:path];

      if (!_privateItems) {
         _privateItems = [[NSMutableArray alloc] init];
      }
   }
   
   return self;
}


#pragma mark - Item Management

- (NSArray *)allItems
{
   return self.privateItems;
}


- (Item *)createItem
{
   Item *item = [[Item alloc] init];
   [self.privateItems addObject:item];
   
   return item;
}


- (void)removeItem:(Item *)item
{
   [self.privateItems removeObjectIdenticalTo:item];
   
   [[ImageStore sharedStore] deleteImageForKey:item.itemKey];
}


- (void)moveItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
   if (fromIndex == toIndex) {
      return;
   }
   
   Item *item = self.privateItems[fromIndex];
   [self.privateItems removeObjectAtIndex:fromIndex];
   [self.privateItems insertObject:item atIndex:toIndex];
}


#pragma mark - Store management

- (BOOL)saveChanges
{
   NSString *path = [self itemArchivePath];
   return [NSKeyedArchiver archiveRootObject:self.privateItems toFile:path];
}


- (NSString *)itemArchivePath
{
   NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                      NSUserDomainMask,
                                                                      YES);
   NSString *documentDirectory = [documentDirectories firstObject];

   return [documentDirectory stringByAppendingPathComponent:@"items.archive"];
}


@end
