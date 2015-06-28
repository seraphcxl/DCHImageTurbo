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
#import "UIImage+DCHImageTurbo.h"
#import "DCHImageTurboCommonConstants.h"
#import <sys/mman.h>
#import "DCHLoadLocalImageOperation.h"

static char kDCHImageTurboImageURLKey;
static char kDCHImageTurboImagePathKey;
static char kDCHImageTurboHighlightedImageURLKey;
static char kDCHImageTurboHighlightedImagePathKey;

@implementation UIImageView (DCHImageTurbo)

- (void)dch_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder customize:(DCHImageTurboCustomizeBlock)customizeBlock options:(SDWebImageOptions)options uiAction:(DCHImageTurboUIActionBlock)uiActionBlock progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(DCHImageTurboLoadImageCompletionBlock)completedBlock {
    do {
        [self sd_cancelCurrentImageLoad];
        objc_setAssociatedObject(self, &kDCHImageTurboImageURLKey, url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        if (!(options & SDWebImageDelayPlaceholder) && placeholder) {
            [NSThread dch_runInMain:^{
                self.image = placeholder;
            }];
        }
        
        if (!DCH_IsEmpty(url)) {
            NSString *customizedImageKey = nil;
            NSDictionary *customizeParamsDic = nil;
            if (customizeBlock) {
                customizeParamsDic = customizeBlock();
            }
            customizedImageKey = [NSString stringWithFormat:@"%@_%@", url, [self dch_imageSignature:customizeParamsDic]];
            @weakify(self)
            [self dch_loadImageFormCacheForKey:customizedImageKey fromDisk:YES completed:^(UIImage *image, NSError *error, NSString *key, SDImageCacheType cacheType) {
                do {
                    if (error && !DCH_IsEmpty(key)) {
                        [NSThread dch_runInMain:^{
                            if (completedBlock) {
                                completedBlock(nil, error, nil, url, SDImageCacheTypeNone);
                            }
                        }];
                        break;
                    }
                    
                    if (!DCH_IsEmpty(image)) {  // use cached image
                        [NSThread dch_runInMain:^{
                            if (uiActionBlock) {
                                uiActionBlock(image, error, nil, url);
                            }
                            if (completedBlock) {
                                completedBlock(image, error, nil, url, cacheType);
                            }
                        }];
                        break;
                    }
                    
                    [self sd_cancelCurrentImageLoad];
                    
                    id <SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadImageWithURL:url options:options progress:progressBlock completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                        @strongify(self)
                        do {
                            if (DCH_IsEmpty(image)) {
                                if ((options & SDWebImageDelayPlaceholder) && placeholder) {
                                    [NSThread dch_runInMain:^{
                                        if (uiActionBlock) {
                                            uiActionBlock(placeholder, error, nil, url);
                                        }
                                        if (completedBlock && finished) {
                                            completedBlock(image, error, nil, url, cacheType);
                                        }
                                    }];
                                }
                            } else {
                                if (DCH_IsEmpty(customizeParamsDic)) {  // use origin image
                                    [NSThread dch_runInMain:^{
                                        if (uiActionBlock) {
                                            uiActionBlock(image, error, nil, url);
                                        }
                                        if (completedBlock && finished) {
                                            completedBlock(image, error, nil, url, cacheType);
                                        }
                                    }];
                                } else {  // use customized image
                                    UIImage *customizedImage = [UIImage customizeImage:image withParams:customizeParamsDic contentMode:self.contentMode];
                                    if (customizedImage) {
                                        BOOL cacheOnDisk = !(options & SDWebImageCacheMemoryOnly);
                                        
                                        if (customizedImage && finished) {
                                            [[SDImageCache sharedImageCache] storeImage:customizedImage recalculateFromImage:NO imageData:nil forKey:customizedImageKey toDisk:cacheOnDisk];
                                        }
                                        
                                        [NSThread dch_runInMain:^{
                                            if (uiActionBlock) {
                                                uiActionBlock(customizedImage, error, nil, url);
                                            }
                                            if (completedBlock && finished) {
                                                completedBlock(customizedImage, error, nil, url, cacheType);
                                            }
                                        }];
                                    }
                                }
                            }
                        } while (NO);
                    }];
                    [self sd_setImageLoadOperation:operation forKey:@"UIImageViewImageLoad"];
                } while (NO);
            }];
        } else {
            [NSThread dch_runInMain:^{
                NSError *error = [NSError errorWithDomain:@"SDWebImageErrorDomain" code:(-1) userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil url"}];
                if (completedBlock) {
                    completedBlock(nil, error, nil, url, SDImageCacheTypeNone);
                }
            }];
        }
    } while (NO);
}

