//
//  YAMCounts.h
//  MostCommentedPosts
//
//  Created by Damir Sitdikov on 16.08.15.
//  Copyright (c) 2015 Damir Sitdikov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface YAMCounts : JSONModel

@property (assign, nonatomic) int media;
@property (assign, nonatomic) int follows;
@property (assign, nonatomic) int followed_by;

@end
