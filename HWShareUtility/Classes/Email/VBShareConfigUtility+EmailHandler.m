//
//  VBShareConfigUtility+EmailHandler.m
//  Person
//
//  Created by 史黎明 on 2019/8/22.
//  Copyright © 2019 史黎明. All rights reserved.
//

#import "VBShareConfigUtility+EmailHandler.h"

@implementation VBShareConfigUtility (EmailHandler)
- (BOOL)canSendEmail {
    return [MFMailComposeViewController canSendMail];
}

- (void)sendEmail:(NSDictionary *)dic {
    if (![self canSendEmail]) {
        return;
    }
    MFMailComposeViewController *emailVC = [[MFMailComposeViewController alloc] init];
    emailVC.mailComposeDelegate = self;
    [emailVC setSubject:dic[shareTitle]];
    switch (self.contentType) {
        case VBShareContentTypeText: {
            [emailVC setMessageBody:dic[shareText] isHTML:NO];
        }
            break;
        case VBShareContentTypeImage:
        case VBShareContentTypeImageText:{
            [self setEmailImageAttachment:dic[shareImageUrl] emailVC:emailVC];
            [emailVC setMessageBody:dic[shareText] isHTML:NO];
        }
            break;
        case VBShareContentTypeWebLink:{
            [self setEmailImageAttachment:dic[shareThumbImage] emailVC:emailVC];
            [emailVC setMessageBody:dic[shareDescription] isHTML:NO];
        }
            break;
        case VBShareContentTypeFile:{
            NSString *fileName = dic[shareFileName]?:[NSString stringWithFormat:@"%@.%@", @"shareFile", dic[shareFileType]];
            [emailVC addAttachmentData:dic[shareFileData] mimeType:dic[shareFileType] fileName:fileName];
        }
            break;
    }
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:emailVC animated:YES completion:nil];
}

- (void)setEmailImageAttachment:(id)data emailVC:(MFMailComposeViewController *)emailVC{
    NSData *imageData = nil;
    if ([data isKindOfClass:UIImage.class]) {
        imageData = UIImagePNGRepresentation(data);
    }else if ([data isKindOfClass:NSString.class]) {
        imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:data]];
    }
    if (imageData) {
        NSString *imageType = [VBShareGlobal getImageTypeWithImageData:imageData];
        NSString *mimeType = [NSString stringWithFormat:@"%@/%@", @"image", imageType];
        NSString *imageName = [NSString stringWithFormat:@"%@.%@", [@"shareImage" md5String], imageType];
        [emailVC addAttachmentData:imageData mimeType:mimeType fileName:imageName];
    }
}

#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    NSDictionary *resultDic = nil;
    switch (result) {
        case MFMailComposeResultCancelled:
            resultDic = @{
                          isShareSuccess: @(0),
                          isShareCancelled: @(1),
                          shareError: error?:[NSError errorWithDomain:NSCocoaErrorDomain code:-200 userInfo:@{NSLocalizedFailureReasonErrorKey:@"MFMailComposeResultCancelled"}]
                          };
            break;
        case MFMailComposeResultSaved:
            resultDic = @{
                          isShareSuccess: @(0),
                          isShareCancelled: @(1),
                          shareError: error?:[NSError errorWithDomain:NSCocoaErrorDomain code:-200 userInfo:@{NSLocalizedFailureReasonErrorKey:@"MFMailComposeResultSaved"}]
                          };
            break;
        case MFMailComposeResultSent:
            resultDic = @{
                          isShareSuccess: @(1)
                          };
            break;
        case MFMailComposeResultFailed:
            resultDic = @{
                          isShareSuccess: @(0),
                          isShareCancelled: @(0),
                          shareError: error?:[NSError errorWithDomain:NSCocoaErrorDomain code:-200 userInfo:@{NSLocalizedFailureReasonErrorKey:@"MFMailComposeResultFailed"}]
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
 如果没有配置邮箱账号直接跳到邮箱会崩溃，所以要处理下
 
 supportImage: @(1),
 supportText: @(1),
 supportImageAndText: @(1),
 supportWebLink: @(1),
 supportFile: @(1),
 */
