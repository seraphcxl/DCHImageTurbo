//
//  DCHFileMappingImage.h
//  DCHImageTurbo
//
//  Created by Derek Chen on 6/29/15.
//  Copyright © 2015 CHEN. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DCHFileMappingImageType) {
    DCHFileMappingImageType_None,
    DCHFileMappingImageType_PNG,
    DCHFileMappingImageType_JPG_JPEG,
};

@interface DCHFileMappingImage : UIImage

+ (nullable DCHFileMappingImage *)imageWithMappingContentsOfFile:(nullable NSString *)path;

- (nullable instancetype)initWithMappingContentsOfFile:(nullable NSString *)path;

@end
