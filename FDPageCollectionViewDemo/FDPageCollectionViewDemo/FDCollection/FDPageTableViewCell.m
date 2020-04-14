//
//  FDPageTableViewCell.m
//  FDPageCollectionViewDemo
//
//  Created by Jason on 2020/4/8.
//  Copyright © 2020 Jason. All rights reserved.
//

#import "FDPageTableViewCell.h"
#import "FDPageCollectionView.h"
#import "FDTagGroupView.h"
#import "FDPageControl.h"

@interface FDPageTableViewCell ()<FDPageCollectionViewDelegate>

@property (nonatomic, strong) FDPageCollectionView *collectionView;
@property (nonatomic, strong) FDPageControl *pageControl;

@property (nonatomic, strong) FDTagGroupView *tagsView;

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
    [self addSubview:self.tagsView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(-30);
        make.height.equalTo(@2);
    }];
    [self.tagsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.right.equalTo(self).offset(-20);
        make.bottom.equalTo(self.pageControl.mas_top).offset(-12);
        make.height.equalTo(@(self.tagsView.sizeOfHeight));
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

- (FDTagGroupView *)tagsView {
    if (!_tagsView) {
        _tagsView = [FDTagGroupView tagGroupViewWithTagModels:[self mockTags]];
        _tagsView.singleLine = NO;
        [_tagsView fullSizeToFitWithWidth:[UIScreen mainScreen].bounds.size.width - 40];
    }
    return _tagsView;
}


- (NSArray *)mockTags {
    FDTagModel *model1 = [FDTagModel new];
    model1.icon = @"icon_logout";
    model1.name = @"RoyalABBBC";
    FDTagModel *model3 = [FDTagModel new];
    model3.name = @"APMorgan，Royalrgan，Royargan，Royargan，Royargan，Royargan，Roya";
    model3.icon = @"icon_logout";
    FDTagModel *model4 = [FDTagModel new];
    model4.name = @"Royal 二七王恶趣味";
    model4.icon = @"icon_logout";
    return @[model1,model3,model4].copy;
}

@end
