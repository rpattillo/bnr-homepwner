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
}


#pragma mark - Table View Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   if (section == 0) {
      return [[[ItemStore sharedStore] expensiveItems] count];
   }
   else {
      return [[[ItemStore sharedStore] inexpensiveItems] count];
   }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
   NSArray *items;
   if (indexPath.section == 0) {
      items = [[ItemStore sharedStore] expensiveItems];
   }
   else {
      items = [[ItemStore sharedStore] inexpensiveItems];
   }
   
   Item *item = items[indexPath.row];
   
   cell.textLabel.text = item.description;
   
   return cell;
}



@end
