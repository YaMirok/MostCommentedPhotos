//
//  InstagramManager.m
//  MostCommentedPosts
//
//  Created by Damir Sitdikov on 16.08.15.
//  Copyright (c) 2015 Damir Sitdikov. All rights reserved.
//

#import "YAMInstagramManager.h"
#import "YAMResourceManager.h"
#import "YAMMedia.h"
#import "YAMPagination.h"
#import "YAMFileManager.h"

@interface YAMInstagramManager(){
    YAMResourceManager* manager;
    AFHTTPRequestOperation* imageDownloadRequest;
}

@property (nonatomic, copy) YAMUser* userInfo;
@property (nonatomic,strong) NSMutableArray* imagesArray;

@end


@implementation YAMInstagramManager

-(instancetype)initWithUserInfo:(YAMUser *)user{
    
    self = [super init];
    if(self){
        
        self.userInfo = user;
        manager = [[YAMResourceManager alloc] init];
        self.imagesArray = [[NSMutableArray alloc] init];
        
    }
    return self;
}

- (void) loadDataForUser{
    
    [self loadPageWithMaxId:nil];
    
}

- (void) loadPageWithMaxId:(NSString*) maxId{
    
    [manager recentUserMediaListWithID:self.userInfo.id andMaxId:maxId success:^(id responseObject) {
        
        NSError* err;
        NSArray* images = [YAMMedia arrayOfModelsFromDictionaries:responseObject[@"data"] error:&err];
        NSPredicate* justImagesPredicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            YAMMedia* media = (YAMMedia*)evaluatedObject;
            if(media)
            {
                
                return [media.type isEqualToString:@"image"];
                
            }
            return NO;
        }];
        NSArray* justImages = [images filteredArrayUsingPredicate:justImagesPredicate];
        [self.imagesArray addObjectsFromArray: justImages];
        
        YAMPagination* pageInfo = [[YAMPagination alloc]initWithDictionary:responseObject[@"pagination"] error:&err];
        if(pageInfo && pageInfo.next_max_id)
        {
            [self loadPageWithMaxId:pageInfo.next_max_id];
        } else {
            
            [self.imagesArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                YAMMedia* media1 = (YAMMedia*)obj1;
                YAMMedia* media2 = (YAMMedia*)obj2;
                return  media1.comments.count < media2.comments.count;
            }];
            
            [self.delegate loadMediaForUserFinished];
            
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (NSString*)getFullName{
    
    return self.userInfo.full_name;
    
}

- (int)getMediaCount{
    
    if(self.userInfo.counts)
        return (int)self.imagesArray.count;
    return 0;
}

- (int) getCommentsCountForIndex:(int)index{
    
    YAMMedia* curMedia = [self.imagesArray objectAtIndex:index];
    return curMedia.comments.count;
    
}

- (void) getImageForIndex:(int)index onSuccess:(ImageLoadResult)success{
    
    if(imageDownloadRequest)
       [imageDownloadRequest cancel];
    UIImage* curImage;
    YAMMedia* curMedia = [self.imagesArray objectAtIndex:index];
    YAMImage* curImageLowRes = curMedia.images.low_resolution;
    if (curImageLowRes && curImageLowRes.url) {
        
        NSArray* urlComponents = [curImageLowRes.url componentsSeparatedByString:@"/"];
        NSString* imageName = [urlComponents lastObject];
        curImage = [[YAMFileManager sharedInstance] getImageWithFileName:imageName];
        if (curImage) {
            success(curImage);
        } else {
            
            imageDownloadRequest = [manager getImageWithUrl:curImageLowRes.url
                                                  OnSuccess:^(UIImage *image)
                                    {
                                        imageDownloadRequest = nil;
                                        [[YAMFileManager sharedInstance] saveImage:image withFileName:imageName];
                                        success(image);
                                        
                                    } OnFailure:^(NSError *err) {
                                        NSLog(@"image download error: %@",err.description);
                                        imageDownloadRequest = nil;
                                        success(nil);
                                    }];
            
        }
    }
    
    
}

@end
