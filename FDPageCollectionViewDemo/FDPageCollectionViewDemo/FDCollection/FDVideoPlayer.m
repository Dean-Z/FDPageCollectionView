//
//  FDVideoPlayer.m
//  FDPageCollectionViewDemo
//
//  Created by Jason on 2020/4/9.
//  Copyright © 2020 Jason. All rights reserved.
//

#import "FDVideoPlayer.h"

@interface FDVideoPlayer ()

@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerItem *item;
@property (nonatomic, strong, readwrite) AVPlayerLayer *playerLayer;

@property (assign, nonatomic) BOOL isReadToPlay;
@property (assign, nonatomic) FDAVStatus status;

@property (nonatomic, strong) id mTimeObserver;
@property (nonatomic, strong) NSURL *currentPlayURL;

@end

static FDVideoPlayer *player;

@implementation FDVideoPlayer

@dynamic currentVideoPlayer;

+ (instancetype)currentVideoPlayer {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        player = [[FDVideoPlayer alloc] init];
    });
    return player;
}

- (instancetype)init {
    self = [super init];
    self.loop = YES;
    [self periodicTime];
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItemStatus status = [change[NSKeyValueChangeNewKey]intValue];
        switch (status) {
            case AVPlayerItemStatusFailed:
                NSLog(@"Item Failed");
                self.isReadToPlay = NO;
                self.status = FDFail;
                break;
            case AVPlayerItemStatusReadyToPlay:
                NSLog(@"Ready To Play");
                self.isReadToPlay = YES;
                self.status = FDReadToPlay;
                [self.player play];
                [self tryPlayAgain];
                break;
            case AVPlayerItemStatusUnknown:
                NSLog(@"Item Unknown");
                self.isReadToPlay = NO;
                self.status = FDFail;
                break;
            default:
                break;
        }
    }
    [object removeObserver:self forKeyPath:@"status"];
}

- (void)playWithURL:(NSURL *)url {
    self.currentPlayURL = url;
    if (url == nil) {
        NSAssert(url = nil, @"当前播放视频地址为空");
        return;
    }
    NSLog(@"准备播放视频");
    
    self.item = nil;
    self.item = [AVPlayerItem playerItemWithURL:url];
    [self.item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [self.player replaceCurrentItemWithPlayerItem:self.item];
}

/**
    容错处理
 Apple API play 可能会没反应
 */
- (void)tryPlayAgain {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.player.rate < 1) {
            [self.player play];
            [self tryPlayAgain];
        }
    });
}

- (void)periodicTime {
    __weak typeof(self)WeakSelf = self;
    [self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1, NSEC_PER_SEC)
                                              queue:NULL
                                         usingBlock:^(CMTime time) {
        CGFloat progress = CMTimeGetSeconds(WeakSelf.player.currentItem.currentTime) / CMTimeGetSeconds(WeakSelf.player.currentItem.duration);
        if (progress >= 1.0f) {
            if (WeakSelf.loop) {
                [WeakSelf playWithURL:WeakSelf.currentPlayURL];
            }
        }
    }];
}

- (void)stop {
    [self.player pause];
    [self.playerLayer removeFromSuperlayer];
}

- (void)replacePlayerlayerContainer:(UIView *)container {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [container.layer addSublayer:FDVideoPlayer.currentVideoPlayer.playerLayer];
        self.playerLayer.frame = container.bounds;
    });
}

#pragma mark - Getter

- (FDAVStatus)status {
    if (self.isReadToPlay) {
        _status = FDReadToPlay;
        if (self.player.rate == 0.0) {
            _status = FDPaused;
        }else if (self.player.rate > 0.0 ){
            _status = FDPlay;
        }
    } else {
        _status = FDFail;
    }
    return _status;
}

- (AVPlayer *)player{
    if (!_player) {
        _player = [AVPlayer playerWithPlayerItem:self.item];
    }
    return _player;
}

- (AVPlayerLayer *)playerLayer{
    if (!_playerLayer) {
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    }
    return _playerLayer;
}

@end
