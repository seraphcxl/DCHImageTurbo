//
//  UIImageView+DCHImageTurbo.m
//  DCHImageTurbo
//
//  Created by Derek Chen on 7/28/15.
//  Copyright (c) 2015 CHEN. All rights reserved.
//

#import "UIImageView+DCHImageTurbo.h"
#import <SDWebImage/UIView+WebCacheOperation.h>
#import "UIView+DCHImageTurbo.h"
#import <libextobjc/EXTScope.h>
#import "UIImage+DCHImageTurbo.h"

NSString * const key_DCHImageTurbo_UIImageView_webImageLoadOperation = @"key_DCHImageTurbo_UIImageView_webImageLoadOperation";
NSString * const key_DCHImageTurbo_UIImageView_webHighlightedImageLoadOperation = @"key_DCHImageTurbo_UIImageView_webHighlightedImageLoadOperation";
NSString * const key_DCHImageTurbo_UIImageView_localImageLoadOperation = @"key_DCHImageTurbo_UIImageView_localImageLoadOperation";
NSString * const key_DCHImageTurbo_UIImageView_localHighlightedImageLoadOperation = @"key_DCHImageTurbo_UIImageView_localHighlightedImageLoadOperation";

@implementation UIImageView (DCHImageTurbo)

DCH_DEFINE_ASSOCIATEDOBJECT_FOR_CLASS(WebImageURL, key_DCHImageTurbo_UIImageView_webImageLoadOperation, OBJC_ASSOCIATION_RETAIN_NONATOMIC)
DCH_DEFINE_ASSOCIATEDOBJECT_FOR_CLASS(WebHighlightedImageURL, key_DCHImageTurbo_UIImageView_webHighlightedImageLoadOperation, OBJC_ASSOCIATION_RETAIN_NONATOMIC)
DCH_DEFINE_ASSOCIATEDOBJECT_FOR_CLASS(LocalImagePath, key_DCHImageTurbo_UIImageView_localImageLoadOperation, OBJC_ASSOCIATION_RETAIN_NONATOMIC)
DCH_DEFINE_ASSOCIATEDOBJECT_FOR_CLASS(LocalHighlightedImagePath, key_DCHImageTurbo_UIImageView_localHighlightedImageLoadOperation, OBJC_ASSOCIATION_RETAIN_NONATOMIC)

#pragma mark - Web image
- (void)dch_setWebImageLoadOperation:(id)operation {
    do {
        if (DCH_IsEmpty(operation)) {
            break;
        }
        [self sd_setImageLoadOperation:operation forKey:key_DCHImageTurbo_UIImageView_webImageLoadOperation];
    } while (NO);
}

- (void)dch_cancelCurrentWebImageLoadOperation {
    [self sd_cancelImageLoadOperationWithKey:key_DCHImageTurbo_UIImageView_webImageLoadOperation];
}

- (void)dch_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(DCHImageTurboLoadImageCompletionBlock)completion {
    [self dch_setImageWithURL:url placeholderImage:placeholder resize:self.frame.size scale:[self dch_screenScale] completed:completion];
}

- (void)dch_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder resize:(CGSize)newSize scale:(CGFloat)scale completed:(DCHImageTurboLoadImageCompletionBlock)completion {
    [self dch_setImageWithURL:url placeholderImage:placeholder options:0 customize:^NSDictionary *{
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        [result dch_safe_setObject:@(newSize.width) forKey:key_DCHImageTurbo_UIImage_ResizeWidth];
        [result dch_safe_setObject:@(newSize.height) forKey:key_DCHImageTurbo_UIImage_ResizeHeight];
        [result dch_safe_setObject:@(scale) forKey:key_DCHImageTurbo_UIImage_ResizeScale];
        return result;
    } progress:nil completed:completion];
}

- (void)dch_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder cornerRadius:(CGFloat)cornerRadius completed:(DCHImageTurboLoadImageCompletionBlock)completion {
    @weakify(self)
    [self dch_setImageWithURL:url placeholderImage:placeholder options:0 customize:^NSDictionary *{
        @strongify(self)
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        [result dch_safe_setObject:@([self dch_frameWidth]) forKey:key_DCHImageTurbo_UIImage_ResizeWidth];
        [result dch_safe_setObject:@([self dch_frameHeight]) forKey:key_DCHImageTurbo_UIImage_ResizeHeight];
        [result dch_safe_setObject:@([self dch_screenScale]) forKey:key_DCHImageTurbo_UIImage_ResizeScale];
        [result dch_safe_setObject:@(cornerRadius) forKey:key_DCHImageTurbo_UIImage_CornerRadius];
        return result;
    } progress:nil completed:completion];
}

