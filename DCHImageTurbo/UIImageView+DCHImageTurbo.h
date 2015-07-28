//
//  UIImageView+DCHImageTurbo.h
//  DCHImageTurbo
//
//  Created by Derek Chen on 7/28/15.
//  Copyright (c) 2015 CHEN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (DCHImageTurbo)

#pragma mark - Image
- (NSURL *)dch_imageURL;
#pragma mark - HighlightedImage
- (NSURL *)dch_highlightedImageURL;
@end
