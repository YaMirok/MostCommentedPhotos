//
//  YAMUser.h
//  MostCommentedPosts
//
//  Created by Damir Sitdikov on 16.08.15.
//  Copyright (c) 2015 Damir Sitdikov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "YAMCounts.h"

@interface YAMUser : JSONModel

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *full_name;

@property (nonatomic, strong) NSString<Optional> *profile_picture;

@property (nonatomic, strong) NSString<Optional> *bio;
@property (nonatomic, strong) NSString<Optional> *website;
@property (nonatomic, strong) YAMCounts<Optional> *counts;

@end