- (void)dch_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor completed:(DCHImageTurboLoadImageCompletionBlock)completion {
    @weakify(self)
    [self dch_setImageWithURL:url placeholderImage:placeholder options:0 customize:^NSDictionary *{
        @strongify(self)
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        [result dch_safe_setObject:@([self dch_frameWidth]) forKey:key_DCHImageTurbo_UIImage_ResizeWidth];
        [result dch_safe_setObject:@([self dch_frameHeight]) forKey:key_DCHImageTurbo_UIImage_ResizeHeight];
        [result dch_safe_setObject:@([self dch_screenScale]) forKey:key_DCHImageTurbo_UIImage_ResizeScale];
        [result dch_safe_setObject:@(borderWidth) forKey:key_DCHImageTurbo_UIImage_BorderWidth];
        [result dch_safe_setObject:borderColor forKey:key_DCHImageTurbo_UIImage_BorderColor];
        return result;
    } progress:nil completed:completion];
}

- (void)dch_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options customize:(DCHImageTurboCustomizeBlock)customization progress:(SDWebImageDownloaderProgressBlock)progress completed:(DCHImageTurboLoadImageCompletionBlock)completion {
    @weakify(self)
    do {
        if (DCH_IsEmpty(url)) {
            break;
        }
        
        [self dch_cancelAllImageLoadOperations];
        [self dch_cleanAllImageURLs];
        
        [self setWebImageURL:url];
        
        if (!(options & SDWebImageDelayPlaceholder) && placeholder) {
            [NSThread dch_runInMain:^{
                @strongify(self)
                self.image = placeholder;
                [self setNeedsLayout];
            }];
        }
        
        [self dch_loadImageWithURL:url placeholderImage:placeholder options:options customize:customization uiRender:^(UIImage *image, NSError *error, NSString *imagePath, NSURL *imageURL) {
            @strongify(self)
            self.image = image;
            [self setNeedsLayout];
        } operationHandler:^(id<SDWebImageOperation> operation, NSString *imagePath, NSURL *imageURL) {
            @strongify(self)
            [self dch_setWebImageLoadOperation:operation];
        } progress:progress completed:completion];
    } while (NO);
}

#pragma mark - Web highlighted image
- (void)dch_setWebHighlightedImageLoadOperation:(id)operation {
    do {
        if (DCH_IsEmpty(operation)) {
            break;
        }
        [self sd_setImageLoadOperation:operation forKey:key_DCHImageTurbo_UIImageView_webHighlightedImageLoadOperation];
    } while (NO);
}

- (void)dch_cancelCurrentWebHighlightedImageLoadOperation {
    [self sd_cancelImageLoadOperationWithKey:key_DCHImageTurbo_UIImageView_webHighlightedImageLoadOperation];
}

- (void)dch_setHighlightedImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(DCHImageTurboLoadImageCompletionBlock)completion {
    [self dch_setHighlightedImageWithURL:url placeholderImage:placeholder resize:self.frame.size scale:[self dch_screenScale] completed:completion];
}

- (void)dch_setHighlightedImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder resize:(CGSize)newSize scale:(CGFloat)scale completed:(DCHImageTurboLoadImageCompletionBlock)completion {
    [self dch_setHighlightedImageWithURL:url placeholderImage:placeholder options:0 customize:^NSDictionary *{
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        [result dch_safe_setObject:@(newSize.width) forKey:key_DCHImageTurbo_UIImage_ResizeWidth];
        [result dch_safe_setObject:@(newSize.height) forKey:key_DCHImageTurbo_UIImage_ResizeHeight];
        [result dch_safe_setObject:@(scale) forKey:key_DCHImageTurbo_UIImage_ResizeScale];
        return result;
    } progress:nil completed:completion];
}

