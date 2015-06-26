//
//  DCHLoadLocalImageOperation.h
//  DCHImageTurbo
//
//  Created by Derek Chen on 6/26/15.
//  Copyright (c) 2015 CHEN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SDWebImage/SDWebImageOperation.h>

@class DCHLoadLocalImageOperation;

typedef void(^DCHLoadLocalImageActionBlock)(DCHLoadLocalImageOperation *operation);

@interface DCHLoadLocalImageOperation : NSObject <SDWebImageOperation>

@property (nonatomic, copy) DCHLoadLocalImageActionBlock actionBlock;
@property (nonatomic, assign, readonly) BOOL isCanceled;

- (void)execute;

@end
