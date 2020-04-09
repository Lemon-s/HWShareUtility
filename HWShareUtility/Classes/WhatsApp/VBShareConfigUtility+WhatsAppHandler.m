//
//  VBShareConfigUtility+WhatsAppHandler.m
//  Person
//
//  Created by 史黎明 on 2019/8/23.
//  Copyright © 2019 史黎明. All rights reserved.
//

#import "VBShareConfigUtility+WhatsAppHandler.h"

@implementation VBShareConfigUtility (WhatsAppHandler)
- (BOOL)canSendWhatsApp {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"whatsapp://"]];
}

- (void)sendWhatsApp:(NSDictionary *)dic {
    NSString *msg;
    switch (self.contentType) {
        case VBShareContentTypeText:
            msg = dic[shareTitle]?[NSString stringWithFormat:@"%@ %@", dic[shareTitle], dic[shareText]]:dic[shareText];
            break;
        case VBShareContentTypeWebLink:
            if (dic[shareDescription]) {
                msg = dic[shareTitle]?[NSString stringWithFormat:@"%@ %@", dic[shareTitle], dic[shareDescription]]:dic[shareDescription];
            }else {
                msg = dic[shareTitle]?[NSString stringWithFormat:@"%@ %@", dic[shareTitle], dic[shareUrl]]:dic[shareUrl];
            }
            break;
            
        default:
            break;
    }
    NSString *url = [NSString stringWithFormat:@"whatsapp://send?text=%@", [msg stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    NSURL *whatsappURL = [NSURL URLWithString: url];
    BOOL shareSuccess = [[UIApplication sharedApplication] openURL:whatsappURL];
    NSDictionary *resultDic = shareSuccess?@{isShareSuccess: @(1)}:
                                            @{
                                              isShareSuccess: @(0),
                                              isShareCancelled: @(0),
                                              shareError: [NSError errorWithDomain:NSCocoaErrorDomain code:-200 userInfo:@{NSLocalizedFailureReasonErrorKey:@"whatsappShareError"}]
                                              };
    [[NSNotificationCenter defaultCenter] postNotificationName:VBShareResultNotification object:VBShareResultNotification userInfo:resultDic];
}
    
@end

/*
 https://faq.whatsapp.com/zh_cn/iphone/23559013, 因share extension不满足需求,只通过scheme形式打开分享
 
 supportImage: @(0),
 supportText: @(1),
 supportImageAndText: @(0),
 supportWebLink: @(1),
 supportFile: @(0),
 */

/*
 文字（UTI：public.plain-text）
 照片（UTI：public.image）
 视频（UTI：public.movie）
 音频笔记和音乐文件（UTI：public.audio）
 PDF文件（UTI：com.adobe.pdf）
 联系卡（UTI：public.vcard）
 网址（UTI：public.url）
 */
