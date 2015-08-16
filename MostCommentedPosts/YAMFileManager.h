//
//  YAMFileManager.h
//  MostCommentedPosts
//
//  Created by Damir Sitdikov on 17.08.15.
//  Copyright (c) 2015 Damir Sitdikov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"

@interface YAMFileManager : NSObject

+ (instancetype)sharedInstance;

- (UIImage*) getImageWithFileName:(NSString*)fileName;
- (void) saveImage:(UIImage*)image withFileName:(NSString*)fileName;

@end
