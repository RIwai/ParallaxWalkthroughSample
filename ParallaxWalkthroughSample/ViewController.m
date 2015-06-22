//
//  ViewController.m
//  ParallaxWalkthroughSample
//
//  Created by Ryota Iwai on 2015/06/22.
//  Copyright (c) 2015年 RIwai. All rights reserved.
//

#import "ViewController.h"
#import "ContentViewController.h"

typedef NS_ENUM (NSUInteger, ContentsIndex) {
    ContentsIndexLeft = 0,
    ContentsIndexCenter,
    ContentsIndexRight
};

static NSUInteger const kPageCount     = 7;
static NSUInteger const kContentViewCount = 3;

@interface ViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) NSMutableArray *contentsViewControllers;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Init ScrollView
    self.scrollView.pagingEnabled = YES;
    CGRect scrollViewRect = UIScreen.mainScreen.bounds;
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(scrollViewRect) * kContentViewCount,
                                             CGRectGetHeight(scrollViewRect));

    self.contentsViewControllers = @[].mutableCopy;

    CGRect contentsViewRect = CGRectMake(0.0,
                                         0.0,
                                         CGRectGetWidth(scrollViewRect),
                                         CGRectGetHeight(scrollViewRect));

    for (NSUInteger page = 0; page < kContentViewCount; page++) {
        ContentViewController *contentViewController = [[ContentViewController alloc] initWithNibName:@"ContentViewController" bundle:nil];
        contentViewController.view.frame = contentsViewRect;

        contentViewController.pageNum = page;

        [self addChildViewController:contentViewController];
        [self.scrollView addSubview:contentViewController.view];
        [contentViewController didMoveToParentViewController:self];

        [self.contentsViewControllers addObject:contentViewController];

        contentsViewRect.origin.x += CGRectGetWidth(scrollViewRect);
    }

    // Current page => to page 1
    self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(scrollViewRect), 0.0);

    // Append PageControl
    CGRect pageControlRect = CGRectMake(0.0, 0.0, scrollViewRect.size.width, 0.0);
    self.pageControl = [[UIPageControl alloc] initWithFrame:pageControlRect];
    pageControlRect = self.pageControl.frame;
    pageControlRect.origin.y = CGRectGetHeight(scrollViewRect) - CGRectGetHeight(pageControlRect) - 20.0;
    self.pageControl.frame = pageControlRect;
    self.pageControl.numberOfPages = kPageCount;
    self.pageControl.currentPage = 1;
    [self.view addSubview:self.pageControl];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    self.scrollView.frame = self.view.frame;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (NSUInteger)leftPageNumberWithCenterPageNumber:(NSUInteger)centerPageNumber {
    if (centerPageNumber == 0) {
        return kContentViewCount - 1;
    }
    return centerPageNumber - 1;
}

- (NSUInteger)rightPageNumberWithCenterPageNumber:(NSUInteger)centerPageNumber {
    NSUInteger maxPageNum = kContentViewCount - 1;
    if (centerPageNumber == maxPageNum) {
        return 0;
    }
    return centerPageNumber + 1;
}

- (void)renumberingByCenterContetnsPageNum {
    ContentViewController *centerController = self.contentsViewControllers[ContentsIndexCenter];
    NSUInteger centerPageNum = centerController.pageNum;

    ContentViewController *leftController = self.contentsViewControllers[ContentsIndexLeft];
    leftController.pageNum = [self leftPageNumberWithCenterPageNumber:centerPageNum];

    ContentViewController *rightController = self.contentsViewControllers[ContentsIndexRight];
    rightController.pageNum = [self rightPageNumberWithCenterPageNumber:centerPageNum];

    self.pageControl.currentPage = centerPageNum;
}

