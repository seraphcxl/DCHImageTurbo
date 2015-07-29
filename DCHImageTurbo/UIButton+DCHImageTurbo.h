//
//  UIButton+DCHImageTurbo.h
//  DCHImageTurbo
//
//  Created by Derek Chen on 7/28/15.
//  Copyright (c) 2015 CHEN. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const key_DCHImageTurbo_UIButton_WebImageURL;
extern NSString * const key_DCHImageTurbo_UIButton_WebHighlightedImageURL;
extern NSString * const key_DCHImageTurbo_UIButton_LocalImagePath;
extern NSString * const key_DCHImageTurbo_UIButton_LocalHighlightedImagePath;

extern NSString * const key_DCHImageTurbo_UIButton_WebImageLoadOperation;
extern NSString * const key_DCHImageTurbo_UIButton_WebHighlightedImageLoadOperation;
extern NSString * const key_DCHImageTurbo_UIButton_LocalImageLoadOperation;
extern NSString * const key_DCHImageTurbo_UIButton_LocalHighlightedImageLoadOperation;

@interface UIButton (DCHImageTurbo)

#pragma mark - Web image
- (NSURL *)dch_currentWebImageURL;
- (void)dch_setWebImageURL:(NSURL *)url;

- (void)dch_setWebImageLoadOperation:(id)operation;
- (void)dch_cancelCurrentWebImageLoadOperation;

#pragma mark - Web highlighted image
- (NSURL *)dch_currentWebHighlightedImageURL;
- (void)dch_setWebHighlightedImageURL:(NSURL *)url;

- (void)dch_setWebHighlightedImageLoadOperation:(id)operation;
- (void)dch_cancelCurrentWebHighlightedImageLoadOperation;

#pragma mark - Local image
- (NSString *)dch_currentLocalImagePath;
- (void)dch_setLocalImagePath:(NSString *)path;

- (void)dch_setLocalImageLoadOperation:(id)operation;
- (void)dch_cancelCurrentLocalImageLoadOperation;

#pragma mark - Local highlighted image
- (NSString *)dch_currentLocalHighlightedImagePath;
- (void)dch_setLocalHighlightedImagePath:(NSString *)path;

- (void)dch_setLocalHighlightedImageLoadOperation:(id)operation;
- (void)dch_cancelCurrentLocalHighlightedImageLoadOperation;

@end
