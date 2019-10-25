//
//  VBViewController.m
//  HWShareUtility
//
//  Created by 史黎明 on 10/25/2019.
//  Copyright (c) 2019 史黎明. All rights reserved.
//

#import "VBViewController.h"
#import <Masonry.h>
#import <HWShareUtility/VBShareUtility.h>

@interface VBViewController ()

@end

@implementation VBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    UIButton *button = [UIButton buttonWithType:UIButtonTypeInfoLight];
    button.center = self.view.center;
    [self.view addSubview:button];
    
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)buttonClick {
    NSDictionary *dic = @{
                   @"channelList" :  @[@0, @1, @2, @3, @4],
                   @"description" : @"欢迎使用 livi http://vbsit2.s.livibank.com/5ee3e903",
                   @"title" : @"[livi] 这是title!",
                   @"type" : @"webUrl",
                   @"text": @"text 欢迎使用 livi http://vbsit2.s.livibank.com/5ee3e903",
                   @"url" : @"http://vbsit2.s.livibank.com/5ee3e903",
//                   @"thumbImage": [UIImage imageNamed:@"SettingResource.bundle/feedback_topbanner"],
                   //        @"thumbImage": @"https://s1.ax1x.com/2018/05/07/Caao4g.png",
                   @"imageUrl"  : @"https://s1.ax1x.com/2018/05/07/Caao4g.png"
                   };
    [[[VBShareUtility alloc] init] shareWithContentType:VBShareContentTypeText content:dic];
}


@end
