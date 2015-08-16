//
//  YAMComments.h
//  MostCommentedPosts
//
//  Created by Damir Sitdikov on 16.08.15.
//  Copyright (c) 2015 Damir Sitdikov. All rights reserved.
//

#import "JSONModel.h"
#import "YAMComment.h"

@interface YAMComments : JSONModel

@property (nonatomic, assign) int count;

@property (nonatomic, strong) NSArray<YAMComment>* comments;

@end
