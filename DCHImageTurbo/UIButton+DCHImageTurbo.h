//
//  UIButton+DCHImageTurbo.h
//  DCHImageTurbo
//
//  Created by Derek Chen on 7/28/15.
//  Copyright (c) 2015 CHEN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+DCHImageTurbo.h"
#import <SDWebImage/UIView+WebCacheOperation.h>

extern NSString * const key_DCHImageTurbo_UIButton_WebImageURLStorage;
extern NSString * const key_DCHImageTurbo_UIButton_WebBackgroundImageURLStorage;
extern NSString * const key_DCHImageTurbo_UIButton_LocalImagePathStorage;
extern NSString * const key_DCHImageTurbo_UIButton_LocalBackgroundImagePathStorage;

extern NSString * const key_DCHImageTurbo_UIButton_WebImageLoadOperation;
extern NSString * const key_DCHImageTurbo_UIButton_WebBackgroundImageLoadOperation;
extern NSString * const key_DCHImageTurbo_UIButton_LocalImageLoadOperation;
extern NSString * const key_DCHImageTurbo_UIButton_LocalBackgroundImageLoadOperation;

@interface UIButton (DCHImageTurbo)

- (NSString *)dch_createKeyForButtonLoadImageWithPrefix:(NSString *)prefix andState:(UIControlState)state;

#pragma mark - Web image
- (NSMutableDictionary *)dch_webImageURLStorage;
- (NSURL *)dch_currentWebImageURL;
- (NSURL *)dch_webImageURLForState:(UIControlState)state;
- (void)dch_setWebImageURL:(NSURL *)url forState:(UIControlState)state;

- (void)dch_setWebImageLoadOperation:(id <SDWebImageOperation>)operation forState:(UIControlState)state;
- (void)dch_cancelWebImageLoadOperationForState:(UIControlState)state;

- (void)dch_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder forState:(UIControlState)state completed:(DCHImageTurboLoadImageCompletionBlock)completion;
- (void)dch_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder forState:(UIControlState)state resize:(CGSize)newSize scale:(CGFloat)scale completed:(DCHImageTurboLoadImageCompletionBlock)completion;
- (void)dch_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder forState:(UIControlState)state cornerRadius:(CGFloat)cornerRadius completed:(DCHImageTurboLoadImageCompletionBlock)completion;
- (void)dch_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder forState:(UIControlState)state borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor completed:(DCHImageTurboLoadImageCompletionBlock)completion;
- (void)dch_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder forState:(UIControlState)state applyBlurWithRadius:(CGFloat)radius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage completed:(DCHImageTurboLoadImageCompletionBlock)completion;

- (void)dch_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder forState:(UIControlState)state options:(SDWebImageOptions)options customize:(DCHImageTurboCustomizeBlock)customization progress:(SDWebImageDownloaderProgressBlock)progress completed:(DCHImageTurboLoadImageCompletionBlock)completion;

#pragma mark - Web background image
- (NSMutableDictionary *)dch_webBackgroundImageURLStorage;
- (NSURL *)dch_currentWebBackgroundImageURL;
- (NSURL *)dch_webBackgroundImageURLForState:(UIControlState)state;
- (void)dch_setWebBackgroundImageURL:(NSURL *)url forState:(UIControlState)state;

- (void)dch_setWebBackgroundImageLoadOperation:(id <SDWebImageOperation>)operation forState:(UIControlState)state;
- (void)dch_cancelWebBackgroundImageLoadOperationForState:(UIControlState)state;

- (void)dch_setBackgroundImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder forState:(UIControlState)state completed:(DCHImageTurboLoadImageCompletionBlock)completion;
- (void)dch_setBackgroundImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder forState:(UIControlState)state resize:(CGSize)newSize scale:(CGFloat)scale completed:(DCHImageTurboLoadImageCompletionBlock)completion;
- (void)dch_setBackgroundImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder forState:(UIControlState)state cornerRadius:(CGFloat)cornerRadius completed:(DCHImageTurboLoadImageCompletionBlock)completion;
- (void)dch_setBackgroundImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder forState:(UIControlState)state borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor completed:(DCHImageTurboLoadImageCompletionBlock)completion;
- (void)dch_setBackgroundImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder forState:(UIControlState)state applyBlurWithRadius:(CGFloat)radius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage completed:(DCHImageTurboLoadImageCompletionBlock)completion;

