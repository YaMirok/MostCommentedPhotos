//
//  YAMApiConfigurator.h
//  MostCommentedPosts
//
//  Created by Damir Sitdikov on 16.08.15.
//  Copyright (c) 2015 Damir Sitdikov. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, YAMApiConfiguratorType) {
    YAMApiConfiguratorBase,
    YAMApiConfiguratorAuth
};

@interface YAMApiConfigurator : NSObject

#pragma mark Base Type

@property (nonatomic, strong) NSURL *baseAPIURL;
@property (nonatomic, strong) NSDictionary *baseParameters;

#pragma mark - Authentication

@property (nonatomic, strong) NSString *clientID;
@property (nonatomic, strong) NSString *clientSecret;
@property (nonatomic, strong) NSString *grantType;

@property (nonatomic, strong) NSDictionary *authenticateBaseParameters;

@property (nonatomic, strong) NSString *authenticateURLString;
@property (nonatomic, strong) NSString *requestTokenURLString;
@property (nonatomic, strong) NSString *redirectURLString;

#pragma mark - Initialize

- (instancetype)initWithBaseURL:(NSURL *)baseURL
                 baseParameters:(id)parameters;

+ (instancetype)baseConfigurator;
+ (instancetype)authenticationConfigurator;



@end
