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

@import CoreData;

@interface ItemStore ()

@property (nonatomic, strong) NSMutableArray *privateItems;
@property (nonatomic, strong) NSMutableArray *allAssetTypes;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSManagedObjectModel *model;

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
   if (self) {
      _model = [NSManagedObjectModel mergedModelFromBundles:nil];
      NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc]
                                           initWithManagedObjectModel:_model];
      NSString *path = [self itemArchivePath];
      NSURL *storeURL = [NSURL fileURLWithPath:path];

      NSError *error = nil;
      if (![psc addPersistentStoreWithType:NSSQLiteStoreType
                             configuration:nil
                                       URL:storeURL
                                   options:nil
                                     error:&error]) {
         @throw [NSException exceptionWithName:@"OpenFailure"
                                        reason:[error localizedDescription]
                                      userInfo:nil];
      }

      _context = [[NSManagedObjectContext alloc] init];
      _context.persistentStoreCoordinator = psc;

      [self loadAllItems];
   }
   
   return self;
}


#pragma mark - Item Management

- (void)loadAllItems
{
   if (!self.privateItems) {
      NSFetchRequest *request = [[NSFetchRequest alloc] init];

      NSEntityDescription *entity = [NSEntityDescription entityForName:@"Item"
                                                inManagedObjectContext:self.context];
      request.entity = entity;

      NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"orderingValue"
                                                             ascending:YES];
      request.sortDescriptors = @[sort];

      NSError *error = nil;
      NSArray *result = [self.context executeFetchRequest:request error:&error];
      if (!result) {
         [NSException raise:@"Fetch failed"
                     format:@"Reason: %@", [error localizedDescription]];
      }

      self.privateItems = [[NSMutableArray alloc] initWithArray:result];
   }
}


- (NSArray *)allItems
{
   return self.privateItems;
}


- (Item *)createItem
{
   double order;
   if ([self.allItems count] == 0) {
      order = 1.0;
   }
   else {
      order = [[self.privateItems lastObject] orderingValue] + 1.0;
   }

   NSLog(@"Adding after %lu items, order = %.2f",
         (unsigned long)[self.privateItems count],
         order);

   Item *item = [NSEntityDescription insertNewObjectForEntityForName:@"Item"
                                              inManagedObjectContext:self.context];

   item.orderingValue = order;

   [self.privateItems addObject:item];
   
   return item;
}


- (void)removeItem:(Item *)item
{
   [self.privateItems removeObjectIdenticalTo:item];

   [[ImageStore sharedStore] deleteImageForKey:item.itemKey];

   [self.context deleteObject:item];
}


- (void)moveItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
   if (fromIndex == toIndex) {
      return;
   }
   
   Item *item = self.privateItems[fromIndex];
   [self.privateItems removeObjectAtIndex:fromIndex];
   [self.privateItems insertObject:item atIndex:toIndex];

   double lowerBound = 0.0;
   if (toIndex > 0) {
      lowerBound = [self.privateItems[(toIndex - 1)] orderingValue];
   }
   else {
      lowerBound = [self.privateItems[1] orderingValue] - 2.0;
   }

   double upperBound = 0.0;
   if (toIndex < [self.privateItems count] - 1) {
      upperBound = [self.privateItems[(toIndex + 1)] orderingValue];
   }
   else {
      upperBound = [self.privateItems[(toIndex - 1)] orderingValue] + 2.0;
   }

   double newOrderValue = (lowerBound + upperBound) / 2.0;

   NSLog(@"moving to order %f", newOrderValue);
   item.orderingValue = newOrderValue;
}


#pragma mark - Asset Type management

- (NSArray *)allAssetTypes
{
   if (!_allAssetTypes) {
      NSFetchRequest *request = [[NSFetchRequest alloc] init];
      NSEntityDescription *entity = [NSEntityDescription entityForName:@"AssetType"
                                                inManagedObjectContext:self.context];
      request.entity = entity;

      NSError *error = nil;
      NSArray *result = [self.context executeFetchRequest:request error:&error];
      if (!result) {
         [NSException raise:@"Fetch failed"
                     format:@"Reason: %@", [error localizedDescription]];
      }

      _allAssetTypes = [result mutableCopy];
   }

   if ([_allAssetTypes count] == 0) {
      NSManagedObject *type;

      type = [NSEntityDescription insertNewObjectForEntityForName:@"AssetType"
                                           inManagedObjectContext:self.context];
      [type setValue:@"Furniture" forKey:@"label"];
      [_allAssetTypes addObject:type];

      type = [NSEntityDescription insertNewObjectForEntityForName:@"AssetType"
                                           inManagedObjectContext:self.context];
      [type setValue:@"Jewelry" forKey:@"label"];
      [_allAssetTypes addObject:type];

      type = [NSEntityDescription insertNewObjectForEntityForName:@"AssetType"
                                           inManagedObjectContext:self.context];
      [type setValue:@"Electronics" forKey:@"label"];
      [_allAssetTypes addObject:type];

   }

   return _allAssetTypes;
}


#pragma mark - Store management

- (BOOL)saveChanges
{
   NSError *error = nil;
   BOOL isSuccessful = [self.context save:&error];
   if (!isSuccessful) {
      NSLog(@"Error saving: %@", [error localizedDescription]);
   }

   return isSuccessful;
}


- (NSString *)itemArchivePath
{
   NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                      NSUserDomainMask,
                                                                      YES);
   NSString *documentDirectory = [documentDirectories firstObject];

   return [documentDirectory stringByAppendingPathComponent:@"store.data"];
}


@end
