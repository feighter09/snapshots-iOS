//
//  SSSnapsViewController.m
//  SnapShots-iOS
//
//  Created by Austin Feight on 1/24/14.
//  Copyright (c) 2014 Lost in Flight Studios. All rights reserved.
//

#import "SSSnapsViewController.h"
#import "CameraServer.h"

@interface SSSnapsViewController ()

//@property (strong, nonatomic) AVCaptureSession *captureSession;
@property (strong, nonatomic) IBOutlet UITableView *snapsTable;
@property (strong, nonatomic) UIView *snapView;

@end

@implementation SSSnapsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [_snapsTable setDataSource:self];
  [_snapsTable setDelegate:self];
}

#pragma mark - Table View

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Snap Cell"];
  [cell.textLabel setText:@"Here's some text"];
  
  UILongPressGestureRecognizer *tapRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
  [tapRecognizer setMinimumPressDuration:0];
  [cell addGestureRecognizer:tapRecognizer];
  
  return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 4;
  //  return [_snaps count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (void)handleTap:(UITapGestureRecognizer *)sender {
  // get picture
  
  if (sender.state == UIGestureRecognizerStateBegan) {
    NSLog(@"Tap start");
    [self showSnap];
  } else if (sender.state == UIGestureRecognizerStateEnded) {
    NSLog(@"Tap end");
    [self hideSnap];
  } else {
    NSLog(@"Something else");
  }
}

- (void)showSnap {
  UIImage *img = [[UIImage alloc] init];
  
  if (_snapView == nil) {
    _snapView = [[UIView alloc] initWithFrame:self.view.frame];
  }
  [_snapView setBackgroundColor:[UIColor blueColor]];
  [self.view addSubview:_snapView];

  //maybe background later
  [self startCapture];
}

- (void)hideSnap {
  [_snapView removeFromSuperview];
}

#pragma mark - Video Recording


- (void) startCapture {
  AVCaptureVideoPreviewLayer *preview = [[CameraServer server] getPreviewLayer];
  [preview removeFromSuperlayer];
  preview.frame = _snapView.bounds;
  [[preview connection] setVideoOrientation:AVCaptureVideoOrientationPortrait];
  
  [_snapView.layer addSublayer:preview];
  
//  self.serverAddress.text = [[CameraServer server] getURL];
}

// ----- Demo Code ------//
//
//-(void) startRecording
//{
//  [self initCaptureSession];
//  
//  NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
//                                       pathForResource:@"video"
//                                       ofType:@"mp4"]];
//  [self playMovieAtURL:url];
//  
//  [self startVideoRecording];
//}

@end
