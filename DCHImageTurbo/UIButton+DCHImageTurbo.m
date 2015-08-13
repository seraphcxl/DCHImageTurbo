//
//  UIButton+DCHImageTurbo.m
//  DCHImageTurbo
//
//  Created by Derek Chen on 7/28/15.
//  Copyright (c) 2015 CHEN. All rights reserved.
//

#import "UIButton+DCHImageTurbo.h"
#import "UIView+DCHImageTurbo.h"
#import <libextobjc/EXTScope.h>
#import "UIImage+DCHImageTurbo.h"

NSString * const key_DCHImageTurbo_UIButton_WebImageURLStorage = @"key_DCHImageTurbo_UIButton_WebImageURLStorage";
NSString * const key_DCHImageTurbo_UIButton_WebBackgroundImageURLStorage = @"key_DCHImageTurbo_UIButton_WebBackgroundImageURLStorage";
NSString * const key_DCHImageTurbo_UIButton_LocalImagePathStorage = @"key_DCHImageTurbo_UIButton_LocalImagePathStorage";
NSString * const key_DCHImageTurbo_UIButton_LocalBackgroundImagePathStorage = @"key_DCHImageTurbo_UIButton_LocalBackgroundImagePathStorage";

NSString * const key_DCHImageTurbo_UIButton_WebImageLoadOperation = @"key_DCHImageTurbo_UIButton_WebImageLoadOperation";
NSString * const key_DCHImageTurbo_UIButton_WebBackgroundImageLoadOperation = @"key_DCHImageTurbo_UIButton_WebBackgroundImageLoadOperation";
NSString * const key_DCHImageTurbo_UIButton_LocalImageLoadOperation = @"key_DCHImageTurbo_UIButton_LocalImageLoadOperation";
NSString * const key_DCHImageTurbo_UIButton_LocalBackgroundImageLoadOperation = @"key_DCHImageTurbo_UIButton_LocalBackgroundImageLoadOperation";

@implementation UIButton (DCHImageTurbo)

- (NSString *)dch_createKeyForButtonLoadImageWithPrefix:(NSString *)prefix andState:(UIControlState)state {
    NSString *result = nil;
    do {
        if (DCH_IsEmpty(prefix)) {
            break;
        }
        result = [NSString stringWithFormat:@"%@%@", prefix, @(state)];
    } while (NO);
    return result;
}

