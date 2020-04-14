//
//  FDPageCollectionView.h
//  FDPageCollectionViewDemo
//
//  Created by Jason on 2020/4/8.
//  Copyright © 2020 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"

@protocol FDPageCollectionViewDelegate;

@interface FDPageCollectionView : UIView

@property (nonatomic, assign) BOOL scrollEnable;
@property (nonatomic, weak) id<FDPageCollectionViewDelegate> delegate;

- (void)render:(NSArray *)imgs;

- (void)prepareFirstCellVideo;

@end

@protocol FDPageCollectionViewDelegate <NSObject>

- (void)pageCollectionViewDidScrollToPage:(NSInteger)indexPage;

@end
