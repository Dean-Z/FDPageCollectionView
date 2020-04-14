//
//  FDTagGroupView.h
//  FDPageCollectionViewDemo
//
//  Created by Jason on 2020/4/14.
//  Copyright © 2020 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDTagModel.h"

@interface FDTagButton : UIView

@property (nonatomic, strong) FDTagModel *tagModel;

@end

@protocol FDTagGroupViewDelegate;

@interface FDTagGroupView : UIView

@property (nonatomic, weak) id<FDTagGroupViewDelegate> delegate;
/**
    是否一行显示完
    默认 = YES
 */
@property (nonatomic, assign) BOOL singleLine;

/**
    Tag 背景颜色
 */
@property (nonatomic, strong) UIColor *tagBackgroundColor;

/**
   Tag 标题颜色
*/
@property (nonatomic, strong) UIColor *tagTitleColor;

/**
   Tag 标题字体
*/
@property (nonatomic, assign) UIFont *tagTitleFont;

/**
   Tag 标签高度
*/
@property (nonatomic, assign) CGFloat tagHeight;


/**
   Tag 标签文本左右间距
*/
@property (nonatomic, assign) CGFloat tagTitlePadding;

/**
   Tag 图标 size
*/
@property (nonatomic, assign) CGSize imageSize;

/**
   Tag 标签之间横向间距
*/
@property (nonatomic, assign) CGFloat horizontalMargin;

/**
   Tag 标签之间纵向间距
*/
@property (nonatomic, assign) CGFloat verticalMargin;

@property (nonatomic, assign) CGFloat sizeOfHeight;

+ (instancetype)tagGroupViewWithTagModels:(NSArray<FDTagModel *> *) dataArray;

- (void)fullSizeToFitWithWidth:(CGFloat)width;

@end

@protocol FDTagGroupViewDelegate <NSObject>

- (void)tagGroupViewDidSelectAt:(FDTagModel *)tagModel;

@end