#pragma mark - Web image
- (NSMutableDictionary *)dch_webImageURLStorage {
    NSMutableDictionary *storage = [[self getImageLocationStorage] dch_safe_objectForKey:key_DCHImageTurbo_UIButton_WebImageURLStorage];
    if (!storage) {
        storage = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, &key_DCHImageTurbo_UIButton_WebImageURLStorage, storage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return storage;
}

- (NSURL *)dch_currentWebImageURL {
    NSURL *url = [self dch_webImageURLStorage][@(self.state)];
    
    if (!url) {
        url = [self dch_webImageURLStorage][@(UIControlStateNormal)];
    }
    
    return url;
}

- (NSURL *)dch_webImageURLForState:(UIControlState)state {
    return [self dch_webImageURLStorage][@(state)];
}

- (NSMutableDictionary *)dch_webBackgroundImageURLStorage {
    NSMutableDictionary *storage = [[self getImageLocationStorage] dch_safe_objectForKey:key_DCHImageTurbo_UIButton_WebBackgroundImageURLStorage];
    if (!storage) {
        storage = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, &key_DCHImageTurbo_UIButton_WebBackgroundImageURLStorage, storage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return storage;
}

- (NSURL *)dch_currentWebBackgroundImageURL {
    NSURL *url = [self dch_webImageURLStorage][@(self.state)];
    
    if (!url) {
        url = [self dch_webImageURLStorage][@(UIControlStateNormal)];
    }
    
    return url;
}

- (NSURL *)dch_webBackgroundImageURLForState:(UIControlState)state {
    return [self dch_webImageURLStorage][@(state)];
}

- (void)dch_setWebImageLoadOperation:(id <SDWebImageOperation>)operation forState:(UIControlState)state {
    do {
        if (DCH_IsEmpty(operation)) {
            break;
        }
        [self sd_setImageLoadOperation:operation forKey:[self dch_createKeyForButtonLoadImageWithPrefix:key_DCHImageTurbo_UIButton_WebImageLoadOperation andState:state]];
    } while (NO);
}

- (void)dch_cancelWebImageURLForState:(UIControlState)state {
    [self sd_cancelImageLoadOperationWithKey:[self dch_createKeyForButtonLoadImageWithPrefix:key_DCHImageTurbo_UIButton_WebImageLoadOperation andState:state]];
}

- (void)dch_setWebBackgroundImageLoadOperation:(id <SDWebImageOperation>)operation forState:(UIControlState)state {
    do {
        if (DCH_IsEmpty(operation)) {
            break;
        }
        [self sd_setImageLoadOperation:operation forKey:[self dch_createKeyForButtonLoadImageWithPrefix:key_DCHImageTurbo_UIButton_WebBackgroundImageLoadOperation andState:state]];
    } while (NO);
}

- (void)dch_cancelWebBackgroundImageURLForState:(UIControlState)state {
    [self sd_cancelImageLoadOperationWithKey:[self dch_createKeyForButtonLoadImageWithPrefix:key_DCHImageTurbo_UIButton_WebBackgroundImageLoadOperation andState:state]];
}

#pragma mark - Local image
- (NSMutableDictionary *)dch_localImagePathStorage {
    NSMutableDictionary *storage = [[self getImageLocationStorage] dch_safe_objectForKey:key_DCHImageTurbo_UIButton_LocalImagePathStorage];
    if (!storage) {
        storage = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, &key_DCHImageTurbo_UIButton_LocalImagePathStorage, storage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return storage;
}

- (NSURL *)dch_currentLocalImageURL {
    NSURL *url = [self dch_localImagePathStorage][@(self.state)];
    
    if (!url) {
        url = [self dch_localImagePathStorage][@(UIControlStateNormal)];
    }
    
    return url;
}

- (NSURL *)dch_localImageURLForState:(UIControlState)state {
    return [self dch_localImagePathStorage][@(state)];
}

- (NSMutableDictionary *)dch_localBackgroundImagePathStorage {
    NSMutableDictionary *storage = [[self getImageLocationStorage] dch_safe_objectForKey:key_DCHImageTurbo_UIButton_LocalBackgroundImagePathStorage];
    if (!storage) {
        storage = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, &key_DCHImageTurbo_UIButton_LocalBackgroundImagePathStorage, storage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return storage;
}

- (NSURL *)dch_currentLocalBackgroundImageURL {
    NSURL *url = [self dch_localImagePathStorage][@(self.state)];
    
    if (!url) {
        url = [self dch_localImagePathStorage][@(UIControlStateNormal)];
    }
    
    return url;
}

- (NSURL *)dch_localBackgroundImageURLForState:(UIControlState)state {
    return [self dch_localImagePathStorage][@(state)];
}

- (void)dch_setLocalImageLoadOperation:(id <SDWebImageOperation>)operation forState:(UIControlState)state {
    do {
        if (DCH_IsEmpty(operation)) {
            break;
        }
        [self sd_setImageLoadOperation:operation forKey:[self dch_createKeyForButtonLoadImageWithPrefix:key_DCHImageTurbo_UIButton_LocalImageLoadOperation andState:state]];
    } while (NO);
}

- (void)dch_cancelLocalImageURLForState:(UIControlState)state {
    [self sd_cancelImageLoadOperationWithKey:[self dch_createKeyForButtonLoadImageWithPrefix:key_DCHImageTurbo_UIButton_LocalImageLoadOperation andState:state]];
}

- (void)dch_setLocalBackgroundImageLoadOperation:(id <SDWebImageOperation>)operation forState:(UIControlState)state {
    do {
        if (DCH_IsEmpty(operation)) {
            break;
        }
        [self sd_setImageLoadOperation:operation forKey:[self dch_createKeyForButtonLoadImageWithPrefix:key_DCHImageTurbo_UIButton_LocalBackgroundImageLoadOperation andState:state]];
    } while (NO);
}

- (void)dch_cancelLocalBackgroundImageURLForState:(UIControlState)state {
    [self sd_cancelImageLoadOperationWithKey:[self dch_createKeyForButtonLoadImageWithPrefix:key_DCHImageTurbo_UIButton_LocalBackgroundImageLoadOperation andState:state]];
}

@end
