//
//  DCHLoadLocalImageOperation.m
//  DCHImageTurbo
//
//  Created by Derek Chen on 6/26/15.
//  Copyright (c) 2015 CHEN. All rights reserved.
//

#import "DCHLoadLocalImageOperation.h"

@interface DCHLoadLocalImageOperation ()

@property (nonatomic, assign) BOOL isCanceled;

@end

@implementation DCHLoadLocalImageOperation

- (void)dealloc {
    self.actionBlock = nil;
}

- (void)cancel {
    self.isCanceled = YES;
}

- (void)execute {
    if (self.actionBlock) {
        self.actionBlock(self);
    }
}

@end
