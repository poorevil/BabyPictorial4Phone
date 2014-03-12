//
//  CustomTabBarController.h
//  BabyPictorial4Phone
//
//  Created by hanchao on 14-3-7.
//  Copyright (c) 2014年 hanchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainViewController;
@class HotViewController;
@class MeViewController;

@interface CustomTabBarController : UITabBarController

@property (nonatomic,retain) MainViewController *mainViewController;
@property (nonatomic,retain) HotViewController *hotViewController;
@property (nonatomic,retain) MeViewController *meViewController;


@end
