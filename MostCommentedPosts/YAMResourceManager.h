//
//  YAMResourceManager.h
//  MostCommentedPosts
//
//  Created by Damir Sitdikov on 16.08.15.
//  Copyright (c) 2015 Damir Sitdikov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YAMUser.h"
#import "AFNetworking.h"


typedef void(^ResourceManagerCompletionBlockWithSuccess)(id responseObject);
typedef void(^ResourceManagerCompletionBlockWithFailure)(NSError *error);

@interface YAMResourceManager : NSObject

#pragma mark - Users

- (NSURLSessionDataTask *)userInfoWithID:(NSString *)userID
                                 success:(ResourceManagerCompletionBlockWithSuccess)success
                                 failure:(ResourceManagerCompletionBlockWithFailure)failure;

- (NSURLSessionDataTask *)recentUserMediaListWithID:(NSString *)userID andMaxId:(NSString*)maxID
                                            success:(ResourceManagerCompletionBlockWithSuccess)success
                                            failure:(ResourceManagerCompletionBlockWithFailure)failure;

- (AFHTTPRequestOperation*) getImageWithUrl:(NSString*)url OnSuccess:(void (^)(UIImage*))success OnFailure:(void (^)(NSError*))failure;

@end
