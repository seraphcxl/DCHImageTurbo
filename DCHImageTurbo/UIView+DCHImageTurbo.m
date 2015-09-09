//
//  UIView+DCHImageTurbo.m
//  DCHImageTurbo
//
//  Created by Derek Chen on 6/26/15.
//  Copyright © 2015 CHEN. All rights reserved.
//

#import "UIView+DCHImageTurbo.h"
#import <Tourbillon/DCHTourbillon.h>
#import "UIImage+DCHImageEffect.h"
#import "UIImage+DCHImageTurbo.h"
#import "DCHImageTurboCommonConstants.h"
#import <libextobjc/EXTScope.h>
#import <sys/mman.h>
#import "DCHLoadLocalImageOperation.h"
#import "DCHFileMappingImage.h"

NSString * const key_DCHImageTurbo_UIView_ImageLocationStorage = @"key_DCHImageTurbo_UIView_ImageLocationStorage";

@implementation UIView (DCHImageTurbo)

- (NSMutableDictionary *)getImageLocationStorage {
    NSMutableDictionary *result = objc_getAssociatedObject(self, (__bridge const void *)(key_DCHImageTurbo_UIView_ImageLocationStorage));
    if (!result) {
        result = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, (__bridge const void *)(key_DCHImageTurbo_UIView_ImageLocationStorage), result, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return result;
}

- (CGFloat)dch_frameWidth {
    return self.frame.size.width;
}

- (CGFloat)dch_frameHeight {
    return self.frame.size.height;
}

- (CGFloat)dch_screenScale {
    return [UIScreen mainScreen].scale;
}

- (void)dch_loadImageFormCacheForKey:(NSString *)key fromDisk:(BOOL)fromDisk completed:(DCHImageTurboLoadImageFromCacheCompletionBlock)completion {
    __block UIImage *loadedImage = nil;
    NSError *error = nil;
    __block SDImageCacheType cacheType = SDImageCacheTypeNone;
    do {
        if (DCH_IsEmpty(key)) {
            error = [NSError errorWithDomain:DCHImageTurboErrorDomain code:(-1002) userInfo:@{NSLocalizedDescriptionKey : @"DCH_IsEmpty(key)"}];
            if (completion) {
                completion(loadedImage, error, key, cacheType);
            }
            break;
        }
        loadedImage = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:key];
        if (loadedImage) {
            cacheType = SDImageCacheTypeMemory;
            if (completion) {
                completion(loadedImage, error, key, cacheType);
            }
        } else {
            if (fromDisk) {
                [NSThread dch_runInBackground:^{
                    do {
                        loadedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:key];
                        if (loadedImage) {
                            cacheType = SDImageCacheTypeDisk;
                        }
                        if (completion) {
                            completion(loadedImage, error, key, cacheType);
                        }
                    } while (NO);
                }];
            } else {
                if (completion) {
                    completion(loadedImage, error, key, cacheType);
                }
            }
        }
    } while (NO);
}

- (void)dch_loadImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options customize:(DCHImageTurboCustomizeBlock)customization uiRender:(DCHImageTurboUIRenderBlock)uiRender operationHandler:(DCHImageTurboOperationHandlerBlock)operationHandler progress:(SDWebImageDownloaderProgressBlock)progress completed:(DCHImageTurboLoadImageCompletionBlock)completion {
    do {
        if (!DCH_IsEmpty(url)) {
            NSString *customizedImageKey = nil;
            NSDictionary *customizeParamsDic = nil;
            if (customization) {
                customizeParamsDic = customization();
            }
            customizedImageKey = [NSString stringWithFormat:@"%@_%@", url, [UIImage dch_imageSignature:customizeParamsDic]];
            @weakify(self)
            [self dch_loadImageFormCacheForKey:customizedImageKey fromDisk:YES completed:^(UIImage *image, NSError *error, NSString *key, SDImageCacheType cacheType) {
                do {
                    if (error && !DCH_IsEmpty(key)) {
                        [NSThread dch_runInMain:^{
                            if (completion) {
                                completion(nil, error, nil, url, SDImageCacheTypeNone);
                            }
                        }];
                        break;
                    }
                    
                    if (!DCH_IsEmpty(image)) {  // use cached image
                        [NSThread dch_runInMain:^{
                            if (uiRender) {
                                uiRender(image, error, nil, url);
                            }
                            if (completion) {
                                completion(image, error, nil, url, cacheType);
                            }
                        }];
                        break;
                    }
                    
                    id <SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadImageWithURL:url options:options progress:progress completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                        @strongify(self)
                        do {
                            if (DCH_IsEmpty(image)) {
                                if ((options & SDWebImageDelayPlaceholder) && placeholder) {
                                    if (uiRender) {
                                        uiRender(placeholder, error, nil, url);
                                    }
                                    if (completion && finished) {
                                        completion(image, error, nil, url, cacheType);
                                    }
                                }
                            } else {
                                if (DCH_IsEmpty(customizeParamsDic)) {  // use origin image
                                    if (uiRender) {
                                        uiRender(image, error, nil, url);
                                    }
                                    if (completion && finished) {
                                        completion(image, error, nil, url, cacheType);
                                    }
                                } else {  // use customized image
                                    [NSThread dch_runInBackground:^{
                                        UIImage *customizedImage = [UIImage dch_customizeImage:image withParams:customizeParamsDic contentMode:self.contentMode];
                                        if (customizedImage) {
                                            BOOL cacheOnDisk = !(options & SDWebImageCacheMemoryOnly);
                                            
                                            if (customizedImage && finished) {
                                                [[SDImageCache sharedImageCache] storeImage:customizedImage recalculateFromImage:NO imageData:nil forKey:customizedImageKey toDisk:cacheOnDisk];
                                            }
                                            
                                            [NSThread dch_runInMain:^{
                                                if (uiRender) {
                                                    uiRender(customizedImage, error, nil, url);
                                                }
                                                if (completion && finished) {
                                                    completion(customizedImage, error, nil, url, cacheType);
                                                }
                                            }];
                                        }
                                    }];
                                }
                            }
                        } while (NO);
                    }];
                    if (operationHandler) {
                        operationHandler(operation, nil, url);
                    }
                } while (NO);
            }];
        } else {
            [NSThread dch_runInMain:^{
                NSError *error = [NSError errorWithDomain:@"SDWebImageErrorDomain" code:(-1) userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil url"}];
                if (completion) {
                    completion(nil, error, nil, url, SDImageCacheTypeNone);
                }
            }];
        }
    } while (NO);
}

