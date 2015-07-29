//
//  UIView+DCHImageTurbo.h
//  DCHImageTurbo
//
//  Created by Derek Chen on 6/26/15.
//  Copyright © 2015 CHEN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/SDWebImageManager.h>
#import <Tourbillon/DCHTourbillon.h>

typedef void(^DCHImageTurboLoadImageCompletionBlock)(UIImage *image, NSError *error, NSString *imagePath, NSURL *imageURL, SDImageCacheType cacheType);
typedef void(^DCHImageTurboLoadImageFromCacheCompletionBlock)(UIImage *image, NSError *error, NSString *key, SDImageCacheType cacheType);
typedef NSDictionary *(^DCHImageTurboCustomizeBlock)();
typedef void(^DCHImageTurboUIRenderBlock)(UIImage *image, NSError *error, NSString *imagePath, NSURL *imageURL);
typedef void(^DCHImageTurboOperationHandlerBlock)(id<SDWebImageOperation> operation, NSString *imagePath, NSURL *imageURL);

extern NSString * const key_DCHImageTurbo_UIView_ImageURLStorage;

@interface UIView (DCHImageTurbo)

DCH_DEFINE_ASSOCIATEDOBJECT_FOR_HEADER(ImageURLStorage)

- (CGFloat)dch_frameWidth;
- (CGFloat)dch_frameHeight;
- (CGFloat)dch_screenScale;

- (NSString *)dch_imageSignature:(NSDictionary *)dic;

- (void)dch_loadImageFormCacheForKey:(NSString *)key fromDisk:(BOOL)fromDisk completed:(DCHImageTurboLoadImageFromCacheCompletionBlock)completion;

- (void)dch_loadImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options customize:(DCHImageTurboCustomizeBlock)customization uiRender:(DCHImageTurboUIRenderBlock)uiRender operationHandler:(DCHImageTurboOperationHandlerBlock)operationHandler progress:(SDWebImageDownloaderProgressBlock)progress completed:(DCHImageTurboLoadImageCompletionBlock)completion;

- (void)dch_loadImageWithContentsOfFile:(NSString *)path placeholderImage:(UIImage *)placeholder customize:(DCHImageTurboCustomizeBlock)customization uiRender:(DCHImageTurboUIRenderBlock)uiRender operationHandler:(DCHImageTurboOperationHandlerBlock)operationHandler completed:(DCHImageTurboLoadImageCompletionBlock)completion;

@end
