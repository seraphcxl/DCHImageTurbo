//
//  UIImageView+DCHImageTurbo.h
//  DCHImageTurbo
//
//  Created by Derek Chen on 6/25/15.
//  Copyright (c) 2015 CHEN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIImageView+HighlightedWebCache.h>

@interface UIImageView (DCHImageTurbo)

- (NSString *)dch_imageSignatureWithSize:(CGSize)size andScale:(CGFloat)scale;

#pragma mark - Image
/**
 * Get the current image URL.
 */
- (NSURL *)dch_imageURL;

/**
 * Set the imageView `image` with an `url`, placeholder and custom options.
 *
 * The download is asynchronous and cached.
 *
 * @param url            The url for the image.
 * @param placeholder    The image to be set initially, until the image request finishes.
 * @param imageSize      size of image you wanted.
 * @param completedBlock A block called when operation has been completed. This block has no return value
 *                       and takes the requested UIImage as first parameter. In case of error the image parameter
 *                       is nil and the second parameter may contain an NSError. The third parameter is a Boolean
 *                       indicating if the image was retrived from the local cache or from the network.
 *                       The fourth parameter is the original image url.
 */
- (void)dch_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder size:(CGSize)imageSize completed:(SDWebImageCompletionBlock)completedBlock;

/**
 * Set the imageView `image` with an `url`, placeholder and custom options.
 *
 * The download is asynchronous and cached.
 *
 * @param url            The url for the image.
 * @param placeholder    The image to be set initially, until the image request finishes.
 * @param imageSize      size of image you wanted.
 * @param allowZoomOut   allow to zoom out image to imageSize.
 * @param options        The options to use when downloading the image. @see SDWebImageOptions for the possible values.
 * @param progressBlock  A block called while image is downloading
 * @param completedBlock A block called when operation has been completed. This block has no return value
 *                       and takes the requested UIImage as first parameter. In case of error the image parameter
 *                       is nil and the second parameter may contain an NSError. The third parameter is a Boolean
 *                       indicating if the image was retrived from the local cache or from the network.
 *                       The fourth parameter is the original image url.
 */
- (void)dch_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder size:(CGSize)imageSize allowZoomOut:(BOOL)allowZoomOut options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock;

/**
 * Cancel the current image download
 */
- (void)dch_cancelCurrentImageLoad;

#pragma mark - HighlightedImage
/**
 * Get the current highlighted image URL.
 */
- (NSURL *)dch_highlightedImageURL;

/**
 * Set the imageView `image` with an `url`, placeholder and custom options.
 *
 * The download is asynchronous and cached.
 *
 * @param url            The url for the image.
 * @param imageSize      size of image you wanted.
 * @param completedBlock A block called when operation has been completed. This block has no return value
 *                       and takes the requested UIImage as first parameter. In case of error the image parameter
 *                       is nil and the second parameter may contain an NSError. The third parameter is a Boolean
 *                       indicating if the image was retrived from the local cache or from the network.
 *                       The fourth parameter is the original image url.
 */
- (void)dch_setHighlightedImageWithURL:(NSURL *)url size:(CGSize)imageSize completed:(SDWebImageCompletionBlock)completedBlock;

/**
 * Set the imageView `image` with an `url`, placeholder and custom options.
 *
 * The download is asynchronous and cached.
 *
 * @param url            The url for the image.
 * @param imageSize      size of image you wanted.
 * @param allowZoomOut   allow to zoom out image to imageSize.
 * @param options        The options to use when downloading the image. @see SDWebImageOptions for the possible values.
 * @param progressBlock  A block called while image is downloading
 * @param completedBlock A block called when operation has been completed. This block has no return value
 *                       and takes the requested UIImage as first parameter. In case of error the image parameter
 *                       is nil and the second parameter may contain an NSError. The third parameter is a Boolean
 *                       indicating if the image was retrived from the local cache or from the network.
 *                       The fourth parameter is the original image url.
 */
- (void)dch_setHighlightedImageWithURL:(NSURL *)url size:(CGSize)imageSize allowZoomOut:(BOOL)allowZoomOut options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock;

/**
 * Cancel the current highlighted image download
 */
- (void)dch_cancelCurrentHighlightedImageLoad;

@end
