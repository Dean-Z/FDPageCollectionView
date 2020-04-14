//
//  FDPageControl.h
//  FDPageCollectionViewDemo
//
//  Created by Jason on 2020/4/14.
//  Copyright © 2020 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FDPageControl : UIView

@property(nonatomic) NSInteger numberOfPages;
@property(nonatomic) NSInteger currentPage;

@property(nullable, nonatomic,strong) UIColor *pageIndicatorTintColor;
@property(nullable, nonatomic,strong) UIColor *currentPageIndicatorTintColor;

@property(nonatomic) CGFloat margin;
@property(nonatomic) CGFloat padding;
@property(nonatomic) CGFloat height;

@end
