//
//  UIImage+DCHImageTurbo.m
//  DCHImageTurbo
//
//  Created by Derek Chen on 6/28/15.
//  Copyright (c) 2015 CHEN. All rights reserved.
//

#import "UIImage+DCHImageTurbo.h"
#import <Tourbillon/DCHTourbillon.h>
#import "UIImage+DCHImageEffect.h"

NSString * const key_DCHImageTurbo_UIImage_ResizeWidth = @"key_DCHImageTurbo_UIImage_ResizeWidth";  // NSNumber
NSString * const key_DCHImageTurbo_UIImage_ResizeHeight = @"key_DCHImageTurbo_UIImage_ResizeHeight";  // NSNumber
NSString * const key_DCHImageTurbo_UIImage_ResizeScale = @"key_DCHImageTurbo_UIImage_ResizeScale";  // NSNumber
NSString * const key_DCHImageTurbo_UIImage_CornerRadius = @"key_DCHImageTurbo_UIImage_CornerRadius";  // NSNumber
NSString * const key_DCHImageTurbo_UIImage_BorderColor = @"key_DCHImageTurbo_UIImage_BorderColor";  // UIColor
NSString * const key_DCHImageTurbo_UIImage_BorderWidth = @"key_DCHImageTurbo_UIImage_BorderWidth";  // NSNumber
NSString * const key_DCHImageTurbo_UIImage_BlurEdgeInsets = @"key_DCHImageTurbo_UIImage_BlurEdgeInsets";  // NSValue(UIEdgeInsets)
NSString * const key_DCHImageTurbo_UIImage_BlurRadius = @"key_DCHImageTurbo_UIImage_BlurRadius";  // NSNumber
NSString * const key_DCHImageTurbo_UIImage_BlurTintColor = @"key_DCHImageTurbo_UIImage_BlurTintColor";  // UIColor
NSString * const key_DCHImageTurbo_UIImage_BlurSaturationDeltaFactor = @"key_DCHImageTurbo_UIImage_BlurSaturationDeltaFactor";  // NSNumber
NSString * const key_DCHImageTurbo_UIImage_BlurMaskImage = @"key_DCHImageTurbo_UIImage_BlurMaskImage";  // UIImage

@implementation UIImage (DCHImageTurbo)

+ (instancetype)dch_customizeImage:(UIImage *)image withParams:(NSDictionary *)paramsDic contentMode:(UIViewContentMode)contentMode {
    UIImage *result = image;
    do {
        if (DCH_IsEmpty(image) || DCH_IsEmpty(paramsDic)) {
            break;
        }
        NSNumber *resizeWidth = [paramsDic dch_safe_objectForKey:key_DCHImageTurbo_UIImage_ResizeWidth];
        NSNumber *resizeHeight = [paramsDic dch_safe_objectForKey:key_DCHImageTurbo_UIImage_ResizeHeight];
        NSNumber *resizeScale = [paramsDic dch_safe_objectForKey:key_DCHImageTurbo_UIImage_ResizeScale];
        
        NSNumber *cornerRadius = [paramsDic dch_safe_objectForKey:key_DCHImageTurbo_UIImage_CornerRadius];
        
        NSNumber *borderWidth = [paramsDic dch_safe_objectForKey:key_DCHImageTurbo_UIImage_BorderWidth];
        UIColor *borderColor = [paramsDic dch_safe_objectForKey:key_DCHImageTurbo_UIImage_BorderColor];
        
        NSValue *blurEdgeInsetsValue = [paramsDic dch_safe_objectForKey:key_DCHImageTurbo_UIImage_BlurEdgeInsets];
        NSNumber *blurRadius = [paramsDic dch_safe_objectForKey:key_DCHImageTurbo_UIImage_BlurRadius];
        UIColor *blurTintColor = [paramsDic dch_safe_objectForKey:key_DCHImageTurbo_UIImage_BlurTintColor];
        NSNumber *blurSaturationDeltaFactor = [paramsDic dch_safe_objectForKey:key_DCHImageTurbo_UIImage_BlurSaturationDeltaFactor];
        UIImage *blurMaskImage = [paramsDic dch_safe_objectForKey:key_DCHImageTurbo_UIImage_BlurMaskImage];
        
        CGSize targetSize = image.size;
        CGFloat scale = image.scale;
        
        // Resize
        if (!DCH_IsEmpty(resizeWidth) && !DCH_IsEmpty(resizeHeight) && !DCH_IsEmpty(resizeScale)) {
            CGSize size = CGSizeMake(resizeWidth.floatValue, resizeHeight.floatValue);
            if (!CGSizeEqualToSize(size, CGSizeZero)) {
                targetSize = CGSizeMake(resizeWidth.floatValue, resizeHeight.floatValue);
                scale = resizeScale.floatValue;
            }
        }
        
        UIGraphicsBeginImageContextWithOptions(targetSize, NO, scale);
        CGContextRef context1 = UIGraphicsGetCurrentContext();
        CALayer *layer1 = [CALayer layer];
        layer1.frame = (CGRect){CGPointZero, targetSize};
        layer1.contentsGravity = [UIImage dch_layerContentsGravityFromViewContentMode:contentMode];
        layer1.contents = (__bridge id)(image.CGImage);
        [layer1 renderInContext:context1];
        result = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        // Blur
        if (!DCH_IsEmpty(blurRadius) && !DCH_IsEmpty(blurTintColor) && !DCH_IsEmpty(blurSaturationDeltaFactor)) {
            if (DCH_IsEmpty(blurEdgeInsetsValue)) {
                result = [UIImage dch_applyBlur:result withRadius:blurRadius.floatValue tintColor:blurTintColor saturationDeltaFactor:blurSaturationDeltaFactor.floatValue maskImage:blurMaskImage];
            } else {
                UIEdgeInsets edgeInsets = [blurEdgeInsetsValue UIEdgeInsetsValue];
                result = [UIImage dch_applyBlur:result forEdgeInsets:edgeInsets withRadius:blurRadius.floatValue tintColor:blurTintColor saturationDeltaFactor:blurSaturationDeltaFactor.floatValue maskImage:blurMaskImage didCancel:nil];
            }
            
        }
        
        // Corner and Border
        UIGraphicsBeginImageContextWithOptions(targetSize, NO, scale);
        CGContextRef context2 = UIGraphicsGetCurrentContext();
        CALayer *layer2 = [CALayer layer];
        layer2.frame = (CGRect){CGPointZero, targetSize};
        layer2.contentsGravity = [UIImage dch_layerContentsGravityFromViewContentMode:contentMode];
        layer2.contents = (__bridge id)(result.CGImage);
        if (!DCH_IsEmpty(cornerRadius)) {
            layer2.cornerRadius = cornerRadius.floatValue;
        }
        if (!DCH_IsEmpty(borderWidth) && !DCH_IsEmpty(borderColor)) {
            layer2.borderWidth = borderWidth.floatValue;
            layer2.borderColor = borderColor.CGColor;
        }
        layer2.masksToBounds = YES;
        [layer2 renderInContext:context2];
        result = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    } while (NO);
    return result;
}

