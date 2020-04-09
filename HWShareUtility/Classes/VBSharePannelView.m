//
//  VBSharePannelView.m
//  VBCommon
//
//  Created by 史黎明 on 2019/8/14.
//  Copyright © 2019 彭冬华. All rights reserved.
//

#import "VBSharePannelView.h"

#define kShareItemWidth         60*kRatio
#define kShareItemHeight        80*kRatio
#define kShareItemHoriMargin    (kScreenWidth- 4*kShareItemWidth)/5
#define kShareItemVerMargin     33*kRatio

//=========================================面板Item===================================================
@interface VBShareItemView : UIView  //(60*kRatio)*(80*kRatio)

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) UIView *iconShadowView;
- (void)setTitle:(NSString *)title image:(NSString *)imageName;
@end

@implementation VBShareItemView
- (instancetype)init {
    if (self = [super initWithFrame:CGRectMake(0, 0, kShareItemWidth, kShareItemHeight)]) {
        [self addSubviews];
        [self setupConstraints];
    }
    return self;
}

- (void)addSubviews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.iconImgView];
}

- (void)setupConstraints {
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kShareItemWidth, kShareItemWidth));
        make.top.left.right.equalTo(self);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.centerX.mas_equalTo(self);
    }];
}

- (void)setTitle:(NSString *)title image:(NSString *)imageName {
    self.titleLabel.text = title;
    NSString *iconBundlePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"HWShareIcons" ofType:@"bundle"];
    NSBundle *iconBundle = [NSBundle bundleWithPath:iconBundlePath];
    self.iconImgView.image = [UIImage imageNamed:imageName
                                inBundle:iconBundle
           compatibleWithTraitCollection:nil];
    
    UIImage *buImg = [UIImage imageNamed:@"cc_back"];
    UIImage *img3 = [UIImage imageNamed:@"cc_back" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil];
    
    
    NSString *img4Path = [[NSBundle bundleForClass:[self class]] pathForResource:@"JDDScanBankCard" ofType:@"bundle"];
    NSBundle *img4Bundle = [NSBundle bundleWithPath:img4Path];
    UIImage *img4 = [UIImage imageNamed:@"cc_back"
                                inBundle:img4Bundle
           compatibleWithTraitCollection:nil];
}
#pragma mark - access
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = THAUI_Font12;
        _titleLabel.textColor = THAUI_Color_TextBlackColor;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.contentMode = UIViewContentModeCenter;
        _iconImgView.layer.cornerRadius = kShareItemWidth/2.0;
        _iconImgView.backgroundColor = THAUI_Color_White;
        _iconImgView.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1].CGColor;
        _iconImgView.layer.shadowOpacity = 0.1;
        _iconImgView.layer.shadowRadius = 11*kRatio;
        _iconImgView.layer.shadowOffset = CGSizeMake(0, 1);
    }
    return _iconImgView; 
}
@end

//=========================================分享面板===================================================

@interface VBSharePannelView () <CAAnimationDelegate>
@property (nonatomic, strong) UIView *pannelContainer;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) NSArray *itemInfoList;
@property (nonatomic, strong) NSMutableArray *itemViewList;
@property (nonatomic, copy) ItemSelectionHandler itemSelectHandler;
@end

@implementation VBSharePannelView
- (void)dealloc {
    NSLog(@"VBSharePannelView============>>>>dealloc");
}

- (instancetype)init {
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.backgroundColor = [UIColor colorWithRGB:0x000000 alpha:0.5];
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPannelBackgroundViewAction:)];
        [self addGestureRecognizer:gesture];
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews {
    [self addSubview:self.pannelContainer];
    [self.pannelContainer addSubview:self.titleLabel];
    [self.pannelContainer addSubview:self.closeButton];
}


