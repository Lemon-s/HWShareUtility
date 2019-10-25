//
//  VBShareUtility+FacebookHandler.h
//  Person
//
//  Created by 史黎明 on 2019/9/6.
//  Copyright © 2019 史黎明. All rights reserved.
//

#import "VBShareUtility.h"
#import <FBSDKShareKit/FBSDKShareKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VBShareUtility (FacebookHandler) <FBSDKSharingDelegate>

- (BOOL)canSendFacebook;
- (void)sendFacebook:(NSDictionary *)dic ;
@end

NS_ASSUME_NONNULL_END
