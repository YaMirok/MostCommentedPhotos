//
//  YAMMedia.h
//  MostCommentedPosts
//
//  Created by Damir Sitdikov on 16.08.15.
//  Copyright (c) 2015 Damir Sitdikov. All rights reserved.
//

#import "JSONModel.h"
#import "YAMImages.h"
#import "YAMComments.h"

@interface YAMMedia : JSONModel

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) YAMComments *comments;
@property (nonatomic, strong) YAMImages* images;


@end
