//
//  DetailViewController.m
//  Homepwner
//
//  Created by Ricky Pattillo on 12/24/14.
//  Copyright (c) 2014 Ricky Pattillo. All rights reserved.
//

#import "DetailViewController.h"
#import "Item.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *serialNumberField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end



@implementation DetailViewController

#pragma mark - Accessors

- (void)setItem:(Item *)item
{
   _item = item;
   self.navigationItem.title = _item.itemName;
}


#pragma mark - View life cycle

- (void)viewWillAppear:(BOOL)animated
{
   [super viewWillAppear:animated];
   
   Item *item = self.item;
   self.nameField.text = item.itemName;
   self.serialNumberField.text = item.serialNumber;
   self.valueField.text = [NSString stringWithFormat:@"%d", item.valueInDollars];

   static NSDateFormatter *dateFormatter = nil;
   if ( !dateFormatter ) {
      dateFormatter = [[NSDateFormatter alloc] init];
      dateFormatter.dateStyle = NSDateFormatterMediumStyle;
      dateFormatter.timeStyle = NSDateFormatterNoStyle;
   }
   self.dateLabel.text = [dateFormatter stringFromDate:item.dateCreated];
}


- (void)viewWillDisappear:(BOOL)animated
{
   [super viewWillDisappear:animated];
   
   Item *item = self.item;
   item.itemName = self.nameField.text;
   item.serialNumber = self.serialNumberField.text;
   item.valueInDollars = [self.valueField.text intValue];
}

@end
