//
//  VBShareUtility+WechatHandler.h
//  Person
//
//  Created by 史黎明 on 2019/8/23.
//  Copyright © 2019 史黎明. All rights reserved.
//

#import "VBShareUtility.h"

NS_ASSUME_NONNULL_BEGIN

@interface VBShareUtility (WechatHandler) <WXApiDelegate, VBSharePannelViewDelegate>

/**
 * 注册微信appKey
 */
- (void)registWechat;

/**
 * 微信是否可用
 */
- (BOOL)canSendWechat;

/**
 * 调起微信分享
 */
- (void)sendWechat:(NSDictionary *)dic;

/**
 * 处理微信回调
 */
+ (BOOL)canHandleWechatOpenURL:(NSURL *)url;

/**
 * 处理微信回调
 */
+ (BOOL)canHandleWechatOpenURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options;
@end

NS_ASSUME_NONNULL_END
