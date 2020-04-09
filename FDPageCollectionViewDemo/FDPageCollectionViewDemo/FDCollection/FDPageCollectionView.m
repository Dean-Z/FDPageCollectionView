//
//  FDPageCollectionView.m
//  FDPageCollectionViewDemo
//
//  Created by Jason on 2020/4/8.
//  Copyright © 2020 Jason. All rights reserved.
//

#import "FDPageCollectionView.h"
#import "FDHorizontalCollectionViewFlowLayout.h"
#import "FDDemoCollectionViewCell.h"

#define BARandomColor      [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0f];

@interface FDPageCollectionView ()<UICollectionViewDelegate ,UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation FDPageCollectionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

- (void)setup {}

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
    }
    return _collectionView;
}

@end
