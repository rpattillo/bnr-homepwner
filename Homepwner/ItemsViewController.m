//
//  ItemsViewController.m
//  Homepwner
//
//  Created by Ricky Pattillo on 12/20/14.
//  Copyright (c) 2014 Ricky Pattillo. All rights reserved.
//

#import "ItemsViewController.h"
#import "ItemStore.h"
#import "Item.h"
#import "DetailViewController.h"
#import "ItemCell.h"
#import "ImageStore.h"
#import "ImageViewController.h"

@interface ItemsViewController() <UIPopoverControllerDelegate>

@property (nonatomic, strong) UIPopoverController *imagePopover;

@end


@implementation ItemsViewController

#pragma mark - Initializers

- (instancetype)init
{
   self = [super initWithStyle:UITableViewStylePlain];
   if (self) {
      UINavigationItem *navItem = self.navigationItem;
      navItem.title = @"Homepwner";
      UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]
                                        initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                        target:self
                                        action:@selector(addNewItem:)];
      navItem.rightBarButtonItem = barButtonItem;
      navItem.leftBarButtonItem = self.editButtonItem;
   }

   return self;
}


- (instancetype)initWithStyle:(UITableViewStyle)style
{
   return [self init];
}


#pragma mark - View life cycle

- (void)viewDidLoad
{
   [super viewDidLoad];
   
   UINib *itemCellNib = [UINib nibWithNibName:@"ItemCell" bundle:nil];
   [self.tableView registerNib:itemCellNib forCellReuseIdentifier:@"ItemCell"];
}


- (void)viewWillAppear:(BOOL)animated
{
   [super viewWillAppear:animated];
   
   [self.tableView reloadData];
}


#pragma mark - Table View Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return [[[ItemStore sharedStore] allItems] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   NSArray *items = [[ItemStore sharedStore] allItems];
   Item *item = items[indexPath.row];

   ItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemCell"
                                                    forIndexPath:indexPath];
   cell.nameLabel.text = item.itemName;
   cell.serialNumberLabel.text = item.serialNumber;
   cell.valueLabel.text = [NSString stringWithFormat:@"$%d", item.valueInDollars];
   cell.thumbnailView.image = item.thumbnail;

   __weak ItemCell *weakCell = cell;
   cell.actionBlock = ^{
      NSLog(@"Going to show image for %@", item);

      ItemCell *strongCell = weakCell;

      if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
         NSString *itemKey = item.itemKey;
         UIImage *image = [[ImageStore sharedStore] imageForKey:itemKey];

         if (!image) {
            return;
         }

         CGRect rect = [self.view convertRect:strongCell.thumbnailView.bounds
                                     fromView:strongCell.thumbnailView];
         ImageViewController *imageVC = [[ImageViewController alloc] init];
         imageVC.image = image;

         self.imagePopover = [[UIPopoverController alloc] initWithContentViewController:imageVC];
         self.imagePopover.delegate = self;
         self.imagePopover.popoverContentSize = CGSizeMake(600, 600);
         [self.imagePopover presentPopoverFromRect:rect
                                            inView:self.view
                          permittedArrowDirections:UIPopoverArrowDirectionAny
                                          animated:YES];
      }
   };

   return cell;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
   if (editingStyle == UITableViewCellEditingStyleDelete) {
      NSArray *items = [[ItemStore sharedStore] allItems];
      Item *item = items[indexPath.row];
      [[ItemStore sharedStore] removeItem:item];
      
      [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
   }
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
   [[ItemStore sharedStore] moveItemAtIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
}


#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   DetailViewController *detailVC = [[DetailViewController alloc] initForNewItem:NO];
   NSArray *items = [[ItemStore sharedStore] allItems];
   detailVC.item = items[indexPath.row];
   [self.navigationController pushViewController:detailVC animated:YES];
}


#pragma mark - Item Management

- (void)addNewItem:(id)sender
{
   Item *newItem = [[ItemStore sharedStore] createItem];

   DetailViewController *detailVC = [[DetailViewController alloc] initForNewItem:YES];
   detailVC.item = newItem;
   detailVC.dismissBlock = ^{
      [self.tableView reloadData];
   };
   UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:detailVC];
   navVC.modalPresentationStyle = UIModalPresentationFormSheet;

   [self presentViewController:navVC animated:YES completion:nil];

}


#pragma mark - Popover Controller delegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
   self.imagePopover = nil;
}

@end
