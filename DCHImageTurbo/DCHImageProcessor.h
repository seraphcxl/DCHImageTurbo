//
//  DCHImageProcessor.h
//  DCHImageTurbo
//
//  Created by Derek Chen on 6/5/15.
//  Copyright (c) 2015 Derek Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern NSString * const DCHImageTurboKey_ResizeWidth;  // NSNumber
extern NSString * const DCHImageTurboKey_ResizeHeight;  // NSNumber
extern NSString * const DCHImageTurboKey_ResizeScale;  // NSNumber
extern NSString * const DCHImageTurboKey_CornerRadius;  // NSNumber
extern NSString * const DCHImageTurboKey_BorderColor;  // UIColor
extern NSString * const DCHImageTurboKey_BorderWidth;  // NSNumber

//typedef void(^DCHImageProcessCompletionBlock)(NSString *UUID, UIImage *originalImage, UIImage *image, NSDictionary *info, NSError *error);
//
//@interface DCHImageProcessOperation : NSOperation
//
//@property (nonatomic, strong, readonly) NSString *UUID;
//@property (nonatomic, strong, readonly) UIImage *originalImage;
//@property (nonatomic, copy) DCHImageProcessCompletionBlock completion;
//
//- (instancetype)initWithImage:(UIImage *)image;
//
//@end
//
//@interface DCHImageGaussianBlurOperation : DCHImageProcessOperation
//
//- (instancetype)initWithImage:(UIImage *)image;
//
//@end

@interface DCHImageProcessor : NSObject

+ (UIImage *)customizeImage:(UIImage *)image withParams:(NSDictionary *)paramsDic contentMode:(UIViewContentMode)contentMode;

#pragma mark - GaussianBlur
+ (NSOperationQueue *)sharedGaussianBlurQueue;
+ (UIImage *)applyGaussianBlur:(UIImage *)image withRadius:(CGFloat)blurRadius;

#pragma mark - Resize
+ (NSOperationQueue *)sharedResizeQueue;
+ (UIImage *)applyResize:(UIImage *)image toSize:(CGSize)newSize withContentMode:(UIViewContentMode)contentMode allowZoomOut:(BOOL)allowZoomOut;

@end
