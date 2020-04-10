//
//  VBShareGlobal.h
//  Person
//
//  Created by 史黎明 on 2019/8/22.
//  Copyright © 2019 史黎明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//================测试添加代码
#define kRatio (kScreenWidth / 375)
#define THALocalizedStringFromTable(a, b) @"title"
#define THAUI_Font12 [UIFont systemFontOfSize:12]
#define THAUI_Color_TextBlackColor          UIColorHex(0x484848) ///< 文本黑 72 72 72
#define THAUI_Color_White                      UIColorHex(0xFFFFFF) ///< 白色
typedef void (^HWActionDataSuccessBlock)(id data);
typedef void (^HWActionDataFailBlock)(BOOL canceled,  NSError * _Nullable error);
extern NSString * const kHWActionDataSuccessBlock;
extern NSString * const kHWActionDataFailBlock;
//================测试添加代码

NS_ASSUME_NONNULL_BEGIN

@interface VBShareGlobal : NSObject

+ (NSString *)getImageTypeWithImageData:(NSData *)imageData;
+ (NSString *)getImageTypeWithImage:(UIImage *)image;
@end

extern NSString *const supportImage;                //分享渠道是否支持图片
extern NSString *const supportText;                 //分享渠道是否支持文本
extern NSString *const supportImageAndText;         //分享渠道是否支持图文
extern NSString *const supportWebLink;              //分享渠道是否支持链接
extern NSString *const supportFile;                 //分享渠道是否支持文件
extern NSString *const channelName;                 //分享渠道名称
extern NSString *const channelIcon;                 //分享渠道图标
extern NSString *const channelTag;                  //分享渠道tag(标识,VBShareChannelType)
extern NSString *const VBShareResultNotification;   //分享结果通知
extern NSString *const isShareSuccess;              //分享是否成功
extern NSString *const isShareCancelled;            //分享是否取消
extern NSString *const shareError;                  //分享错误（NSLocalizedFailureReasonErrorKey描述）

extern NSString *const shareChannelList;            //分享渠道列表
extern NSString *const shareDescription;            //分享内容（weblink使用）
extern NSString *const shareTitle;                  //分享主题
extern NSString *const shareText;                   //分享内容（text使用）
extern NSString *const shareUrl;                    //分享URL
extern NSString *const shareThumbImage;             //分享缩略图
extern NSString *const shareImageUrl;               //分享图片
extern NSString *const shareFileData;               //分享文件内容
extern NSString *const shareFileType;               //分享文件类型
extern NSString *const shareFileName;               //分享文件名
extern NSString *const shareNotShowToast;           //分享操作过程中是否显示toast
NS_ASSUME_NONNULL_END
