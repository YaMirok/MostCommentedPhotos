//
//  YAMSessionManager.m
//  MostCommentedPosts
//
//  Created by Damir Sitdikov on 16.08.15.
//  Copyright (c) 2015 Damir Sitdikov. All rights reserved.
//

#import "YAMSessionManager.h"

@interface YAMSessionManager()

@property (nonatomic, strong) NSURL *baseURL;
@property (nonatomic, strong) NSDictionary *baseParameters;

@end


@implementation YAMSessionManager

- (instancetype)initWithSessionConfiguration:(NSURLSessionConfiguration *)configuration
                            configurationAPI:(YAMApiConfigurator *)configurationAPI
{
    if (self == [super initWithSessionConfiguration:configuration]) {
        _baseURL = configurationAPI.baseAPIURL;
        _baseParameters = configurationAPI.baseParameters;
    }
    return self;
}

#pragma mark - Requests data tasks

- (NSURLSessionDataTask *)method:(YAMHTTPMethod)method
                       URLString:(NSString *)URLString
                      parameters:(id)parameters
                         success:(SessionManagerCompletionBlockWithSuccess)success
                         failure:(SessionManagerCompletionBlockWithFailure)failure
{
    return [self dataTaskWithMethod:method
                          URLString:URLString
                         parameters:parameters
                            success:success
                            failure:failure];
}

#pragma mark - HTTP Methods Data Tasks

- (NSURLSessionDataTask *)dataTaskWithMethod:(YAMHTTPMethod)method
                                   URLString:(NSString *)URLString
                                  parameters:(id)parameters
                                     success:(SessionManagerCompletionBlockWithSuccess)success
                                     failure:(SessionManagerCompletionBlockWithFailure)failure
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:self.baseParameters];
    [params addEntriesFromDictionary:parameters];
    
    NSString *urlString = [[NSURL URLWithString:URLString? : [NSString string] relativeToURL:self.baseURL] absoluteString];
    NSURLRequest *urlRequest;
    
    switch (method) {
        case YAMHTTPMethodGET:
            urlRequest = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET"
                                                                       URLString:urlString
                                                                      parameters:params
                                                                           error:NULL];
            break;
        case YAMHTTPMethodPOST:
            urlRequest = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST"
                                                                       URLString:urlString
                                                                      parameters:params
                                                                           error:NULL];
            break;
        case YAMHTTPMethodPUT:
            urlRequest = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"PUT"
                                                                       URLString:urlString
                                                                      parameters:params
                                                                           error:NULL];
            break;
        case YAMHTTPMethodPATCH:
            urlRequest = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"PATCH"
                                                                       URLString:urlString
                                                                      parameters:params
                                                                           error:NULL];
            break;
        case YAMHTTPMethodDELETE:
            urlRequest = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"DELETE"
                                                                       URLString:urlString
                                                                      parameters:params
                                                                           error:NULL];
            break;
            
        default:
            urlRequest = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET"
                                                                       URLString:urlString
                                                                      parameters:params
                                                                           error:NULL];
    }
    
    NSURLSessionDataTask *dataTask = [self dataTaskWithRequest:urlRequest
                                             completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                                                 if (error)
                                                 {
                                                     failure(dataTask, error);
                                                 }
                                                 else
                                                 {
                                                     success(dataTask, responseObject);
                                                 }
                                             }];
    return dataTask;
}



@end