- (void)dch_setBackgroundImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder forState:(UIControlState)state options:(SDWebImageOptions)options customize:(DCHImageTurboCustomizeBlock)customization progress:(SDWebImageDownloaderProgressBlock)progress completed:(DCHImageTurboLoadImageCompletionBlock)completion;

#pragma mark - Local image
- (NSMutableDictionary *)dch_localImagePathStorage;
- (NSString *)dch_currentLocalImagePath;
- (NSString *)dch_localImagePathForState:(UIControlState)state;
- (void)dch_setLocalImageURL:(NSString *)path forState:(UIControlState)state;

- (void)dch_setLocalImageLoadOperation:(id <SDWebImageOperation>)operation forState:(UIControlState)state;
- (void)dch_cancelLocalImageLoadOperationForState:(UIControlState)state;

- (void)dch_setImageWithContentsOfFile:(NSString *)path placeholderImage:(UIImage *)placeholder forState:(UIControlState)state completed:(DCHImageTurboLoadImageCompletionBlock)completion;
- (void)dch_setImageWithContentsOfFile:(NSString *)path placeholderImage:(UIImage *)placeholder forState:(UIControlState)state resize:(CGSize)newSize scale:(CGFloat)scale completed:(DCHImageTurboLoadImageCompletionBlock)completion;
- (void)dch_setImageWithContentsOfFile:(NSString *)path placeholderImage:(UIImage *)placeholder forState:(UIControlState)state cornerRadius:(CGFloat)cornerRadius completed:(DCHImageTurboLoadImageCompletionBlock)completion;
- (void)dch_setImageWithContentsOfFile:(NSString *)path placeholderImage:(UIImage *)placeholder forState:(UIControlState)state borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor completed:(DCHImageTurboLoadImageCompletionBlock)completion;
- (void)dch_setImageWithContentsOfFile:(NSString *)path placeholderImage:(UIImage *)placeholder forState:(UIControlState)state applyBlurWithRadius:(CGFloat)radius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage completed:(DCHImageTurboLoadImageCompletionBlock)completion;

- (void)dch_setImageWithContentsOfFile:(NSString *)path placeholderImage:(UIImage *)placeholder forState:(UIControlState)state customize:(DCHImageTurboCustomizeBlock)customization completed:(DCHImageTurboLoadImageCompletionBlock)completion;

#pragma mark - Local background image
- (NSMutableDictionary *)dch_localBackgroundImagePathStorage;
- (NSString *)dch_currentLocalBackgroundImagePath;
- (NSString *)dch_localBackgroundImagePathForState:(UIControlState)state;
- (void)dch_setLocalBackgroundImageURL:(NSString *)path forState:(UIControlState)state;

- (void)dch_setLocalBackgroundImageLoadOperation:(id <SDWebImageOperation>)operation forState:(UIControlState)state;
- (void)dch_cancelLocalBackgroundImageLoadOperationForState:(UIControlState)state;

- (void)dch_setBackgroundImageWithContentsOfFile:(NSString *)path placeholderImage:(UIImage *)placeholder forState:(UIControlState)state completed:(DCHImageTurboLoadImageCompletionBlock)completion;
- (void)dch_setBackgroundImageWithContentsOfFile:(NSString *)path placeholderImage:(UIImage *)placeholder forState:(UIControlState)state resize:(CGSize)newSize scale:(CGFloat)scale completed:(DCHImageTurboLoadImageCompletionBlock)completion;
- (void)dch_setBackgroundImageWithContentsOfFile:(NSString *)path placeholderImage:(UIImage *)placeholder forState:(UIControlState)state cornerRadius:(CGFloat)cornerRadius completed:(DCHImageTurboLoadImageCompletionBlock)completion;
- (void)dch_setBackgroundImageWithContentsOfFile:(NSString *)path placeholderImage:(UIImage *)placeholder forState:(UIControlState)state borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor completed:(DCHImageTurboLoadImageCompletionBlock)completion;
- (void)dch_setBackgroundImageWithContentsOfFile:(NSString *)path placeholderImage:(UIImage *)placeholder forState:(UIControlState)state applyBlurWithRadius:(CGFloat)radius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage completed:(DCHImageTurboLoadImageCompletionBlock)completion;

- (void)dch_setBackgroundImageWithContentsOfFile:(NSString *)path placeholderImage:(UIImage *)placeholder forState:(UIControlState)state customize:(DCHImageTurboCustomizeBlock)customization completed:(DCHImageTurboLoadImageCompletionBlock)completion;

@end
