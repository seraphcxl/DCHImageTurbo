//
//  DCHFileMappingImage.h
//  DCHImageTurbo
//
//  Created by Derek Chen on 6/29/15.
//  Copyright © 2015 CHEN. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DCHFileMappingImageType) {
    DCHFileMappingImageType_PNG,
    DCHFileMappingImageType_JPG_JPEG,
};

@interface DCHFileMappingImage : UIImage

+ (nullable DCHFileMappingImage *)imageWithMappingContentsOfFile:(nullable NSString *)path withType:(DCHFileMappingImageType)type;

- (nullable instancetype)initWithMappingContentsOfFile:(nullable NSString *)path withType:(DCHFileMappingImageType)type;

@end
