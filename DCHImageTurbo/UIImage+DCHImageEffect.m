//
//  UIImage+DCHImageEffect.m
//  DCHImageTurbo
//
//  Created by Derek Chen on 7/28/15.
//  Copyright (c) 2015 CHEN. All rights reserved.
//

#import "UIImage+DCHImageEffect.h"
#import <Tourbillon/DCHTourbillon.h>
#import <Accelerate/Accelerate.h>

@implementation UIImage (DCHImageEffect)

+ (instancetype)dch_decodedImageWithImage:(UIImage *)image {
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

+ (instancetype)dch_applyResize:(UIImage *)image toSize:(CGSize)newSize withContentMode:(UIViewContentMode)contentMode allowZoomOut:(BOOL)allowZoomOut {
    UIImage *result = nil;
    CGContextRef bitmapContext = nil;
    CGImageRef scaledImageRef = nil;
    CGColorSpaceRef colourSpace = nil;
    do {
        if (!image) {
            break;
        }
        result = image;
        if (CGSizeEqualToSize(newSize, CGSizeZero)) {
            break;
        }
        
        CGFloat pxLocX = 0;
        CGFloat pxLocY = 0;
        CGFloat pxOldWidth = image.size.width * image.scale;
        CGFloat pxOldHeight = image.size.height * image.scale;
        CGFloat screenScale = [UIScreen mainScreen].scale;
        CGFloat pxNewWidth = newSize.width * screenScale;
        CGFloat pxNewHeight = newSize.height * screenScale;
        
        if (pxNewWidth > pxOldWidth && pxNewHeight > pxOldHeight && !allowZoomOut) {
            break;
        }
        
        switch (contentMode) {
            case UIViewContentModeCenter: {
                pxLocX = (pxNewWidth - pxOldWidth) / 2;
                pxLocY = (pxNewHeight - pxOldHeight) / 2;
            }
                break;
            case UIViewContentModeTop: {
                pxLocX = (pxNewWidth - pxOldWidth) / 2;
                pxLocY = (pxNewHeight - pxOldHeight);
            }
                break;
            case UIViewContentModeBottom: {
                pxLocX = (pxNewWidth - pxOldWidth) / 2;
            }
                break;
            case UIViewContentModeLeft: {
                pxLocY = (pxNewHeight - pxOldHeight) / 2;
            }
                break;
            case UIViewContentModeRight: {
                pxLocX = (pxNewWidth - pxOldWidth);
                pxLocY = (pxNewHeight - pxOldHeight) / 2;
            }
                break;
            case UIViewContentModeTopLeft: {
                pxLocY = (pxNewHeight - pxOldHeight);
            }
                break;
            case UIViewContentModeTopRight: {
                pxLocX = (pxNewWidth - pxOldWidth);
                pxLocY = (pxNewHeight - pxOldHeight);
            }
                break;
            case UIViewContentModeBottomLeft:
                break;
            case UIViewContentModeBottomRight: {
                pxLocX = (pxNewWidth - pxOldWidth);
            }
                break;
            case UIViewContentModeScaleAspectFit: {
                CGFloat ratio = MIN((pxNewWidth / pxOldWidth), (pxNewHeight / pxOldHeight));
                pxOldWidth *= ratio;
                pxOldHeight *= ratio;
                pxLocX = (pxNewWidth - pxOldWidth) / 2;
                pxLocY = (pxNewHeight - pxOldHeight) / 2;
            }
                break;
            case UIViewContentModeScaleAspectFill: {
                CGFloat ratio = MAX((pxNewWidth / pxOldWidth), (pxNewHeight / pxOldHeight));
                pxOldWidth *= ratio;
                pxOldHeight *= ratio;
                pxLocX = (pxNewWidth - pxOldWidth) / 2;
                pxLocY = (pxNewHeight - pxOldHeight) / 2;
            }
                break;
            case UIViewContentModeScaleToFill:
            default: {
                pxOldWidth = pxNewWidth;
                pxOldHeight = pxNewHeight;
            }
                break;
        }
        
        colourSpace = CGColorSpaceCreateDeviceRGB();
        
        const CGBitmapInfo originalBitmapInfo = CGImageGetBitmapInfo(image.CGImage);
        
        // See: http://stackoverflow.com/questions/23723564/which-cgimagealphainfo-should-we-use
        const uint32_t alphaInfo = (originalBitmapInfo & kCGBitmapAlphaInfoMask);
        CGBitmapInfo bitmapInfo = originalBitmapInfo;
        BOOL unsupported = NO;
        switch (alphaInfo) {
            case kCGImageAlphaNone: {
                bitmapInfo &= ~kCGBitmapAlphaInfoMask;
                bitmapInfo |= kCGImageAlphaNoneSkipFirst;
            }
                break;
            case kCGImageAlphaPremultipliedFirst:
            case kCGImageAlphaPremultipliedLast:
            case kCGImageAlphaNoneSkipFirst:
            case kCGImageAlphaNoneSkipLast:
                break;
            case kCGImageAlphaOnly:
            case kCGImageAlphaLast:
            case kCGImageAlphaFirst: { // Unsupported
                unsupported = YES;
            }
                break;
        }
        
        if (unsupported) {
            break;
        }
        
        bitmapContext = CGBitmapContextCreate(NULL, pxNewWidth, pxNewHeight, CGImageGetBitsPerComponent(image.CGImage), 0, colourSpace, bitmapInfo);
        
        CGContextSetShouldAntialias(bitmapContext, true);
        CGContextSetAllowsAntialiasing(bitmapContext, true);
        CGContextSetInterpolationQuality(bitmapContext, kCGInterpolationHigh);
        
        CGContextDrawImage(bitmapContext, CGRectMake(pxLocX, pxLocY, pxOldWidth, pxOldHeight), image.CGImage);
        
        scaledImageRef = CGBitmapContextCreateImage(bitmapContext);
        result = [UIImage imageWithCGImage:scaledImageRef scale:screenScale orientation:image.imageOrientation];
    } while (NO);
    if (colourSpace) {
        CGColorSpaceRelease(colourSpace);
        colourSpace = nil;
    }
    if (scaledImageRef) {
        CGImageRelease(scaledImageRef);
        scaledImageRef = nil;
    }
    if (bitmapContext) {
        CGContextRelease(bitmapContext);
        bitmapContext = nil;
    }
    return result;
}

+ (instancetype)dch_applyBlur:(UIImage *)image withRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage {
    return [UIImage dch_applyBlur:image withRadius:blurRadius tintColor:tintColor saturationDeltaFactor:saturationDeltaFactor maskImage:maskImage didCancel:^BOOL{ return NO; }];
}

+ (instancetype)dch_applyBlur:(UIImage *)image withRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage didCancel:(BOOL (^)())didCancel {
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 0, 1, 1);
    return [UIImage dch_applyBlur:image forEdgeInsets:edgeInsets withRadius:blurRadius tintColor:tintColor saturationDeltaFactor:saturationDeltaFactor maskImage:maskImage didCancel:didCancel];
}

