//
//  UIImageView+DCHImageTurbo.h
//  DCHImageTurbo
//
//  Created by Derek Chen on 7/28/15.
//  Copyright (c) 2015 CHEN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Tourbillon/DCHTourbillon.h>
#import "UIView+DCHImageTurbo.h"

extern NSString * const key_DCHImageTurbo_UIImageView_webImageLoadOperation;
extern NSString * const key_DCHImageTurbo_UIImageView_webHighlightedImageLoadOperation;
extern NSString * const key_DCHImageTurbo_UIImageView_localImageLoadOperation;
extern NSString * const key_DCHImageTurbo_UIImageView_localHighlightedImageLoadOperation;

@interface UIImageView (DCHImageTurbo)

DCH_DEFINE_ASSOCIATEDOBJECT_FOR_HEADER(WebImageURL)
DCH_DEFINE_ASSOCIATEDOBJECT_FOR_HEADER(WebHighlightedImageURL)
DCH_DEFINE_ASSOCIATEDOBJECT_FOR_HEADER(LocalImagePath)
DCH_DEFINE_ASSOCIATEDOBJECT_FOR_HEADER(LocalHighlightedImagePath)

#pragma mark - Web image
- (void)dch_setWebImageLoadOperation:(id)operation;
- (void)dch_cancelCurrentWebImageLoadOperation;

- (void)dch_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(DCHImageTurboLoadImageCompletionBlock)completion;
- (void)dch_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder resize:(CGSize)newSize scale:(CGFloat)scale completed:(DCHImageTurboLoadImageCompletionBlock)completion;
- (void)dch_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder cornerRadius:(CGFloat)cornerRadius completed:(DCHImageTurboLoadImageCompletionBlock)completion;
- (void)dch_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor completed:(DCHImageTurboLoadImageCompletionBlock)completion;

- (void)dch_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options customize:(DCHImageTurboCustomizeBlock)customization progress:(SDWebImageDownloaderProgressBlock)progress completed:(DCHImageTurboLoadImageCompletionBlock)completion;

#pragma mark - Web highlighted image
- (void)dch_setWebHighlightedImageLoadOperation:(id)operation;
- (void)dch_cancelCurrentWebHighlightedImageLoadOperation;

- (void)dch_setHighlightedImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(DCHImageTurboLoadImageCompletionBlock)completion;
- (void)dch_setHighlightedImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder resize:(CGSize)newSize scale:(CGFloat)scale completed:(DCHImageTurboLoadImageCompletionBlock)completion;
- (void)dch_setHighlightedImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder cornerRadius:(CGFloat)cornerRadius completed:(DCHImageTurboLoadImageCompletionBlock)completion;
- (void)dch_setHighlightedImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor completed:(DCHImageTurboLoadImageCompletionBlock)completion;

- (void)dch_setHighlightedImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options customize:(DCHImageTurboCustomizeBlock)customization progress:(SDWebImageDownloaderProgressBlock)progress completed:(DCHImageTurboLoadImageCompletionBlock)completion;

#pragma mark - Local image
- (void)dch_setLocalImageLoadOperation:(id)operation;
- (void)dch_cancelCurrentLocalImageLoadOperation;

- (void)dch_setImageWithContentsOfFile:(NSString *)path placeholderImage:(UIImage *)placeholder completed:(DCHImageTurboLoadImageCompletionBlock)completion;
- (void)dch_setImageWithContentsOfFile:(NSString *)path placeholderImage:(UIImage *)placeholder resize:(CGSize)newSize scale:(CGFloat)scale completed:(DCHImageTurboLoadImageCompletionBlock)completion;
- (void)dch_setImageWithContentsOfFile:(NSString *)path placeholderImage:(UIImage *)placeholder cornerRadius:(CGFloat)cornerRadius completed:(DCHImageTurboLoadImageCompletionBlock)completion;
- (void)dch_setImageWithContentsOfFile:(NSString *)path placeholderImage:(UIImage *)placeholder borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor completed:(DCHImageTurboLoadImageCompletionBlock)completion;

- (void)dch_setImageWithContentsOfFile:(NSString *)path placeholderImage:(UIImage *)placeholder customize:(DCHImageTurboCustomizeBlock)customization completed:(DCHImageTurboLoadImageCompletionBlock)completion;

#pragma mark - Local highlighted image
- (void)dch_setLocalHighlightedImageLoadOperation:(id)operation;
- (void)dch_cancelCurrentLocalHighlightedImageLoadOperation;

- (void)dch_setHighlightedImageWithContentsOfFile:(NSString *)path placeholderImage:(UIImage *)placeholder completed:(DCHImageTurboLoadImageCompletionBlock)completion;
- (void)dch_setHighlightedImageWithContentsOfFile:(NSString *)path placeholderImage:(UIImage *)placeholder resize:(CGSize)newSize scale:(CGFloat)scale completed:(DCHImageTurboLoadImageCompletionBlock)completion;
- (void)dch_setHighlightedImageWithContentsOfFile:(NSString *)path placeholderImage:(UIImage *)placeholder cornerRadius:(CGFloat)cornerRadius completed:(DCHImageTurboLoadImageCompletionBlock)completion;
- (void)dch_setHighlightedImageWithContentsOfFile:(NSString *)path placeholderImage:(UIImage *)placeholder borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor completed:(DCHImageTurboLoadImageCompletionBlock)completion;

- (void)dch_setHighlightedImageWithContentsOfFile:(NSString *)path placeholderImage:(UIImage *)placeholder customize:(DCHImageTurboCustomizeBlock)customization completed:(DCHImageTurboLoadImageCompletionBlock)completion;

#pragma mark - Action
- (void)dch_cleanAllImageURLs;
- (void)dch_cancelAllImageLoadOperations;

@end
