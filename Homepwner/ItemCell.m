//
//  ItemCell.m
//  Homepwner
//
//  Created by Ricky Pattillo on 1/12/15.
//  Copyright (c) 2015 Ricky Pattillo. All rights reserved.
//

#import "ItemCell.h"

@implementation ItemCell

- (IBAction)showImage:(id)sender
{
   if (self.actionBlock) {
      self.actionBlock();
   }
}

@end
