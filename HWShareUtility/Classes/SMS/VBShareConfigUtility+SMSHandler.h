//
//  VBShareConfigUtility+SMSHandler.h
//  Person
//
//  Created by 史黎明 on 2019/8/22.
//  Copyright © 2019 史黎明. All rights reserved.
//

#import "VBShareConfigUtility.h"
#import <MessageUI/MessageUI.h>

NS_ASSUME_NONNULL_BEGIN

@interface VBShareConfigUtility (SMSHandler) <MFMessageComposeViewControllerDelegate>

/**
 * 短信是否可用
 */
- (BOOL)canSendMsg;

/**
 * 调起短信分享
 */
- (void)sendMsg:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
