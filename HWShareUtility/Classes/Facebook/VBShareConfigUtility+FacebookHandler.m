//
//  VBShareConfigUtility+FacebookHandler.m
//  Person
//
//  Created by 史黎明 on 2019/9/6.
//  Copyright © 2019 史黎明. All rights reserved.
//

#import "VBShareConfigUtility+FacebookHandler.h"

@implementation VBShareConfigUtility (FacebookHandler)
- (BOOL)canOpenFacebook {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fbapi://"]];
}

- (BOOL)canOpenFacebookMessenger {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb-messenger-api://"]]||[[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb-messenger-share-api://"]];
}

#pragma mark - public
- (BOOL)canSendFacebook {
    return [self canOpenFacebook]||[self canOpenFacebookMessenger];
}

- (void)sendFacebook:(NSDictionary *)dic {    
    switch (self.contentType) {
        case VBShareContentTypeImage:{
            FBSDKSharePhoto *photo = [FBSDKSharePhoto photoWithImage:dic[shareImageUrl] userGenerated:YES];
            FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
            content.photos = @[photo];
            
            [self showDialogContent:content];
        }
            break;
        case VBShareContentTypeWebLink:{
            FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
            content.contentURL = [NSURL URLWithString:@"https://developers.facebook.com"];
            if (dic[shareDescription]) {
                content.quote = dic[shareTitle]?[dic[shareTitle] stringByAppendingString:dic[shareDescription]]:dic[shareDescription];
            }
            [self showDialogContent:content];
        }
            break;
            
        default:
            break;
    }
}

- (void)showDialogContent:(id<FBSDKSharingContent>)content {
    if ([self canOpenFacebook]) {
        FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
        dialog.delegate = self;
        dialog.shareContent = content;
        dialog.fromViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        dialog.mode = FBSDKShareDialogModeNative;
        [dialog show];
    }else {
        FBSDKMessageDialog *msgDialog = [FBSDKMessageDialog showWithContent:content delegate:self];
        [msgDialog show];
    }
}

#pragma mark - FBSDKSharingDelegate
- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results {
    NSDictionary *resultDic = @{
                                isShareSuccess: @(1)
                                };
    [[NSNotificationCenter defaultCenter] postNotificationName:VBShareResultNotification object:VBShareResultNotification userInfo:resultDic];
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error {
    NSDictionary *resultDic = @{
                                  isShareSuccess: @(0),
                                  isShareCancelled: @(0),
                                  shareError: error?:[NSError errorWithDomain:NSCocoaErrorDomain code:-200 userInfo:@{NSLocalizedFailureReasonErrorKey:@"FacebookShareFailed"}]
                                  };
    [[NSNotificationCenter defaultCenter] postNotificationName:VBShareResultNotification object:VBShareResultNotification userInfo:resultDic];
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer {
    NSDictionary * resultDic = @{
                                 isShareSuccess: @(0),
                                 isShareCancelled: @(1),
                                 shareError: [NSError errorWithDomain:NSCocoaErrorDomain code:-200 userInfo:@{NSLocalizedFailureReasonErrorKey:@"FacebookShareCancel"}]
                                 };
    [[NSNotificationCenter defaultCenter] postNotificationName:VBShareResultNotification object:VBShareResultNotification userInfo:resultDic];
}

@end

/*
 在info.plist中配置: FacebookAppID(appId)/FacebookDisplayName(display name)
 
 supportImage: @(1),
 supportText: @(0),
 supportImageAndText: @(0),
 supportWebLink: @(1),
 supportFile: @(0),
 
 注意:分享成功和失败都会调用cancel...原因不明
 */
