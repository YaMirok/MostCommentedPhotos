//
//  YAMSessionManager.h
//  MostCommentedPosts
//
//  Created by Damir Sitdikov on 16.08.15.
//  Copyright (c) 2015 Damir Sitdikov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YAMApiConfigurator.h"
#import "AFNetworking.h"

typedef void(^SessionManagerCompletionBlockWithSuccess)(NSURLSessionDataTask *task, id responseObject);
typedef void(^SessionManagerCompletionBlockWithFailure)(NSURLSessionDataTask *task, NSError *error);

typedef NS_ENUM(NSUInteger, YAMHTTPMethod) {
    YAMHTTPMethodGET,
    YAMHTTPMethodPOST,
    YAMHTTPMethodPUT,
    YAMHTTPMethodPATCH,
    YAMHTTPMethodDELETE
};

@interface YAMSessionManager : AFURLSessionManager

- (instancetype)initWithSessionConfiguration:(NSURLSessionConfiguration *)configuration
                            configurationAPI:(YAMApiConfigurator *)configurationAPI;

- (NSURLSessionDataTask *)method:(YAMHTTPMethod)method
                       URLString:(NSString *)URLString
                      parameters:(id)parameters
                         success:(SessionManagerCompletionBlockWithSuccess)success
                         failure:(SessionManagerCompletionBlockWithFailure)failure;

@end
