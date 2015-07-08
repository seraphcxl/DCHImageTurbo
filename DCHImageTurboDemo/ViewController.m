//
//  ViewController.m
//  DCHImageTurboDemo
//
//  Created by Derek Chen on 6/26/15.
//  Copyright (c) 2015 CHEN. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+DCHImageTurbo.h"
#import "DCHFileMappingImage.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    [imgView dch_setImageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"梵高_向日葵" ofType:@"jpg"] placeholderImage:nil completed:^(UIImage *image, NSError *error, NSString *imagePath, NSURL *imageURL, SDImageCacheType cacheType) {
        NSLog(@"%@", image);
    }];
    
    DCHFileMappingImage *img = [DCHFileMappingImage imageWithMappingContentsOfFile:[[NSBundle mainBundle] pathForResource:@"梵高_向日葵" ofType:@"jpg"]];
    NSLog(@"%@", img);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
