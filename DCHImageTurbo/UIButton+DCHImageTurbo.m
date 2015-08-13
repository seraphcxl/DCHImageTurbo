//
//  UIButton+DCHImageTurbo.m
//  DCHImageTurbo
//
//  Created by Derek Chen on 7/28/15.
//  Copyright (c) 2015 CHEN. All rights reserved.
//

#import "UIButton+DCHImageTurbo.h"
#import "UIView+DCHImageTurbo.h"
#import <libextobjc/EXTScope.h>
#import "UIImage+DCHImageTurbo.h"

NSString * const key_DCHImageTurbo_UIButton_WebImageURLStorage = @"key_DCHImageTurbo_UIButton_WebImageURLStorage";
NSString * const key_DCHImageTurbo_UIButton_WebBackgroundImageURLStorage = @"key_DCHImageTurbo_UIButton_WebBackgroundImageURLStorage";
NSString * const key_DCHImageTurbo_UIButton_LocalImagePathStorage = @"key_DCHImageTurbo_UIButton_LocalImagePathStorage";
NSString * const key_DCHImageTurbo_UIButton_LocalBackgroundImagePathStorage = @"key_DCHImageTurbo_UIButton_LocalBackgroundImagePathStorage";

NSString * const key_DCHImageTurbo_UIButton_WebImageLoadOperation = @"key_DCHImageTurbo_UIButton_WebImageLoadOperation";
NSString * const key_DCHImageTurbo_UIButton_WebBackgroundImageLoadOperation = @"key_DCHImageTurbo_UIButton_WebBackgroundImageLoadOperation";
NSString * const key_DCHImageTurbo_UIButton_LocalImageLoadOperation = @"key_DCHImageTurbo_UIButton_LocalImageLoadOperation";
NSString * const key_DCHImageTurbo_UIButton_LocalBackgroundImageLoadOperation = @"key_DCHImageTurbo_UIButton_LocalBackgroundImageLoadOperation";

@implementation UIButton (DCHImageTurbo)

- (NSString *)dch_createKeyForButtonLoadImageWithPrefix:(NSString *)prefix andState:(UIControlState)state {
    NSString *result = nil;
    do {
        if (DCH_IsEmpty(prefix)) {
            break;
        }
        result = [NSString stringWithFormat:@"%@%@", prefix, @(state)];
    } while (NO);
    return result;
}