+ (instancetype)dch_applyBlur:(UIImage *)image forEdgeInsets:(UIEdgeInsets)edgeInsets withRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage didCancel:(BOOL (^)())didCancel {
    UIImage *result = nil;
    do {
        if (!image || !image.CGImage || image.size.width < 1 || image.size.height < 1) {
            break;
        }
        
        @autoreleasepool {
            CGRect imageRect = {CGPointZero, image.size};
            CGPoint imageBlurOrigin = CGPointMake(edgeInsets.left, edgeInsets.bottom);
            imageBlurOrigin.x = MAX(imageBlurOrigin.x, 0);
            imageBlurOrigin.y = MAX(imageBlurOrigin.y, 0);
            imageBlurOrigin.x = MIN(imageBlurOrigin.x, imageRect.size.width);
            imageBlurOrigin.y = MIN(imageBlurOrigin.y, imageRect.size.height);
            
            CGSize imageBlurSize = CGSizeMake(image.size.width - edgeInsets.right - imageBlurOrigin.x, image.size.height - edgeInsets.top - imageBlurOrigin.y);
            imageBlurSize.width = MAX(imageBlurSize.width, 0);
            imageBlurSize.height = MAX(imageBlurSize.height, 0);;
            
            CGRect imageBlurRect = {imageBlurOrigin, imageBlurSize};
            
            UIImage *effectImage = image;
            
            BOOL hasBlur = blurRadius > __FLT_EPSILON__;
            BOOL hasSaturationChange = fabs(saturationDeltaFactor - 1.) > __FLT_EPSILON__;
            
            if (hasBlur || hasSaturationChange) {
                UIGraphicsBeginImageContextWithOptions(imageBlurRect.size, NO, [[UIScreen mainScreen] scale]);
                CGContextRef effectInContext = UIGraphicsGetCurrentContext();
                CGContextScaleCTM(effectInContext, 1.0, -1.0);
                CGContextTranslateCTM(effectInContext, 0, -imageBlurRect.size.height);
                CGContextDrawImage(effectInContext, imageRect, image.CGImage);
                vImage_Buffer effectInBuffer;
                effectInBuffer.data     = CGBitmapContextGetData(effectInContext);
                effectInBuffer.width    = CGBitmapContextGetWidth(effectInContext);
                effectInBuffer.height   = CGBitmapContextGetHeight(effectInContext);
                effectInBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectInContext);
                
                UIGraphicsBeginImageContextWithOptions(imageBlurRect.size, NO, [[UIScreen mainScreen] scale]);
                CGContextRef effectOutContext = UIGraphicsGetCurrentContext();
                vImage_Buffer effectOutBuffer;
                effectOutBuffer.data     = CGBitmapContextGetData(effectOutContext);
                effectOutBuffer.width    = CGBitmapContextGetWidth(effectOutContext);
                effectOutBuffer.height   = CGBitmapContextGetHeight(effectOutContext);
                effectOutBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext);
                
                if (hasBlur) {
                    // A description of how to compute the box kernel width from the Gaussian
                    // radius (aka standard deviation) appears in the SVG spec:
                    // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
                    //
                    // For larger values of 's' (s >= 2.0), an approximation can be used: Three
                    // successive box-blurs build a piece-wise quadratic convolution kernel, which
                    // approximates the Gaussian kernel to within roughly 3%.
                    //
                    // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
                    //
                    // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
                    //
                    CGFloat inputRadius = blurRadius * [[UIScreen mainScreen] scale];
                    uint32_t radius = floor(inputRadius * 3. * sqrt(2 * M_PI) / 4 + 0.5);
                    if (radius % 2 != 1) {
                        radius += 1; // force radius to be odd so that the three box-blur methodology works.
                    }
                    
                    if (!DCH_IsEmpty(didCancel) && didCancel()) {
                        UIGraphicsEndImageContext();
                        break;
                    }
                    
                    vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
                    
                    if (!DCH_IsEmpty(didCancel) && didCancel()) {
                        UIGraphicsEndImageContext();
                        break;
                    }
                    
                    vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
                    
                    if (!DCH_IsEmpty(didCancel) && didCancel()) {
                        UIGraphicsEndImageContext();
                        break;
                    }
                    
                    vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
                }
                
                if (!DCH_IsEmpty(didCancel) && didCancel()) {
                    UIGraphicsEndImageContext();
                    break;
                }
                
                
                BOOL effectImageBuffersAreSwapped = NO;
                if (hasSaturationChange) {
                    CGFloat s = saturationDeltaFactor;
                    CGFloat floatingPointSaturationMatrix[] = {
                        0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                        0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                        0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
                        0,                    0,                    0,  1,
                    };
                    const int32_t divisor = 256;
                    NSUInteger matrixSize = sizeof(floatingPointSaturationMatrix)/sizeof(floatingPointSaturationMatrix[0]);
                    int16_t saturationMatrix[matrixSize];
                    for (NSUInteger i = 0; i < matrixSize; ++i) {
                        saturationMatrix[i] = (int16_t)roundf(floatingPointSaturationMatrix[i] * divisor);
                    }
                    if (hasBlur) {
                        vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
                        effectImageBuffersAreSwapped = YES;
                    } else {
                        vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
                    }
                }
                if (!effectImageBuffersAreSwapped) {
                    effectImage = UIGraphicsGetImageFromCurrentImageContext();
                }
                UIGraphicsEndImageContext();
            }
            
            // Set up output context.
            UIGraphicsBeginImageContextWithOptions(image.size, NO, [[UIScreen mainScreen] scale]);
            CGContextRef outputContext = UIGraphicsGetCurrentContext();
            CGContextScaleCTM(outputContext, 1.0, -1.0);
            CGContextTranslateCTM(outputContext, 0, -image.size.height);
            
            // Draw base image.
            CGContextDrawImage(outputContext, imageRect, image.CGImage);
            
            // Draw effect image.
            if (hasBlur) {
                CGContextSaveGState(outputContext);
                if (maskImage) {
                    CGContextClipToMask(outputContext, imageRect, maskImage.CGImage);
                }
                CGContextDrawImage(outputContext, imageBlurRect, effectImage.CGImage);
                CGContextRestoreGState(outputContext);
            }
            
            // Add in color tint.
            if (tintColor) {
                CGContextSaveGState(outputContext);
                CGContextSetFillColorWithColor(outputContext, tintColor.CGColor);
                CGContextFillRect(outputContext, imageBlurRect);
                CGContextRestoreGState(outputContext);
            }
            
            // Output image is ready.
            result = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
    } while (NO);
    return result;
}

+ (instancetype)dch_applyGaussianBlur:(UIImage *)image withRadius:(CGFloat)blurRadius {
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

#pragma mark - image with color
+ (instancetype)dch_imageWithColor:(UIColor *)color size:(CGSize)size {
    UIImage *result = nil;
    do {
        if (DCH_IsEmpty(color) || size.width == 0 || size.height == 0) {
            break;
        }
        
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        
        // Create a context depending on given size
        UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
        
        // Fill it with your color
        [color setFill];
        UIRectFill(rect);
        
        result = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    } while (NO);
    return result;
}

@end
