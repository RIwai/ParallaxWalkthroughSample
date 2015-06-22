//
//  ContentViewController.h
//  ParallaxWalkthroughSample
//
//  Created by Ryota Iwai on 2015/06/22.
//  Copyright (c) 2015年 RIwai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentViewController : UIViewController

@property (nonatomic) NSUInteger pageNum;

- (void)moveOffset:(CGFloat)offsetX;

@end
