//
//  ImageStore.h
//  Homepwner
//
//  Created by Ricky Pattillo on 12/27/14.
//  Copyright (c) 2014 Ricky Pattillo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageStore : NSObject

+ (instancetype)sharedStore;

- (void)setImage:(UIImage *)image forKey:(NSString *)key;
- (UIImage *)imageForKey:(NSString *)key;
- (void)deleteImageForKey:(NSString *)key;

@end
