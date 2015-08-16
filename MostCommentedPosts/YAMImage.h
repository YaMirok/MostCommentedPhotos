//
//  YAMImage.h
//  MostCommentedPosts
//
//  Created by Damir Sitdikov on 16.08.15.
//  Copyright (c) 2015 Damir Sitdikov. All rights reserved.
//

#import "JSONModel.h"

@interface YAMImage : JSONModel

@property (nonatomic, strong) NSString *url;
@property (nonatomic, assign) float width;
@property (nonatomic, assign) float height;

@end
