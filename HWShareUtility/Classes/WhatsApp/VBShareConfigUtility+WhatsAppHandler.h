//
//  VBShareConfigUtility+WhatsAppHandler.h
//  Person
//
//  Created by 史黎明 on 2019/8/23.
//  Copyright © 2019 史黎明. All rights reserved.
//

#import "VBShareConfigUtility.h"

NS_ASSUME_NONNULL_BEGIN

@interface VBShareConfigUtility (WhatsAppHandler) 

/**
 * whatsapp是否可用
 */
- (BOOL)canSendWhatsApp;

/**
 * 调起WhatsApp
 */
- (void)sendWhatsApp:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
