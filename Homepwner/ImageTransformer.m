//
//  ImageTransformer.m
//  Homepwner
//
//  Created by Ricky Pattillo on 1/19/15.
//  Copyright (c) 2015 Ricky Pattillo. All rights reserved.
//

#import "ImageTransformer.h"

@implementation ImageTransformer

+ (Class)transformedValueClass
{
   return [NSData class];
}


- (id)transformedValue:(id)value
{
   if (!value) {
      return nil;
   }

   if ([value isKindOfClass:[NSData class]]) {
      return value;
   }

   return UIImagePNGRepresentation(value);
}


- (id)reverseTransformedValue:(id)value
{
   return [UIImage imageWithData:value];
}

@end
