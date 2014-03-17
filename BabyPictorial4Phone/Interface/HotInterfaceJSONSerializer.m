//
//  HotInterfaceJSONSerializer.m
//  BabyPictorial4Phone
//
//  Created by hanchao on 14-3-17.
//  Copyright (c) 2014年 hanchao. All rights reserved.
//

#import "HotInterfaceJSONSerializer.h"
#import "PicDetailModel.h"

@implementation HotInterfaceJSONSerializer

#pragma mark - AFURLRequestSerialization
-(id)responseObjectForResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError *__autoreleasing *)error
{
//    {
//        "total_count": 122219,
//        "picDetail_items": [
//                            {
//                                "albunm_id": "4504051090",
//                                "user_id": "童妈8800",
//                                "description": "淑女风前蕾丝拼接领口蝴蝶结收袖衬衫，做工很好，穿起来很显气质。",
//                                "taoke_price": "59",
//                                "pid": "6861471080",
//                                "root_cate_id": 0,
//                                "height": 528,
//                                "width": 519,
//                                "cate_id": 9,
//                                "custom_tag": 0,
//                                "time": "2014-03-17 03:40:02",
//                                "taoke_title": "",
//                                "pic_path": "http://img04.taobaocdn.com/bao/uploaded/i4/15959035651491250/T1yTRZFyXjXXXXXXXX_!!1128575959-2-pix.png",
//                                "taoke_url": null,
//                                "albunm_name": "糖果色风靡街...",
//                                "ownerAlbunm": {
//                                    "pic_amount": 14,
//                                    "albunm_name": "糖果色风靡街...",
//                                    "id": "4504051090",
//                                    "custom_tag": 0,
//                                    "last_add_time": "2014-03-17 03:40:02"
//                                },
//                                "taoke_num_iid": "37209887464"
//                            },
//                            ...
//                            ],
//        "result_code": 200
//    }
    
    NSDictionary *jsonDict = [super responseObjectForResponse:response
                                                         data:data
                                                        error:error];
    
    NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];//返回结果
    
    [resultDict setObject:[[jsonDict objectForKey:@"result_code"] copy] forKey:@"result_code"];
    [resultDict setObject:[[jsonDict objectForKey:@"total_count"] copy] forKey:@"total_count"];
    
    NSMutableArray * picDetailArray = [NSMutableArray array];
    NSInteger result_code = [[jsonDict objectForKey:@"result_code"] integerValue];
    if (result_code == 200)
    {
        NSArray *picDetailJsonArray = [jsonDict objectForKey:@"picDetail_items"];
        
        [picDetailJsonArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [picDetailArray addObject:[[[PicDetailModel alloc] initWithDictionary:obj] autorelease]];
        }];
    }
    
    [resultDict setObject:picDetailArray forKey:@"picDetail_items"];
    
    return resultDict;
}

@end
