//
//  AssetTypeViewController.m
//  Homepwner
//
//  Created by Ricky Pattillo on 1/19/15.
//  Copyright (c) 2015 Ricky Pattillo. All rights reserved.
//

#import "AssetTypeViewController.h"
#import "ItemStore.h"
#import "Item.h"

@implementation AssetTypeViewController

- (instancetype)init
{
   self = [super initWithStyle:UITableViewStylePlain];
   if (self) {
      self.navigationItem.title = NSLocalizedString(@"Asset Type",
                                                    @"AssetTypeViewController title");
   }

   return self;
}


- (instancetype)initWithStyle:(UITableViewStyle)style
{
   return [self init];
}


- (void)viewDidLoad
{
   [super viewDidLoad];

   [self.tableView registerClass:[UITableViewCell class]
          forCellReuseIdentifier:@"UITableViewCell"];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return [[[ItemStore sharedStore] allAssetTypes] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"
                                                           forIndexPath:indexPath];

   NSArray *allAssets = [[ItemStore sharedStore] allAssetTypes];
   NSManagedObject *assetType = allAssets[indexPath.row];

   NSString *assetLabel = [assetType valueForKey:@"label"];
   cell.textLabel.text = assetLabel;

   if (assetType == self.item.assetType) {
      cell.accessoryType = UITableViewCellAccessoryCheckmark;
   }
   else {
      cell.accessoryType = UITableViewCellAccessoryNone;
   }

   return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
   cell.accessoryType = UITableViewCellAccessoryCheckmark;

   NSArray *allAssets = [[ItemStore sharedStore] allAssetTypes];
   NSManagedObject *assetType = allAssets[indexPath.row];
   self.item.assetType = assetType;

   [self.navigationController popViewControllerAnimated:YES];
}

@end
