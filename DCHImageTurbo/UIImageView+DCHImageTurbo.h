//
//  UIImageView+DCHImageTurbo.h
//  DCHImageTurbo
//
//  Created by Derek Chen on 7/28/15.
//  Copyright (c) 2015 CHEN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+DCHImageTurbo.h"

extern NSString * const key_DCHImageTurbo_UIImageView_WebImageURL;
extern NSString * const key_DCHImageTurbo_UIImageView_WebHighlightedImageURL;
extern NSString * const key_DCHImageTurbo_UIImageView_LocalImagePath;
extern NSString * const key_DCHImageTurbo_UIImageView_LocalHighlightedImagePath;

extern NSString * const key_DCHImageTurbo_UIImageView_WebImageLoadOperation;
extern NSString * const key_DCHImageTurbo_UIImageView_WebHighlightedImageLoadOperation;
extern NSString * const key_DCHImageTurbo_UIImageView_LocalImageLoadOperation;
extern NSString * const key_DCHImageTurbo_UIImageView_LocalHighlightedImageLoadOperation;

@interface UIImageView (DCHImageTurbo)

#pragma mark - Web image
- (NSURL *)dch_currentWebImageURL;
- (void)dch_setWebImageURL:(NSURL *)url;

- (void)dch_setWebImageLoadOperation:(id)operation;
- (void)dch_cancelCurrentWebImageLoadOperation;

- (void)dch_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(DCHImageTurboLoadImageCompletionBlock)completion;
- (void)dch_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder resize:(CGSize)newSize scale:(CGFloat)scale completed:(DCHImageTurboLoadImageCompletionBlock)completion;
- (void)dch_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder cornerRadius:(CGFloat)cornerRadius completed:(DCHImageTurboLoadImageCompletionBlock)completion;
- (void)dch_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor completed:(DCHImageTurboLoadImageCompletionBlock)completion;
- (void)dch_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder applyBlurWithRadius:(CGFloat)radius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage completed:(DCHImageTurboLoadImageCompletionBlock)completion;

- (void)dch_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options customize:(DCHImageTurboCustomizeBlock)customization progress:(SDWebImageDownloaderProgressBlock)progress completed:(DCHImageTurboLoadImageCompletionBlock)completion;

#pragma mark - Web highlighted image
- (NSURL *)dch_currentWebHighlightedImageURL;
- (void)dch_setWebHighlightedImageURL:(NSURL *)url;

- (void)dch_setWebHighlightedImageLoadOperation:(id)operation;
- (void)dch_cancelCurrentWebHighlightedImageLoadOperation;

- (void)dch_setHighlightedImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(DCHImageTurboLoadImageCompletionBlock)completion;
- (void)dch_setHighlightedImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder resize:(CGSize)newSize scale:(CGFloat)scale completed:(DCHImageTurboLoadImageCompletionBlock)completion;
- (void)dch_setHighlightedImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder cornerRadius:(CGFloat)cornerRadius completed:(DCHImageTurboLoadImageCompletionBlock)completion;
- (void)dch_setHighlightedImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor completed:(DCHImageTurboLoadImageCompletionBlock)completion;
- (void)dch_setHighlightedImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder applyBlurWithRadius:(CGFloat)radius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage completed:(DCHImageTurboLoadImageCompletionBlock)completion;

- (void)dch_setHighlightedImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options customize:(DCHImageTurboCustomizeBlock)customization progress:(SDWebImageDownloaderProgressBlock)progress completed:(DCHImageTurboLoadImageCompletionBlock)completion;

#pragma mark - Local image
- (NSString *)dch_currentLocalImagePath;
- (void)dch_setLocalImagePath:(NSString *)path;

- (void)dch_setLocalImageLoadOperation:(id)operation;
- (void)dch_cancelCurrentLocalImageLoadOperation;

- (void)dch_setImageWithContentsOfFile:(NSString *)path placeholderImage:(UIImage *)placeholder completed:(DCHImageTurboLoadImageCompletionBlock)completion;
- (void)dch_setImageWithContentsOfFile:(NSString *)path placeholderImage:(UIImage *)placeholder resize:(CGSize)newSize scale:(CGFloat)scale completed:(DCHImageTurboLoadImageCompletionBlock)completion;
- (void)dch_setImageWithContentsOfFile:(NSString *)path placeholderImage:(UIImage *)placeholder cornerRadius:(CGFloat)cornerRadius completed:(DCHImageTurboLoadImageCompletionBlock)completion;
- (void)dch_setImageWithContentsOfFile:(NSString *)path placeholderImage:(UIImage *)placeholder borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor completed:(DCHImageTurboLoadImageCompletionBlock)completion;
- (void)dch_setImageWithContentsOfFile:(NSString *)path placeholderImage:(UIImage *)placeholder applyBlurWithRadius:(CGFloat)radius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage completed:(DCHImageTurboLoadImageCompletionBlock)completion;

- (void)dch_setImageWithContentsOfFile:(NSString *)path placeholderImage:(UIImage *)placeholder customize:(DCHImageTurboCustomizeBlock)customization completed:(DCHImageTurboLoadImageCompletionBlock)completion;

#pragma mark - Local highlighted image
- (NSString *)dch_currentLocalHighlightedImagePath;
- (void)dch_setLocalHighlightedImagePath:(NSString *)path;

- (void)dch_setLocalHighlightedImageLoadOperation:(id)operation;
- (void)dch_cancelCurrentLocalHighlightedImageLoadOperation;

- (void)dch_setHighlightedImageWithContentsOfFile:(NSString *)path placeholderImage:(UIImage *)placeholder completed:(DCHImageTurboLoadImageCompletionBlock)completion;
- (void)dch_setHighlightedImageWithContentsOfFile:(NSString *)path placeholderImage:(UIImage *)placeholder resize:(CGSize)newSize scale:(CGFloat)scale completed:(DCHImageTurboLoadImageCompletionBlock)completion;
- (void)dch_setHighlightedImageWithContentsOfFile:(NSString *)path placeholderImage:(UIImage *)placeholder cornerRadius:(CGFloat)cornerRadius completed:(DCHImageTurboLoadImageCompletionBlock)completion;
- (void)dch_setHighlightedImageWithContentsOfFile:(NSString *)path placeholderImage:(UIImage *)placeholder borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor completed:(DCHImageTurboLoadImageCompletionBlock)completion;
- (void)dch_setHighlightedImageWithContentsOfFile:(NSString *)path placeholderImage:(UIImage *)placeholder applyBlurWithRadius:(CGFloat)radius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage completed:(DCHImageTurboLoadImageCompletionBlock)completion;

- (void)dch_setHighlightedImageWithContentsOfFile:(NSString *)path placeholderImage:(UIImage *)placeholder customize:(DCHImageTurboCustomizeBlock)customization completed:(DCHImageTurboLoadImageCompletionBlock)completion;

#pragma mark - Action
- (void)dch_cleanAllImageLocations;
- (void)dch_cancelAllImageLoadOperations;

@end
