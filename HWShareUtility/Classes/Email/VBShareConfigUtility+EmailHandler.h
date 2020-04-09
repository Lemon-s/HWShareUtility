//
//  VBShareConfigUtility+EmailHandler.h
//  Person
//
//  Created by 史黎明 on 2019/8/22.
//  Copyright © 2019 史黎明. All rights reserved.
//

#import "VBShareConfigUtility.h"
#import <MessageUI/MessageUI.h>

NS_ASSUME_NONNULL_BEGIN

@interface VBShareConfigUtility (EmailHandler) <MFMailComposeViewControllerDelegate>

- (BOOL)canSendEmail;
- (void)sendEmail:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