- (void)dch_setHighlightedImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder cornerRadius:(CGFloat)cornerRadius completed:(DCHImageTurboLoadImageCompletionBlock)completion {
    @weakify(self)
    [self dch_setHighlightedImageWithURL:url placeholderImage:placeholder options:0 customize:^NSDictionary *{
        @strongify(self)
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        [result dch_safe_setObject:@([self dch_frameWidth]) forKey:key_DCHImageTurbo_UIImage_ResizeWidth];
        [result dch_safe_setObject:@([self dch_frameHeight]) forKey:key_DCHImageTurbo_UIImage_ResizeHeight];
        [result dch_safe_setObject:@([self dch_screenScale]) forKey:key_DCHImageTurbo_UIImage_ResizeScale];
        [result dch_safe_setObject:@(cornerRadius) forKey:key_DCHImageTurbo_UIImage_CornerRadius];
        return result;
    } progress:nil completed:completion];
}

- (void)dch_setHighlightedImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor completed:(DCHImageTurboLoadImageCompletionBlock)completion {
    @weakify(self)
    [self dch_setHighlightedImageWithURL:url placeholderImage:placeholder options:0 customize:^NSDictionary *{
        @strongify(self)
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        [result dch_safe_setObject:@([self dch_frameWidth]) forKey:key_DCHImageTurbo_UIImage_ResizeWidth];
        [result dch_safe_setObject:@([self dch_frameHeight]) forKey:key_DCHImageTurbo_UIImage_ResizeHeight];
        [result dch_safe_setObject:@([self dch_screenScale]) forKey:key_DCHImageTurbo_UIImage_ResizeScale];
        [result dch_safe_setObject:@(borderWidth) forKey:key_DCHImageTurbo_UIImage_BorderWidth];
        [result dch_safe_setObject:borderColor forKey:key_DCHImageTurbo_UIImage_BorderColor];
        return result;
    } progress:nil completed:completion];
}

- (void)dch_setHighlightedImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options customize:(DCHImageTurboCustomizeBlock)customization progress:(SDWebImageDownloaderProgressBlock)progress completed:(DCHImageTurboLoadImageCompletionBlock)completion {
    @weakify(self)
    do {
        if (DCH_IsEmpty(url)) {
            break;
        }
        
        [self dch_cancelAllImageLoadOperations];
        [self dch_cleanAllImageURLs];
        
        [self setWebHighlightedImageURL:url];
        
        if (!(options & SDWebImageDelayPlaceholder) && placeholder) {
            [NSThread dch_runInMain:^{
                @strongify(self)
                self.highlightedImage = placeholder;
                [self setNeedsLayout];
            }];
        }
        
        [self dch_loadImageWithURL:url placeholderImage:placeholder options:options customize:customization uiRender:^(UIImage *image, NSError *error, NSString *imagePath, NSURL *imageURL) {
            @strongify(self)
            self.highlightedImage = image;
            [self setNeedsLayout];
        } operationHandler:^(id<SDWebImageOperation> operation, NSString *imagePath, NSURL *imageURL) {
            @strongify(self)
            [self dch_setWebHighlightedImageLoadOperation:operation];
        } progress:progress completed:completion];
    } while (NO);
}

#pragma mark - Local image
- (void)dch_setLocalImageLoadOperation:(id)operation {
    do {
        if (DCH_IsEmpty(operation)) {
            break;
        }
        [self sd_setImageLoadOperation:operation forKey:key_DCHImageTurbo_UIImageView_localImageLoadOperation];
    } while (NO);
}

- (void)dch_cancelCurrentLocalImageLoadOperation {
    [self sd_cancelImageLoadOperationWithKey:key_DCHImageTurbo_UIImageView_localImageLoadOperation];
}

- (void)dch_setImageWithContentsOfFile:(NSString *)path placeholderImage:(UIImage *)placeholder completed:(DCHImageTurboLoadImageCompletionBlock)completion {
    [self dch_setImageWithContentsOfFile:path placeholderImage:placeholder resize:self.frame.size scale:[self dch_screenScale] completed:completion];
}

- (void)dch_setImageWithContentsOfFile:(NSString *)path placeholderImage:(UIImage *)placeholder resize:(CGSize)newSize scale:(CGFloat)scale completed:(DCHImageTurboLoadImageCompletionBlock)completion {
    [self dch_setImageWithContentsOfFile:path placeholderImage:placeholder customize:^NSDictionary *{
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        [result dch_safe_setObject:@(newSize.width) forKey:key_DCHImageTurbo_UIImage_ResizeWidth];
        [result dch_safe_setObject:@(newSize.height) forKey:key_DCHImageTurbo_UIImage_ResizeHeight];
        [result dch_safe_setObject:@(scale) forKey:key_DCHImageTurbo_UIImage_ResizeScale];
        return result;
    } completed:completion];
}

