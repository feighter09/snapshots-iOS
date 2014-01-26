//
//  SSNetworking.m
//  SnapShots-iOS
//
//  Created by Austin Feight on 1/25/14.
//  Copyright (c) 2014 Lost in Flight Studios. All rights reserved.
//

#import "SSNetworking.h"

//static NSString *baseURL = @"http://snapchatshots.herokuapp.com/";
static NSString *baseURL = @"http://54.203.205.223/";

@implementation SSNetworking

+(void)getAllSnapsWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))successBlock
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock {
//  NSURLRequest *request = [NSURLRequest alloc] initWithURL:[NSURL URLWithString:[baseURL stringByAppendingPathComponent:@"getAll"]];
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  [manager GET:[baseURL stringByAppendingPathComponent:@"getAll"] parameters:[self getParams] success:^(AFHTTPRequestOperation *operation, id responseObject) {
    successBlock(operation, responseObject);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    failureBlock(operation, error);
  }];
}

+ (void)sendImage:(UIImage *)img {

  NSData *imageToUpload = UIImageJPEGRepresentation(img, 1.0);
  if (imageToUpload == nil) {
    return;
  }
  
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  [manager POST:[baseURL stringByAppendingString:@"send/image"] parameters:[self getParams] constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    [formData appendPartWithFormData:imageToUpload name:@"file"];
  } success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSLog(@"Success: %@", responseObject);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"Error: %@", error);
  }];
}

+ (void)sendVideo {
  
  NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Directory/video.mp4"];
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  [manager POST:[baseURL stringByAppendingString:@"send/video"] parameters:[self getParams] constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    [formData appendPartWithFileURL:[NSURL URLWithString:filePath] name:@"file" error:nil];
  } success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSLog(@"Success: %@", responseObject);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"Error: %@", error);
  }];
}

+ (NSDictionary *)getParams {
  NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
  NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
  return @{@"username": username, @"password": password, @"recipient": @"shotsshots"};
}

@end
