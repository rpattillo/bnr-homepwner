//
//  Item.m
//  Homepwner
//
//  Created by Ricky Pattillo on 1/19/15.
//  Copyright (c) 2015 Ricky Pattillo. All rights reserved.
//

#import "Item.h"


@implementation Item

@dynamic itemName;
@dynamic serialNumber;
@dynamic valueInDollars;
@dynamic dateCreated;
@dynamic itemKey;
@dynamic thumbnail;
@dynamic orderingValue;
@dynamic assetType;


- (void)setThumbnailFromImage:(UIImage *)image
{
   CGSize origImageSize = image.size;
   CGRect newRect = CGRectMake(0, 0, 40, 40);
   float ratio = MAX(newRect.size.width / origImageSize.width,
                     newRect.size.height / origImageSize.height);

   UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0.0);

   UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:newRect cornerRadius:5.0];
   [path addClip];

   CGRect projectRect;
   projectRect.size.width = ratio * origImageSize.width;
   projectRect.size.height = ratio * origImageSize.height;
   projectRect.origin.x = (newRect.size.width - projectRect.size.width) / 2.0;
   projectRect.origin.y = (newRect.size.height - projectRect.size.height) / 2.0;
   [image drawInRect:projectRect];

   UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
   self.thumbnail = smallImage;

   UIGraphicsEndImageContext();
}


- (void)awakeFromInsert
{
   [super awakeFromInsert];

   self.dateCreated = [NSDate date];

   NSUUID *uuid = [[NSUUID alloc] init];
   NSString *key = [uuid UUIDString];
   self.itemKey = key;
}

@end
