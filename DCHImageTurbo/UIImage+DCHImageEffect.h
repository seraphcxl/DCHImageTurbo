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
+ (instancetype)dch_decodedImageWithImage:(UIImage *)image;

#pragma mark - Resize
+ (instancetype)dch_applyResize:(UIImage *)image toSize:(CGSize)newSize withContentMode:(UIViewContentMode)contentMode allowZoomOut:(BOOL)allowZoomOut;

#pragma mark - Blur
+ (instancetype)dch_applyBlur:(UIImage *)image withRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;

+ (instancetype)dch_applyBlur:(UIImage *)image withRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage didCancel:(BOOL (^)())didCancel;

+ (instancetype)dch_applyBlur:(UIImage *)image forEdgeInsets:(UIEdgeInsets)edgeInsets withRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage didCancel:(BOOL (^)())didCancel;

+ (instancetype)dch_applyGaussianBlur:(UIImage *)image withRadius:(CGFloat)blurRadius;

#pragma mark - image with color
+ (instancetype)dch_imageWithColor:(UIColor *)color size:(CGSize)size;

@end
