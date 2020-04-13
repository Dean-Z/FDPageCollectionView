//
//  FDPageCollectionView.h
//  FDPageCollectionViewDemo
//
//  Created by Jason on 2020/4/8.
//  Copyright © 2020 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"

@interface FDPageCollectionView : UIView

@property (nonatomic, assign) BOOL scrollEnable;

- (void)render:(NSArray *)imgs;

- (void)prepareFirstCellVideo;

@end
