//
//  VBShareUtility.h
//  VBCommon
//
//  Created by 史黎明 on 2019/8/14.
//  Copyright © 2019 彭冬华. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VBShareEnumHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface VBShareUtility : NSObject

/**
 *  当前分享类型
 */
@property (nonatomic, assign, readonly) VBShareContentType contentType;


/**
 * @param shareType 分享类型(图文分享/链接分享)
 *
 *@param contentDic  文本:{@"text": @"文本分享必传字段"}
 *                   图片:{@"thumbImage": @"图片分享缩略图(非必传)",
 *                        @"imageUrl"  : @"分享的图片(image/data/url)(必传)"}
 *                   图文:{@"thumbImage": @"图片分享缩略图(非必传)",
 *                        @"imageUrl"  : @"分享的图片(image/data/url)(必传),
 *                        @"text"      : @"图文内容(非必传)"}
 *                   链接:{@"thumbImage": @"图片分享缩略图(非必传)",
 *                        @"description": @"内容描述(image/data/url)(非必传),
 *                        @"title"      : @"标题(非必传)",
 *                        @"url"        : @"分享链接(必传)"}
 *
 */
- (void)shareWithContentType:(VBShareContentType)shareType content:(NSDictionary *)contentDic;

/**
 * @param shareType 分享类型(图文分享/链接分享)
 *
 *@param contentDic  文本:{@"text": @"文本分享必传字段",
 *                        @"title": @"主题(邮件渠道才用)" }
 *                   图片:{@"thumbImage": @"图片分享缩略图(非必传)",
 *                        @"imageUrl"  : @"分享的图片(image/data/url)(必传)",
 *                        @"title": @"主题(邮件渠道才用)"}
 *                   图文:{@"thumbImage": @"图片分享缩略图(非必传)",
 *                        @"imageUrl"  : @"分享的图片(image/data/url)(必传),
 *                        @"text"      : @"图文内容(非必传)",
 *                        @"title": @"主题(邮件渠道才用)"}
 *                   链接:{@"thumbImage": @"图片分享缩略图(非必传)",
 *                        @"description": @"内容描述(image/data/url)(非必传),
 *                        @"title"      : @"标题/主题(非必传)",
 *                        @"url"        : @"分享链接(必传)"}
 *                   文件:{@"fileData": @"文件内容(NSData,必传且不能超过10M)",
 *                        @"fileType": @"文件类型(默认"text/ *",必传),
 *                        @"title"      : @"标题/主题(非必传)",
 *                        @"fileName"   : @"文件名(非必传,但必须文件名+后缀)"}
 *
 * @param platforms  支持的分享平台,见VBShareChannelType
 */
- (void)shareWithContentType:(VBShareContentType)shareType content:(NSDictionary *)contentDic platforms:(NSArray * _Nullable)platforms;

/**
 * 能否处理外部回调，如果不能处理，看看是否是其他如支付等SDK的回调
 */
+ (BOOL)canHandleOpenURL:(NSURL *)url;

/**
 * 能否处理外部回调，如果不能处理，看看是否是其他如支付等SDK的回调
 */
+ (BOOL)canHandleOpenURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options;
@end

NS_ASSUME_NONNULL_END
