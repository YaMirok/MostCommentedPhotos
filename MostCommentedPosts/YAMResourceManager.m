//
//  YAMResourceManager.m
//  MostCommentedPosts
//
//  Created by Damir Sitdikov on 16.08.15.
//  Copyright (c) 2015 Damir Sitdikov. All rights reserved.
//

#import "YAMResourceManager.h"
#import "YAMSessionManager.h"

// Users methods
static NSString *const kUserInfoAPIMethod = @"users/%@";
static NSString *const kUserRecentMediaAPIMethod = @"users/%@/media/recent";
static NSString *const kUserSelfFeedAPIMethod = @"users/self/feed";
static NSString *const kUserFollowsListMethod = @"users/%@/follows";
static NSString *const kUserFollowedByListMethod = @"users/%@/followed-by";

// Media methods
static NSString *const kMediaInfoAPIMethod = @"media/%@";
static NSString *const kPopularMediaAPIMethod = @"media/popular";


@interface YAMResourceManager()

@property (nonatomic, strong) YAMSessionManager *manager;

@end



@implementation YAMResourceManager

- (instancetype)init
{
    if (self = [super init])
    {
        YAMApiConfigurator *configuratorAPI = [YAMApiConfigurator baseConfigurator];
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _manager = [[YAMSessionManager alloc] initWithSessionConfiguration:sessionConfiguration
                                                          configurationAPI:configuratorAPI];
    }
    return self;
}

#pragma mark - Users

- (NSURLSessionDataTask *)userInfoWithID:(NSString *)userID
                                 success:(ResourceManagerCompletionBlockWithSuccess)success
                                 failure:(ResourceManagerCompletionBlockWithFailure)failure
{
    NSURLSessionDataTask *task = [self.manager method:YAMHTTPMethodGET
                                            URLString:[NSString stringWithFormat:kUserInfoAPIMethod, userID]
                                           parameters:nil
                                              success:^(NSURLSessionDataTask *task, id responseObject) {
                                                  if (responseObject) {
                                                      NSError* err;
                                                      YAMUser* user = [[YAMUser alloc]initWithDictionary:responseObject[@"data"] error:&err];
                                                      if(err){
                                                          failure(err);
                                                      }
                                                      success(user);
                                                  }
                                              } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                  if (error) {
                                                      failure(error);
                                                  }
                                              }];
    [task resume];
    
    return task;
}

- (NSURLSessionDataTask *)recentUserMediaListWithID:(NSString *)userID andMaxId:(NSString*)maxID
                                            success:(ResourceManagerCompletionBlockWithSuccess)success
                                            failure:(ResourceManagerCompletionBlockWithFailure)failure
{
    NSDictionary* params = nil;
    if(maxID){
        params = [NSDictionary dictionaryWithObject:maxID forKey:@"max_id"];
    }
    NSURLSessionDataTask *task = [self.manager method:YAMHTTPMethodGET
                                            URLString:[NSString stringWithFormat:kUserRecentMediaAPIMethod, userID]
                                           parameters:params
                                          success:^(NSURLSessionDataTask *task, id responseObject) {
                                                  if (responseObject) {
                                                      success(responseObject);
                                                  }
                                              } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                  if (error) {
                                                      failure(error);
                                                  }
                                              }];
    [task resume];
    
    return task;
}

- (AFHTTPRequestOperation*) getImageWithUrl:(NSString*)url OnSuccess:(void (^)(UIImage*))success OnFailure:(void (^)(NSError*))failure{
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];

    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        success(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
    [requestOperation start];
    return requestOperation;
}


@end
