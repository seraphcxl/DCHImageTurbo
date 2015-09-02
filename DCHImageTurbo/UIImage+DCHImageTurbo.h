//
//  UIImage+DCHImageTurbo.h
//  DCHImageTurbo
//
//  Created by Derek Chen on 6/28/15.
//  Copyright (c) 2015 CHEN. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const key_DCHImageTurbo_UIImage_ResizeWidth;  // NSNumber
extern NSString * const key_DCHImageTurbo_UIImage_ResizeHeight;  // NSNumber
extern NSString * const key_DCHImageTurbo_UIImage_ResizeScale;  // NSNumber
extern NSString * const key_DCHImageTurbo_UIImage_CornerRadius;  // NSNumber
extern NSString * const key_DCHImageTurbo_UIImage_BorderColor;  // UIColor
extern NSString * const key_DCHImageTurbo_UIImage_BorderWidth;  // NSNumber
extern NSString * const key_DCHImageTurbo_UIImage_BlurRatioRect;  // DCHImageBlurRatioRect
extern NSString * const key_DCHImageTurbo_UIImage_BlurRadius;  // NSNumber
extern NSString * const key_DCHImageTurbo_UIImage_BlurTintColor;  // UIColor
extern NSString * const key_DCHImageTurbo_UIImage_BlurSaturationDeltaFactor;  // NSNumber
extern NSString * const key_DCHImageTurbo_UIImage_BlurMaskImage;  // UIImage

@interface UIImage (DCHImageTurbo)

#pragma mark - customize
+ (instancetype)dch_customizeImage:(UIImage *)image withParams:(NSDictionary *)paramsDic contentMode:(UIViewContentMode)contentMode;

+ (NSString *)dch_layerContentsGravityFromViewContentMode:(UIViewContentMode)viewContentMode;

+ (NSString *)dch_imageSignature:(NSDictionary *)dic;

@end
