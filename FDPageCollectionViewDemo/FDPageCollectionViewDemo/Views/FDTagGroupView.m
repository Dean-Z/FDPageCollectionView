//
//  FDTagGroupView.m
//  FDPageCollectionViewDemo
//
//  Created by Jason on 2020/4/14.
//  Copyright © 2020 Jason. All rights reserved.
//

#import "FDTagGroupView.h"
#import "Masonry.h"

static CGFloat kIconImageLeftPadding = 8;
static CGFloat kIconImageRightPadding = 2;

@interface FDTagButton ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign) CGFloat padding;

@property (nonatomic, assign) CGSize imageSize;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImage *iconImage;

@end

@implementation FDTagButton

- (instancetype)init {
    self = [super init];
    [self setup];
    return self;
}

- (void)setup {
    self.imageSize = CGSizeMake(14, 14);
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
}

#pragma mark - Setter

- (void)setPadding:(CGFloat)padding {
    _padding = padding;
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(padding));
        make.right.equalTo(@(-padding));
        make.centerY.equalTo(self);
    }];
}

- (void)setIconImage:(UIImage *)iconImage {
    _iconImage = iconImage;
    self.iconImageView.image = iconImage;
    if (_iconImage != nil) {
        [self addSubview:self.iconImageView];
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(kIconImageLeftPadding));
            make.centerY.equalTo(self);
            make.width.equalTo(@(self.imageSize.width));
            make.height.equalTo(@(self.imageSize.height));
        }];
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImageView.mas_right).offset(kIconImageRightPadding);
            make.right.equalTo(@(-self.padding));
            make.centerY.equalTo(self);
        }];
    } else {
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(self.padding));
            make.right.equalTo(@(-self.padding));
            make.centerY.equalTo(self);
        }];
    }
}

#pragma mark - Getter

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
    }
    return _iconImageView;
}

@end

@interface FDTagGroupView ()

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation FDTagGroupView

+ (instancetype)tagGroupViewWithTagModels:(NSArray<FDTagModel *> *)dataArray {
    FDTagGroupView *groupView = [FDTagGroupView new];
    groupView.dataArray = dataArray;
    return groupView;
}

- (instancetype)init {
    self = [super init];
    [self setup];
    return self;
}

- (void)setup {
    self.singleLine = YES;
    self.tagBackgroundColor = UIColor.systemBlueColor;
    self.tagTitleColor = UIColor.whiteColor;
    self.tagTitleFont = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    self.tagHeight = 28.f;
    self.tagTitlePadding = 12;
    self.horizontalMargin = 8.f;
    self.verticalMargin = 14.f;
    self.imageSize = CGSizeMake(14, 14);
}

/**
    计算frame
 */
- (void)calculateTagFrameWithWidth:(CGFloat)width {
    self.sizeOfHeight = self.tagHeight;
    if (self.singleLine) {
        CGFloat right = 0;
        CGFloat maxWidth = (width - (self.dataArray.count - 1) * self.horizontalMargin)/self.dataArray.count;
        for (NSInteger i=0; i<self.dataArray.count; i++) {
            FDTagModel *model = self.dataArray[i];
            CGFloat tagWidth = 0;
            if (model.icon != nil) {
                tagWidth = [self widthWithFont:self.tagTitleFont constrainedToSize:CGSizeMake(MAXFLOAT, self.tagHeight) content:model.name] + self.tagTitlePadding + kIconImageLeftPadding + self.imageSize.width + kIconImageRightPadding;
            } else {
                tagWidth = [self widthWithFont:self.tagTitleFont constrainedToSize:CGSizeMake(MAXFLOAT, self.tagHeight) content:model.name] + self.tagTitlePadding * 2;
            }
            tagWidth = MIN(maxWidth, tagWidth);
            CGRect rect = CGRectMake(right, 0, tagWidth, self.tagHeight);
            model.frameValue = [NSValue valueWithCGRect:rect];
            right = right + tagWidth + self.horizontalMargin;
        }
    } else {
        CGFloat right = 0;
        CGFloat bottom = 0;
        for (NSInteger i=0; i<self.dataArray.count; i++) {
            FDTagModel *model = self.dataArray[i];
            CGFloat tagWidth = 0;
            if (model.icon != nil) {
                tagWidth = [self widthWithFont:self.tagTitleFont constrainedToSize:CGSizeMake(MAXFLOAT, 0) content:model.name] + self.tagTitlePadding + kIconImageLeftPadding + self.imageSize.width + kIconImageRightPadding;
            } else {
                tagWidth = [self widthWithFont:self.tagTitleFont constrainedToSize:CGSizeMake(MAXFLOAT, 0) content:model.name] + self.tagTitlePadding * 2 ;
            }
            if (right != 0 && tagWidth + right + self.horizontalMargin > width) {
                bottom += self.tagHeight + self.verticalMargin;
                self.sizeOfHeight = bottom + self.tagHeight;
                right = 0;
            }
            if (tagWidth + right + self.horizontalMargin > width) {
                tagWidth = width;
            }
            CGRect rect = CGRectMake(right, bottom, tagWidth, self.tagHeight);
            model.frameValue = [NSValue valueWithCGRect:rect];
            right = right + tagWidth + self.horizontalMargin;
        }
    }
}

- (void)fullSizeToFitWithWidth:(CGFloat)width {
    [self calculateTagFrameWithWidth:width];
    for (NSInteger i=0; i<self.dataArray.count; i++) {
        FDTagModel *model = self.dataArray[i];
        FDTagButton *button = [FDTagButton new];
        button.tagModel = model;
        button.imageSize = self.imageSize;
        button.padding = self.tagTitlePadding;
        button.backgroundColor = self.tagBackgroundColor;
        button.titleLabel.textColor = self.tagTitleColor;
        button.titleLabel.text = model.name;
        button.titleLabel.font = self.tagTitleFont;
        if (model.icon != nil) {
            [button setIconImage:[UIImage imageNamed:model.icon]];
        }
        button.layer.cornerRadius = self.tagHeight/2;
        button.frame = [model.frameValue CGRectValue];
        [self addSubview:button];
    }
}

- (CGFloat)widthWithFont:(UIFont *)font constrainedToSize:(CGSize)size content:(NSString *)content {
    if (!content || content.length == 0) return 0;
    return [content boundingRectWithSize:size
                              options:NSStringDrawingUsesFontLeading |
            NSStringDrawingUsesLineFragmentOrigin |
            NSStringDrawingUsesFontLeading
                           attributes:@{ NSFontAttributeName : font }
                              context:nil].size.width + 1;
}

@end
