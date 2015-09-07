//
//  ViewController.m
//  DCHImageTurboDemo
//
//  Created by Derek Chen on 6/26/15.
//  Copyright (c) 2015 CHEN. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+DCHImageTurbo.h"
#import "UIImageView+DCHImageTurbo.h"
#import "DCHFileMappingImage.h"
#import "UIImage+DCHImageEffect.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    imgView.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:imgView];
    imgView.frame = CGRectMake(0, 0, 300, 300);
    imgView.center = self.view.center;
    
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(imgView.bounds.size.height * 0.4, imgView.bounds.size.width * 0.2, imgView.bounds.size.height * 0.2, imgView.bounds.size.width * 0.4);
    
    [imgView dch_setImageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"梵高_向日葵" ofType:@"jpg"] placeholderImage:nil customize:^NSDictionary *{
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        [result dch_safe_setObject:@([imgView dch_frameWidth]) forKey:key_DCHImageTurbo_UIImage_ResizeWidth];
        [result dch_safe_setObject:@([imgView dch_frameHeight]) forKey:key_DCHImageTurbo_UIImage_ResizeHeight];
        [result dch_safe_setObject:@([imgView dch_screenScale]) forKey:key_DCHImageTurbo_UIImage_ResizeScale];
        [result dch_safe_setObject:@(24) forKey:key_DCHImageTurbo_UIImage_CornerRadius];
        [result dch_safe_setObject:@(2) forKey:key_DCHImageTurbo_UIImage_BorderWidth];
        [result dch_safe_setObject:[UIColor aquaColor] forKey:key_DCHImageTurbo_UIImage_BorderColor];
        [result dch_safe_setObject:[NSValue valueWithUIEdgeInsets:edgeInsets] forKey:key_DCHImageTurbo_UIImage_BlurEdgeInsets];
        [result dch_safe_setObject:@(8) forKey:key_DCHImageTurbo_UIImage_BlurRadius];
        [result dch_safe_setObject:[UIColor colorWithWhite:0 alpha:0.2] forKey:key_DCHImageTurbo_UIImage_BlurTintColor];
        [result dch_safe_setObject:@(1) forKey:key_DCHImageTurbo_UIImage_BlurSaturationDeltaFactor];
        [result dch_safe_setObject:nil forKey:key_DCHImageTurbo_UIImage_BlurMaskImage];
        return result;
    } completed:^(UIImage *image, NSError *error, NSString *imagePath, NSURL *imageURL, SDImageCacheType cacheType) {
        NSLog(@"%@", image);
    }];
//    [imgView dch_setImageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"梵高_向日葵" ofType:@"jpg"] placeholderImage:nil completed:^(UIImage *image, NSError *error, NSString *imagePath, NSURL *imageURL, SDImageCacheType cacheType) {
//        NSLog(@"%@", image);
//    }];
//    
//    DCHFileMappingImage *img = [DCHFileMappingImage imageWithMappingContentsOfFile:[[NSBundle mainBundle] pathForResource:@"梵高_向日葵" ofType:@"jpg"]];
//    NSLog(@"%@", img);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
