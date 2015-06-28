//
//  UIView+DCHImageTurbo.h
//  DCHImageTurbo
//
//  Created by Derek Chen on 6/26/15.
//  Copyright © 2015 CHEN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/SDImageCache.h>

typedef void(^DCHImageTurboLoadImageCompletionBlock)(UIImage *image, NSError *error, NSString *imagePath, NSURL *imageURL, SDImageCacheType cacheType);
typedef void(^DCHImageTurboLoadImageFromCacheCompletionBlock)(UIImage *image, NSError *error, NSString *key, SDImageCacheType cacheType);
typedef NSDictionary *(^DCHImageTurboCustomizeBlock)();
typedef void(^DCHImageTurboUIActionBlock)(UIImage *image, NSError *error, NSString *imagePath, NSURL *imageURL);

@interface UIView (DCHImageTurbo)

- (NSString *)dch_imageSignature:(NSDictionary *)dic;

- (void)dch_loadImageFormCacheForKey:(NSString *)key fromDisk:(BOOL)fromDisk completed:(DCHImageTurboLoadImageFromCacheCompletionBlock)completedBlock;

@end
