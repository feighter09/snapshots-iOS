//
//  SSNetworking.h
//  SnapShots-iOS
//
//  Created by Austin Feight on 1/25/14.
//  Copyright (c) 2014 Lost in Flight Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFHTTPRequestOperation.h>


@interface SSNetworking : NSObject

+(void)getAllSnapsWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))successBlock
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock;

+ (void)sendImage:(UIImage *)img;
+ (void)sendVideo;

@end