- (void)refreshItemList {
    if (!self.itemInfoList.count) {
        return;
    }
    for (UIView *itemView in self.itemViewList) {
        [itemView removeFromSuperview];
    }
    
    for (int i = 0; i < self.itemInfoList.count; i++) {
        NSInteger rowIndex = i/4;
        NSInteger columnIndex = i%4;
        NSDictionary *itemInfoDic = [self.itemInfoList objectOrNilAtIndex:i];
        VBShareItemView *itemView = [[VBShareItemView alloc] init];
        [self.pannelContainer addSubview:itemView];
        [self.itemViewList addObject:itemView];
        itemView.tag = [itemInfoDic[channelTag] integerValue];
        [itemView setTitle:itemInfoDic[channelName] image:itemInfoDic[channelIcon]];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapItemViewAction:)];
        [itemView addGestureRecognizer:tapGesture];
        [itemView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.pannelContainer ).offset(60*kRatio+rowIndex*(kShareItemHeight + kShareItemVerMargin));
            make.left.equalTo(self.pannelContainer ).offset(columnIndex*(kShareItemWidth + kShareItemHoriMargin) + kShareItemHoriMargin);
            make.size.mas_equalTo(CGSizeMake(60*kRatio, 80*kRatio));
        }];
    }
}

#pragma mark - action
- (void)tapItemViewAction:(UITapGestureRecognizer *)gesture {
    NSInteger shareChannel = gesture.view.tag;
    if (self.itemSelectHandler) {
        self.itemSelectHandler(shareChannel);
    }
    [self dismissAmimation];
}

- (void)closePannelView {
    [self dismissAmimation];
    [[NSNotificationCenter defaultCenter] postNotificationName:VBShareResultNotification object:VBShareResultNotification userInfo:nil];
}

- (void)tapPannelBackgroundViewAction:(UITapGestureRecognizer *)gesture {
    CGPoint tapLocation = [gesture locationInView:gesture.view];
    if (!CGRectContainsPoint(self.pannelContainer.frame, tapLocation)) {
        [self closePannelView];
    }
}
#pragma mark - animation
- (void)showAmimation {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    CGFloat rowCount = self.itemInfoList.count/4;
    if (self.itemInfoList.count%4) {
        rowCount++;
    }
    CGFloat pannelHeight = 60*kRatio+(80+33)*kRatio*(rowCount);
    [UIView animateWithDuration:0.25 animations:^{
        self.pannelContainer.frame = CGRectMake(0, kScreenHeight-pannelHeight, kScreenWidth, pannelHeight);
        [self setupPannelViewMask];
    }];
}

- (void)dismissAmimation {
    CGFloat pannelHeight = 60*kRatio+(80+33)*kRatio*(self.itemInfoList.count/4 + 1);
    [UIView animateWithDuration:0.25 animations:^{
        self.pannelContainer.frame = CGRectMake(0, kScreenHeight, kScreenWidth, pannelHeight);
    } completion:^(BOOL finished) {
//        [self removeFromSuperview];
        self.hidden = YES;
    }];
}

- (void)setupPannelViewMask {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_pannelContainer.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(20, 20)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _pannelContainer.bounds;
    maskLayer.path = maskPath.CGPath;
    _pannelContainer.layer.mask = maskLayer;
}

#pragma mark - public
- (void)presentShareViewWithItemList:(NSArray *)itemInfoList itemSelectionHandler:(ItemSelectionHandler)handler {
    self.itemSelectHandler = handler;
    self.itemInfoList = itemInfoList;
    [self refreshItemList];
    [self showAmimation];
}

#pragma mark - access
- (UIView *)pannelContainer {
    if (!_pannelContainer) {
        _pannelContainer = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 60*kRatio+(80+33)*kRatio)];
        _pannelContainer.backgroundColor = THAUI_Color_White;
        [self setupPannelViewMask];
    }
    return _pannelContainer;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30*kRatio)];
        _titleLabel.center = CGPointMake(kScreenWidth/2, self.closeButton.centerY);
        _titleLabel.text = THALocalizedStringFromTable(@"VBShare_PannelView_ViewTitle", @"VBStrings");
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = THAUI_Color_TextBlackColor;
    }
    return _titleLabel;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.frame = CGRectMake(20*kRatio, 19*kRatio, 20*kRatio, 20*kRatio);
        [_closeButton addTarget:self action:@selector(closePannelView) forControlEvents:UIControlEventTouchUpInside];
        [_closeButton setImage:[UIImage imageNamed:@"VBCommon.bundle/VBCommon_ShareClose"] forState:UIControlStateNormal];
    }
    return _closeButton;
}

- (NSArray *)itemInfoList {
    if (!_itemInfoList) {
        _itemInfoList = [NSMutableArray array];
    }
    return _itemInfoList;
}
@end
