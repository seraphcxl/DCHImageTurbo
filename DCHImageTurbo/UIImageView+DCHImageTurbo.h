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
#import "UIView+DCHImageTurbo.h"

@interface UIImageView (DCHImageTurbo)

- (void)dch_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder customize:(DCHImageTurboCustomizeBlock)customizeBlock options:(SDWebImageOptions)options uiAction:(DCHImageTurboUIActionBlock)uiActionBlock progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(DCHImageTurboLoadImageCompletionBlock)completedBlock;
- (void)dch_setImageWithContentsOfFile:(NSString *)path placeholderImage:(UIImage *)placeholder customize:(DCHImageTurboCustomizeBlock)customizeBlock uiAction:(DCHImageTurboUIActionBlock)uiActionBlock completed:(DCHImageTurboLoadImageCompletionBlock)completedBlock;

#pragma mark - Image
/**
 * Cancel the current image download
 */
- (void)dch_cancelCurrentImageLoad;

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
 * @param completedBlock A block called when operation has been completed. This block has no return value
 *                       and takes the requested UIImage as first parameter. In case of error the image parameter
 *                       is nil and the second parameter may contain an NSError. The third parameter is a Boolean
 *                       indicating if the image was retrived from the local cache or from the network.
 *                       The fourth parameter is the original image url.
 */
- (void)dch_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(DCHImageTurboLoadImageCompletionBlock)completedBlock;

/**
 * Set the imageView `image` with an `url`, placeholder and custom options.
 *
 * The download is asynchronous and cached.
 *
 * @param url            The url for the image.
 * @param placeholder    The image to be set initially, until the image request finishes.
 * @param cornerRadius   cornerRadius of image you wanted.
 * @param borderWidth    borderWidth of image you wanted.
 * @param borderColor    borderColor of image you wanted.
 * @param completedBlock A block called when operation has been completed. This block has no return value
 *                       and takes the requested UIImage as first parameter. In case of error the image parameter
 *                       is nil and the second parameter may contain an NSError. The third parameter is a Boolean
 *                       indicating if the image was retrived from the local cache or from the network.
 *                       The fourth parameter is the original image url.
 */
- (void)dch_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor completed:(DCHImageTurboLoadImageCompletionBlock)completedBlock;

/**
 * Set the imageView `image` with an `url`, placeholder and custom options.
 *
 * The download is asynchronous and cached.
 *
 * @param url            The url for the image.
 * @param placeholder    The image to be set initially, until the image request finishes.
 * @param customizeBlock customizeBlock
 * @param options        The options to use when downloading the image. @see SDWebImageOptions for the possible values.
 * @param progressBlock  A block called while image is downloading
 * @param completedBlock A block called when operation has been completed. This block has no return value
 *                       and takes the requested UIImage as first parameter. In case of error the image parameter
 *                       is nil and the second parameter may contain an NSError. The third parameter is a Boolean
 *                       indicating if the image was retrived from the local cache or from the network.
 *                       The fourth parameter is the original image url.
 */
- (void)dch_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder customize:(DCHImageTurboCustomizeBlock)customizeBlock options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(DCHImageTurboLoadImageCompletionBlock)completedBlock;


/**
 * Get the current image path.
 */
- (NSURL *)dch_imagePath;

/**
 * Set the imageView `image` with an `path`.
 *
 * @param path           The path for the image.
 * @param placeholder    The image to be set initially, until the image request finishes.
 * @param allowZoomOut   allow to zoom out image to imageSize.
 * @param completedBlock A block called when operation has been completed. This block has no return value
 *                       and takes the requested UIImage as first parameter. In case of error the image parameter
 *                       is nil and the second parameter may contain an NSError. The third parameter is the original image path.
 *                       The fourth parameter is the original image url.
 */
- (void)dch_setImageWithContentsOfFile:(NSString *)path placeholderImage:(UIImage *)placeholder completed:(DCHImageTurboLoadImageCompletionBlock)completedBlock;

- (void)dch_setImageWithContentsOfFile:(NSString *)path placeholderImage:(UIImage *)placeholder cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor completed:(DCHImageTurboLoadImageCompletionBlock)completedBlock;

- (void)dch_setImageWithContentsOfFile:(NSString *)path placeholderImage:(UIImage *)placeholder customize:(DCHImageTurboCustomizeBlock)customizeBlock options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(DCHImageTurboLoadImageCompletionBlock)completedBlock;

#pragma mark - HighlightedImage
/**
 * Cancel the current highlighted image download
 */
- (void)dch_cancelCurrentHighlightedImageLoad;

/**
 * Get the current highlighted image URL.
 */
- (NSURL *)dch_highlightedImageURL;

/**
 * Set the imageView `highlighted image` with an `url`, placeholder and custom options.
 *
 * The download is asynchronous and cached.
 *
 * @param url            The url for the image.
 * @param placeholder    The image to be set initially, until the image request finishes.
 * @param customizeBlock customizeBlock
 * @param options        The options to use when downloading the image. @see SDWebImageOptions for the possible values.
 * @param progressBlock  A block called while image is downloading
 * @param completedBlock A block called when operation has been completed. This block has no return value
 *                       and takes the requested UIImage as first parameter. In case of error the image parameter
 *                       is nil and the second parameter may contain an NSError. The third parameter is a Boolean
 *                       indicating if the image was retrived from the local cache or from the network.
 *                       The fourth parameter is the original image url.
 */
- (void)dch_setHighlightedImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder customize:(DCHImageTurboCustomizeBlock)customizeBlock options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(DCHImageTurboLoadImageCompletionBlock)completedBlock;

/**
 * Get the current highlighted image path.
 */
- (NSURL *)dch_HighlightedImagePath;

/**
 * Set the imageView `highlighted image` with an `path`.
 *
 * @param path           The path for the image.
 * @param placeholder    The image to be set initially, until the image request finishes.
 * @param imageSize      size of image you wanted.
 * @param allowZoomOut   allow to zoom out image to imageSize.
 * @param completedBlock A block called when operation has been completed. This block has no return value
 *                       and takes the requested UIImage as first parameter. In case of error the image parameter
 *                       is nil and the second parameter may contain an NSError. The third parameter is the original image path.
 *                       The fourth parameter is the original image url.
 */
- (void)dch_setHighlightedImageWithContentsOfFile:(NSString *)path placeholderImage:(UIImage *)placeholder customize:(DCHImageTurboCustomizeBlock)customizeBlock options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(DCHImageTurboLoadImageCompletionBlock)completedBlock;

@end
