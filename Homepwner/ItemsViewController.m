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

@end


@implementation ItemsViewController

#pragma mark - Initializers

- (instancetype)init
{
   self = [super initWithStyle:UITableViewStylePlain];
   if (self) {
      for (int i = 0; i < 5; i++) {
         [[ItemStore sharedStore] createItem];
      }
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


#pragma mark - NIB Connections

- (UIView *)headerView
{
   if ( !_headerView ) {
      [[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:self options:nil];
   }
   
   return _headerView;
}


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
