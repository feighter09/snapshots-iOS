//
//  SSLoginViewController.m
//  SnapShots-iOS
//
//  Created by Austin Feight on 1/25/14.
//  Copyright (c) 2014 Lost in Flight Studios. All rights reserved.
//

#import "SSLoginViewController.h"

@interface SSLoginViewController ()

@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
- (IBAction)save:(id)sender;

@end

@implementation SSLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)save:(id)sender {
  NSString *username = [_usernameField text];
  [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"username"];
  NSString *password = [_passwordField text];
  [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"password"];
  [[NSUserDefaults standardUserDefaults] synchronize];
  
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [self.view endEditing:YES];
}


@end