- (void)dch_setImageWithContentsOfFile:(NSString *)path placeholderImage:(UIImage *)placeholder cornerRadius:(CGFloat)cornerRadius completed:(DCHImageTurboLoadImageCompletionBlock)completion {
    @weakify(self)
    [self dch_setImageWithContentsOfFile:path placeholderImage:placeholder customize:^NSDictionary *{
        @strongify(self)
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        [result dch_safe_setObject:@([self dch_frameWidth]) forKey:key_DCHImageTurbo_UIImage_ResizeWidth];
        [result dch_safe_setObject:@([self dch_frameHeight]) forKey:key_DCHImageTurbo_UIImage_ResizeHeight];
        [result dch_safe_setObject:@([self dch_screenScale]) forKey:key_DCHImageTurbo_UIImage_ResizeScale];
        [result dch_safe_setObject:@(cornerRadius) forKey:key_DCHImageTurbo_UIImage_CornerRadius];
        return result;
    } completed:completion];
}

- (void)dch_setImageWithContentsOfFile:(NSString *)path placeholderImage:(UIImage *)placeholder borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor completed:(DCHImageTurboLoadImageCompletionBlock)completion {
    @weakify(self)
    [self dch_setImageWithContentsOfFile:path placeholderImage:placeholder customize:^NSDictionary *{
        @strongify(self)
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        [result dch_safe_setObject:@([self dch_frameWidth]) forKey:key_DCHImageTurbo_UIImage_ResizeWidth];
        [result dch_safe_setObject:@([self dch_frameHeight]) forKey:key_DCHImageTurbo_UIImage_ResizeHeight];
        [result dch_safe_setObject:@([self dch_screenScale]) forKey:key_DCHImageTurbo_UIImage_ResizeScale];
        [result dch_safe_setObject:@(borderWidth) forKey:key_DCHImageTurbo_UIImage_BorderWidth];
        [result dch_safe_setObject:borderColor forKey:key_DCHImageTurbo_UIImage_BorderColor];
        return result;
    } completed:completion];
}

- (void)dch_setImageWithContentsOfFile:(NSString *)path placeholderImage:(UIImage *)placeholder customize:(DCHImageTurboCustomizeBlock)customization completed:(DCHImageTurboLoadImageCompletionBlock)completion {
    @weakify(self)
    [self dch_cancelAllImageLoadOperations];
    [self dch_cleanAllImageURLs];
    
    [self setLocalImagePath:path];
    
    if (placeholder) {
        [NSThread dch_runInMain:^{
            @strongify(self)
            self.image = placeholder;
            [self setNeedsLayout];
        }];
    }
    
    [self dch_loadImageWithContentsOfFile:path placeholderImage:placeholder customize:customization uiRender:^(UIImage *image, NSError *error, NSString *imagePath, NSURL *imageURL) {
        @strongify(self)
        self.image = image;
        [self setNeedsLayout];
    } operationHandler:^(id<SDWebImageOperation> operation, NSString *imagePath, NSURL *imageURL) {
        @strongify(self)
        [self dch_setLocalImageLoadOperation:operation];
    } completed:completion];
}

#pragma mark - Local highlighted image
- (void)dch_setLocalHighlightedImageLoadOperation:(id)operation {
    do {
        if (DCH_IsEmpty(operation)) {
            break;
        }
        [self sd_setImageLoadOperation:operation forKey:key_DCHImageTurbo_UIImageView_localHighlightedImageLoadOperation];
    } while (NO);
}

- (void)dch_cancelCurrentLocalHighlightedImageLoadOperation {
    [self sd_cancelImageLoadOperationWithKey:key_DCHImageTurbo_UIImageView_localHighlightedImageLoadOperation];
}

- (void)dch_setHighlightedImageWithContentsOfFile:(NSString *)path placeholderImage:(UIImage *)placeholder completed:(DCHImageTurboLoadImageCompletionBlock)completion {
    [self dch_setHighlightedImageWithContentsOfFile:path placeholderImage:placeholder resize:self.frame.size scale:[self dch_screenScale] completed:completion];
}

