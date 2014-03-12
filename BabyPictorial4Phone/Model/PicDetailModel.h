//
//  PicDetailModel.h
//  BabyPictorial4Phone
//
//  Created by hanchao on 14-3-11.
//  Copyright (c) 2014年 hanchao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PicDetailModel : NSObject

@property (nonatomic,retain) NSString *pid;
@property (nonatomic,retain) NSString *picUrl;
@property (nonatomic,retain) NSString *userId;
@property (nonatomic,retain) NSString *descTitle;
@property (nonatomic,retain) NSString *time;
@property (nonatomic,retain) NSString *taokeTitle;
@property (nonatomic,retain) NSString *taokePrice;
@property (nonatomic,retain) NSString *taokeNumiid;
@property (nonatomic,retain) NSString *taokeUrl;//淘客地址
@property (nonatomic,assign) NSInteger customTag;//是否手动添加

@end
