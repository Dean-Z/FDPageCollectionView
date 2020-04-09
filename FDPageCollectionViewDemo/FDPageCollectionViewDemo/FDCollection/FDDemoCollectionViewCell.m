//
//  FDDemoCollectionViewCell.m
//  FDPageCollectionViewDemo
//
//  Created by Jason on 2020/4/9.
//  Copyright © 2020 Jason. All rights reserved.
//

#import "FDDemoCollectionViewCell.h"
#import "FDVideoPlayer.h"
#import "Masonry.h"

@interface FDDemoCollectionViewCell()

@property (nonatomic, strong) UIImageView *coverImageview;
@property (nonatomic, strong) UIView *playerContainerView;

@property (nonatomic, strong) NSString *currentImg;

@end

@implementation FDDemoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

- (void)setup {
    [self addSubview:self.coverImageview];
    [self addSubview:self.playerContainerView];
    [self.coverImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.playerContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    self.clipsToBounds = YES;
}

- (void)render:(NSString *)img {
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",img]];
    self.coverImageview.image = image;
    
    self.currentImg = img;
}

- (void)prepareVideo {
    [FDVideoPlayer.currentVideoPlayer stop];
    if ([self.currentImg isEqualToString:@"img_17"]) {
        self.playerContainerView.hidden = NO;
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"parsevideo_2" ofType:@"mp4"];
        [FDVideoPlayer.currentVideoPlayer playWithURL:[NSURL fileURLWithPath:filePath]];
        [FDVideoPlayer.currentVideoPlayer replacePlayerlayerContainer:self.playerContainerView];
    } else if ([self.currentImg isEqualToString:@"img_18"]) {
        self.playerContainerView.hidden = NO;
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"parsevideo_1" ofType:@"mp4"];
        [FDVideoPlayer.currentVideoPlayer playWithURL:[NSURL fileURLWithPath:filePath]];
        [FDVideoPlayer.currentVideoPlayer replacePlayerlayerContainer:self.playerContainerView];
    }
}

#pragma mark -

- (UIImageView *)coverImageview {
    if (!_coverImageview) {
        _coverImageview = [UIImageView new];
        _coverImageview.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _coverImageview;
}

- (UIView *)playerContainerView {
    if (!_playerContainerView) {
        _playerContainerView = [UIView new];
        _playerContainerView.backgroundColor = [UIColor clearColor];
        _playerContainerView.hidden = YES;
    }
    return _playerContainerView;
}

@end
