//
//  AlbunmModel.m
//  BabyPictorial4Phone
//
//  Created by hanchao on 14-3-10.
//  Copyright (c) 2014年 hanchao. All rights reserved.
//

#import "AlbunmModel.h"
#import "PicDetailModel.h"
#import "NSDate+DynamicDateString.h"

@implementation AlbunmModel

-(id)initWithDictionary:(NSDictionary *)dict
{
//     {
//         "picdetail_list": [
//                            {
//                                "albunm_id": "4504053614",
//                                "user_id": "永生部落",
//                                "description": "韩版可爱熊猫卡通卖萌长袖套装，呆萌的设计，非常俏皮可爱",
//                                "taoke_price": "93",
//                                "pid": "6851438044",
//                                "root_cate_id": 0,
//                                "height": 460,
//                                "width": 460,
//                                "cate_id": 9,
//                                "custom_tag": 0,
//                                "time": "2014-03-12 02:40:02",
//                                "taoke_title": "",
//                                "pic_path": "http://img02.taobaocdn.com/bao/uploaded/i2/15614036924367743/T1uhGlFuJdXXXXXXXX_!!75105614-0-pix.jpg",
//                                "taoke_url": null,
//                                "albunm_name": "拉风出行必备...",
//                                "taoke_num_iid": "27374948249"
//                            },
//                            ...
//                            ],
//         "last_add_time": "2014-03-12 02:40:02",
//         "custom_tag": 0,
//         "pic_amount": 103,
//         "albunm_name": "拉风出行必备...",
//         "id": "4504053614"
//     },
    
    if (self = [super init]) {
        self.aid = [dict objectForKey:@"id"];
        self.albunm_name = [dict objectForKey:@"albunm_name"];
        self.last_add_time = [NSDate dateFromString:[dict objectForKey:@"last_add_time"]];
        self.pic_amount = [[dict objectForKey:@"pic_amount"] integerValue];
        self.custom_tag = [[dict objectForKey:@"custom_tag"] integerValue];
        
        NSArray *picDetailArray = [dict objectForKey:@"picdetail_list"];
        if (picDetailArray.count>0) {
            self.photoArray = [NSMutableArray array];
            
            [picDetailArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [self.photoArray addObject:[[[PicDetailModel alloc] initWithDictionary:obj] autorelease]];
            }];
        }
        
        //TODO:评论部分
    }
    
    return self;
}

-(void)dealloc
{ 
    self.aid = nil;
    self.albunm_name = nil;
    self.last_add_time = nil;
    
    [super dealloc];
}

@end
