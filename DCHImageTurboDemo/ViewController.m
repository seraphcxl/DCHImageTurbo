//
//  ViewController.m
//  DCHImageTurboDemo
//
//  Created by Derek Chen on 6/26/15.
//  Copyright (c) 2015 CHEN. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+DCHImageTurbo.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIImageView *imgView = [[UIImageView alloc] init];
    [imgView dch_setImageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"梵高_向日葵" ofType:@"png"] placeholderImage:nil size:CGSizeMake(200, 200) completed:^(UIImage *image, NSError *error, NSString *imagePath, NSURL *imageURL, SDImageCacheType cacheType) {
        int i = 0;
    }];
//    [imgView dch_setImageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"梵高_向日葵" ofType:@"png"] placeholderImage:nil size:CGSizeZero allowZoomOut:NO completed:^(UIImage *image, NSError *error, NSString *imagePath, NSURL *imageURL) {
//        do {
//            ;
//        } while (NO);
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
