//
//  FDPageTableViewCell.m
//  FDPageCollectionViewDemo
//
//  Created by Jason on 2020/4/8.
//  Copyright © 2020 Jason. All rights reserved.
//

#import "FDPageTableViewCell.h"
#import "FDPageCollectionView.h"
#import "FDPageControl.h"

@interface FDPageTableViewCell ()<FDPageCollectionViewDelegate>

@property (nonatomic, strong) FDPageCollectionView *collectionView;
@property (nonatomic, strong) FDPageControl *pageControl;

@end

@implementation FDPageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self setup];
    return self;
}

- (void)setup {
    [self addSubview:self.collectionView];
    [self addSubview:self.pageControl];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(-30);
        make.height.equalTo(@2);
    }];
}

- (void)render:(NSArray *)imgs {
    [self.collectionView render:imgs];
    self.collectionView.scrollEnable = NO;
    self.pageControl.numberOfPages = imgs.count;
    self.pageControl.currentPage = 0;
}

- (void)prepareCollectionVideo {
    [self.collectionView prepareFirstCellVideo];
}

#pragma mark - FDPageCollectionViewDelegate

- (void)pageCollectionViewDidScrollToPage:(NSInteger)indexPage {
    self.pageControl.currentPage = indexPage;
}

#pragma mark - Getter

- (FDPageCollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[FDPageCollectionView alloc] initWithFrame:self.bounds];
        _collectionView.delegate = self;
    }
    return _collectionView;
}

- (FDPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[FDPageControl alloc] init];
    }
    return _pageControl;
}

@end
