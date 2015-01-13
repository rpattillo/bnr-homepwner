//
//  ImageViewController.m
//  Homepwner
//
//  Created by Ricky Pattillo on 1/12/15.
//  Copyright (c) 2015 Ricky Pattillo. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()

@end

@implementation ImageViewController

#pragma mark - View life cycle

- (void)loadView
{
   UIImageView *imageView = [[UIImageView alloc] init];
   imageView.contentMode = UIViewContentModeScaleAspectFit;
   self.view = imageView;
}


- (void)viewWillAppear:(BOOL)animated
{
   [super viewWillAppear:animated];
   UIImageView *imageView = (UIImageView *)self.view;
   imageView.image = self.image;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
