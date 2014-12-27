//
//  ImageStore.m
//  Homepwner
//
//  Created by Ricky Pattillo on 12/27/14.
//  Copyright (c) 2014 Ricky Pattillo. All rights reserved.
//

#import "ImageStore.h"

@interface ImageStore ()

@property (nonatomic, strong) NSMutableDictionary *dictionary;

@end


@implementation ImageStore


#pragma mark - Initializers

+ (instancetype)sharedStore
{
   static ImageStore *sharedStore = nil;
   
   if (!sharedStore) {
      sharedStore = [[ImageStore alloc] initPrivate];
   }
   return sharedStore;
}


- (instancetype)init
{
   @throw [NSException exceptionWithName:@"Singleton"
                                  reason:@"Use +[ImageStore sharedStore]"
                                userInfo:nil];
   return nil;
}


- (instancetype)initPrivate
{
   self = [super init];
   if (self) {
      _dictionary = [[NSMutableDictionary alloc] init];
   }
   
   return self;
}


#pragma mark - Store management

- (void)setImage:(UIImage *)image forKey:(NSString *)key
{
   [self.dictionary setObject:image forKey:key];
}


- (UIImage *)imageForKey:(NSString *)key
{
   return [self.dictionary objectForKey:key];
}


- (void)deleteImageForKey:(NSString *)key
{
   if (!key) {
      return;
   }
   [self.dictionary removeObjectForKey:key];
}


@end