- (void)dch_loadImageWithContentsOfFile:(NSString *)path placeholderImage:(UIImage *)placeholder customize:(DCHImageTurboCustomizeBlock)customization uiRender:(DCHImageTurboUIRenderBlock)uiRender operationHandler:(DCHImageTurboOperationHandlerBlock)operationHandler completed:(DCHImageTurboLoadImageCompletionBlock)completion {
    do {
        if (!DCH_IsEmpty(path)) {
            NSString *customizedImageKey = nil;
            NSDictionary *customizeParamsDic = nil;
            if (customization) {
                customizeParamsDic = customization();
            }
            customizedImageKey = [NSString stringWithFormat:@"%@_%@", path, [UIImage dch_imageSignature:customizeParamsDic]];
            @weakify(self)
            [self dch_loadImageFormCacheForKey:customizedImageKey fromDisk:YES completed:^(UIImage *image, NSError *error, NSString *key, SDImageCacheType cacheType) {
                do {
                    if (error && !DCH_IsEmpty(key)) {
                        [NSThread dch_runInMain:^{
                            if (completion) {
                                completion(nil, error, path, nil, SDImageCacheTypeNone);
                            }
                        }];
                        break;
                    }
                    
                    if (!DCH_IsEmpty(image)) {  // use cached image
                        [NSThread dch_runInMain:^{
                            if (uiRender) {
                                uiRender(image, error, path, nil);
                            }
                            if (completion) {
                                completion(image, error, path, nil, cacheType);
                            }
                        }];
                        break;
                    }
                    
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
                            
                            DCHFileMappingImage *fileMappingImage = [DCHFileMappingImage imageWithMappingContentsOfFile:path];
                            
                            if (DCH_IsEmpty(fileMappingImage)) {
                                [NSThread dch_runInMain:^{
                                    if (placeholder) {
                                        if (uiRender) {
                                            uiRender(placeholder, error, path, nil);
                                        }
                                    }
                                    if (completion) {
                                        completion(fileMappingImage, error, path, nil, SDImageCacheTypeNone);
                                    }
                                }];
                                break;
                            }
                            
                            if (operation.isCanceled) {
                                break;
                            }
                            
                            UIImage *decompressedImage = [UIImage dch_decodedImageWithImage:fileMappingImage];
                            
                            if (DCH_IsEmpty(decompressedImage)) {
                                [NSThread dch_runInMain:^{
                                    NSError *error = [NSError errorWithDomain:DCHImageTurboErrorDomain code:(-1004) userInfo:@{NSLocalizedDescriptionKey : @"DCH_IsEmpty(decompressedImage)"}];
                                    if (completion) {
                                        completion(decompressedImage, error, path, nil, SDImageCacheTypeNone);
                                    }
                                }];
                                break;
                            }
                            
                            [[SDImageCache sharedImageCache] storeImage:decompressedImage recalculateFromImage:NO imageData:nil forKey:path toDisk:NO];
                            
                            if (operation.isCanceled) {
                                break;
                            }
                            
                            if (DCH_IsEmpty(customizeParamsDic)) {  // use origin image
                                [NSThread dch_runInMain:^{
                                    if (uiRender) {
                                        uiRender(decompressedImage, error, path, nil);
                                    }
                                    if (completion) {
                                        completion(decompressedImage, error, path, nil, SDImageCacheTypeDisk);
                                    }
                                }];
                            } else {  // use customized image
                                UIImage *customizedImage = [UIImage dch_customizeImage:decompressedImage withParams:customizeParamsDic contentMode:self.contentMode];
                                if (customizedImage) {
                                    if (customizedImage) {
                                        [[SDImageCache sharedImageCache] storeImage:customizedImage recalculateFromImage:NO imageData:nil forKey:customizedImageKey toDisk:YES];
                                    }
                                    
                                    [NSThread dch_runInMain:^{
                                        if (uiRender) {
                                            uiRender(customizedImage, error, path, nil);
                                        }
                                        if (completion) {
                                            completion(customizedImage, error, path, nil, cacheType);
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
                    if (operationHandler) {
                        operationHandler(operation, path, nil);
                    }
                    [NSThread dch_runInBackground:^{
                        [operation execute];
                    }];
                } while (NO);
            }];
        } else {
            [NSThread dch_runInMain:^{
                NSError *error = [NSError errorWithDomain:DCHImageTurboErrorDomain code:(-1003) userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil path"}];
                if (completion) {
                    completion(nil, error, path, nil, SDImageCacheTypeNone);
                }
            }];
        }
    } while (NO);
}

@end
