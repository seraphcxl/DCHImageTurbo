//
//  UIImage+DCHImageEffect.h
//  DCHImageTurbo
//
//  Created by Derek Chen on 7/28/15.
//  Copyright (c) 2015 CHEN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (DCHImageEffect)

#pragma mark - Decode
+ (UIImage *)dch_decodedImageWithImage:(UIImage *)image;

#pragma mark - Resize
+ (UIImage *)dch_applyResize:(UIImage *)image toSize:(CGSize)newSize withContentMode:(UIViewContentMode)contentMode allowZoomOut:(BOOL)allowZoomOut;

#pragma mark - Blur
+ (UIImage *)dch_applyBlur:(UIImage *)image withRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;

+ (UIImage *)dch_applyBlur:(UIImage *)image withRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage didCancel:(BOOL (^)())didCancel;

+ (UIImage *)dch_applyGaussianBlur:(UIImage *)image withRadius:(CGFloat)blurRadius;

@end
