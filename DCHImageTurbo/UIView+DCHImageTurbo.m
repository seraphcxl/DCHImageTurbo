//
//  UIView+DCHImageTurbo.m
//  DCHImageTurbo
//
//  Created by Derek Chen on 6/26/15.
//  Copyright © 2015 CHEN. All rights reserved.
//

#import "UIView+DCHImageTurbo.h"
#import <Tourbillon/DCHTourbillon.h>
#import "DCHImageProcessor.h"
#import "DCHImageTurboCommonConstants.h"

@implementation UIView (DCHImageTurbo)

- (NSString *)dch_imageSignature:(NSDictionary *)dic {
    NSMutableString *result = [NSMutableString string];
    do {
        if (DCH_IsEmpty(dic)) {
            break;
        }
        NSNumber *resizeWidth = [dic objectForKey:DCHImageTurboKey_ResizeWidth];
        if (resizeWidth) {
            [result appendFormat:@"ResizeWidth%f", [resizeWidth floatValue]];
        }
        NSNumber *resizeHeight = [dic objectForKey:DCHImageTurboKey_ResizeHeight];
        if (resizeHeight) {
            [result appendFormat:@"ResizeHeight%f", [resizeHeight floatValue]];
        }
        NSNumber *resizeScale = [dic objectForKey:DCHImageTurboKey_ResizeScale];
        if (resizeScale) {
            [result appendFormat:@"ResizeScale%f", [resizeScale floatValue]];
        }
        NSNumber *cornerRadius = [dic objectForKey:DCHImageTurboKey_CornerRadius];
        if (cornerRadius) {
            [result appendFormat:@"CornerRadius%f", [cornerRadius floatValue]];
        }
        UIColor *borderColor = [dic objectForKey:DCHImageTurboKey_BorderColor];
        if (borderColor) {
            CGFloat components[4] = {0.0, 0.0, 0.0, 0.0};
            [borderColor getRed:&components[0] green:&components[1] blue:&components[2] alpha:&components[3]];
            [result appendFormat:@"BorderColorR%fG:%fB:%fA:%f", components[0], components[1], components[2], components[3]];
        }
        NSNumber *borderWidth = [dic objectForKey:DCHImageTurboKey_BorderWidth];
        if (borderWidth) {
            [result appendFormat:@"BorderWidth%f", [borderWidth floatValue]];
        }
    } while (NO);
    return result;
}

- (void)dch_loadImageFormCacheForKey:(NSString *)key fromDisk:(BOOL)fromDisk completed:(DCHImageTurboLoadImageFromCacheCompletionBlock)completedBlock {
    __block UIImage *loadedImage = nil;
    NSError *error = nil;
    __block SDImageCacheType cacheType = SDImageCacheTypeNone;
    do {
        if (DCH_IsEmpty(key)) {
            error = [NSError errorWithDomain:DCHImageTurboErrorDomain code:(-1002) userInfo:@{NSLocalizedDescriptionKey : @"DCH_IsEmpty(key)"}];
            if (completedBlock) {
                completedBlock(loadedImage, error, key, cacheType);
            }
            break;
        }
        loadedImage = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:key];
        if (loadedImage) {
            cacheType = SDImageCacheTypeMemory;
            if (completedBlock) {
                completedBlock(loadedImage, error, key, cacheType);
            }
        } else {
            if (fromDisk) {
                [NSThread dch_runInBackground:^{
                    do {
                        loadedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:key];
                        if (loadedImage) {
                            cacheType = SDImageCacheTypeDisk;
                        }
                        if (completedBlock) {
                            completedBlock(loadedImage, error, key, cacheType);
                        }
                    } while (NO);
                }];
            } else {
                if (completedBlock) {
                    completedBlock(loadedImage, error, key, cacheType);
                }
            }
        }
    } while (NO);
}

@end
