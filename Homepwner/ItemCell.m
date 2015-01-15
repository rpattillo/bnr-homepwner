//
//  ItemCell.m
//  Homepwner
//
//  Created by Ricky Pattillo on 1/12/15.
//  Copyright (c) 2015 Ricky Pattillo. All rights reserved.
//

#import "ItemCell.h"

@interface ItemCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeightConstraint;


@end


@implementation ItemCell

- (void)awakeFromNib
{
   [self updateInterfaceForDynamicTypeSize];

   NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
   [nc addObserver:self
          selector:@selector(updateInterfaceForDynamicTypeSize)
              name:UIContentSizeCategoryDidChangeNotification
            object:nil];

   NSLayoutConstraint *constraint =
      [NSLayoutConstraint constraintWithItem:self.thumbnailView
                                   attribute:NSLayoutAttributeHeight
                                   relatedBy:NSLayoutRelationEqual
                                      toItem:self.thumbnailView
                                   attribute:NSLayoutAttributeWidth
                                  multiplier:1
                                    constant:0];
   [self.thumbnailView addConstraint:constraint];
}


- (void)dealloc
{
   NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
   [nc removeObserver:self];
}


- (void)updateInterfaceForDynamicTypeSize
{
   UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
   self.nameLabel.font = font;
   self.serialNumberLabel.font = font;
   self.valueLabel.font = font;

   static NSDictionary *imageSizeDictionary;
   if (!imageSizeDictionary) {
      imageSizeDictionary = @{UIContentSizeCategoryExtraSmall: @40,
                              UIContentSizeCategorySmall: @40,
                              UIContentSizeCategoryMedium: @40,
                              UIContentSizeCategoryLarge: @40,
                              UIContentSizeCategoryExtraLarge: @45,
                              UIContentSizeCategoryExtraExtraLarge: @55,
                              UIContentSizeCategoryExtraExtraExtraLarge: @65};
   }

   NSString *userSize = [[UIApplication sharedApplication] preferredContentSizeCategory];
   NSNumber *imageSize = imageSizeDictionary[userSize];
   self.imageViewHeightConstraint.constant = imageSize.floatValue;
}


- (IBAction)showImage:(id)sender
{
   if (self.actionBlock) {
      self.actionBlock();
   }
}

@end