- (void)dch_setHighlightedImageWithContentsOfFile:(NSString *)path placeholderImage:(UIImage *)placeholder resize:(CGSize)newSize scale:(CGFloat)scale completed:(DCHImageTurboLoadImageCompletionBlock)completion {
    [self dch_setHighlightedImageWithContentsOfFile:path placeholderImage:placeholder customize:^NSDictionary *{
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        [result dch_safe_setObject:@(newSize.width) forKey:key_DCHImageTurbo_UIImage_ResizeWidth];
        [result dch_safe_setObject:@(newSize.height) forKey:key_DCHImageTurbo_UIImage_ResizeHeight];
        [result dch_safe_setObject:@(scale) forKey:key_DCHImageTurbo_UIImage_ResizeScale];
        return result;
    } completed:completion];
}

- (void)dch_setHighlightedImageWithContentsOfFile:(NSString *)path placeholderImage:(UIImage *)placeholder cornerRadius:(CGFloat)cornerRadius completed:(DCHImageTurboLoadImageCompletionBlock)completion {
    @weakify(self)
    [self dch_setHighlightedImageWithContentsOfFile:path placeholderImage:placeholder customize:^NSDictionary *{
        @strongify(self)
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        [result dch_safe_setObject:@([self dch_frameWidth]) forKey:key_DCHImageTurbo_UIImage_ResizeWidth];
        [result dch_safe_setObject:@([self dch_frameHeight]) forKey:key_DCHImageTurbo_UIImage_ResizeHeight];
        [result dch_safe_setObject:@([self dch_screenScale]) forKey:key_DCHImageTurbo_UIImage_ResizeScale];
        [result dch_safe_setObject:@(cornerRadius) forKey:key_DCHImageTurbo_UIImage_CornerRadius];
        return result;
    } completed:completion];
}

- (void)dch_setHighlightedImageWithContentsOfFile:(NSString *)path placeholderImage:(UIImage *)placeholder borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor completed:(DCHImageTurboLoadImageCompletionBlock)completion {
    @weakify(self)
    [self dch_setHighlightedImageWithContentsOfFile:path placeholderImage:placeholder customize:^NSDictionary *{
        @strongify(self)
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        [result dch_safe_setObject:@([self dch_frameWidth]) forKey:key_DCHImageTurbo_UIImage_ResizeWidth];
        [result dch_safe_setObject:@([self dch_frameHeight]) forKey:key_DCHImageTurbo_UIImage_ResizeHeight];
        [result dch_safe_setObject:@([self dch_screenScale]) forKey:key_DCHImageTurbo_UIImage_ResizeScale];
        [result dch_safe_setObject:@(borderWidth) forKey:key_DCHImageTurbo_UIImage_BorderWidth];
        [result dch_safe_setObject:borderColor forKey:key_DCHImageTurbo_UIImage_BorderColor];
        return result;
    } completed:completion];
}

- (void)dch_setHighlightedImageWithContentsOfFile:(NSString *)path placeholderImage:(UIImage *)placeholder customize:(DCHImageTurboCustomizeBlock)customization completed:(DCHImageTurboLoadImageCompletionBlock)completion {
    @weakify(self)
    [self dch_cancelAllImageLoadOperations];
    [self dch_cleanAllImageURLs];
    
    [self setLocalHighlightedImagePath:path];
    
    if (placeholder) {
        [NSThread dch_runInMain:^{
            @strongify(self)
            self.highlightedImage = placeholder;
            [self setNeedsLayout];
        }];
    }
    
    [self dch_loadImageWithContentsOfFile:path placeholderImage:placeholder customize:customization uiRender:^(UIImage *image, NSError *error, NSString *imagePath, NSURL *imageURL) {
        @strongify(self)
        self.highlightedImage = image;
        [self setNeedsLayout];
    } operationHandler:^(id<SDWebImageOperation> operation, NSString *imagePath, NSURL *imageURL) {
        @strongify(self)
        [self dch_setLocalHighlightedImageLoadOperation:operation];
    } completed:completion];
}

#pragma mark - Action
- (void)dch_cleanAllImageURLs {
    [self setWebImageURL:nil];
    [self setWebHighlightedImageURL:nil];
    [self setLocalImagePath:nil];
    [self setLocalHighlightedImagePath:nil];
}

- (void)dch_cancelAllImageLoadOperations {
    [self dch_cancelCurrentWebImageLoadOperation];
    [self dch_cancelCurrentWebHighlightedImageLoadOperation];
    [self dch_cancelCurrentLocalImageLoadOperation];
    [self dch_cancelCurrentLocalHighlightedImageLoadOperation];
}

@end
