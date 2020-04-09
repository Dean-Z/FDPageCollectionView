//
//  FDPageTableViewCell.h
//  FDPageCollectionViewDemo
//
//  Created by Jason on 2020/4/8.
//  Copyright © 2020 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FDPageTableViewCell : UITableViewCell

- (void)render:(NSArray *)imgs;
- (void)prepareCollectionVideo;

@end

NS_ASSUME_NONNULL_END
