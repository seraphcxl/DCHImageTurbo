//
//  UIImageView+DCHImageTurbo.h
//  DCHImageTurbo
//
//  Created by Derek Chen on 7/28/15.
//  Copyright (c) 2015 CHEN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Tourbillon/DCHTourbillon.h>

extern NSString * const key_DCHImageTurbo_UIImageView_imageLoadOperation;
extern NSString * const key_DCHImageTurbo_UIImageView_highlightedImageLoadOperation;

@interface UIImageView (DCHImageTurbo)

DCH_DEFINE_ASSOCIATEDOBJECT_FOR_HEADER(imageURL)
DCH_DEFINE_ASSOCIATEDOBJECT_FOR_HEADER(highlightedImageURL)

- (void)dch_setImageLoadOperation:(id)operation;
- (void)dch_cancelCurrentImageLoadOperation;

- (void)dch_setHighlightedImageLoadOperation:(id)operation;
- (void)dch_cancelCurrentHighlightedImageLoadOperation;

@end