#pragma mark - Web image
- (NSMutableDictionary *)dch_webImageURLStorage {
    NSMutableDictionary *storage = [[self getImageLocationStorage] dch_safe_objectForKey:key_DCHImageTurbo_UIButton_WebImageURLStorage];
    if (!storage) {
        storage = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, &key_DCHImageTurbo_UIButton_WebImageURLStorage, storage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return storage;
}

- (NSURL *)dch_currentWebImageURL {
    NSURL *url = [self dch_webImageURLStorage][@(self.state)];
    
    if (!url) {
        url = [self dch_webImageURLStorage][@(UIControlStateNormal)];
    }
    
    return url;
}

- (NSURL *)dch_webImageURLForState:(UIControlState)state {
    return [self dch_webImageURLStorage][@(state)];
}

- (void)dch_setWebImageURL:(NSURL *)url forState:(UIControlState)state {
    do {
        if (DCH_IsEmpty(url)) {
            break;
        }
        NSMutableDictionary *storage = [self dch_webImageURLStorage];
        if (DCH_IsEmpty(storage)) {
            break;
        }
        [storage dch_safe_setObject:url forKey:@(state)];
    } while (NO);
}

- (void)dch_setWebImageLoadOperation:(id <SDWebImageOperation>)operation forState:(UIControlState)state {
    do {
        if (DCH_IsEmpty(operation)) {
            break;
        }
        [self sd_setImageLoadOperation:operation forKey:[self dch_createKeyForButtonLoadImageWithPrefix:key_DCHImageTurbo_UIButton_WebImageLoadOperation andState:state]];
    } while (NO);
}

- (void)dch_cancelWebImageLoadOperationForState:(UIControlState)state {
    [self sd_cancelImageLoadOperationWithKey:[self dch_createKeyForButtonLoadImageWithPrefix:key_DCHImageTurbo_UIButton_WebImageLoadOperation andState:state]];
}

- (void)dch_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder forState:(UIControlState)state completed:(DCHImageTurboLoadImageCompletionBlock)completion {
    [self dch_setImageWithURL:url placeholderImage:placeholder forState:state resize:self.frame.size scale:[self dch_screenScale] completed:completion];
}

- (void)dch_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder forState:(UIControlState)state resize:(CGSize)newSize scale:(CGFloat)scale completed:(DCHImageTurboLoadImageCompletionBlock)completion {
    [self dch_setImageWithURL:url placeholderImage:placeholder forState:state options:0 customize:^NSDictionary *{
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        [result dch_safe_setObject:@(newSize.width) forKey:key_DCHImageTurbo_UIImage_ResizeWidth];
        [result dch_safe_setObject:@(newSize.height) forKey:key_DCHImageTurbo_UIImage_ResizeHeight];
        [result dch_safe_setObject:@(scale) forKey:key_DCHImageTurbo_UIImage_ResizeScale];
        return result;
    } progress:nil completed:completion];
}

- (void)dch_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder forState:(UIControlState)state cornerRadius:(CGFloat)cornerRadius completed:(DCHImageTurboLoadImageCompletionBlock)completion {
    @weakify(self)
    [self dch_setImageWithURL:url placeholderImage:placeholder forState:state options:0 customize:^NSDictionary *{
        @strongify(self)
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        [result dch_safe_setObject:@([self dch_frameWidth]) forKey:key_DCHImageTurbo_UIImage_ResizeWidth];
        [result dch_safe_setObject:@([self dch_frameHeight]) forKey:key_DCHImageTurbo_UIImage_ResizeHeight];
        [result dch_safe_setObject:@([self dch_screenScale]) forKey:key_DCHImageTurbo_UIImage_ResizeScale];
        [result dch_safe_setObject:@(cornerRadius) forKey:key_DCHImageTurbo_UIImage_CornerRadius];
        return result;
    } progress:nil completed:completion];
}

- (void)dch_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder forState:(UIControlState)state borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor completed:(DCHImageTurboLoadImageCompletionBlock)completion {
    @weakify(self)
    [self dch_setImageWithURL:url placeholderImage:placeholder forState:state options:0 customize:^NSDictionary *{
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

- (void)dch_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder forState:(UIControlState)state applyBlurWithRadius:(CGFloat)radius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage completed:(DCHImageTurboLoadImageCompletionBlock)completion {
    @weakify(self)
    [self dch_setImageWithURL:url placeholderImage:placeholder forState:state options:0 customize:^NSDictionary *{
        @strongify(self)
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        [result dch_safe_setObject:@([self dch_frameWidth]) forKey:key_DCHImageTurbo_UIImage_ResizeWidth];
        [result dch_safe_setObject:@([self dch_frameHeight]) forKey:key_DCHImageTurbo_UIImage_ResizeHeight];
        [result dch_safe_setObject:@([self dch_screenScale]) forKey:key_DCHImageTurbo_UIImage_ResizeScale];
        [result dch_safe_setObject:@(radius) forKey:key_DCHImageTurbo_UIImage_BlurRadius];
        [result dch_safe_setObject:tintColor forKey:key_DCHImageTurbo_UIImage_BlurTintColor];
        [result dch_safe_setObject:@(saturationDeltaFactor) forKey:key_DCHImageTurbo_UIImage_BlurSaturationDeltaFactor];
        [result dch_safe_setObject:maskImage forKey:key_DCHImageTurbo_UIImage_BlurMaskImage];
        return result;
    } progress:nil completed:completion];
}

- (void)dch_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder forState:(UIControlState)state options:(SDWebImageOptions)options customize:(DCHImageTurboCustomizeBlock)customization progress:(SDWebImageDownloaderProgressBlock)progress completed:(DCHImageTurboLoadImageCompletionBlock)completion {
    @weakify(self)
    do {
        if (DCH_IsEmpty(url)) {
            break;
        }
        
        [self dch_cancelWebImageLoadOperationForState:state];
        
        [self dch_setWebImageURL:url forState:state];
        
        if (!(options & SDWebImageDelayPlaceholder) && placeholder) {
            [NSThread dch_runInMain:^{
                @strongify(self)
                [self setImage:placeholder forState:state];
                [self setNeedsLayout];
            }];
        }
        
        [self dch_loadImageWithURL:url placeholderImage:placeholder options:options customize:customization uiRender:^(UIImage *image, NSError *error, NSString *imagePath, NSURL *imageURL) {
            @strongify(self)
            [self setImage:image forState:state];
            [self setNeedsLayout];
        } operationHandler:^(id<SDWebImageOperation> operation, NSString *imagePath, NSURL *imageURL) {
            @strongify(self)
            [self dch_setWebImageLoadOperation:operation forState:state];
        } progress:progress completed:completion];
    } while (NO);
}

#pragma mark - Web background image
- (NSMutableDictionary *)dch_webBackgroundImageURLStorage {
    NSMutableDictionary *storage = [[self getImageLocationStorage] dch_safe_objectForKey:key_DCHImageTurbo_UIButton_WebBackgroundImageURLStorage];
    if (!storage) {
        storage = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, &key_DCHImageTurbo_UIButton_WebBackgroundImageURLStorage, storage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return storage;
}

- (NSURL *)dch_currentWebBackgroundImageURL {
    NSURL *url = [self dch_webBackgroundImageURLStorage][@(self.state)];
    
    if (!url) {
        url = [self dch_webBackgroundImageURLStorage][@(UIControlStateNormal)];
    }
    
    return url;
}

- (NSURL *)dch_webBackgroundImageURLForState:(UIControlState)state {
    return [self dch_webBackgroundImageURLStorage][@(state)];
}

- (void)dch_setWebBackgroundImageURL:(NSURL *)url forState:(UIControlState)state {
    do {
        if (DCH_IsEmpty(url)) {
            break;
        }
        NSMutableDictionary *storage = [self dch_webBackgroundImageURLStorage];
        if (DCH_IsEmpty(storage)) {
            break;
        }
        [storage dch_safe_setObject:url forKey:@(state)];
    } while (NO);
}

- (void)dch_setWebBackgroundImageLoadOperation:(id <SDWebImageOperation>)operation forState:(UIControlState)state {
    do {
        if (DCH_IsEmpty(operation)) {
            break;
        }
        [self sd_setImageLoadOperation:operation forKey:[self dch_createKeyForButtonLoadImageWithPrefix:key_DCHImageTurbo_UIButton_WebBackgroundImageLoadOperation andState:state]];
    } while (NO);
}

- (void)dch_cancelWebBackgroundImageLoadOperationForState:(UIControlState)state {
    [self sd_cancelImageLoadOperationWithKey:[self dch_createKeyForButtonLoadImageWithPrefix:key_DCHImageTurbo_UIButton_WebBackgroundImageLoadOperation andState:state]];
}

- (void)dch_setBackgroundImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder forState:(UIControlState)state completed:(DCHImageTurboLoadImageCompletionBlock)completion {
    [self dch_setBackgroundImageWithURL:url placeholderImage:placeholder forState:state resize:self.frame.size scale:[self dch_screenScale] completed:completion];
}

- (void)dch_setBackgroundImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder forState:(UIControlState)state resize:(CGSize)newSize scale:(CGFloat)scale completed:(DCHImageTurboLoadImageCompletionBlock)completion {
    [self dch_setBackgroundImageWithURL:url placeholderImage:placeholder forState:state options:0 customize:^NSDictionary *{
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        [result dch_safe_setObject:@(newSize.width) forKey:key_DCHImageTurbo_UIImage_ResizeWidth];
        [result dch_safe_setObject:@(newSize.height) forKey:key_DCHImageTurbo_UIImage_ResizeHeight];
        [result dch_safe_setObject:@(scale) forKey:key_DCHImageTurbo_UIImage_ResizeScale];
        return result;
    } progress:nil completed:completion];
}

- (void)dch_setBackgroundImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder forState:(UIControlState)state cornerRadius:(CGFloat)cornerRadius completed:(DCHImageTurboLoadImageCompletionBlock)completion {
    @weakify(self)
    [self dch_setBackgroundImageWithURL:url placeholderImage:placeholder forState:state options:0 customize:^NSDictionary *{
        @strongify(self)
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        [result dch_safe_setObject:@([self dch_frameWidth]) forKey:key_DCHImageTurbo_UIImage_ResizeWidth];
        [result dch_safe_setObject:@([self dch_frameHeight]) forKey:key_DCHImageTurbo_UIImage_ResizeHeight];
        [result dch_safe_setObject:@([self dch_screenScale]) forKey:key_DCHImageTurbo_UIImage_ResizeScale];
        [result dch_safe_setObject:@(cornerRadius) forKey:key_DCHImageTurbo_UIImage_CornerRadius];
        return result;
    } progress:nil completed:completion];
}

- (void)dch_setBackgroundImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder forState:(UIControlState)state borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor completed:(DCHImageTurboLoadImageCompletionBlock)completion {
    @weakify(self)
    [self dch_setBackgroundImageWithURL:url placeholderImage:placeholder forState:state options:0 customize:^NSDictionary *{
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

- (void)dch_setBackgroundImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder forState:(UIControlState)state applyBlurWithRadius:(CGFloat)radius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage completed:(DCHImageTurboLoadImageCompletionBlock)completion {
    @weakify(self)
    [self dch_setBackgroundImageWithURL:url placeholderImage:placeholder forState:state options:0 customize:^NSDictionary *{
        @strongify(self)
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        [result dch_safe_setObject:@([self dch_frameWidth]) forKey:key_DCHImageTurbo_UIImage_ResizeWidth];
        [result dch_safe_setObject:@([self dch_frameHeight]) forKey:key_DCHImageTurbo_UIImage_ResizeHeight];
        [result dch_safe_setObject:@([self dch_screenScale]) forKey:key_DCHImageTurbo_UIImage_ResizeScale];
        [result dch_safe_setObject:@(radius) forKey:key_DCHImageTurbo_UIImage_BlurRadius];
        [result dch_safe_setObject:tintColor forKey:key_DCHImageTurbo_UIImage_BlurTintColor];
        [result dch_safe_setObject:@(saturationDeltaFactor) forKey:key_DCHImageTurbo_UIImage_BlurSaturationDeltaFactor];
        [result dch_safe_setObject:maskImage forKey:key_DCHImageTurbo_UIImage_BlurMaskImage];
        return result;
    } progress:nil completed:completion];
}

- (void)dch_setBackgroundImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder forState:(UIControlState)state options:(SDWebImageOptions)options customize:(DCHImageTurboCustomizeBlock)customization progress:(SDWebImageDownloaderProgressBlock)progress completed:(DCHImageTurboLoadImageCompletionBlock)completion {
    @weakify(self)
    do {
        if (DCH_IsEmpty(url)) {
            break;
        }
        
        [self dch_cancelWebBackgroundImageLoadOperationForState:state];
        
        [self dch_setWebBackgroundImageURL:url forState:state];
        
        if (!(options & SDWebImageDelayPlaceholder) && placeholder) {
            [NSThread dch_runInMain:^{
                @strongify(self)
                [self setBackgroundImage:placeholder forState:state];
                [self setNeedsLayout];
            }];
        }
        
        [self dch_loadImageWithURL:url placeholderImage:placeholder options:options customize:customization uiRender:^(UIImage *image, NSError *error, NSString *imagePath, NSURL *imageURL) {
            @strongify(self)
            [self setBackgroundImage:image forState:state];
            [self setNeedsLayout];
        } operationHandler:^(id<SDWebImageOperation> operation, NSString *imagePath, NSURL *imageURL) {
            @strongify(self)
            [self dch_setWebBackgroundImageLoadOperation:operation forState:state];
        } progress:progress completed:completion];
    } while (NO);
}

#pragma mark - Local image
- (NSMutableDictionary *)dch_localImagePathStorage {
    NSMutableDictionary *storage = [[self getImageLocationStorage] dch_safe_objectForKey:key_DCHImageTurbo_UIButton_LocalImagePathStorage];
    if (!storage) {
        storage = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, &key_DCHImageTurbo_UIButton_LocalImagePathStorage, storage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return storage;
}

- (NSString *)dch_currentLocalImagePath {
    NSString *path = [self dch_localImagePathStorage][@(self.state)];
    
    if (!path) {
        path = [self dch_localImagePathStorage][@(UIControlStateNormal)];
    }
    
    return path;
}

- (NSString *)dch_localImagePathForState:(UIControlState)state {
    return [self dch_localImagePathStorage][@(state)];
}

- (void)dch_setLocalImageURL:(NSString *)path forState:(UIControlState)state {
    do {
        if (DCH_IsEmpty(path)) {
            break;
        }
        NSMutableDictionary *storage = [self dch_localImagePathStorage];
        if (DCH_IsEmpty(storage)) {
            break;
        }
        [storage dch_safe_setObject:path forKey:@(state)];
    } while (NO);
}

- (void)dch_setLocalImageLoadOperation:(id <SDWebImageOperation>)operation forState:(UIControlState)state {
    do {
        if (DCH_IsEmpty(operation)) {
            break;
        }
        [self sd_setImageLoadOperation:operation forKey:[self dch_createKeyForButtonLoadImageWithPrefix:key_DCHImageTurbo_UIButton_LocalImageLoadOperation andState:state]];
    } while (NO);
}

- (void)dch_cancelLocalImageLoadOperationForState:(UIControlState)state {
    [self sd_cancelImageLoadOperationWithKey:[self dch_createKeyForButtonLoadImageWithPrefix:key_DCHImageTurbo_UIButton_LocalImageLoadOperation andState:state]];
}

- (void)dch_setImageWithContentsOfFile:(NSString *)path placeholderImage:(UIImage *)placeholder forState:(UIControlState)state completed:(DCHImageTurboLoadImageCompletionBlock)completion {
    [self dch_setImageWithContentsOfFile:path placeholderImage:placeholder forState:state resize:self.frame.size scale:[self dch_screenScale] completed:completion];
}

- (void)dch_setImageWithContentsOfFile:(NSString *)path placeholderImage:(UIImage *)placeholder forState:(UIControlState)state resize:(CGSize)newSize scale:(CGFloat)scale completed:(DCHImageTurboLoadImageCompletionBlock)completion {
    [self dch_setImageWithContentsOfFile:path placeholderImage:placeholder forState:state customize:^NSDictionary *{
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        [result dch_safe_setObject:@(newSize.width) forKey:key_DCHImageTurbo_UIImage_ResizeWidth];
        [result dch_safe_setObject:@(newSize.height) forKey:key_DCHImageTurbo_UIImage_ResizeHeight];
        [result dch_safe_setObject:@(scale) forKey:key_DCHImageTurbo_UIImage_ResizeScale];
        return result;
    } completed:completion];
}

- (void)dch_setImageWithContentsOfFile:(NSString *)path placeholderImage:(UIImage *)placeholder forState:(UIControlState)state cornerRadius:(CGFloat)cornerRadius completed:(DCHImageTurboLoadImageCompletionBlock)completion {
    @weakify(self)
    [self dch_setImageWithContentsOfFile:path placeholderImage:placeholder forState:state customize:^NSDictionary *{
        @strongify(self)
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        [result dch_safe_setObject:@([self dch_frameWidth]) forKey:key_DCHImageTurbo_UIImage_ResizeWidth];
        [result dch_safe_setObject:@([self dch_frameHeight]) forKey:key_DCHImageTurbo_UIImage_ResizeHeight];
        [result dch_safe_setObject:@([self dch_screenScale]) forKey:key_DCHImageTurbo_UIImage_ResizeScale];
        [result dch_safe_setObject:@(cornerRadius) forKey:key_DCHImageTurbo_UIImage_CornerRadius];
        return result;
    } completed:completion];
}

- (void)dch_setImageWithContentsOfFile:(NSString *)path placeholderImage:(UIImage *)placeholder forState:(UIControlState)state borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor completed:(DCHImageTurboLoadImageCompletionBlock)completion {
    @weakify(self)
    [self dch_setImageWithContentsOfFile:path placeholderImage:placeholder forState:state customize:^NSDictionary *{
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

- (void)dch_setImageWithContentsOfFile:(NSString *)path placeholderImage:(UIImage *)placeholder forState:(UIControlState)state applyBlurWithRadius:(CGFloat)radius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage completed:(DCHImageTurboLoadImageCompletionBlock)completion {
    @weakify(self)
    [self dch_setImageWithContentsOfFile:path placeholderImage:placeholder forState:state customize:^NSDictionary *{
        @strongify(self)
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        [result dch_safe_setObject:@([self dch_frameWidth]) forKey:key_DCHImageTurbo_UIImage_ResizeWidth];
        [result dch_safe_setObject:@([self dch_frameHeight]) forKey:key_DCHImageTurbo_UIImage_ResizeHeight];
        [result dch_safe_setObject:@([self dch_screenScale]) forKey:key_DCHImageTurbo_UIImage_ResizeScale];
        [result dch_safe_setObject:@(radius) forKey:key_DCHImageTurbo_UIImage_BlurRadius];
        [result dch_safe_setObject:tintColor forKey:key_DCHImageTurbo_UIImage_BlurTintColor];
        [result dch_safe_setObject:@(saturationDeltaFactor) forKey:key_DCHImageTurbo_UIImage_BlurSaturationDeltaFactor];
        [result dch_safe_setObject:maskImage forKey:key_DCHImageTurbo_UIImage_BlurMaskImage];
        return result;
    } completed:completion];
}

- (void)dch_setImageWithContentsOfFile:(NSString *)path placeholderImage:(UIImage *)placeholder forState:(UIControlState)state customize:(DCHImageTurboCustomizeBlock)customization completed:(DCHImageTurboLoadImageCompletionBlock)completion {
    @weakify(self)
    do {
        if (DCH_IsEmpty(path)) {
            break;
        }
        
        [self dch_cancelLocalImageLoadOperationForState:state];
        
        [self dch_setLocalImageURL:path forState:state];
        
        if (placeholder) {
            [NSThread dch_runInMain:^{
                @strongify(self)
                [self setImage:placeholder forState:state];
                [self setNeedsLayout];
            }];
        }
        
        [self dch_loadImageWithContentsOfFile:path placeholderImage:placeholder customize:customization uiRender:^(UIImage *image, NSError *error, NSString *imagePath, NSURL *imageURL) {
            @strongify(self)
            [self setImage:image forState:state];
            [self setNeedsLayout];
        } operationHandler:^(id<SDWebImageOperation> operation, NSString *imagePath, NSURL *imageURL) {
            @strongify(self)
            [self dch_setLocalImageLoadOperation:operation forState:state];
        } completed:completion];
    } while (NO);
}

#pragma mark - Local background image
- (NSMutableDictionary *)dch_localBackgroundImagePathStorage {
    NSMutableDictionary *storage = [[self getImageLocationStorage] dch_safe_objectForKey:key_DCHImageTurbo_UIButton_LocalBackgroundImagePathStorage];
    if (!storage) {
        storage = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, &key_DCHImageTurbo_UIButton_LocalBackgroundImagePathStorage, storage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return storage;
}

- (NSString *)dch_currentLocalBackgroundImagePath {
    NSString *path = [self dch_localBackgroundImagePathStorage][@(self.state)];
    
    if (!path) {
        path = [self dch_localBackgroundImagePathStorage][@(UIControlStateNormal)];
    }
    
    return path;
}

- (NSString *)dch_localBackgroundImagePathForState:(UIControlState)state {
    return [self dch_localBackgroundImagePathStorage][@(state)];
}

- (void)dch_setLocalBackgroundImageURL:(NSString *)path forState:(UIControlState)state {
    do {
        if (DCH_IsEmpty(path)) {
            break;
        }
        NSMutableDictionary *storage = [self dch_localBackgroundImagePathStorage];
        if (DCH_IsEmpty(storage)) {
            break;
        }
        [storage dch_safe_setObject:path forKey:@(state)];
    } while (NO);
}

- (void)dch_setLocalBackgroundImageLoadOperation:(id <SDWebImageOperation>)operation forState:(UIControlState)state {
    do {
        if (DCH_IsEmpty(operation)) {
            break;
        }
        [self sd_setImageLoadOperation:operation forKey:[self dch_createKeyForButtonLoadImageWithPrefix:key_DCHImageTurbo_UIButton_LocalBackgroundImageLoadOperation andState:state]];
    } while (NO);
}

- (void)dch_cancelLocalBackgroundImageLoadOperationForState:(UIControlState)state {
    [self sd_cancelImageLoadOperationWithKey:[self dch_createKeyForButtonLoadImageWithPrefix:key_DCHImageTurbo_UIButton_LocalBackgroundImageLoadOperation andState:state]];
}

- (void)dch_setBackgroundImageWithContentsOfFile:(NSString *)path placeholderImage:(UIImage *)placeholder forState:(UIControlState)state completed:(DCHImageTurboLoadImageCompletionBlock)completion {
    [self dch_setBackgroundImageWithContentsOfFile:path placeholderImage:placeholder forState:state resize:self.frame.size scale:[self dch_screenScale] completed:completion];
}

- (void)dch_setBackgroundImageWithContentsOfFile:(NSString *)path placeholderImage:(UIImage *)placeholder forState:(UIControlState)state resize:(CGSize)newSize scale:(CGFloat)scale completed:(DCHImageTurboLoadImageCompletionBlock)completion {
    [self dch_setBackgroundImageWithContentsOfFile:path placeholderImage:placeholder forState:state customize:^NSDictionary *{
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        [result dch_safe_setObject:@(newSize.width) forKey:key_DCHImageTurbo_UIImage_ResizeWidth];
        [result dch_safe_setObject:@(newSize.height) forKey:key_DCHImageTurbo_UIImage_ResizeHeight];
        [result dch_safe_setObject:@(scale) forKey:key_DCHImageTurbo_UIImage_ResizeScale];
        return result;
    } completed:completion];
}

- (void)dch_setBackgroundImageWithContentsOfFile:(NSString *)path placeholderImage:(UIImage *)placeholder forState:(UIControlState)state cornerRadius:(CGFloat)cornerRadius completed:(DCHImageTurboLoadImageCompletionBlock)completion {
    @weakify(self)
    [self dch_setBackgroundImageWithContentsOfFile:path placeholderImage:placeholder forState:state customize:^NSDictionary *{
        @strongify(self)
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        [result dch_safe_setObject:@([self dch_frameWidth]) forKey:key_DCHImageTurbo_UIImage_ResizeWidth];
        [result dch_safe_setObject:@([self dch_frameHeight]) forKey:key_DCHImageTurbo_UIImage_ResizeHeight];
        [result dch_safe_setObject:@([self dch_screenScale]) forKey:key_DCHImageTurbo_UIImage_ResizeScale];
        [result dch_safe_setObject:@(cornerRadius) forKey:key_DCHImageTurbo_UIImage_CornerRadius];
        return result;
    } completed:completion];
}

- (void)dch_setBackgroundImageWithContentsOfFile:(NSString *)path placeholderImage:(UIImage *)placeholder forState:(UIControlState)state borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor completed:(DCHImageTurboLoadImageCompletionBlock)completion {
    @weakify(self)
    [self dch_setBackgroundImageWithContentsOfFile:path placeholderImage:placeholder forState:state customize:^NSDictionary *{
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

- (void)dch_setBackgroundImageWithContentsOfFile:(NSString *)path placeholderImage:(UIImage *)placeholder forState:(UIControlState)state applyBlurWithRadius:(CGFloat)radius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage completed:(DCHImageTurboLoadImageCompletionBlock)completion {
    @weakify(self)
    [self dch_setBackgroundImageWithContentsOfFile:path placeholderImage:placeholder forState:state customize:^NSDictionary *{
        @strongify(self)
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        [result dch_safe_setObject:@([self dch_frameWidth]) forKey:key_DCHImageTurbo_UIImage_ResizeWidth];
        [result dch_safe_setObject:@([self dch_frameHeight]) forKey:key_DCHImageTurbo_UIImage_ResizeHeight];
        [result dch_safe_setObject:@([self dch_screenScale]) forKey:key_DCHImageTurbo_UIImage_ResizeScale];
        [result dch_safe_setObject:@(radius) forKey:key_DCHImageTurbo_UIImage_BlurRadius];
        [result dch_safe_setObject:tintColor forKey:key_DCHImageTurbo_UIImage_BlurTintColor];
        [result dch_safe_setObject:@(saturationDeltaFactor) forKey:key_DCHImageTurbo_UIImage_BlurSaturationDeltaFactor];
        [result dch_safe_setObject:maskImage forKey:key_DCHImageTurbo_UIImage_BlurMaskImage];
        return result;
    } completed:completion];
}

- (void)dch_setBackgroundImageWithContentsOfFile:(NSString *)path placeholderImage:(UIImage *)placeholder forState:(UIControlState)state customize:(DCHImageTurboCustomizeBlock)customization completed:(DCHImageTurboLoadImageCompletionBlock)completion {
    @weakify(self)
    do {
        if (DCH_IsEmpty(path)) {
            break;
        }
        
        [self dch_cancelLocalBackgroundImageLoadOperationForState:state];
        
        [self dch_setLocalBackgroundImageURL:path forState:state];
        
        if (placeholder) {
            [NSThread dch_runInMain:^{
                @strongify(self)
                [self setBackgroundImage:placeholder forState:state];
                [self setNeedsLayout];
            }];
        }
        
        [self dch_loadImageWithContentsOfFile:path placeholderImage:placeholder customize:customization uiRender:^(UIImage *image, NSError *error, NSString *imagePath, NSURL *imageURL) {
            @strongify(self)
            [self setBackgroundImage:image forState:state];
            [self setNeedsLayout];
        } operationHandler:^(id<SDWebImageOperation> operation, NSString *imagePath, NSURL *imageURL) {
            @strongify(self)
            [self dch_setLocalBackgroundImageLoadOperation:operation forState:state];
        } completed:completion];
    } while (NO);
}

@end
