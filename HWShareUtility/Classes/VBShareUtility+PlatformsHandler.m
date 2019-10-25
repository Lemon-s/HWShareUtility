//
//  VBShareUtility+PlatformsHandler.m
//  Person
//
//  Created by 史黎明 on 2019/8/22.
//  Copyright © 2019 史黎明. All rights reserved.
//

#import "VBShareUtility+PlatformsHandler.h"
#import "VBShareUtility+EmailHandler.h"
#import "VBShareUtility+SMSHandler.h"
#import "VBShareUtility+WechatHandler.h"
#import "VBShareUtility+WhatsAppHandler.h"
#import "VBShareUtility+FacebookHandler.h"


@implementation VBShareUtility (PlatformsHandler)

#pragma mark - 微信、Facebook等后台配置注册
- (void)registPlatformConfiguration {
    [self registWechat];
}

#pragma mark - 从channels中获取可用的分享渠道
- (NSArray *)getValidChannels:(NSArray *)channels contentType:(VBShareContentType)shareType content:(NSDictionary *)dic {
    NSMutableArray *tempPlatforms = [NSMutableArray array];
    NSArray *supportPlatforms = [self supportPlatformsWithShareType:shareType content:dic];
    if (channels.count&&supportPlatforms) {
        for (NSNumber *plat in channels) {
            for (NSDictionary *platformDic in supportPlatforms) {
                if ([platformDic[channelTag] isEqual:plat]) {
                    [tempPlatforms addObject:platformDic];
                }
            }
        }
    }
    return tempPlatforms;
}

#pragma mark - 根据分享类型获取支持的分享平台
- (NSArray *)supportPlatformsWithShareType:(VBShareContentType)shareType content:(NSDictionary *)dic {
    NSString *supportType = @"";
    if (shareType == VBShareContentTypeWebLink) {
        supportType = supportWebLink;
    }else if (shareType == VBShareContentTypeImageText) {
        supportType = supportImageAndText;
    }else if (shareType == VBShareContentTypeImage) {
        supportType = supportImage;
    }else if (shareType == VBShareContentTypeText) {
        supportType = supportText;
    }else if (shareType == VBShareContentTypeFile) {
        supportType = supportFile;
    }
    
    NSMutableArray *platforms = [NSMutableArray array];
    for (NSDictionary *platformDic in self.allPlatformsInfo) {
        NSNumber *platformChannel = platformDic[channelTag];
        switch (platformChannel.integerValue) {
            case VBShareChannelTypeWechatSession:
                if ([self canSendWechat]&&[platformDic[supportType] boolValue]) {
                    [platforms addObject:platformDic];
                }
                break;
            case VBShareChannelTypeSms:
                if ([self canSendMsg]&&[platformDic[supportType] boolValue]) {
                    [platforms addObject:platformDic];
                }
                break;
            case VBShareChannelTypeEmail:
                if ([self canSendEmail]&&[platformDic[supportType] boolValue]) {
                    [platforms addObject:platformDic];
                }
                break;
            case VBShareChannelTypeFacebook:
                if ([self canSendFacebook]&&[platformDic[supportType] boolValue]) {
                    if ([supportType isEqualToString:supportImage]) {
                        if ([dic[shareImageUrl] isKindOfClass:UIImage.class]) {
                            [platforms addObject:platformDic];
                        }
                    }else {
                        [platforms addObject:platformDic];
                    }
                }
                break;
            case VBShareChannelTypeWhatsapp:
                if ([self canSendWhatsApp]&&[platformDic[supportType] boolValue]) {
                    [platforms addObject:platformDic];
                }
                break;
                
            default:
                break;
        }
    }
    
    return platforms.count?platforms:nil;
}

#pragma mark - 所有的平台信息(包含未安装的、不支持分享的)
- (NSArray *)allPlatformsInfo {
    return  @[
              @{
                  channelTag: @(VBShareChannelTypeWechatSession), //支持的分享渠道
                  supportImage: @(1),                                 //支持图片分享
                  supportText: @(1),                                  //支持文本分享
                  supportImageAndText: @(1),                          //支持图文分享
                  supportWebLink: @(1),                               //支持web链接分享
                  supportFile: @(1),                                  //支持文件类型分享
                  channelName: THALocalizedStringFromTable(@"VBShare_PannelView_WechatTitle", @"VBStrings"),
                  channelIcon: @"VBCommon.bundle/VBCommon_ShareWechat"
                  },
              @{
                  channelTag: @(VBShareChannelTypeWhatsapp),
                  supportImage: @(0),
                  supportText: @(1),
                  supportImageAndText: @(0),
                  supportWebLink: @(1),
                  supportFile: @(0),
                  channelName: THALocalizedStringFromTable(@"VBShare_PannelView_WhatsappTitle", @"VBStrings"),
                  channelIcon: @"VBCommon.bundle/VBCommon_ShareWhatsapp"
                  },
              @{
                  channelTag: @(VBShareChannelTypeEmail),
                  supportImage: @(1),
                  supportText: @(1),
                  supportImageAndText: @(1),
                  supportWebLink: @(1),
                  supportFile: @(1),
                  channelName: THALocalizedStringFromTable(@"VBShare_PannelView_EmailTitle", @"VBStrings"),
                  channelIcon: @"VBCommon.bundle/VBCommon_ShareEmail"
                  },
              @{
                  channelTag: @(VBShareChannelTypeSms),
                  supportImage: @(1),
                  supportText: @(1),
                  supportImageAndText: @(1),
                  supportWebLink: @(1),
                  supportFile: @(1),
                  channelName: THALocalizedStringFromTable(@"VBShare_PannelView_SMSTitle", @"VBStrings"),
                  channelIcon: @"VBCommon.bundle/VBCommon_ShareSms"
                  },
              @{
                  channelTag: @(VBShareChannelTypeFacebook),
                  supportImage: @(1),
                  supportText: @(0),
                  supportImageAndText: @(0),
                  supportWebLink: @(1),
                  supportFile: @(0),
                  channelName: THALocalizedStringFromTable(@"VBShare_PannelView_FacebookTitle", @"VBStrings"),
                  channelIcon: @"VBCommon.bundle/VBCommon_ShareFacebook"
                  }
              ];
}

@end

/*
 ==ActiveType(CorrespondingAPI)=================CategoryAction=============
 airDrop:                                        string URL Image Files
 addToReadingList(SSReadingList):                       URL
 assignToContact(CNContact):                                Image
 copyToPasteboard(UIPasteboard):                 string URL Image Files
 print(UIPrintInteractionController):                       Image Files
 saveToCameraRoll(UIImageWriteToSavedPhotosAlbum):      URL Image
 ==ActiveType(CorrespondingAPI)=================CategoryShare===============
 mail(MFMailComposeViewController):              string URL Image Files
 message(MFMessageComposeViewController):        string URL Image Files
 postToFacebook(SLComposeViewController):        string URL Image
 postToFlickr(SLComposeViewController):                 URL Image
 postToTecentWeibo(SLComposeViewController):     string URL Image
 postToTwitter(SLComposeViewController):         string URL Image
 postToVimeo(SLComposeViewController):                  URL Image
 postToSinaWeibo(SLComposeViewController):       string URL Image
 ===========================================================================
 */
