//
//  YAMImages.h
//  MostCommentedPosts
//
//  Created by Damir Sitdikov on 16.08.15.
//  Copyright (c) 2015 Damir Sitdikov. All rights reserved.
//

#import "JSONModel.h"
#import "YAMImage.h"

@interface YAMImages : JSONModel

@property (nonatomic, strong) YAMImage* low_resolution;
@property (nonatomic, strong) YAMImage* thumbnail;
@property (nonatomic, strong) YAMImage* standard_resolution;

@end
