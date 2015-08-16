//
//  AuthenticationService.h
//  MostCommentedPosts
//
//  Created by Damir Sitdikov on 16.08.15.
//  Copyright (c) 2015 Damir Sitdikov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YAMApiConfigurator.h"


typedef void(^AuthServiceCompletionBlockWithSuccess)(NSURLSessionDataTask *task, id responseObject);
typedef void(^AuthServiceCompletionBlockWithFailure)(NSURLSessionDataTask *task, NSError *error);

@interface YAMAuthenticationService : NSObject

@property (nonatomic, strong) NSURLRequest *authenticationURLRequest;

#pragma mark - Initialize

- (instancetype)initWithAuthenticationConfigurator:(YAMApiConfigurator *)configurator;

#pragma mark - Access Token Request

- (void)requestAccessTokenWithResponseCode:(NSString *)responseCode
                                   success:(AuthServiceCompletionBlockWithSuccess)success
                                   failure:(AuthServiceCompletionBlockWithFailure)failure;

@end
