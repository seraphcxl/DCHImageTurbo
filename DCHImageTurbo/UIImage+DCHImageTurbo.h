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

+ (NSString *)layerContentsGravityFromViewContentMode:(UIViewContentMode)viewContentMode;

@end
