//
//  VBSharePannelView.h
//  VBCommon
//
//  Created by 史黎明 on 2019/8/14.
//  Copyright © 2019 彭冬华. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ItemSelectionHandler)(NSInteger itemTag);

@protocol VBSharePannelViewDelegate <NSObject>

@end

NS_ASSUME_NONNULL_BEGIN

@interface VBSharePannelView : UIView

@property (nonatomic, weak) id <VBSharePannelViewDelegate>delegate;

/**
 * @itemInfoList 分享渠道list @[@{
 *                              channelTag:@(1),
 *                              channelName: @"weChat",
 *                              channelIcon: @"lSMS-1"
 *                             }]
 * @handler 点击面板回调
 */
- (void)presentShareViewWithItemList:(NSArray *)itemInfoList itemSelectionHandler:(ItemSelectionHandler)handler;
@end

NS_ASSUME_NONNULL_END
