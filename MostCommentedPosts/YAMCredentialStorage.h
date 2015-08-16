//
//  YAMCredentialStorage.h
//  MostCommentedPosts
//
//  Created by Damir Sitdikov on 16.08.15.
//  Copyright (c) 2015 Damir Sitdikov. All rights reserved.
//

#import <Foundation/Foundation.h>
#define CredentialStorage [YAMCredentialStorage sharedInstance]


@interface YAMCredentialStorage : NSObject

@property (nonatomic, strong) NSString *currentAuthenticatedUserID;
@property (nonatomic, strong) NSString *accessToken;

+ (instancetype)sharedInstance;

- (void)clearCookies;
- (void)resetAccessToken;

@end