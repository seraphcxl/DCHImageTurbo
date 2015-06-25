//
//  UIImageView+DCHImageTurbo.m
//  DCHImageTurbo
//
//  Created by Derek Chen on 6/25/15.
//  Copyright (c) 2015 CHEN. All rights reserved.
//

#import "UIImageView+DCHImageTurbo.h"
#import <Tourbillon/DCHTourbillon.h>
#import <SDWebImage/UIView+WebCacheOperation.h>
#import <libextobjc/EXTScope.h>
#import "DCHImageProcessor.h"
#import "DCHImageTurboCommonConstants.h"

static char kDCHImageTurboImageURLKey;
static char kDCHImageTurboHighlightedImageURLKey;

@implementation UIImageView (DCHImageTurbo)

- (NSString *)dch_imageSignatureWithSize:(CGSize)size andScale:(CGFloat)scale {
    return [NSString stringWithFormat:@"W%fH%fS%f", size.width, size.height, scale];
}

- (NSURL *)dch_imageURL {
    return objc_getAssociatedObject(self, &kDCHImageTurboImageURLKey);
}

- (void)dch_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder size:(CGSize)imageSize completed:(SDWebImageCompletionBlock)completedBlock {
    return [self dch_setImageWithURL:url placeholderImage:placeholder size:imageSize allowZoomOut:YES options:0 progress:nil completed:completedBlock];
}

- (void)dch_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder size:(CGSize)imageSize allowZoomOut:(BOOL)allowZoomOut options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock {
    do {
        [self sd_cancelCurrentImageLoad];
        objc_setAssociatedObject(self, &kDCHImageTurboImageURLKey, url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        if (!(options & SDWebImageDelayPlaceholder)) {
            [NSThread dch_runInMain:^{
                self.image = placeholder;
            }];
        }
        
        if (url) {
            NSString *resizedImageKey = [NSString stringWithFormat:@"%@_%@", url, [self dch_imageSignatureWithSize:imageSize andScale:[UIScreen mainScreen].scale]];
            
            @weakify(self)
            
            // Find from memory cache
            __block UIImage *resizedImage = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:resizedImageKey];
            if (!DCH_IsEmpty(resizedImage)) {
                [NSThread dch_runInMain:^{
                    @strongify(self)
                    self.image = resizedImage;
                    [self setNeedsLayout];
                    if (completedBlock) {
                        completedBlock(resizedImage, nil, SDImageCacheTypeMemory, url);
                    }
                }];
            } else {
                [NSThread dch_runInBackground:^{
                    @strongify(self)
                    do {
                        if (![[self dch_imageURL] isEqual:url]) {
                            [NSThread dch_runInMain:^{
                                NSError *error = [NSError errorWithDomain:DCHImageTurboErrorDomain code:(-1001) userInfo:@{NSLocalizedDescriptionKey : @"![[self dch_imageURL] isEqual:url]"}];
                                if (completedBlock) {
                                    completedBlock(nil, error, SDImageCacheTypeNone, url);
                                }
                            }];
                            break;
                        }
                        
                        // Find from disk cache
                        resizedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:resizedImageKey];
                        if (!DCH_IsEmpty(resizedImage)) {
                            [NSThread dch_runInMain:^{
                                @strongify(self)
                                self.image = resizedImage;
                                [self setNeedsLayout];
                                if (completedBlock) {
                                    completedBlock(resizedImage, nil, SDImageCacheTypeDisk, url);
                                }
                            }];
                        } else {
                            [self sd_cancelCurrentImageLoad];
                            
                            id <SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadImageWithURL:url options:options progress:progressBlock completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                @strongify(self)
                                do {
                                    if (DCH_IsEmpty(image)) {
                                        if ((options & SDWebImageDelayPlaceholder)) {
                                            [NSThread dch_runInMain:^{
                                                @strongify(self)
                                                self.image = placeholder;
                                                [self setNeedsLayout];
                                                if (completedBlock && finished) {
                                                    completedBlock(image, error, cacheType, url);
                                                }
                                            }];
                                        }
                                    } else {
                                        [NSThread dch_runInBackground:^{
                                            resizedImage = [DCHImageProcessor applyResize:image toSize:imageSize withContentMode:self.contentMode allowZoomOut:allowZoomOut];
                                            if (resizedImage) {
                                                BOOL cacheOnDisk = !(options & SDWebImageCacheMemoryOnly);
                                                
                                                if (resizedImage && finished) {
                                                    [[SDImageCache sharedImageCache] storeImage:resizedImage recalculateFromImage:NO imageData:nil forKey:resizedImageKey toDisk:cacheOnDisk];
                                                }
                                                
                                                [NSThread dch_runInMain:^{
                                                    @strongify(self)
                                                    self.image = resizedImage;
                                                    [self setNeedsLayout];
                                                    if (completedBlock && finished) {
                                                        completedBlock(resizedImage, error, cacheType, url);
                                                    }
                                                }];
                                            }
                                        }];
                                    }
                                } while (NO);
                            }];
                            [self sd_setImageLoadOperation:operation forKey:@"UIImageViewImageLoad"];
                        }
                    } while (NO);
                }];
            }
        } else {
            [NSThread dch_runInMain:^{
                NSError *error = [NSError errorWithDomain:@"SDWebImageErrorDomain" code:(-1) userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil url"}];
                if (completedBlock) {
                    completedBlock(nil, error, SDImageCacheTypeNone, url);
                }
            }];
        }
    } while (NO);
}

- (void)dch_cancelCurrentImageLoad {
    [self sd_cancelCurrentImageLoad];
}

- (NSURL *)dch_highlightedImageURL {
    return objc_getAssociatedObject(self, &kDCHImageTurboHighlightedImageURLKey);
}

- (void)dch_setHighlightedImageWithURL:(NSURL *)url size:(CGSize)imageSize completed:(SDWebImageCompletionBlock)completedBlock {
    return [self dch_setHighlightedImageWithURL:url size:imageSize allowZoomOut:YES options:0 progress:nil completed:completedBlock];
}

- (void)dch_setHighlightedImageWithURL:(NSURL *)url size:(CGSize)imageSize allowZoomOut:(BOOL)allowZoomOut options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock {
    do {
        [self sd_cancelCurrentHighlightedImageLoad];
        objc_setAssociatedObject(self, &kDCHImageTurboHighlightedImageURLKey, url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        if (url) {
            @weakify(self)
            id<SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadImageWithURL:url options:options progress:progressBlock completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                @strongify(self)
                do {
                    ;
                } while (NO);
            }];
            [self sd_setImageLoadOperation:operation forKey:@"highlightedImage"];
        } else {
            [NSThread dch_runInMain:^{
                NSError *error = [NSError errorWithDomain:@"SDWebImageErrorDomain" code:-1 userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil url"}];
                if (completedBlock) {
                    completedBlock(nil, error, SDImageCacheTypeNone, url);
                }
            }];
        }
    } while (NO);
}

- (void)dch_cancelCurrentHighlightedImageLoad {
}

@end
