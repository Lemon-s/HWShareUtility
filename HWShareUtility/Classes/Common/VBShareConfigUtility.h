//
//  VBShareConfigUtility.h
//  Pods
//
//  Created by 史黎明 on 2019/11/7.
//

#import "VBShareUtility.h"

NS_ASSUME_NONNULL_BEGIN

@interface VBShareConfigUtility : VBShareUtility
/**
 * 微信、Facebook等后台配置注册
 */
- (void)registPlatformConfiguration;

/**
 * 根据shareType从channels中选取可用的分享渠道
 */
- (NSArray *)getValidChannels:(NSArray *)channels contentType:(VBShareContentType)shareType content:(NSDictionary *)dic;

/**
 * 所有的平台信息(包含未安装的、不支持分享的)
 */
- (NSArray *)allPlatformsInfo;
@end

NS_ASSUME_NONNULL_END
