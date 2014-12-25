//
//  DateViewController.m
//  Homepwner
//
//  Created by Ricky Pattillo on 12/24/14.
//  Copyright (c) 2014 Ricky Pattillo. All rights reserved.
//

#import "DateViewController.h"
#import "Item.h"

@interface DateViewController ()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end


@implementation DateViewController

- (void)viewWillAppear:(BOOL)animated
{
   [super viewWillAppear:animated];
   self.datePicker.date = self.item.dateCreated;
}


- (void)viewWillDisappear:(BOOL)animated
{
   [super viewWillDisappear:animated];
   
   self.item.dateCreated = self.datePicker.date;
}

@end
