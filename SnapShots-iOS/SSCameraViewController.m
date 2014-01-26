//
//  SSViewController.m
//  SnapShots-iOS
//
//  Created by Austin Feight on 1/24/14.
//  Copyright (c) 2014 Lost in Flight Studios. All rights reserved.
//

#import "SSCameraViewController.h"
#import "SSLoginViewController.h"

@interface SSCameraViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIImage *chosenImage;

- (IBAction)takePhoto:(id)sender;

@end

@implementation SSCameraViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  if ([[NSUserDefaults standardUserDefaults] objectForKey:@"username"] == nil ||
        [[NSUserDefaults standardUserDefaults] objectForKey:@"password"] == nil) {
//    SSLoginViewController *vc = [[SSLoginViewController alloc] init];
    [self performSegueWithIdentifier:@"Log In" sender:self];
  }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)takePhoto:(id)sender {
  UIImagePickerController *picker = [[UIImagePickerController alloc] init];
  [picker setDelegate:self];
  [picker setAllowsEditing:YES];
  [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
  
  [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - Image Picker Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
  NSLog(@"here");
  UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
  [_imageView setImage:chosenImage];
  [picker dismissViewControllerAnimated:YES completion:^{
    [SSNetworking sendImage:chosenImage];
  }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
  [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
