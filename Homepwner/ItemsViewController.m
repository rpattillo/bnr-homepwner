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

@interface ItemsViewController()

@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) UITableViewRowAction *deleteAction;

@end


@implementation ItemsViewController

#pragma mark - Initializers

- (instancetype)init
{
   self = [super initWithStyle:UITableViewStylePlain];
   if (self) {

   }

   return self;
}


- (instancetype)initWithStyle:(UITableViewStyle)style
{
   return [self init];
}


#pragma mark - Accessors

- (UIView *)headerView
{
   if ( !_headerView ) {
      [[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:self options:nil];
   }

   return _headerView;
}


- (UITableViewRowAction *)deleteAction
{
   if ( !_deleteAction ) {
      self.deleteAction =
         [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive
                                            title:@"Remove"
                                          handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                             [self tableView:self.tableView
                                          commitEditingStyle:UITableViewCellEditingStyleDelete
                                           forRowAtIndexPath:indexPath];
                                          }];
   }

   return _deleteAction;
}


#pragma mark - View life cycle

- (void)viewDidLoad
{
   [super viewDidLoad];
   
   [self.tableView registerClass:[UITableViewCell class]
          forCellReuseIdentifier:@"UITableViewCell"];
   
   UIView *header = self.headerView;
   [self.tableView setTableHeaderView:header];
}


#pragma mark - Table View Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return [[[ItemStore sharedStore] allItems] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
   NSArray *items = [[ItemStore sharedStore] allItems];
   Item *item = items[indexPath.row];
   
   cell.textLabel.text = item.description;
   
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

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
   return @[self.deleteAction];
}


#pragma mark - NIB Connections

- (IBAction)addNewItem:(id)sender
{
   Item *newItem = [[ItemStore sharedStore] createItem];
   NSInteger lastRow = [[[ItemStore sharedStore] allItems] indexOfObject:newItem];
   NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
   
   [self.tableView insertRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationTop];
}


- (IBAction)toggleEditingMode:(id)sender
{
   if (self.isEditing) {
      [sender setTitle:@"Edit" forState:UIControlStateNormal];
      [self setEditing:NO animated:YES];
   }
   else {
      [sender setTitle:@"Done" forState:UIControlStateNormal];
      [self setEditing:YES animated:YES];
   }
}



@end
