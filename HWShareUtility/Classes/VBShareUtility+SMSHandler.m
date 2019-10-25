//
//  VBShareUtility+SMSHandler.m
//  Person
//
//  Created by 史黎明 on 2019/8/22.
//  Copyright © 2019 史黎明. All rights reserved.
//

#import "VBShareUtility+SMSHandler.h"

@implementation VBShareUtility (SMSHandler)
- (BOOL)canSendMsg {
    return [MFMessageComposeViewController canSendText];
}

- (void)sendMsg:(NSDictionary *)dic {
    if (![self canSendMsg]) {
        return;
    }
    MFMessageComposeViewController *msgVC = [[MFMessageComposeViewController alloc] init];
    msgVC.messageComposeDelegate = self;
    switch (self.contentType) {
        case VBShareContentTypeText: {
            if (dic[shareText]) {
                msgVC.body = dic[shareTitle]?[[dic[shareTitle] stringByAppendingString:@" "] stringByAppendingString:dic[shareText]]:dic[shareText];
            }
        }
            break;
        case VBShareContentTypeImage:
        case VBShareContentTypeImageText:{
            if ([dic[shareImageUrl] isKindOfClass:UIImage.class]) {
                NSData *imageData = UIImagePNGRepresentation(dic[shareImageUrl]);
                NSString *imageType = [VBShareGlobal getImageTypeWithImageData:imageData];
                NSString *mimeType = [NSString stringWithFormat:@"%@/%@", @"image", imageType];
                NSString *fileName = [NSString stringWithFormat:@"%@.%@", [@"shareImage" md5String], imageType];
                [msgVC addAttachmentData:imageData typeIdentifier:mimeType filename:fileName];
            }else if ([dic[shareImageUrl] isKindOfClass:NSString.class]) {
                [msgVC addAttachmentURL:[NSURL URLWithString:dic[shareImageUrl]] withAlternateFilename:[@"shareImage" md5String]];
            }
            if (dic[shareText]) {
                msgVC.body = dic[shareText];
            }
        }
            break;
        case VBShareContentTypeWebLink:{
            if (dic[shareDescription]) {
                msgVC.body = dic[shareTitle]?[[dic[shareTitle] stringByAppendingString:@" "] stringByAppendingString:dic[shareDescription]]:dic[shareDescription];
            }
        }
            break;
        case VBShareContentTypeFile:{
            NSString *fileName = dic[shareFileName]?:[NSString stringWithFormat:@"%@.%@", @"shareFile", dic[shareFileType]];
            [msgVC addAttachmentData:dic[shareFileData] typeIdentifier:dic[shareFileType] filename:fileName];
        }
            break;
    }
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:msgVC animated:YES completion:nil];
}

#pragma mark - MFMailComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    NSDictionary *resultDic;
    switch (result) {
        case MessageComposeResultCancelled:
            resultDic = @{
                          isShareSuccess: @(0),
                          isShareCancelled: @(1),
                          shareError: [NSError errorWithDomain:NSCocoaErrorDomain code:-200 userInfo:@{NSLocalizedFailureReasonErrorKey:@"MessageComposeResultCancelled"}]
                          };
            break;
        case MessageComposeResultSent:
            resultDic = @{
                          isShareSuccess: @(1)
                          };
            break;
        case MessageComposeResultFailed:
            resultDic = @{
                          isShareSuccess: @(0),
                          isShareCancelled: @(0),
                          shareError: [NSError errorWithDomain:NSCocoaErrorDomain code:-200 userInfo:@{NSLocalizedFailureReasonErrorKey:@"MessageComposeResultFailed"}]
                          };
            break;
        default:
            break;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:VBShareResultNotification object:VBShareResultNotification userInfo:resultDic];
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end

/*
 supportImage: @(1),
 supportText: @(1),
 supportImageAndText: @(1),
 supportWebLink: @(1),
 supportFile: @(1),
 */
