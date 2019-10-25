//
//  VBShareGlobal.m
//  Person
//
//  Created by 史黎明 on 2019/8/22.
//  Copyright © 2019 史黎明. All rights reserved.
//

#import "VBShareGlobal.h"

NSString * const kHWActionDataSuccessBlock = @"successBlock";
NSString * const kHWActionDataFailBlock = @"failBlock";

//===========================分享渠道用到的字段============================
NSString *const supportImage              = @"supportImage";
NSString *const supportText               = @"supportText";
NSString *const supportImageAndText       = @"supportImageAndText";
NSString *const supportWebLink            = @"supportWebLink";
NSString *const supportFile               = @"supportFile";
//===========================分享渠道/面板用到的字段=========================
NSString *const channelName               = @"channelName";
NSString *const channelIcon               = @"channelIcon";
NSString *const channelTag                = @"channelTag";
//===========================分享回调用到的字段=============================
NSString *const VBShareResultNotification = @"VBShareResultNotification";
NSString *const isShareSuccess            = @"isShareSuccess";
NSString *const isShareCancelled          = @"isShareCancelled";
NSString *const shareError                = @"shareError";
//===========================外部调用分享方法时,传递的分享内容=================
NSString *const shareChannelList          = @"channelList";
NSString *const shareDescription          = @"description";
NSString *const shareTitle                = @"title";
NSString *const shareText                 = @"text";
NSString *const shareUrl                  = @"url";
NSString *const shareThumbImage           = @"thumbImage";
NSString *const shareImageUrl             = @"imageUrl";
NSString *const shareFileData             = @"fileData";
NSString *const shareFileType             = @"fileType";
NSString *const shareFileName             = @"fileName";
NSString *const shareNotShowToast         = @"notShowResult";


@implementation VBShareGlobal
+ (NSString *)getImageTypeWithImageData:(NSData *)imageData {
    if (!imageData) {
        return nil;
    }
    uint8_t c;
    [imageData getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return @"jpeg";
        case 0x89:
            return @"png";
        case 0x47:
            return @"gif";
        case 0x49:
        case 0x4D:
            return @"tiff";
        case 0x52:
            // R as RIFF for WEBP
            if ([imageData length] < 12) {
                return nil;
            }
            NSString *testString = [[NSString alloc] initWithData:[imageData subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                return @"webp";
            }
            return nil;
    }
    return nil;
}

+ (NSString *)getImageTypeWithImage:(UIImage *)image {
    if (!image) {
        return nil;
    }
    return [self getImageTypeWithImageData:UIImagePNGRepresentation(image)];
}
@end