- (void)dch_setImageWithContentsOfFile:(NSString *)path placeholderImage:(UIImage *)placeholder customize:(DCHImageTurboCustomizeBlock)customizeBlock uiAction:(DCHImageTurboUIActionBlock)uiActionBlock completed:(DCHImageTurboLoadImageCompletionBlock)completedBlock {
    do {
        [self sd_cancelCurrentImageLoad];
        objc_setAssociatedObject(self, &kDCHImageTurboImagePathKey, path, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        if (placeholder) {
            [NSThread dch_runInMain:^{
                self.image = placeholder;
            }];
        }
        
        if (!DCH_IsEmpty(path)) {
            NSString *customizedImageKey = nil;
            NSDictionary *customizeParamsDic = nil;
            if (customizeBlock) {
                customizeParamsDic = customizeBlock();
            }
            customizedImageKey = [NSString stringWithFormat:@"%@_%@", path, [self dch_imageSignature:customizeParamsDic]];
            @weakify(self)
            [self dch_loadImageFormCacheForKey:customizedImageKey fromDisk:NO completed:^(UIImage *image, NSError *error, NSString *key, SDImageCacheType cacheType) {
                do {
                    if (error && !DCH_IsEmpty(key)) {
                        [NSThread dch_runInMain:^{
                            if (completedBlock) {
                                completedBlock(nil, error, path, nil, SDImageCacheTypeNone);
                            }
                        }];
                        break;
                    }
                    
                    if (!DCH_IsEmpty(image)) {  // use cached image
                        [NSThread dch_runInMain:^{
                            if (uiActionBlock) {
                                uiActionBlock(image, error, path, nil);
                            }
                            if (completedBlock) {
                                completedBlock(image, error, path, nil, cacheType);
                            }
                        }];
                        break;
                    }
                    
                    [self sd_cancelCurrentImageLoad];
                    
                    DCHLoadLocalImageOperation *operation = [[DCHLoadLocalImageOperation alloc] init];
                    operation.actionBlock = ^(DCHLoadLocalImageOperation *operation) {
                        @strongify(self)
                        int fileDescriptor = -1;
                        off_t fileLength = 0;
                        void *bytes = NULL;
                        do {
                            if (DCH_IsEmpty(path) || DCH_IsEmpty(operation)) {
                                break;
                            }
                            
                            if (operation.isCanceled) {
                                break;
                            }
                            
                            fileDescriptor = open([path fileSystemRepresentation], (O_RDWR | O_CREAT), 0666);
                            if (fileDescriptor < 0) {
                                break;
                            }
                            fileLength = lseek(fileDescriptor, 0, SEEK_END);
                            bytes = mmap(NULL, (size_t)fileLength, (PROT_READ|PROT_WRITE), (MAP_FILE|MAP_SHARED), fileDescriptor, 0);
                            
                            if (operation.isCanceled) {
                                break;
                            }
                            
                            NSData *data = [NSData dataWithBytes:bytes length:(NSUInteger)fileLength];
                            UIImage *image = [UIImage imageWithData:data];
                            if (DCH_IsEmpty(image)) {
                                [NSThread dch_runInMain:^{
                                    if (placeholder) {
                                        if (uiActionBlock) {
                                            uiActionBlock(placeholder, error, path, nil);
                                        }
                                    }
                                    if (completedBlock) {
                                        completedBlock(image, error, path, nil, SDImageCacheTypeNone);
                                    }
                                }];
                                break;
                            }
                            
                            if (operation.isCanceled) {
                                break;
                            }
                            
                            UIImage *decompressedImage = [UIImage decodedImageWithImage:image];
                            
                            if (DCH_IsEmpty(decompressedImage)) {
                                [NSThread dch_runInMain:^{
                                    NSError *error = [NSError errorWithDomain:DCHImageTurboErrorDomain code:(-1004) userInfo:@{NSLocalizedDescriptionKey : @"DCH_IsEmpty(decompressedImage)"}];
                                    if (completedBlock) {
                                        completedBlock(decompressedImage, error, path, nil, SDImageCacheTypeNone);
                                    }
                                }];
                                break;
                            }
                            
                            [[SDImageCache sharedImageCache] storeImage:decompressedImage recalculateFromImage:NO imageData:nil forKey:customizedImageKey toDisk:NO];
                            
                            if (operation.isCanceled) {
                                break;
                            }
                            
                            if (DCH_IsEmpty(customizeParamsDic)) {  // use origin image
                                [NSThread dch_runInMain:^{
                                    if (uiActionBlock) {
                                        uiActionBlock(decompressedImage, error, path, nil);
                                    }
                                    if (completedBlock) {
                                        completedBlock(decompressedImage, error, path, nil, SDImageCacheTypeDisk);
                                    }
                                }];
                            } else {  // use customized image
                                UIImage *customizedImage = [UIImage customizeImage:decompressedImage withParams:customizeParamsDic contentMode:self.contentMode];
                                if (customizedImage) {
                                    if (customizedImage) {
                                        [[SDImageCache sharedImageCache] storeImage:customizedImage recalculateFromImage:NO imageData:nil forKey:customizedImageKey toDisk:NO];
                                    }
                                    
                                    [NSThread dch_runInMain:^{
                                        if (uiActionBlock) {
                                            uiActionBlock(customizedImage, error, path, nil);
                                        }
                                        if (completedBlock) {
                                            completedBlock(customizedImage, error, path, nil, cacheType);
                                        }
                                    }];
                                }
                            }
                        } while (NO);
                        if (bytes != NULL) {
                            munmap(bytes, (size_t)fileLength);
                            bytes = NULL;
                        }
                        if (fileDescriptor >= 0) {
                            close(fileDescriptor);
                            fileDescriptor = -1;
                        }
                    };
                    [self sd_setImageLoadOperation:operation forKey:@"UIImageViewImageLoad"];
                    [NSThread dch_runInBackground:^{
                        [operation execute];
                    }];
                } while (NO);
            }];
        } else {
            [NSThread dch_runInMain:^{
                NSError *error = [NSError errorWithDomain:DCHImageTurboErrorDomain code:(-1003) userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil path"}];
                if (completedBlock) {
                    completedBlock(nil, error, path, nil, SDImageCacheTypeNone);
                }
            }];
        }
    } while (NO);
}

#pragma mark - image
- (void)dch_cancelCurrentImageLoad {
    [self sd_cancelCurrentImageLoad];
}

- (NSURL *)dch_imageURL {
    return objc_getAssociatedObject(self, &kDCHImageTurboImageURLKey);
}

- (void)dch_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder size:(CGSize)imageSize completed:(DCHImageTurboLoadImageCompletionBlock)completedBlock {
    return [self dch_setImageWithURL:url placeholderImage:placeholder size:imageSize options:0 progress:nil completed:completedBlock];
}

- (void)dch_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder size:(CGSize)imageSize options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(DCHImageTurboLoadImageCompletionBlock)completedBlock {
    @weakify(self)
    [self dch_setImageWithURL:url placeholderImage:placeholder customize:^NSDictionary *{
        return @{DCHImageTurboKey_ResizeWidth: @(imageSize.width), DCHImageTurboKey_ResizeHeight: @(imageSize.height), DCHImageTurboKey_ResizeScale: @([UIScreen mainScreen].scale)};
    } options:options uiAction:^(UIImage *image, NSError *error, NSString *imagePath, NSURL *imageURL) {
        @strongify(self)
        self.image = image;
        [self setNeedsLayout];
    } progress:progressBlock completed:completedBlock];
}

- (NSURL *)dch_imagePath {
    return objc_getAssociatedObject(self, &kDCHImageTurboImagePathKey);
}

- (void)dch_setImageWithContentsOfFile:(NSString *)path placeholderImage:(UIImage *)placeholder size:(CGSize)imageSize completed:(DCHImageTurboLoadImageCompletionBlock)completedBlock {
    @weakify(self)
    [self dch_setImageWithContentsOfFile:path placeholderImage:placeholder customize:^NSDictionary *{
        return @{DCHImageTurboKey_ResizeWidth: @(imageSize.width), DCHImageTurboKey_ResizeHeight: @(imageSize.height), DCHImageTurboKey_ResizeScale: @([UIScreen mainScreen].scale)};
    } uiAction:^(UIImage *image, NSError *error, NSString *imagePath, NSURL *imageURL) {
        @strongify(self)
        self.image = image;
        [self setNeedsLayout];
    } completed:completedBlock];
}

#pragma mark - highlighted image
- (void)dch_cancelCurrentHighlightedImageLoad {
    [self sd_cancelCurrentHighlightedImageLoad];
}

- (NSURL *)dch_highlightedImageURL {
    return objc_getAssociatedObject(self, &kDCHImageTurboHighlightedImageURLKey);
}

- (void)dch_setHighlightedImageWithURL:(NSURL *)url size:(CGSize)imageSize completed:(DCHImageTurboLoadImageCompletionBlock)completedBlock {
    return [self dch_setHighlightedImageWithURL:url size:imageSize options:0 progress:nil completed:completedBlock];
}

- (void)dch_setHighlightedImageWithURL:(NSURL *)url size:(CGSize)imageSize options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(DCHImageTurboLoadImageCompletionBlock)completedBlock {
    @weakify(self)
    [self dch_setImageWithURL:url placeholderImage:nil customize:^NSDictionary *{
        return @{DCHImageTurboKey_ResizeWidth: @(imageSize.width), DCHImageTurboKey_ResizeHeight: @(imageSize.height), DCHImageTurboKey_ResizeScale: @([UIScreen mainScreen].scale)};
    } options:options uiAction:^(UIImage *image, NSError *error, NSString *imagePath, NSURL *imageURL) {
        @strongify(self)
        self.highlightedImage = image;
        [self setNeedsLayout];
    } progress:progressBlock completed:completedBlock];
}

- (NSURL *)dch_HighlightedImagePath {
    return objc_getAssociatedObject(self, &kDCHImageTurboHighlightedImagePathKey);
}

- (void)dch_setHighlightedImageWithContentsOfFile:(NSString *)path placeholderImage:(UIImage *)placeholder size:(CGSize)imageSize completed:(DCHImageTurboLoadImageCompletionBlock)completedBlock {
    @weakify(self)
    [self dch_setImageWithContentsOfFile:path placeholderImage:placeholder customize:^NSDictionary *{
        return @{DCHImageTurboKey_ResizeWidth: @(imageSize.width), DCHImageTurboKey_ResizeHeight: @(imageSize.height), DCHImageTurboKey_ResizeScale: @([UIScreen mainScreen].scale)};
    } uiAction:^(UIImage *image, NSError *error, NSString *imagePath, NSURL *imageURL) {
        @strongify(self)
        self.highlightedImage = image;
        [self setNeedsLayout];
    } completed:completedBlock];
}

@end
