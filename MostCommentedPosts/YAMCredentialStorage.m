//
//  YAMCredentialStorage.m
//  MostCommentedPosts
//
//  Created by Damir Sitdikov on 16.08.15.
//  Copyright (c) 2015 Damir Sitdikov. All rights reserved.
//

#import "YAMCredentialStorage.h"
#import "SSKeychain.h"

@implementation YAMCredentialStorage

+ (instancetype)sharedInstance
{
    static YAMCredentialStorage *sharedInstance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Properties

- (void)setCurrentAuthenticatedUserID:(NSString *)currentAuthenticatedUserID
{
    [[NSUserDefaults standardUserDefaults] setObject:currentAuthenticatedUserID forKey:@"userID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)currentAuthenticatedUserID
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
}

- (void)setAccessToken:(NSString *)accessToken
{
    [SSKeychain setPassword:accessToken
                 forService:kKeychainServiceName
                    account:kKeychainAccountName];
}

- (NSString *)accessToken
{
    return [SSKeychain passwordForService:kKeychainServiceName
                                  account:kKeychainAccountName];
}

#pragma mark - Helper methods

- (void)clearCookies
{
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)resetAccessToken
{
    [SSKeychain deletePasswordForService:kKeychainServiceName
                                 account:kKeychainAccountName];
}


@end