+ (NSString *)dch_layerContentsGravityFromViewContentMode:(UIViewContentMode)viewContentMode {
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

+ (NSString *)dch_imageSignature:(NSDictionary *)dic {
    NSString *result = nil;
    do {
        if (DCH_IsEmpty(dic)) {
            break;
        }
        
        NSMutableString *tmp = [NSMutableString string];
        NSNumber *resizeWidth = [dic objectForKey:key_DCHImageTurbo_UIImage_ResizeWidth];
        NSNumber *resizeHeight = [dic objectForKey:key_DCHImageTurbo_UIImage_ResizeHeight];
        NSNumber *resizeScale = [dic objectForKey:key_DCHImageTurbo_UIImage_ResizeScale];
        if (resizeWidth && resizeHeight && resizeScale) {
            [tmp appendFormat:@"ResizeW%fH%fS%f", [resizeWidth floatValue], [resizeHeight floatValue], [resizeScale floatValue]];
        }
        
        NSNumber *cornerRadius = [dic objectForKey:key_DCHImageTurbo_UIImage_CornerRadius];
        if (cornerRadius) {
            [tmp appendFormat:@"CornerRadius%f", [cornerRadius floatValue]];
        }
        
        UIColor *borderColor = [dic objectForKey:key_DCHImageTurbo_UIImage_BorderColor];
        NSNumber *borderWidth = [dic objectForKey:key_DCHImageTurbo_UIImage_BorderWidth];
        if (borderColor && borderWidth) {
            CGFloat components[4] = {0.0, 0.0, 0.0, 0.0};
            [borderColor getRed:&components[0] green:&components[1] blue:&components[2] alpha:&components[3]];
            [tmp appendFormat:@"BorderColorR%fG:%fB:%fA:%fWidth%f", components[0], components[1], components[2], components[3], [borderWidth floatValue]];
        }
        
        NSValue *blurEdgeInsetsValue = [dic objectForKey:key_DCHImageTurbo_UIImage_BlurEdgeInsets];
        UIColor *blurTintColor = [dic objectForKey:key_DCHImageTurbo_UIImage_BlurTintColor];
        NSNumber *blurRadius = [dic objectForKey:key_DCHImageTurbo_UIImage_BlurRadius];
        NSNumber *blurSaturationDeltaFactor = [dic objectForKey:key_DCHImageTurbo_UIImage_BlurSaturationDeltaFactor];
        NSUInteger blurMaskImageHash = [[dic objectForKey:key_DCHImageTurbo_UIImage_BlurMaskImage] hash];
        if (blurTintColor && blurRadius && blurSaturationDeltaFactor) {
            CGFloat components[4] = {0.0, 0.0, 0.0, 0.0};
            [blurTintColor getRed:&components[0] green:&components[1] blue:&components[2] alpha:&components[3]];
            [tmp appendFormat:@"BlurColorR%fG:%fB:%fA:%fRadius%fSaturationDeltaFactor%fMaskImageHash%lu", components[0], components[1], components[2], components[3], [blurRadius floatValue], [blurSaturationDeltaFactor floatValue], (unsigned long)blurMaskImageHash];
            if (blurEdgeInsetsValue) {
                UIEdgeInsets edgeInsets = [blurEdgeInsetsValue UIEdgeInsetsValue];
                [tmp appendFormat:@"RatioRectT%fB%fL%fR%f", edgeInsets.top, edgeInsets.bottom, edgeInsets.left, edgeInsets.right];
            }
        }
        
        result = [tmp dch_md5String];
    } while (NO);
    return result;
}

@end