- (void)moveContetnsOrder {
    CGRect scrollViewRect = self.scrollView.frame;
    CGPoint offset = self.scrollView.contentOffset;
    NSInteger currentPageNum = (NSInteger)offset.x / CGRectGetWidth(scrollViewRect);

    if (currentPageNum == 0) {
        // Shifts the position of the contents
        // Left => Center
        ContentViewController *contentViewController0 = self.contentsViewControllers[ContentsIndexLeft];
        CGRect page0Rect = contentViewController0.view.frame;
        page0Rect.origin.x = CGRectGetWidth(scrollViewRect);
        contentViewController0.view.frame = page0Rect;

        // Move ScrollView contentOffset to center page without animation
        self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(scrollViewRect), 0.0);

        // Shifts the position of the contents
        // Center => Right
        ContentViewController *contentViewController1 = self.contentsViewControllers[ContentsIndexCenter];
        CGRect page1Rect = contentViewController1.view.frame;
        page1Rect.origin.x = CGRectGetWidth(scrollViewRect) * 2.0;
        contentViewController1.view.frame = page1Rect;

        // Right　=> Left
        ContentViewController *contentViewController2 = self.contentsViewControllers[ContentsIndexRight];
        CGRect page2Rect = contentViewController2.view.frame;
        page2Rect.origin.x = 0.0;
        contentViewController2.view.frame = page2Rect;
        // Renumber of page number
        NSInteger nextPageNum = contentViewController0.pageNum;
        if (nextPageNum == 0) {
            contentViewController2.pageNum = kPageCount - 1;
        } else {
            contentViewController2.pageNum = nextPageNum - 1;
        }

        // Remove from Array
        [self.contentsViewControllers removeObject:contentViewController2];
        // Append Array's top
        [self.contentsViewControllers insertObject:contentViewController2 atIndex:0];
    } else if (currentPageNum == 2) {
        // Shifts the position of the contents
        // Right => Center
        ContentViewController *contentViewController2 = self.contentsViewControllers[ContentsIndexRight];
        CGRect page2Rect = contentViewController2.view.frame;
        page2Rect.origin.x = CGRectGetWidth(scrollViewRect);
        contentViewController2.view.frame = page2Rect;

        //  Move ScrollView contentOffset to center page without animation
        self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(scrollViewRect), 0.0);

        // Center => Left
        ContentViewController *contentViewController1 = self.contentsViewControllers[ContentsIndexCenter];
        CGRect page1Rect = contentViewController1.view.frame;
        page1Rect.origin.x = 0.0;
        contentViewController1.view.frame = page1Rect;

        // Left => Right
        ContentViewController *contentViewController0 = self.contentsViewControllers[ContentsIndexLeft];
        CGRect page0Rect = contentViewController0.view.frame;
        page0Rect.origin.x = CGRectGetWidth(scrollViewRect) * 2.0;
        contentViewController0.view.frame = page0Rect;

        // Renumber of page number
        NSInteger prevPageNum = contentViewController2.pageNum;
        if (prevPageNum + 1 >= kPageCount) {
            contentViewController0.pageNum = 0;
        } else {
            contentViewController0.pageNum = prevPageNum + 1;
        }

        // Remove from Array
        [self.contentsViewControllers removeObject:contentViewController0];
        // Append Array's last
        [self.contentsViewControllers addObject:contentViewController0];
    }

    ContentViewController *centerController = self.contentsViewControllers[ContentsIndexCenter];
    self.pageControl.currentPage = centerController.pageNum;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.scrollView != scrollView) {
        return;
    }
    CGFloat offsetX = self.scrollView.contentOffset.x;
    CGFloat offsetMaxX = offsetX + self.scrollView.frame.size.width;

    for (NSUInteger page = 0; page < kContentViewCount; page++) {
        ContentViewController *contentViewController = self.contentsViewControllers[page];
        CGRect contentViewRect = contentViewController.view.frame;

        if (offsetX > CGRectGetMinX(contentViewRect) && offsetX < CGRectGetMaxX(contentViewRect)) {
            [contentViewController moveOffset:CGRectGetMinX(contentViewRect) - offsetX];
        } else if (offsetX < CGRectGetMinX(contentViewRect) && offsetMaxX > CGRectGetMinX(contentViewRect)) {
            [contentViewController moveOffset:(CGRectGetMinX(contentViewRect) - offsetX)];
        } else {
            [contentViewController moveOffset:0];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.scrollView != scrollView) {
        return;
    }
    [self moveContetnsOrder];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (self.scrollView != scrollView) {
        return;
    }
    [self moveContetnsOrder];
}

@end
