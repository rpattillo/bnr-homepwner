//
//  DetailViewController.m
//  Homepwner
//
//  Created by Ricky Pattillo on 12/24/14.
//  Copyright (c) 2014 Ricky Pattillo. All rights reserved.
//

#import "DetailViewController.h"
#import "Item.h"
#import "ImageStore.h"

@interface DetailViewController ()
   <UINavigationControllerDelegate,
   UIImagePickerControllerDelegate,
   UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *serialNumberField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

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
   
   NSString *itemKey = item.itemKey;
   UIImage *imageToDisplay = [[ImageStore sharedStore] imageForKey:itemKey];
   self.imageView.image = imageToDisplay;
}


- (void)viewWillDisappear:(BOOL)animated
{
   [super viewWillDisappear:animated];
   
   Item *item = self.item;
   item.itemName = self.nameField.text;
   item.serialNumber = self.serialNumberField.text;
   item.valueInDollars = [self.valueField.text intValue];
}


#pragma mark - NIB connections

- (IBAction)takePicture:(id)sender
{
   UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
   
   if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
      imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
   }
   else {
      imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
   }
   
   imagePicker.allowsEditing = YES;
   
   imagePicker.delegate = self;
   
   [self presentViewController:imagePicker animated:YES completion:nil];
}


- (IBAction)backgroundTapped:(id)sender
{
   [self.view endEditing:YES];
}


#pragma mark - Image Picker Controller delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
   UIImage *image = info[UIImagePickerControllerEditedImage];
   
   [[ImageStore sharedStore] setImage:image forKey:self.item.itemKey];
   
   self.imageView.image = image;
   [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Text Field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
   [textField resignFirstResponder];
   
   return YES;
}

@end
