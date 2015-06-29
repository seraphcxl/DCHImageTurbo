//
//  UIImage+DCHImageTurbo.h
//  DCHImageTurbo
//
//  Created by Derek Chen on 6/28/15.
//  Copyright (c) 2015 CHEN. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const DCHImageTurboKey_ResizeWidth;  // NSNumber
extern NSString * const DCHImageTurboKey_ResizeHeight;  // NSNumber
extern NSString * const DCHImageTurboKey_ResizeScale;  // NSNumber
extern NSString * const DCHImageTurboKey_CornerRadius;  // NSNumber
extern NSString * const DCHImageTurboKey_BorderColor;  // UIColor
extern NSString * const DCHImageTurboKey_BorderWidth;  // NSNumber

@interface UIImage (DCHImageTurbo)

#pragma mark - customize
+ (UIImage *)dch_customizeImage:(UIImage *)image withParams:(NSDictionary *)paramsDic contentMode:(UIViewContentMode)contentMode;

#pragma mark - Decode
+ (UIImage *)dch_decodedImageWithImage:(UIImage *)image;

#pragma mark - GaussianBlur
+ (UIImage *)dch_applyGaussianBlur:(UIImage *)image withRadius:(CGFloat)blurRadius;

#pragma mark - Resize
+ (UIImage *)dch_applyResize:(UIImage *)image toSize:(CGSize)newSize withContentMode:(UIViewContentMode)contentMode allowZoomOut:(BOOL)allowZoomOut;


@end
