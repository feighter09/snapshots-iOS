//
//  SSSnapsViewController.h
//  SnapShots-iOS
//
//  Created by Austin Feight on 1/24/14.
//  Copyright (c) 2014 Lost in Flight Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface SSSnapsViewController : UIViewController <AVCaptureVideoDataOutputSampleBufferDelegate, UIGestureRecognizerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *snaps;

@end
