//
//  FDPageControl.m
//  FDPageCollectionViewDemo
//
//  Created by Jason on 2020/4/14.
//  Copyright © 2020 Jason. All rights reserved.
//

#import "FDPageControl.h"

@interface FDPageControl ()

@property (nonatomic , strong) NSMutableArray *controlViewsArray;

@end

@implementation FDPageControl

- (instancetype)init {
    self = [super init];
    [self setup];
    return self;
}

- (void)setup {
    self.numberOfPages = 1;
    self.currentPage = 0;
    self.pageIndicatorTintColor = [UIColor colorWithWhite:1 alpha:0.16];
    self.currentPageIndicatorTintColor = [UIColor colorWithWhite:1 alpha:1];
    
    self.margin = 20;
    self.padding = 4;
    self.height = 2;
}

#pragma mark - Setter

- (void)setNumberOfPages:(NSInteger)numberOfPages {
    _numberOfPages = numberOfPages;
    for (UIView *subviews in self.controlViewsArray) {
        [subviews removeFromSuperview];
    }
    [self.controlViewsArray removeAllObjects];
    self.currentPage = 0;
    if (numberOfPages == 0) {
        return;
    }
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - self.margin * 2 - self.padding * (numberOfPages - 1))/numberOfPages;
    for (int i=0; i<numberOfPages; i++) {
        UIView *controlView = [UIView new];
        if (i <= self.currentPage) {
            controlView.backgroundColor = self.currentPageIndicatorTintColor;
        } else {
            controlView.backgroundColor = self.pageIndicatorTintColor;
        }
        controlView.frame = CGRectMake(self.margin + (width + self.padding)*i, 0, width, self.height);
        [self addSubview:controlView];
        [self.controlViewsArray addObject:controlView];
    }
}

- (void)setCurrentPage:(NSInteger)currentPage {
    _currentPage = currentPage;
    for (int i=0; i<self.controlViewsArray.count; i++) {
        UIView *controlView = self.controlViewsArray[i];
        if (i<=currentPage) {
            controlView.backgroundColor = self.currentPageIndicatorTintColor;
        } else {
            controlView.backgroundColor = self.pageIndicatorTintColor;
        }
    }
}

#pragma mark - Getter

- (NSMutableArray *)controlViewsArray {
    if (!_controlViewsArray) {
        _controlViewsArray = @[].mutableCopy;
    }
    return _controlViewsArray;
}

@end
