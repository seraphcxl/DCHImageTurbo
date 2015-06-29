//
//  DCHFileMappingImage.m
//  DCHImageTurbo
//
//  Created by Derek Chen on 6/29/15.
//  Copyright © 2015 CHEN. All rights reserved.
//

#import "DCHFileMappingImage.h"
#import <Tourbillon/DCHTourbillon.h>
#import <sys/mman.h>

@interface DCHFileMappingImage ()

@property (nonatomic, assign) int fileDescriptor;
@property (nonatomic, assign) off_t fileLength;
@property (nonatomic, assign) void *bytes;

@end

@implementation DCHFileMappingImage

static void DCHFileMappingImageReleaseImageData(void *info, const void *data, size_t size) {
    if (info) {
        CFRelease(info);
    }
}

+ (nullable DCHFileMappingImage *)imageWithMappingContentsOfFile:(nullable NSString *)path withType:(DCHFileMappingImageType)type {
    return [[DCHFileMappingImage alloc] initWithMappingContentsOfFile:path withType:type];
}

- (void)dealloc {
    if (self.bytes != NULL) {
        munmap(self.bytes, (size_t)self.fileLength);
        self.bytes = NULL;
        self.fileLength = 0;
    }
    if (self.fileDescriptor >= 0) {
        close(self.fileDescriptor);
        self.fileDescriptor = -1;
    }
}

- (nullable instancetype)initWithMappingContentsOfFile:(nullable NSString *)path withType:(DCHFileMappingImageType)type {
    if (DCH_IsEmpty(path)) {
        return nil;
    }
    self.fileDescriptor = -1;
    self.fileLength = 0;
    CGDataProviderRef dataProvider = NULL;
    CGImageRef imageRef = NULL;
    do {
        self.fileDescriptor = open([path fileSystemRepresentation], (O_RDWR | O_CREAT), 0666);
        if (self.fileDescriptor < 0) {
            break;
        }
        self.fileLength = lseek(self.fileDescriptor, 0, SEEK_END);
        self.bytes = mmap(NULL, (size_t)self.fileLength, (PROT_READ|PROT_WRITE), (MAP_FILE|MAP_SHARED), self.fileDescriptor, 0);
        
        dataProvider = CGDataProviderCreateWithData(NULL, self.bytes, (size_t)self.fileLength, DCHFileMappingImageReleaseImageData);
        switch (type) {
            case DCHFileMappingImageType_PNG:
            {
                imageRef = CGImageCreateWithPNGDataProvider(dataProvider, NULL, YES, kCGRenderingIntentDefault);
            }
                break;
            case DCHFileMappingImageType_JPG_JPEG:
            {
                imageRef = CGImageCreateWithJPEGDataProvider(dataProvider, NULL, YES, kCGRenderingIntentDefault);
            }
                break;
            default:
                break;
        }
        if (imageRef == NULL) {
            break;
        }
        self = [self initWithCGImage:imageRef];
    } while (NO);
    if (imageRef) {
        CGImageRelease(imageRef);
        imageRef = NULL;
    }
    if (dataProvider) {
        CGDataProviderRelease(dataProvider);
        dataProvider = NULL;
    }
    return self;
}

@end
