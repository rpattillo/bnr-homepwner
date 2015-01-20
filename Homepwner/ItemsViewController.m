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

@interface ItemsViewController() <UIPopoverControllerDelegate,
   UIViewControllerRestoration,
   UIDataSourceModelAssociation>

@property (nonatomic, strong) UIPopoverController *imagePopover;

@end


@implementation ItemsViewController

#pragma mark - State Restoration

+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents
                                                            coder:(NSCoder *)coder
{
   return [[self alloc] init];
}


- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
   [coder encodeBool:self.isEditing forKey:@"TableViewIsEditing"];

   [super encodeRestorableStateWithCoder:coder];
}


- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
   [coder decodeBoolForKey:@"TableViewIsEditing"];

   [super decodeRestorableStateWithCoder:coder];
}


#pragma mark Datasource model association

- (NSString *)modelIdentifierForElementAtIndexPath:(NSIndexPath *)idx inView:(UIView *)view
{
   NSString *identifier = nil;

   if (idx && view) {
      Item *item = [[ItemStore sharedStore] allItems][idx.row];
      identifier = item.itemKey;
   }

   return identifier;
}


- (NSIndexPath *)indexPathForElementWithModelIdentifier:(NSString *)identifier inView:(UIView *)view
{
   NSIndexPath *indexPath = nil;

   if (identifier && view) {
      NSArray *items = [[ItemStore sharedStore] allItems];
      for (Item *item in items) {
         if ([identifier isEqualToString:item.itemKey]) {
            int row = (int)[items indexOfObjectIdenticalTo:item];
            indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            break;
         }
      }
   }

   return indexPath;
}


#pragma mark - Initializers

- (instancetype)init
{
   self = [super initWithStyle:UITableViewStylePlain];
   if (self) {
      UINavigationItem *navItem = self.navigationItem;
      navItem.title = NSLocalizedString(@"Homepwner", @"Name of application");
      UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]
                                        initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                        target:self
                                        action:@selector(addNewItem:)];
      navItem.rightBarButtonItem = barButtonItem;
      navItem.leftBarButtonItem = self.editButtonItem;

      NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
      [nc addObserver:self
             selector:@selector(updateTableViewForDynamicTypeSize)
                 name:UIContentSizeCategoryDidChangeNotification
               object:nil];
      [nc addObserver:self
             selector:@selector(localeChanged)
                 name:NSCurrentLocaleDidChangeNotification
               object:nil];

      self.restorationIdentifier = NSStringFromClass([self class]);
      self.restorationClass = [self class];
   }

   return self;
}


- (instancetype)initWithStyle:(UITableViewStyle)style
{
   return [self init];
}


- (void)dealloc
{
   NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
   [nc removeObserver:self];
}


#pragma mark - View life cycle

- (void)viewDidLoad
{
   [super viewDidLoad];
   
   UINib *itemCellNib = [UINib nibWithNibName:@"ItemCell" bundle:nil];
   [self.tableView registerNib:itemCellNib forCellReuseIdentifier:@"ItemCell"];

   self.tableView.restorationIdentifier = @"ItemsViewControllerTableView";
}


- (void)viewWillAppear:(BOOL)animated
{
   [super viewWillAppear:animated];

   [self updateTableViewForDynamicTypeSize];
}


#pragma mark - Interface adjustments

- (void)updateTableViewForDynamicTypeSize
{
   static NSDictionary *cellHeightDictionary;
   if (!cellHeightDictionary) {
      cellHeightDictionary = @{UIContentSizeCategoryExtraSmall: @44,
                               UIContentSizeCategorySmall: @44,
                               UIContentSizeCategoryMedium: @44,
                               UIContentSizeCategoryLarge: @44,
                               UIContentSizeCategoryExtraLarge: @55,
                               UIContentSizeCategoryExtraExtraLarge: @65,
                               UIContentSizeCategoryExtraExtraExtraLarge: @75};
   }

   NSString *userSize = [[UIApplication sharedApplication] preferredContentSizeCategory];
   NSNumber *cellHeight= cellHeightDictionary[userSize];
   [self.tableView setRowHeight:cellHeight.floatValue];

   [self.tableView reloadData];
}


- (void)localeChanged
{
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

   static NSNumberFormatter *currencyFormatter = nil;
   if (!currencyFormatter) {
      currencyFormatter = [[NSNumberFormatter alloc] init];
      currencyFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
   }
   cell.valueLabel.text = [currencyFormatter stringFromNumber:@(item.valueInDollars)];

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
   navVC.restorationIdentifier = NSStringFromClass([navVC class]);

   [self presentViewController:navVC animated:YES completion:nil];

}


#pragma mark - Popover Controller delegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
   self.imagePopover = nil;
}

@end
