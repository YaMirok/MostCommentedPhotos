//
//  InstagramManager.h
//  MostCommentedPosts
//
//  Created by Damir Sitdikov on 16.08.15.
//  Copyright (c) 2015 Damir Sitdikov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YAMUser.h"



@protocol YAMInstagramManagerDelegate

- (void) loadMediaForUserFinished;

@end

typedef void (^ ImageLoadResult) (id);

@interface YAMInstagramManager : NSObject

- (instancetype) initWithUserInfo:(YAMUser*)user;
- (void) loadDataForUser;
- (int) getCommentsCountForIndex:(int)index;
- (void) getImageForIndex:(int)index onSuccess:(ImageLoadResult)success;


@property (readonly, nonatomic) NSString* fullName;
@property (getter=getMediaCount, nonatomic) int mediaCount;

@property (strong,nonatomic) id<YAMInstagramManagerDelegate> delegate;



@end
