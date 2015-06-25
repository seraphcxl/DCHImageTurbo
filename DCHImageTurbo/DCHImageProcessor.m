//
//  DCHImageProcessor.m
//  DCHImageTurbo
//
//  Created by Derek Chen on 6/5/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import "DCHImageProcessor.h"
#import <Tourbillon/DCHTourbillon.h>

//@interface DCHImageProcessOperation ()
//
//@property (nonatomic, strong) NSString *UUID;
//@property (nonatomic, strong) UIImage *originalImage;
//
//@end
//
//@implementation DCHImageProcessOperation
//
//- (void)dealloc {
//    do {
//        self.originalImage = nil;
//        self.completion = nil;
//        self.UUID = nil;
//    } while (NO);
//}
//
//- (instancetype)initWithImage:(UIImage *)image {
//    if (!image) {
//        return nil;
//    }
//    self = [self init];
//    if (self) {
//        self.UUID = [NSString dch_createUUID];
//        self.originalImage = image;
//    }
//    return self;
//}
//
//@end
//
//@implementation DCHImageGaussianBlurOperation
//
//- (void)main {
//    do {
//        if (!self.originalImage) {
//            break;
//        }
//    } while (NO);
//}
//
//@end

@implementation DCHImageProcessor

+ (NSOperationQueue *)sharedGaussianBlurQueue {
    static dispatch_once_t onceToken;
    static NSOperationQueue *gDCHImageProcessorSharedGaussianBlurQueue;
    dispatch_once(&onceToken, ^{
        gDCHImageProcessorSharedGaussianBlurQueue = [[NSOperationQueue alloc] init];
        gDCHImageProcessorSharedGaussianBlurQueue.maxConcurrentOperationCount = 2;
    });
    return gDCHImageProcessorSharedGaussianBlurQueue;
}

+ (UIImage *)applyGaussianBlur:(UIImage *)image withRadius:(CGFloat)blurRadius {
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

+ (NSOperationQueue *)sharedResizeQueue {
    static dispatch_once_t onceToken;
    static NSOperationQueue *gDCHImageProcessorSharedResizeQueue;
    dispatch_once(&onceToken, ^{
        gDCHImageProcessorSharedResizeQueue = [[NSOperationQueue alloc] init];
        gDCHImageProcessorSharedResizeQueue.maxConcurrentOperationCount = 2;
    });
    return gDCHImageProcessorSharedResizeQueue;
}

+ (UIImage *)applyResize:(UIImage *)image toSize:(CGSize)newSize withContentMode:(UIViewContentMode)contentMode allowZoomOut:(BOOL)allowZoomOut {
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

@end

