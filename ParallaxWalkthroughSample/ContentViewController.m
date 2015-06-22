//
//  ContentViewController.m
//  ParallaxWalkthroughSample
//
//  Created by Ryota Iwai on 2015/06/22.
//  Copyright (c) 2015年 RIwai. All rights reserved.
//

#import "ContentViewController.h"

@interface ContentViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.imageView.backgroundColor = [UIColor darkGrayColor];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    CGRect frame = self.view.frame;
    frame.size.width = UIScreen.mainScreen.bounds.size.width;
    self.view.frame = frame;
}

#pragma mark - Setter

- (void)setPageNum:(NSUInteger)pageNum {
    _pageNum = pageNum;
    self.imageView.image = [UIImage imageNamed:@(pageNum).stringValue];
}

#pragma mark - Public

- (void)moveOffset:(CGFloat)offsetX {
    CGPoint offset = CGPointMake(offsetX * 0.4, 0.0);
    self.scrollView.contentOffset = offset;
}

@end
