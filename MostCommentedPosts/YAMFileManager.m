//
//  YAMFileManager.m
//  MostCommentedPosts
//
//  Created by Damir Sitdikov on 17.08.15.
//  Copyright (c) 2015 Damir Sitdikov. All rights reserved.
//

#import "YAMFileManager.h"

@interface YAMFileManager(){


    
}

@end

@implementation YAMFileManager

+ (instancetype)sharedInstance
{
    static YAMFileManager *sharedInstance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (NSString*) documentsDirectory{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
    
}

- (UIImage*) getImageWithFileName:(NSString*)fileName{
    UIImage* result;
    NSString* imagePath = [[self documentsDirectory] stringByAppendingPathComponent:fileName];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:imagePath isDirectory: false ]){
        result = [UIImage imageWithContentsOfFile:imagePath];
        return result;
    }
    return nil;
}

- (void) saveImage:(UIImage*)image withFileName:(NSString*)fileName{
    
    NSString* imagePath = [[self documentsDirectory] stringByAppendingPathComponent:fileName];
    NSData *imageData = UIImageJPEGRepresentation(image, 90);
    [imageData writeToFile:imagePath atomically:YES];
    
}

@end
