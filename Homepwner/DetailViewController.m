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
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraButton;

@end



@implementation DetailViewController

#pragma mark - Accessors

- (void)setItem:(Item *)item
{
   _item = item;
   self.navigationItem.title = _item.itemName;
}

#pragma mark - Interface Adjustments

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration
{
   [self prepareViewsForOrientation:toInterfaceOrientation];
}


#pragma mark - View life cycle

- (void)viewDidLoad
{
   [super viewDidLoad];
   
   UIImageView *imageView = [[UIImageView alloc] initWithImage:nil];
   [self.view addSubview:imageView];
   self.imageView = imageView;
   
   imageView.contentMode = UIViewContentModeScaleAspectFit;
   imageView.translatesAutoresizingMaskIntoConstraints = NO;
   [imageView setContentHuggingPriority:200
                                forAxis:UILayoutConstraintAxisVertical];
   [imageView setContentCompressionResistancePriority:700
                                              forAxis:UILayoutConstraintAxisVertical];

   
   NSDictionary *horizontalNameMap = @{@"imageView": imageView};
   NSArray *horizontalConstraints =
      [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageView]|"
                                              options:0
                                              metrics:nil
                                                views:horizontalNameMap];
   [self.view addConstraints:horizontalConstraints];
   
   
   NSDictionary *verticalNameMap = @{@"imageView": imageView,
                                      @"dateLabel": self.dateLabel,
                                      @"toolbar": self.toolbar};
   NSArray *verticalConstraints =
      [NSLayoutConstraint constraintsWithVisualFormat:@"V:[dateLabel]-[imageView]-[toolbar]"
                                              options:0
                                              metrics:nil
                                                views:verticalNameMap];
   [self.view addConstraints:verticalConstraints];
}


- (void)viewWillAppear:(BOOL)animated
{
   [super viewWillAppear:animated];
   
   UIInterfaceOrientation io = [[UIApplication sharedApplication] statusBarOrientation];
   [self prepareViewsForOrientation:io];
   
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


#pragma mark - Private view adjustment methods

- (void)prepareViewsForOrientation:(UIInterfaceOrientation)orientation
{
   if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
      return;
   }
   
   if (UIInterfaceOrientationIsLandscape(orientation)) {
      self.imageView.hidden = YES;
      self.cameraButton.enabled = NO;
   }
   else {
      self.imageView.hidden = NO;
      self.cameraButton.enabled = YES;
   }
}


#pragma mark - NIB connections and Actions

- (IBAction)takePicture:(id)sender
{
   UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
   
   if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
      imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
   }
   else {
      imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
   }
   
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
   UIImage *image = info[UIImagePickerControllerOriginalImage];
   
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
