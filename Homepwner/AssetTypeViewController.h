//
//  AssetTypeViewController.h
//  Homepwner
//
//  Created by Ricky Pattillo on 1/19/15.
//  Copyright (c) 2015 Ricky Pattillo. All rights reserved.
//

@import UIKit;

@class Item;

@interface AssetTypeViewController : UITableViewController

@property (nonatomic, strong) Item *item;
@property (nonatomic, copy) void (^dismissBlock)(void);

@end
