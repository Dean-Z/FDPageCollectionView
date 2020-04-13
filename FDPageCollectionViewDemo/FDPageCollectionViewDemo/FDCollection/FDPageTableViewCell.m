//
//  FDPageTableViewCell.m
//  FDPageCollectionViewDemo
//
//  Created by Jason on 2020/4/8.
//  Copyright © 2020 Jason. All rights reserved.
//

#import "FDPageTableViewCell.h"
#import "FDPageCollectionView.h"

@interface FDPageTableViewCell ()

@property (nonatomic, strong) FDPageCollectionView *collectionView;

@end

@implementation FDPageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self setup];
    return self;
}

- (void)setup {
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)render:(NSArray *)imgs {
    [self.collectionView render:imgs];
    self.collectionView.scrollEnable = NO;
}

- (void)prepareCollectionVideo {
    [self.collectionView prepareFirstCellVideo];
}

#pragma mark - Getter

- (FDPageCollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[FDPageCollectionView alloc] initWithFrame:self.bounds];
    }
    return _collectionView;
}

@end
