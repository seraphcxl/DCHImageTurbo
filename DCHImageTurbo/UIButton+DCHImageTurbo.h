//
//  UIButton+DCHImageTurbo.h
//  DCHImageTurbo
//
//  Created by Derek Chen on 7/28/15.
//  Copyright (c) 2015 CHEN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIView+WebCacheOperation.h>

extern NSString * const key_DCHImageTurbo_UIButton_WebImageURLStorage;
extern NSString * const key_DCHImageTurbo_UIButton_WebBackgroundImageURLStorage;
extern NSString * const key_DCHImageTurbo_UIButton_LocalImagePathStorage;
extern NSString * const key_DCHImageTurbo_UIButton_LocalBackgroundImagePathStorage;

extern NSString * const key_DCHImageTurbo_UIButton_WebImageLoadOperation;
extern NSString * const key_DCHImageTurbo_UIButton_WebBackgroundImageLoadOperation;
extern NSString * const key_DCHImageTurbo_UIButton_LocalImageLoadOperation;
extern NSString * const key_DCHImageTurbo_UIButton_LocalBackgroundImageLoadOperation;

@interface UIButton (DCHImageTurbo)

- (NSString *)dch_createKeyForButtonLoadImageWithPrefix:(NSString *)prefix andState:(UIControlState)state;

#pragma mark - Web image
- (NSMutableDictionary *)dch_webImageURLStorage;
- (NSURL *)dch_currentWebImageURL;
- (NSURL *)dch_webImageURLForState:(UIControlState)state;

- (NSMutableDictionary *)dch_webBackgroundImageURLStorage;
- (NSURL *)dch_currentWebBackgroundImageURL;
- (NSURL *)dch_webBackgroundImageURLForState:(UIControlState)state;

- (void)dch_setWebImageLoadOperation:(id <SDWebImageOperation>)operation forState:(UIControlState)state;
- (void)dch_cancelWebImageURLForState:(UIControlState)state;

- (void)dch_setWebBackgroundImageLoadOperation:(id <SDWebImageOperation>)operation forState:(UIControlState)state;
- (void)dch_cancelWebBackgroundImageURLForState:(UIControlState)state;
//- (NSURL *)dch_currentWebImageURL;
//- (void)dch_setWebImageURL:(NSURL *)url;
//
//- (void)dch_setWebImageLoadOperation:(id)operation;
//- (void)dch_cancelCurrentWebImageLoadOperation;
//
//#pragma mark - Web highlighted image
//- (NSURL *)dch_currentWebHighlightedImageURL;
//- (void)dch_setWebHighlightedImageURL:(NSURL *)url;
//
//- (void)dch_setWebHighlightedImageLoadOperation:(id)operation;
//- (void)dch_cancelCurrentWebHighlightedImageLoadOperation;
//
#pragma mark - Local image
- (NSMutableDictionary *)dch_localImagePathStorage;
- (NSURL *)dch_currentLocalImageURL;
- (NSURL *)dch_localImageURLForState:(UIControlState)state;

- (NSMutableDictionary *)dch_localBackgroundImagePathStorage;
- (NSURL *)dch_currentLocalBackgroundImageURL;
- (NSURL *)dch_localBackgroundImageURLForState:(UIControlState)state;

- (void)dch_setLocalImageLoadOperation:(id <SDWebImageOperation>)operation forState:(UIControlState)state;
- (void)dch_cancelLocalImageURLForState:(UIControlState)state;

- (void)dch_setLocalBackgroundImageLoadOperation:(id <SDWebImageOperation>)operation forState:(UIControlState)state;
- (void)dch_cancelLocalBackgroundImageURLForState:(UIControlState)state;
//- (NSString *)dch_currentLocalImagePath;
//- (void)dch_setLocalImagePath:(NSString *)path;
//
//- (void)dch_setLocalImageLoadOperation:(id)operation;
//- (void)dch_cancelCurrentLocalImageLoadOperation;
//
//#pragma mark - Local highlighted image
//- (NSString *)dch_currentLocalHighlightedImagePath;
//- (void)dch_setLocalHighlightedImagePath:(NSString *)path;
//
//- (void)dch_setLocalHighlightedImageLoadOperation:(id)operation;
//- (void)dch_cancelCurrentLocalHighlightedImageLoadOperation;

@end
