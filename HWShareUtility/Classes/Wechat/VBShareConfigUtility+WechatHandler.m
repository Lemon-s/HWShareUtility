//
//  VBShareConfigUtility+WechatHandler.m
//  Person
//
//  Created by 史黎明 on 2019/8/23.
//  Copyright © 2019 史黎明. All rights reserved.
//

#import "VBShareConfigUtility+WechatHandler.h"

static NSString *const weChatAppKey = @"wx204f662d6f508027";
static NSString *const weChatAppSecret = @"17b0b012ab07402a2ddfcd7060206652";

@implementation VBShareConfigUtility (WechatHandler)
- (void)registWechat {
    BOOL res = [WXApi registerApp:weChatAppKey];
}

- (BOOL)canSendWechat {
    return [WXApi isWXAppInstalled]&&[WXApi isWXAppSupportApi];
}

- (void)sendWechat:(NSDictionary *)dic {
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    switch (self.contentType) {
        case VBShareContentTypeText: {
            req.bText = YES;
            req.text = dic[shareTitle]?[NSString stringWithFormat:@"%@ %@", dic[shareTitle], dic[shareText]]:dic[shareText];
        }
            break;
        case VBShareContentTypeImage:
        case VBShareContentTypeImageText:{
            WXMediaMessage *mediaMsg = [WXMediaMessage message];
            WXImageObject *imageObject = [WXImageObject object];
            imageObject.imageData = [self getDataFromObjc:dic[shareImageUrl]];
            mediaMsg.mediaObject = imageObject;
            if (dic[shareThumbImage]) {
                mediaMsg.thumbData = [self getDataFromObjc:dic[shareThumbImage]];
            }
            mediaMsg.title = dic[shareTitle];
            mediaMsg.description = dic[shareText];
            req.message = mediaMsg;
        }
            break;
        case VBShareContentTypeWebLink:{
            WXWebpageObject *webpageObject = [WXWebpageObject object];
            webpageObject.webpageUrl = dic[shareUrl];
            WXMediaMessage *message = [WXMediaMessage message];
            message.title = dic[shareTitle];
            message.description = dic[shareDescription];
            message.thumbData = [self getDataFromObjc:dic[shareThumbImage]];
            message.mediaObject = webpageObject;
            req.message = message;
        }
            break;
        case VBShareContentTypeFile:{
            WXFileObject *fileObject = [WXFileObject object];
            fileObject.fileExtension = dic[shareFileType];
            fileObject.fileData = dic[shareFileData];
            WXMediaMessage *message = [WXMediaMessage message];
            message.title = dic[shareTitle];
            message.description = dic[shareDescription];
            message.mediaObject = fileObject;
            req.message = message;
        }
            break;
    }
    req.scene = WXSceneSession;
    [WXApi sendReq:req];
}

- (NSData *)getDataFromObjc:(id)obj {
    NSData *data = nil;
    if ([obj isKindOfClass:UIImage.class]) {
        data = UIImageJPEGRepresentation(obj, 0.5);
    }else if ([obj isKindOfClass:NSData.class]) {
        data = obj;
    }else if ([obj isKindOfClass:NSString.class]) {
        data = [NSData dataWithContentsOfURL:[NSURL URLWithString:obj]];
    }
    return data;
}

+ (BOOL)canHandleWechatOpenURL:(NSURL *)url {
    if ([url.host isEqualToString:@"platformId=wechat"]&&[url.scheme isEqualToString:weChatAppKey]) {
        VBSharePannelView *pannelView = nil;
        for (UIView *subView in [UIApplication sharedApplication].keyWindow.subviews) {
            if ([subView.class isEqual:VBSharePannelView.class]) {
                pannelView = (VBSharePannelView *)subView;
            }
        }
        VBShareConfigUtility *utility = (VBShareConfigUtility *)pannelView.delegate;
        return [WXApi handleOpenURL:url delegate:utility];
    }
    
    return NO;
}

+ (BOOL)canHandleWechatOpenURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    return [self canHandleWechatOpenURL:url];
}

#pragma mark - delegate
- (void)onResp:(BaseResp*)resp {
    NSDictionary *resultDic;
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        switch (resp.errCode) {
            case WXSuccess:
                resultDic = @{
                              isShareSuccess: @(1)
                              };
                break;
            case WXErrCodeUserCancel:
                resultDic = @{
                              isShareSuccess: @(0),
                              isShareCancelled: @(1),
                              shareError: [NSError errorWithDomain:NSCocoaErrorDomain code:-200 userInfo:@{NSLocalizedFailureReasonErrorKey:@"WXErrCodeUserCancel"}]
                              };
                break;
            case WXErrCodeSentFail:
                resultDic = @{
                              isShareSuccess: @(0),
                              isShareCancelled: @(0),
                              shareError: [NSError errorWithDomain:NSCocoaErrorDomain code:-200 userInfo:@{NSLocalizedFailureReasonErrorKey:@"WXErrCodeSentFail"}]
                              };
                break;
                
            default:
                break;
        }
    }    
    [[NSNotificationCenter defaultCenter] postNotificationName:VBShareResultNotification object:VBShareResultNotification userInfo:resultDic];
}

@end

/*
 supportImage: @(1),                                 //支持图片分享
 supportText: @(1),                                  //支持文本分享
 supportImageAndText: @(1),                          //支持图文分享
 supportWebLink: @(1),                               //支持web链接分享
 supportFile: @(1),
 */
