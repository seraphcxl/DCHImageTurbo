//
//  UIImage+DCHImageTurbo.m
//  DCHImageTurbo
//
//  Created by Derek Chen on 6/28/15.
//  Copyright (c) 2015 CHEN. All rights reserved.
//

#import "UIImage+DCHImageTurbo.h"
#import <Tourbillon/DCHTourbillon.h>

NSString * const DCHImageTurboKey_ResizeWidth = @"DCHImageTurboKey_ResizeWidth";  // NSNumber
NSString * const DCHImageTurboKey_ResizeHeight = @"DCHImageTurboKey_ResizeHeight";  // NSNumber
NSString * const DCHImageTurboKey_ResizeScale = @"DCHImageTurboKey_ResizeScale";  // NSNumber
NSString * const DCHImageTurboKey_CornerRadius = @"DCHImageTurboKey_CornerRadius";  // NSNumber
NSString * const DCHImageTurboKey_BorderColor = @"DCHImageTurboKey_BorderColor";  // UIColor
NSString * const DCHImageTurboKey_BorderWidth = @"DCHImageTurboKey_BorderWidth";  // NSNumber

@implementation UIImage (DCHImageTurbo)

+ (UIImage *)dch_customizeImage:(UIImage *)image withParams:(NSDictionary *)paramsDic contentMode:(UIViewContentMode)contentMode {
    UIImage *result = nil;
    do {
        if (DCH_IsEmpty(image) || DCH_IsEmpty(paramsDic)) {
            break;
        }
        NSNumber *resizeWidth = [paramsDic objectForKey:DCHImageTurboKey_ResizeWidth];
        NSNumber *resizeHeight = [paramsDic objectForKey:DCHImageTurboKey_ResizeHeight];
        NSNumber *resizeScale = [paramsDic objectForKey:DCHImageTurboKey_ResizeScale];
        NSNumber *cornerRadius = [paramsDic objectForKey:DCHImageTurboKey_CornerRadius];
        NSNumber *borderWidth = [paramsDic objectForKey:DCHImageTurboKey_BorderWidth];
        UIColor *borderColor = [paramsDic objectForKey:DCHImageTurboKey_BorderColor];
        
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

+ (UIImage *)dch_decodedImageWithImage:(UIImage *)image {
    UIImage *result = nil;
    CGColorSpaceRef colorSpace = NULL;
    CGContextRef context = NULL;
    CGImageRef decompressedImageRef = NULL;
    do {
        if (DCH_IsEmpty(image)) {
            break;
        }
        if (image.images) {
            // Do not decode animated images
            result = image;
            break;
        }
        
        CGImageRef imageRef = image.CGImage;
        CGSize imageSize = CGSizeMake(CGImageGetWidth(imageRef), CGImageGetHeight(imageRef));
        CGRect imageRect = (CGRect){.origin = CGPointZero, .size = imageSize};
        
        colorSpace = CGColorSpaceCreateDeviceRGB();
        CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
        
        int infoMask = (bitmapInfo & kCGBitmapAlphaInfoMask);
        BOOL anyNonAlpha = (infoMask == kCGImageAlphaNone || infoMask == kCGImageAlphaNoneSkipFirst || infoMask == kCGImageAlphaNoneSkipLast);
        
        // CGBitmapContextCreate doesn't support kCGImageAlphaNone with RGB.
        // https://developer.apple.com/library/mac/#qa/qa1037/_index.html
        if (infoMask == kCGImageAlphaNone && CGColorSpaceGetNumberOfComponents(colorSpace) > 1) {
            // Unset the old alpha info.
            bitmapInfo &= ~kCGBitmapAlphaInfoMask;
            
            // Set noneSkipFirst.
            bitmapInfo |= kCGImageAlphaNoneSkipFirst;
        }
        // Some PNGs tell us they have alpha but only 3 components. Odd.
        else if (!anyNonAlpha && CGColorSpaceGetNumberOfComponents(colorSpace) == 3) {
            // Unset the old alpha info.
            bitmapInfo &= ~kCGBitmapAlphaInfoMask;
            bitmapInfo |= kCGImageAlphaPremultipliedFirst;
        }
        
        context = CGBitmapContextCreate(NULL, imageSize.width, imageSize.height, CGImageGetBitsPerComponent(imageRef), 0, colorSpace, bitmapInfo);
        
        if (!context) {
            result = image;
            break;
        }
        
        CGContextDrawImage(context, imageRect, imageRef);
        decompressedImageRef = CGBitmapContextCreateImage(context);
        
        result = [UIImage imageWithCGImage:decompressedImageRef scale:image.scale orientation:image.imageOrientation];
    } while (NO);
    if (colorSpace) {
        CGColorSpaceRelease(colorSpace);
        colorSpace = NULL;
    }
    if (context) {
        CGContextRelease(context);
        context = NULL;
    }
    if (decompressedImageRef) {
        CGImageRelease(decompressedImageRef);
        decompressedImageRef = NULL;
    }
    return result;
}

+ (UIImage *)dch_applyGaussianBlur:(UIImage *)image withRadius:(CGFloat)blurRadius {
    UIImage *result = nil;
    do {
        if (!image) {
            break;
        }
        CIContext *ciContent = [CIContext contextWithOptions:nil];
        CIImage *ciImage = [CIImage imageWithCGImage:image.CGImage];
        CIFilter *ciGaussianBlurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
        [ciGaussianBlurFilter setValue:ciImage forKey:kCIInputImageKey];
        [ciGaussianBlurFilter setValue:@(blurRadius) forKey:kCIInputRadiusKey];
        CGImageRef cgImage = [ciContent createCGImage:ciGaussianBlurFilter.outputImage fromRect:ciImage.extent];
        result = [UIImage imageWithCGImage:cgImage];
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

//+ (UIImage *)dch_applyResize:(UIImage *)image toSize:(CGSize)newSize withContentMode:(UIViewContentMode)contentMode allowZoomOut:(BOOL)allowZoomOut {
//    UIImage *result = nil;
//    CGContextRef bitmapContext = nil;
//    CGImageRef scaledImageRef = nil;
//    CGColorSpaceRef colourSpace = nil;
//    do {
//        if (!image) {
//            break;
//        }
//        result = image;
//        if (CGSizeEqualToSize(newSize, CGSizeZero)) {
//            break;
//        }
//        
//        CGFloat pxLocX = 0;
//        CGFloat pxLocY = 0;
//        CGFloat pxOldWidth = image.size.width * image.scale;
//        CGFloat pxOldHeight = image.size.height * image.scale;
//        CGFloat screenScale = [UIScreen mainScreen].scale;
//        CGFloat pxNewWidth = newSize.width * screenScale;
//        CGFloat pxNewHeight = newSize.height * screenScale;
//        
//        if (pxNewWidth > pxOldWidth && pxNewHeight > pxOldHeight && !allowZoomOut) {
//            break;
//        }
//        
//        switch (contentMode) {
//            case UIViewContentModeCenter: {
//                pxLocX = (pxNewWidth - pxOldWidth) / 2;
//                pxLocY = (pxNewHeight - pxOldHeight) / 2;
//            }
//                break;
//            case UIViewContentModeTop: {
//                pxLocX = (pxNewWidth - pxOldWidth) / 2;
//                pxLocY = (pxNewHeight - pxOldHeight);
//            }
//                break;
//            case UIViewContentModeBottom: {
//                pxLocX = (pxNewWidth - pxOldWidth) / 2;
//            }
//                break;
//            case UIViewContentModeLeft: {
//                pxLocY = (pxNewHeight - pxOldHeight) / 2;
//            }
//                break;
//            case UIViewContentModeRight: {
//                pxLocX = (pxNewWidth - pxOldWidth);
//                pxLocY = (pxNewHeight - pxOldHeight) / 2;
//            }
//                break;
//            case UIViewContentModeTopLeft: {
//                pxLocY = (pxNewHeight - pxOldHeight);
//            }
//                break;
//            case UIViewContentModeTopRight: {
//                pxLocX = (pxNewWidth - pxOldWidth);
//                pxLocY = (pxNewHeight - pxOldHeight);
//            }
//                break;
//            case UIViewContentModeBottomLeft:
//                break;
//            case UIViewContentModeBottomRight: {
//                pxLocX = (pxNewWidth - pxOldWidth);
//            }
//                break;
//            case UIViewContentModeScaleAspectFit: {
//                CGFloat ratio = MIN((pxNewWidth / pxOldWidth), (pxNewHeight / pxOldHeight));
//                pxOldWidth *= ratio;
//                pxOldHeight *= ratio;
//                pxLocX = (pxNewWidth - pxOldWidth) / 2;
//                pxLocY = (pxNewHeight - pxOldHeight) / 2;
//            }
//                break;
//            case UIViewContentModeScaleAspectFill: {
//                CGFloat ratio = MAX((pxNewWidth / pxOldWidth), (pxNewHeight / pxOldHeight));
//                pxOldWidth *= ratio;
//                pxOldHeight *= ratio;
//                pxLocX = (pxNewWidth - pxOldWidth) / 2;
//                pxLocY = (pxNewHeight - pxOldHeight) / 2;
//            }
//                break;
//            case UIViewContentModeScaleToFill:
//            default: {
//                pxOldWidth = pxNewWidth;
//                pxOldHeight = pxNewHeight;
//            }
//                break;
//        }
//        
//        colourSpace = CGColorSpaceCreateDeviceRGB();
//        
//        const CGBitmapInfo originalBitmapInfo = CGImageGetBitmapInfo(image.CGImage);
//        
//        // See: http://stackoverflow.com/questions/23723564/which-cgimagealphainfo-should-we-use
//        const uint32_t alphaInfo = (originalBitmapInfo & kCGBitmapAlphaInfoMask);
//        CGBitmapInfo bitmapInfo = originalBitmapInfo;
//        BOOL unsupported = NO;
//        switch (alphaInfo) {
//            case kCGImageAlphaNone: {
//                bitmapInfo &= ~kCGBitmapAlphaInfoMask;
//                bitmapInfo |= kCGImageAlphaNoneSkipFirst;
//            }
//                break;
//            case kCGImageAlphaPremultipliedFirst:
//            case kCGImageAlphaPremultipliedLast:
//            case kCGImageAlphaNoneSkipFirst:
//            case kCGImageAlphaNoneSkipLast:
//                break;
//            case kCGImageAlphaOnly:
//            case kCGImageAlphaLast:
//            case kCGImageAlphaFirst: { // Unsupported
//                unsupported = YES;
//            }
//                break;
//        }
//        
//        if (unsupported) {
//            break;
//        }
//        
//        bitmapContext = CGBitmapContextCreate(NULL, pxNewWidth, pxNewHeight, CGImageGetBitsPerComponent(image.CGImage), 0, colourSpace, bitmapInfo);
//        
//        CGContextSetShouldAntialias(bitmapContext, true);
//        CGContextSetAllowsAntialiasing(bitmapContext, true);
//        CGContextSetInterpolationQuality(bitmapContext, kCGInterpolationHigh);
//        
//        CGContextDrawImage(bitmapContext, CGRectMake(pxLocX, pxLocY, pxOldWidth, pxOldHeight), image.CGImage);
//        
//        scaledImageRef = CGBitmapContextCreateImage(bitmapContext);
//        result = [UIImage imageWithCGImage:scaledImageRef scale:screenScale orientation:image.imageOrientation];
//    } while (NO);
//    if (colourSpace) {
//        CGColorSpaceRelease(colourSpace);
//        colourSpace = nil;
//    }
//    if (scaledImageRef) {
//        CGImageRelease(scaledImageRef);
//        scaledImageRef = nil;
//    }
//    if (bitmapContext) {
//        CGContextRelease(bitmapContext);
//        bitmapContext = nil;
//    }
//    return result;
//}
//
//+ (UIImage *)dch_applyCorner:(UIImage *)image withRadius:(CGFloat)radius {
//    UIImage *result = nil;
//    do {
//        if (DCH_IsEmpty(image)) {
//            break;
//        }
//        CGSize viewSize = image.size;
//        UIGraphicsBeginImageContextWithOptions(CGSizeMake(100, 100), NO, 0.0f);
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        CALayer *layer = [CALayer layer];
//        layer.frame = CGRectMake(0.0f, 0.0f, 100, 100);
//        layer.contents = (__bridge id)(image.CGImage);
//        layer.cornerRadius = radius;
//        layer.masksToBounds = YES;
//        [layer renderInContext:context];
//        result = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//    } while (NO);
//    return result;
//}

@end
