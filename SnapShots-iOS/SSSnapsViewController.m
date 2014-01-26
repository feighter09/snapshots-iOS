//
//  SSSnapsViewController.m
//  SnapShots-iOS
//
//  Created by Austin Feight on 1/24/14.
//  Copyright (c) 2014 Lost in Flight Studios. All rights reserved.
//

#import "SSSnapsViewController.h"
#import "CameraServer.h"
#import "SSNetworking.h"
#import <MediaPlayer/MediaPlayer.h>

@interface SSSnapsViewController ()

//@property (strong, nonatomic) AVCaptureSession *captureSession;
@property (strong, nonatomic) IBOutlet UITableView *snapsTable;
@property (strong, nonatomic) UIView *snapView;
@property (nonatomic) NSUInteger selectedIndex;

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
  [self loadSnaps];
}

- (void)viewDidAppear:(BOOL)animated {
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(handleMPMoviePlayerPlaybackDidFinish:)
                                               name:MPMoviePlayerPlaybackDidFinishNotification
                                             object:nil];
  
  [[NSNotificationCenter defaultCenter] postNotificationName:@"Start Camera Server" object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:MPMoviePlayerPlaybackDidFinishNotification
                                                object:nil];
}

#pragma mark - Table View

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Snap Cell"];
  NSDictionary *snap = [_snaps objectAtIndex:indexPath.row];
  [cell.textLabel setText:@"some text"];
//  [cell.textLabel setText:[snap objectForKey:@"from"]];
  [cell.detailTextLabel setText:[snap objectForKey:@"when"]];
  
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
  _selectedIndex = indexPath.row;
}

- (void)handleTap:(UITapGestureRecognizer *)sender {
  // get picture
  
  if (sender.state == UIGestureRecognizerStateBegan) {
    NSLog(@"Tap start");
//    [[CameraServer server] startup];
    [self showSnap];
  } else if (sender.state == UIGestureRecognizerStateEnded) {
    NSLog(@"Tap end");
    [self hideSnap];
  } else {
    NSLog(@"Something else");
  }
}

#pragma mark - Data load 

- (void)loadSnaps {
  [SSNetworking getAllSnapsWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
    _snaps = responseObject;
    [_snapsTable reloadData];
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"Error loading snaps: %@", error);
  }];
}

#pragma mark - Snap show / hide actions

- (void)showSnap {
  UIImage *img = [[_snaps objectAtIndex:_selectedIndex] objectForKey:@"image"];
  
  if (_snapView == nil) {
    _snapView = [[UIView alloc] initWithFrame:self.view.frame];
  }
  [_snapView setBackgroundColor:[UIColor blueColor]];
  [self.view addSubview:_snapView];

  //maybe background later
  [self startCapture];
}

- (void)hideSnap {

  [[NSNotificationCenter defaultCenter] postNotificationName:@"Stop Camera Server" object:nil];
//  [[CameraServer server] shutdown];
  NSString *filepath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/video.mp4"];
  NSLog(@"File: %@", filepath);
  NSURL *fileURL = [NSURL fileURLWithPath:filepath];
  MPMoviePlayerViewController *moviePlayerController = [[MPMoviePlayerViewController alloc] initWithContentURL:fileURL];
  [moviePlayerController.moviePlayer setMovieSourceType:MPMovieSourceTypeFile];
  NSLog(@"Error: %@", [moviePlayerController.moviePlayer errorLog]);
  NSLog(@"Duration: %f", [moviePlayerController.moviePlayer duration]);
  
  [self presentMoviePlayerViewControllerAnimated:moviePlayerController];
  [moviePlayerController.moviePlayer prepareToPlay];
  [moviePlayerController.moviePlayer play];
  [moviePlayerController.moviePlayer errorLog];
  NSLog(@"Error: %@", [moviePlayerController.moviePlayer errorLog]);
  [SSNetworking sendVideo];
  [_snapView removeFromSuperview];
}

#pragma mark - Video Recording

- (void) startCapture {
  AVCaptureVideoPreviewLayer *preview = [[CameraServer server] getPreviewLayer];
  [preview removeFromSuperlayer];
  preview.frame = _snapView.bounds;
  [[preview connection] setVideoOrientation:AVCaptureVideoOrientationPortrait];
  NSLog(@"url: %@", [[CameraServer server] getURL]);
}

- (void)handleMPMoviePlayerPlaybackDidFinish:(NSNotification *)notification
{
  NSDictionary *notificationUserInfo = [notification userInfo];
  NSNumber *resultValue = [notificationUserInfo objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
  MPMovieFinishReason reason = [resultValue intValue];
  if (reason == MPMovieFinishReasonPlaybackError)
  {
    NSError *mediaPlayerError = [notificationUserInfo objectForKey:@"error"];
    if (mediaPlayerError)
    {
      NSLog(@"playback failed with error description: %@", [mediaPlayerError localizedDescription]);
    }
    else
    {
      NSLog(@"playback failed without any given reason");
    }
  }
}
@end
