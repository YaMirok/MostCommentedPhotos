//
//  YAMComments.m
//  MostCommentedPosts
//
//  Created by Damir Sitdikov on 16.08.15.
//  Copyright (c) 2015 Damir Sitdikov. All rights reserved.
//

#import "YAMComments.h"

@implementation YAMComments

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"count": @"count",
                                                       @"data": @"comments"
                                                       }];
}

@end
