//
//  UIImage+DCHImageTurbo.m
//  DCHImageTurbo
//
//  Created by Derek Chen on 6/28/15.
//  Copyright (c) 2015 CHEN. All rights reserved.
//

#import "UIImage+DCHImageTurbo.h"
#import <Tourbillon/DCHTourbillon.h>

NSString * const key_DCHImageTurbo_UIImage_ResizeWidth = @"key_DCHImageTurbo_UIImage_ResizeWidth";  // NSNumber
NSString * const key_DCHImageTurbo_UIImage_ResizeHeight = @"key_DCHImageTurbo_UIImage_ResizeHeight";  // NSNumber
NSString * const key_DCHImageTurbo_UIImage_ResizeScale = @"key_DCHImageTurbo_UIImage_ResizeScale";  // NSNumber
NSString * const key_DCHImageTurbo_UIImage_CornerRadius = @"key_DCHImageTurbo_UIImage_CornerRadius";  // NSNumber
NSString * const key_DCHImageTurbo_UIImage_BorderColor = @"key_DCHImageTurbo_UIImage_BorderColor";  // UIColor
NSString * const key_DCHImageTurbo_UIImage_BorderWidth = @"key_DCHImageTurbo_UIImage_BorderWidth";  // NSNumber

@implementation UIImage (DCHImageTurbo)

+ (UIImage *)dch_customizeImage:(UIImage *)image withParams:(NSDictionary *)paramsDic contentMode:(UIViewContentMode)contentMode {
    UIImage *result = nil;
    do {
        if (DCH_IsEmpty(image) || DCH_IsEmpty(paramsDic)) {
            break;
        }
        NSNumber *resizeWidth = [paramsDic objectForKey:key_DCHImageTurbo_UIImage_ResizeWidth];
        NSNumber *resizeHeight = [paramsDic objectForKey:key_DCHImageTurbo_UIImage_ResizeHeight];
        NSNumber *resizeScale = [paramsDic objectForKey:key_DCHImageTurbo_UIImage_ResizeScale];
        NSNumber *cornerRadius = [paramsDic objectForKey:key_DCHImageTurbo_UIImage_CornerRadius];
        NSNumber *borderWidth = [paramsDic objectForKey:key_DCHImageTurbo_UIImage_BorderWidth];
        UIColor *borderColor = [paramsDic objectForKey:key_DCHImageTurbo_UIImage_BorderColor];
        
        CGSize targetSize = image.size;
        CGFloat scale = image.scale;
        
        if (!DCH_IsEmpty(resizeWidth) && !DCH_IsEmpty(resizeHeight) && !DCH_IsEmpty(resizeScale)) {
            CGSize size = CGSizeMake(resizeWidth.floatValue, resizeHeight.floatValue);
            if (!CGSizeEqualToSize(size, CGSizeZero)) {
                targetSize = CGSizeMake(resizeWidth.floatValue, resizeHeight.floatValue);
                scale = resizeScale.floatValue;
            }
        }
        
        UIGraphicsBeginImageContextWithOptions(targetSize, NO, scale);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CALayer *layer = [CALayer layer];
        layer.frame = (CGRect){CGPointZero, targetSize};
        layer.contentsGravity = [UIImage layerContentsGravityFromViewContentMode:contentMode];
        layer.contents = (__bridge id)(image.CGImage);
        if (!DCH_IsEmpty(cornerRadius)) {
            layer.cornerRadius = cornerRadius.floatValue;
        }
        if (!DCH_IsEmpty(borderWidth) && !DCH_IsEmpty(borderColor)) {
            layer.borderWidth = borderWidth.floatValue;
            layer.borderColor = borderColor.CGColor;
        }
        layer.masksToBounds = YES;
        [layer renderInContext:context];
        result = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    } while (NO);
    return result;
}

+ (NSString *)layerContentsGravityFromViewContentMode:(UIViewContentMode)viewContentMode {
    NSString *result = kCAGravityResize;
    switch (viewContentMode) {
        case UIViewContentModeCenter: {
            result = kCAGravityCenter;
        }
            break;
        case UIViewContentModeTop: {
            result = kCAGravityTop;
        }
            break;
        case UIViewContentModeBottom: {
            result = kCAGravityBottom;
        }
            break;
        case UIViewContentModeLeft: {
            result = kCAGravityLeft;
        }
            break;
        case UIViewContentModeRight: {
            result = kCAGravityRight;
        }
            break;
        case UIViewContentModeTopLeft: {
            result = kCAGravityTopLeft;
        }
            break;
        case UIViewContentModeTopRight: {
            result = kCAGravityRight;
        }
            break;
        case UIViewContentModeBottomLeft:
            result = kCAGravityBottomLeft;
            break;
        case UIViewContentModeBottomRight: {
            result = kCAGravityBottomRight;
        }
            break;
        case UIViewContentModeScaleAspectFit: {
            result = kCAGravityResizeAspect;
        }
            break;
        case UIViewContentModeScaleAspectFill: {
            result = kCAGravityResizeAspectFill;
        }
            break;
        case UIViewContentModeScaleToFill:
        default: {
            result = kCAGravityResize;
        }
            break;
    }
    return result;
}

@end
