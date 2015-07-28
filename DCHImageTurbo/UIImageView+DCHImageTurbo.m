//
//  UIImageView+DCHImageTurbo.m
//  DCHImageTurbo
//
//  Created by Derek Chen on 7/28/15.
//  Copyright (c) 2015 CHEN. All rights reserved.
//

#import "UIImageView+DCHImageTurbo.h"
#import <SDWebImage/UIView+WebCacheOperation.h>

NSString * const key_DCHImageTurbo_UIImageView_imageLoadOperation = @"key_DCHImageTurbo_UIImageView_imageLoadOperation";
NSString * const key_DCHImageTurbo_UIImageView_highlightedImageLoadOperation = @"key_DCHImageTurbo_UIImageView_highlightedImageLoadOperation";

@implementation UIImageView (DCHImageTurbo)

DCH_DEFINE_ASSOCIATEDOBJECT_FOR_CLASS(imageURL, key_DCHImageTurbo_UIImageView_imageURL, OBJC_ASSOCIATION_RETAIN_NONATOMIC)
DCH_DEFINE_ASSOCIATEDOBJECT_FOR_CLASS(highlightedImageURL, key_DCHImageTurbo_UIImageView_highlightedImageURL, OBJC_ASSOCIATION_RETAIN_NONATOMIC)

- (void)dch_setImageLoadOperation:(id)operation {
    do {
        if (DCH_IsEmpty(operation)) {
            break;
        }
        [self sd_setImageLoadOperation:operation forKey:key_DCHImageTurbo_UIImageView_imageLoadOperation];
    } while (NO);
}

- (void)dch_cancelCurrentImageLoadOperation {
    [self sd_cancelImageLoadOperationWithKey:key_DCHImageTurbo_UIImageView_imageLoadOperation];
}

- (void)dch_setHighlightedImageLoadOperation:(id)operation {
    do {
        if (DCH_IsEmpty(operation)) {
            break;
        }
        [self sd_setImageLoadOperation:operation forKey:key_DCHImageTurbo_UIImageView_highlightedImageLoadOperation];
    } while (NO);
}

- (void)dch_cancelCurrentHighlightedImageLoadOperation {
    [self sd_cancelImageLoadOperationWithKey:key_DCHImageTurbo_UIImageView_highlightedImageLoadOperation];
}

@end
