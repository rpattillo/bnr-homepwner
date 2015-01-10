//
//  DetailViewController.h
//  Homepwner
//
//  Created by Ricky Pattillo on 12/24/14.
//  Copyright (c) 2014 Ricky Pattillo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Item;

@interface DetailViewController : UIViewController

@property (nonatomic, strong) Item *item;
@property (nonatomic, copy) void (^dismissBlock)(void);

- (instancetype) initForNewItem:(BOOL)isNew;

@end
