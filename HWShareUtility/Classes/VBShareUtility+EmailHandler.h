//
//  VBShareUtility+EmailHandler.h
//  Person
//
//  Created by 史黎明 on 2019/8/22.
//  Copyright © 2019 史黎明. All rights reserved.
//

#import "VBShareUtility.h"

NS_ASSUME_NONNULL_BEGIN

@interface VBShareUtility (EmailHandler) <MFMailComposeViewControllerDelegate>

- (BOOL)canSendEmail;
- (void)sendEmail:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
