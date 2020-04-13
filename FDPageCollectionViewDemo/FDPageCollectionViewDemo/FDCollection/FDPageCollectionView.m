//
//  FDPageCollectionView.m
//  FDPageCollectionViewDemo
//
//  Created by Jason on 2020/4/8.
//  Copyright © 2020 Jason. All rights reserved.
//

#import "FDPageCollectionView.h"
#import "FDHorizontalCollectionViewFlowLayout.h"
#import <AudioToolbox/AudioToolbox.h>
#import "FDDemoCollectionViewCell.h"

#define BARandomColor      [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0f];

@interface FDPageCollectionView ()<UICollectionViewDelegate ,UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *touchView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@end

@implementation FDPageCollectionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    return self;
}

- (void)render:(NSArray *)imgs {
    [self.collectionView removeFromSuperview];
    self.collectionView = nil;
    self.dataArray = imgs.mutableCopy;
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)prepareFirstCellVideo {
    [self playCurrentCellVideo];
}

#pragma mark -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FDDemoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FDDemoCollectionViewCell class]) forIndexPath:indexPath];
    [cell render:self.dataArray[indexPath.row]];
    cell.backgroundColor = BARandomColor;
    return cell;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self playCurrentCellVideo];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self playCurrentCellVideo];
}

- (void)playCurrentCellVideo {
    NSInteger index = self.collectionView.contentOffset.x/self.collectionView.frame.size.width;
    FDDemoCollectionViewCell *cell = (FDDemoCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    if (cell) {
        [cell prepareVideo];
    }
}

- (void)handleTouchView:(UITapGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint point = [recognizer locationInView:recognizer.view];
        NSInteger index = self.collectionView.contentOffset.x/self.collectionView.frame.size.width;
        NSInteger baseWidth = self.collectionView.frame.size.width;
        if ((NSInteger)point.x % baseWidth < recognizer.view.center.x/2) {  // left
            if (index == 0) {
                [self sheek];
                return;
            }
            index--;
        } else { // right
            if (index >= self.dataArray.count-1) {
                [self sheek];
                return;
            }
            index++;
        }
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    }
}

- (void)sheek {
    if (@available(iOS 11.0, *)) {
        UIImpactFeedbackGenerator *feedBackGenertor = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
        [feedBackGenertor impactOccurred];
     }
}

#pragma mark - Setter

- (void)setScrollEnable:(BOOL)scrollEnable {
    _scrollEnable = scrollEnable;
    self.collectionView.userInteractionEnabled = scrollEnable;
    if (!_scrollEnable) {
        [self.touchView removeFromSuperview];
        self.touchView = nil;
        [self addSubview:self.touchView];
        [self.touchView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    } else {
        if (self.touchView.superview) {
            [self.touchView removeFromSuperview];
        }
    }
}

#pragma mark - Getter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        FDHorizontalCollectionViewFlowLayout *layout = [[FDHorizontalCollectionViewFlowLayout alloc]initWithRowCount:1 itemCountPerRow:1];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.bounces = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[FDDemoCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([FDDemoCollectionViewCell class])];
        [_collectionView addGestureRecognizer:self.tapGestureRecognizer];
    }
    return _collectionView;
}

- (UIView *)touchView {
    if (!_touchView) {
        _touchView = [UIView new];
        _touchView.backgroundColor = [UIColor clearColor];
        _touchView.userInteractionEnabled = YES;
        [_touchView addGestureRecognizer:self.tapGestureRecognizer];
    }
    return _touchView;
}

- (UITapGestureRecognizer *)tapGestureRecognizer {
    if (!_tapGestureRecognizer) {
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTouchView:)];
    }
    return _tapGestureRecognizer;
}

@end
