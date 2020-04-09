//
//  FDVideoPlayer.h
//  FDPageCollectionViewDemo
//
//  Created by Jason on 2020/4/9.
//  Copyright © 2020 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,FDAVStatus){
    FDPlay,
    FDPaused,
    FDReadToPlay,
    FDFail
};


@interface FDVideoPlayer : NSObject


@property (nonatomic, strong, class) FDVideoPlayer *currentVideoPlayer;

/**
 是否循环播放
 */
@property (nonatomic, assign) BOOL loop;

@property (nonatomic, strong, readonly) AVPlayerLayer *playerLayer;

- (void)playWithURL:(NSURL *)url;

- (void)stop;

- (void)replacePlayerlayerContainer:(UIView *)container;

@end

