//
//  Item.h
//  Homepwner
//
//  Created by Ricky Pattillo on 1/19/15.
//  Copyright (c) 2015 Ricky Pattillo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>


@interface Item : NSManagedObject

@property (nonatomic, strong) NSString *itemName;
@property (nonatomic, strong) NSString *serialNumber;
@property (nonatomic, strong) NSDate *dateCreated;
@property (nonatomic, strong) NSString *itemKey;
@property (nonatomic, strong) UIImage *thumbnail;

@property (nonatomic) int valueInDollars;
@property (nonatomic) double orderingValue;

@property (nonatomic, strong) NSManagedObject *assetType;

- (void)setThumbnailFromImage:(UIImage *)image;

@end
