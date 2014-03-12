//
//  PicDetailModel.m
//  BabyPictorial4Phone
//
//  Created by hanchao on 14-3-11.
//  Copyright (c) 2014年 hanchao. All rights reserved.
//

#import "PicDetailModel.h"

#import "NSDate+DynamicDateString.h"

@implementation PicDetailModel

-(id)initWithDictionary:(NSDictionary *)dict
{
//       {
//            "albunm_id": "4504053614",
//            "user_id": "永生部落",
//            "description": "韩版可爱熊猫卡通卖萌长袖套装，呆萌的设计，非常俏皮可爱",
//            "taoke_price": "93",
//            "pid": "6851438044",
//            "root_cate_id": 0,
//            "height": 460,
//            "width": 460,
//            "cate_id": 9,
//            "custom_tag": 0,
//            "time": "2014-03-12 02:40:02",
//            "taoke_title": "",
//            "pic_path": "http://img02.taobaocdn.com/bao/uploaded/i2/15614036924367743/T1uhGlFuJdXXXXXXXX_!!75105614-0-pix.jpg",
//            "taoke_url": null,
//            "albunm_name": "拉风出行必备...",
//            "taoke_num_iid": "27374948249"
//        },
    
    if (self = [super init]) {
        self.pid = [dict objectForKey:@"pid"];
        self.picUrl = [dict objectForKey:@"pic_path"];
        self.userId = [dict objectForKey:@"user_id"];
        self.descTitle = [dict objectForKey:@"description"];
        self.time = [NSDate dateFromString:[dict objectForKey:@"time"]];
        self.taokeTitle = [dict objectForKey:@"taoke_title"];
        self.taokePrice = [dict objectForKey:@"taoke_price"];
        self.taokeNumiid = [dict objectForKey:@"taoke_num_iid"];
        self.taokeUrl = [dict objectForKey:@"taoke_url"];
        self.customTag = [[dict objectForKey:@"custom_tag"] integerValue];
        
    }
    
    return self;
}


-(void)dealloc
{
    self.pid = nil;
    self.picUrl = nil;
    self.userId = nil;
    self.descTitle = nil;
    self.time = nil;
    self.taokeTitle = nil;
    self.taokePrice = nil;
    self.taokeNumiid = nil;
    self.taokeUrl = nil;
    
    [super dealloc];
}
@end
