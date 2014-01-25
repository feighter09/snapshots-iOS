//
//  SSViewController.m
//  SnapShots-iOS
//
//  Created by Austin Feight on 1/24/14.
//  Copyright (c) 2014 Lost in Flight Studios. All rights reserved.
//

#import "SSCameraViewController.h"

@interface SSCameraViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)takePhoto:(id)sender;

@end

@implementation SSCameraViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
  
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)takePhoto:(id)sender {
  UIImagePickerController *picker = [[UIImagePickerController alloc] init];
  [picker setDelegate:self];
  [picker setAllowsEditing:NO];
  [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
  
  [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - Image Picker Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
  
  UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
  self.imageView.image = chosenImage;
  
  [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
  [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
