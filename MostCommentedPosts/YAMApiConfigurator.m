//
//  YAMApiConfigurator.m
//  MostCommentedPosts
//
//  Created by Damir Sitdikov on 16.08.15.
//  Copyright (c) 2015 Damir Sitdikov. All rights reserved.
//

#import "YAMApiConfigurator.h"

@interface YAMApiConfigurator()

@property (nonatomic, assign) YAMApiConfiguratorType configuratorType;

@end

@implementation YAMApiConfigurator

#pragma mark - Initialize

- (instancetype)initWithBaseURL:(NSURL *)baseURL
baseParameters:(id)parameters
{
    if (self = [self initWithConfiguratorType:YAMApiConfiguratorBase]) {
        _baseAPIURL = baseURL;
        _baseParameters = parameters;
    }
    return self;
}

+ (instancetype)baseConfigurator
{
    return [[self alloc] initWithConfiguratorType:YAMApiConfiguratorBase];
}

+ (instancetype)authenticationConfigurator
{
    return [[self alloc] initWithConfiguratorType:YAMApiConfiguratorAuth];
}

- (instancetype)initWithConfiguratorType:(YAMApiConfiguratorType)configuratorType
{
    if (self = [super init]) {
        _configuratorType = configuratorType;
    }
    return self;
}

#pragma mark - Base

- (NSURL *)baseAPIURL
{
    if (_baseAPIURL) {
        return _baseAPIURL;
    }
    
    switch (_configuratorType) {
        case YAMApiConfiguratorBase:
            return [NSURL URLWithString:kInstagramBaseAPIUrl];
            break;
        case YAMApiConfiguratorAuth:
            return [NSURL URLWithString:kInstagramAuthToken];
        default:
            return [NSURL URLWithString:kInstagramBaseAPIUrl];
            break;
    }
}

- (NSDictionary *)baseParameters
{
    switch (_configuratorType)
    {
        case YAMApiConfiguratorBase:
            return @{
                     @"access_token" : [CredentialStorage accessToken]
                     };
            break;
        case YAMApiConfiguratorAuth:
            return @{
                     @"client_id" : self.clientID,
                     @"client_secret" : self.clientSecret,
                     @"grant_type" : self.grantType,
                     @"redirect_uri" : self.redirectURLString
                     };
        default:
            return @{
                     @"access_token" : [CredentialStorage accessToken]
                     };
            break;
    }
}

#pragma mark - Authentication

- (NSString *)clientID
{
    if (_clientID) {
        return _clientID;
    }
    // default
    return kInstagramAPIClientID;
}

- (NSString *)clientSecret
{
    if (_clientSecret) {
        return _clientSecret;
    }
    // default
    return kInstagramAPIClientSecret;
}

- (NSString *)grantType
{
    if (_grantType) {
        return _grantType;
    }
    // default
    return @"authorization_code";
}

- (NSDictionary *)authenticateBaseParameters
{
    return @{
             @"client_id" : self.clientID,
             @"redirect_uri" : self.redirectURLString,
             @"response_type" : @"code"
             };
}

- (NSString *)authenticateURLString
{
    if (_authenticateURLString) {
        return _authenticateURLString;
    }
    // default
    return kInstagramAuthURL;
}

- (NSString *)requestTokenURLString
{
    if (_requestTokenURLString) {
        return _requestTokenURLString;
    }
    // default
    return kInstagramAuthToken;
}

- (NSString *)redirectURLString
{
    if (_redirectURLString) {
        return _redirectURLString;
    }
    // default
    return kInstagramAPIRedirectUri;
}

@end

