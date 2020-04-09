//
//  VBShareUtility.m
//  VBCommon
//
//  Created by 史黎明 on 2019/8/14.
//  Copyright © 2019 彭冬华. All rights reserved.
//

#import "VBShareUtility.h"
#import "VBSharePannelView.h"
#import "VBShareConfigUtility.h"
#import "VBShareGlobal.h"

@interface VBShareUtility ()

@property (nonatomic, strong) NSDictionary *contentDic;
@property (nonatomic, assign) VBShareContentType contentType;
@property (nonatomic, assign) BOOL notShowResult;
@property (nonatomic, copy) HWActionDataSuccessBlock succBlock;
@property (nonatomic, copy) HWActionDataFailBlock failBlock;
@property (nonatomic, strong) VBSharePannelView *pannelView;
@property (nonatomic, strong) VBShareConfigUtility *configUtility;
@end

@implementation VBShareUtility
#pragma mark - lifecycle
- (void)dealloc {
    NSLog(@"VBShareUtility=================>>>>dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareResultCallback:) name:VBShareResultNotification object:VBShareResultNotification];
    }
    return self;
}

#pragma mark - 分享结果通知回调
- (void)shareResultCallback:(NSNotification *)notifi {
    NSDictionary *resultDic = notifi.userInfo;
    if (resultDic) {
        if ([resultDic[isShareSuccess] boolValue]) {
            if (self.succBlock) {
                self.succBlock(@"分享成功");
            }
        }else {
            if (self.failBlock) {
                self.failBlock([resultDic[isShareCancelled] boolValue], resultDic[shareError]);
            }
        }
    }
    [self.pannelView removeFromSuperview];
    self.pannelView = nil;
}

#pragma mark - public,供外部调起分享界面
- (void)shareWithContentType:(VBShareContentType)shareType content:(NSDictionary *)contentDic {
    [self shareWithContentType:shareType content:contentDic platforms:@[
                                                                          @(VBShareChannelTypeWechatSession),
                                                                        @(VBShareChannelTypeSms),
                                                                        @(VBShareChannelTypeEmail),
                                                                        @(VBShareChannelTypeFacebook),
                                                                        @(VBShareChannelTypeWhatsapp),
                                                                        ]];
}

- (void)shareWithContentType:(VBShareContentType)shareType content:(NSDictionary *)contentDic platforms:(NSArray * _Nullable)platforms {
    [self clearProperty];
    [self saveShareContent:contentDic type:shareType];
    NSArray *validPlatforms = [self.configUtility getValidChannels:platforms contentType:self.contentType content:contentDic];
    if (validPlatforms.count) {
        [self.pannelView presentShareViewWithItemList:validPlatforms itemSelectionHandler:^(NSInteger itemTag) {
                                                          switch (itemTag) {
                                                              case VBShareChannelTypeWechatSession:
                                                                  [self sendWechat:contentDic];
                                                                  break;
                                                              case VBShareChannelTypeSms:
                                                                  [self sendMsg:contentDic];
                                                                  break;
                                                              case VBShareChannelTypeEmail:
                                                                  [self sendEmail:contentDic];
                                                                  break;
                                                              case VBShareChannelTypeFacebook:
                                                                  [self sendFacebook:contentDic];
                                                                  break;
                                                              case VBShareChannelTypeWhatsapp:
                                                                  [self sendWhatsApp:contentDic];
                                                                  break;
                                                          }
                                                        }];
    }
}

#pragma mark - 回调block、变量存储/释放处理
- (void)saveShareContent:(NSDictionary *)contentDic type:(VBShareContentType)type {
    self.contentDic = contentDic;
    self.contentType = type;
    self.notShowResult = [contentDic[shareNotShowToast] boolValue];
    self.succBlock = contentDic[kHWActionDataSuccessBlock];
    self.failBlock = contentDic[kHWActionDataFailBlock];
}


- (void)clearProperty {
    self.contentDic = nil;
    self.contentType = VBShareContentTypeText;
    self.notShowResult = NO;
    self.succBlock = nil;
    self.failBlock = nil;
}

#pragma mark - 能否处理外部回调结果
+ (BOOL)canHandleOpenURL:(NSURL *)url {
    if ([url.host isEqualToString:@"platformId=wechat"]) {
        return [self canHandleWechatOpenURL:url];
    }else {
        return NO;
    }
}

+ (BOOL)canHandleOpenURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    if ([url.host isEqualToString:@"platformId=wechat"]) {
       return [self canHandleWechatOpenURL:url options:options];
    }else {
        return NO;
    }
}

#pragma mark - 虚函数，需分类实现对应功能
//========微信相关函数，如果集成对应的子类pod，则子类pod需要实现对应的方法===========
- (void)sendWechat:(NSDictionary *)dic {
    
}

+ (BOOL)canHandleWechatOpenURL:(NSURL *)url {
    return NO;
}

+ (BOOL)canHandleWechatOpenURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    return NO;
}

//========短信相关函数，如果集成对应的子类pod，则子类pod需要实现对应的方法============
- (void)sendMsg:(NSDictionary *)dic {
    
}

//========邮件相关函数，如果集成对应的子类pod，则子类pod需要实现对应的方法============
- (void)sendEmail:(NSDictionary *)dic {
    
}

//========facebook相关函数，如果集成对应的子类pod，则子类pod需要实现对应的方法========
- (void)sendFacebook:(NSDictionary *)dic {
    
}

//========WhatsApp相关函数，如果集成对应的子类pod，则子类pod需要实现对应的方法========
- (void)sendWhatsApp:(NSDictionary *)dic {
    
}



#pragma mark - access
- (VBSharePannelView *)pannelView {
    if (!_pannelView) {
        _pannelView = [[VBSharePannelView alloc] init];
        _pannelView.delegate = self;
    }
    return _pannelView;
}

- (VBShareConfigUtility *)configUtility {
    if (!_configUtility) {
        _configUtility = [[VBShareConfigUtility alloc] init];
    }
    return _configUtility;
}

@end
