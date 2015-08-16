//
//  AuthenticationService.m
//  MostCommentedPosts
//
//  Created by Damir Sitdikov on 16.08.15.
//  Copyright (c) 2015 Damir Sitdikov. All rights reserved.
//

#import "YAMAuthenticationService.h"

#import "YAMSessionManager.h"
#import <AFNetworking/AFURLRequestSerialization.h>
#import "YAMUser.h"

@interface YAMAuthenticationService()

@property (nonatomic, strong) YAMSessionManager *manager;
@property (nonatomic, strong) YAMApiConfigurator *configurator;

@end

@implementation YAMAuthenticationService

#pragma mark - Initialize

- (instancetype)initWithAuthenticationConfigurator:(YAMApiConfigurator *)configurator;
{
    if (self = [super init]) {
        
        _configurator = configurator;
        
        _manager = [[YAMSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                          configurationAPI:configurator];
    }
    return self;
}

#pragma mark - Properties

- (NSURLRequest *)authenticationURLRequest
{
    return [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET"
                                                         URLString:self.configurator.authenticateURLString
                                                        parameters:self.configurator.authenticateBaseParameters
                                                             error:NULL];
}

#pragma mark - Access Token Request

- (void)requestAccessTokenWithResponseCode:(NSString *)responseCode
                                   success:(AuthServiceCompletionBlockWithSuccess)success
                                   failure:(AuthServiceCompletionBlockWithFailure)failure
{
    NSURLSessionDataTask *task = [self.manager method:YAMHTTPMethodPOST
                                            URLString:nil
                                           parameters:@{
                                                        @"code" : responseCode
                                                        }
                                              success:^(NSURLSessionDataTask *task, id responseObject) {
                                                  if (responseObject)
                                                  {
                                                      NSString *accessToken = responseObject[@"access_token"];
                                                      
                                                      if (accessToken)
                                                      {
                                                          [CredentialStorage setAccessToken:accessToken];
                                                          NSError* err = nil;
                                                          
                                                          YAMUser *user = [[YAMUser alloc]initWithDictionary:responseObject[@"user"] error:&err];
                                                          if (!err) {
                                                              [CredentialStorage setCurrentAuthenticatedUserID:user.id];
                                                          }
                                                      }
                                                      success(task, accessToken);
                                                  }
                                              }
                                              failure:failure];
    [task resume];
}

@end

