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
   
   static dispatch_once_t onceToken;
   dispatch_once(&onceToken, ^{
      sharedStore = [[self alloc] initPrivate];
   });

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

      NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
      [nc addObserver:self
             selector:@selector(clearCache:)
                 name:UIApplicationDidReceiveMemoryWarningNotification
               object:nil];
   }
   
   return self;
}


#pragma mark - Image management

- (void)setImage:(UIImage *)image forKey:(NSString *)key
{
   self.dictionary[key] = image;

   NSData *data = UIImagePNGRepresentation(image);
   NSString *imagePath = [self imagePathForKey:key];
   [data writeToFile:imagePath atomically:YES];
}


- (UIImage *)imageForKey:(NSString *)key
{
   UIImage *image = self.dictionary[key];

   if (!image) {
      NSString *imagePath = [self imagePathForKey:key];
      image = [UIImage imageWithContentsOfFile:imagePath];

      if (image) {
         self.dictionary[key] = image;
      }
      else {
         NSLog(@"Error: unable to find %@", imagePath);
      }
   }

   return image;
}


- (void)deleteImageForKey:(NSString *)key
{
   if (!key) {
      return;
   }
   [self.dictionary removeObjectForKey:key];

   NSString *imagePath = [self imagePathForKey:key];
   [[NSFileManager defaultManager] removeItemAtPath:imagePath error:nil];
}

#pragma mark - Private image management

- (NSString *)imagePathForKey:(NSString *)key
{
   NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                      NSUserDomainMask,
                                                                      YES);
   NSString *documentDirectory = [documentDirectories firstObject];
   return [documentDirectory stringByAppendingPathComponent:key];
}


#pragma mark - Store management

- (void)clearCache:(NSNotification *)note
{
   NSLog( @"flushing %lu images out of the cache", [self.dictionary count]);
   [self.dictionary removeAllObjects];
}

@end
