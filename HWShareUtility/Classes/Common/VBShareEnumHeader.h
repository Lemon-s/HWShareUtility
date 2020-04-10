//
//  VBShareEnumHeader.h
//  HWShareUtility
//
//  Created by 史黎明 on 2019/11/11.
//

#ifndef VBShareEnumHeader_h
#define VBShareEnumHeader_h

//分享类型，目前分享只做图文、web链接
typedef NS_ENUM(NSInteger, VBShareContentType) {
    VBShareContentTypeText,          //文本
    VBShareContentTypeImage,         //图片
    VBShareContentTypeImageText,     //图文
    VBShareContentTypeWebLink,       //web链接
    VBShareContentTypeFile           //文件
};

//分享渠道
typedef NS_ENUM(NSInteger, VBShareChannelType) {
    VBShareChannelTypeWechatSession = 1,           //微信聊天
    VBShareChannelTypeSms = 13,                    //短信
    VBShareChannelTypeEmail = 14,                   //Email
    VBShareChannelTypeFacebook = 16,               //Facebook
    VBShareChannelTypeWhatsapp = 26                //Whatsapp
};

#endif /* VBShareEnumHeader_h */
