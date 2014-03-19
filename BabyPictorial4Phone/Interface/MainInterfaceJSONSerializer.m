//
//  MainInterfaceJSONSerializer.m
//  BabyPictorial4Phone
//
//  用于主页的图集列表接口
//
//  Created by hanchao on 14-3-11.
//  Copyright (c) 2014年 hanchao. All rights reserved.
//

#import "MainInterfaceJSONSerializer.h"
#import "AlbunmModel.h"

@implementation MainInterfaceJSONSerializer

#pragma mark - AFURLRequestSerialization
-(id)responseObjectForResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError *__autoreleasing *)error
{
//    {
//        "total_count": 3383,
//        "albunm_items": [
//                         {
//                             "picdetail_list": [
//                                                {
//                                                    "albunm_id": "4504053614",
//                                                    "user_id": "永生部落",
//                                                    "description": "韩版可爱熊猫卡通卖萌长袖套装，呆萌的设计，非常俏皮可爱",
//                                                    "taoke_price": "93",
//                                                    "pid": "6851438044",
//                                                    "root_cate_id": 0,
//                                                    "height": 460,
//                                                    "width": 460,
//                                                    "cate_id": 9,
//                                                    "custom_tag": 0,
//                                                    "time": "2014-03-12 02:40:02",
//                                                    "taoke_title": "",
//                                                    "pic_path": "http://img02.taobaocdn.com/bao/uploaded/i2/15614036924367743/T1uhGlFuJdXXXXXXXX_!!75105614-0-pix.jpg",
//                                                    "taoke_url": null,
//                                                    "albunm_name": "拉风出行必备...",
//                                                    "taoke_num_iid": "27374948249"
//                                                },
//                                                ...
//                                                ],
//                             "last_add_time": "2014-03-12 02:40:02",
//                             "custom_tag": 0,
//                             "pic_amount": 103,
//                             "albunm_name": "拉风出行必备...",
//                             "id": "4504053614"
//                         },
//                         ...
//                         ],
//        "result_code": 200
//    }
    
    NSDictionary *jsonDict = [super responseObjectForResponse:response
                                                           data:data
                                                          error:error];
    
    NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];//返回结果
    
    [resultDict setObject:[[[jsonDict objectForKey:@"result_code"] copy] autorelease] forKey:@"result_code"];
    [resultDict setObject:[[[jsonDict objectForKey:@"total_count"] copy] autorelease] forKey:@"total_count"];
    
    NSMutableArray * albunmArray = [NSMutableArray array];
    NSInteger result_code = [[jsonDict objectForKey:@"result_code"] integerValue];
    if (result_code == 200)
    {
        NSArray *albunmJsonArray = [jsonDict objectForKey:@"albunm_items"];
        
        [albunmJsonArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [albunmArray addObject:[[[AlbunmModel alloc] initWithDictionary:obj] autorelease]];
        }];
    }
    
    [resultDict setObject:albunmArray forKey:@"albunm_items"];
    
    return resultDict;
}

@end
