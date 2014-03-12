//
//  MainInterfaceJSONSerializer.m
//  BabyPictorial4Phone
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
    //    "id":   obj.id,
    //    "name": obj.name,
    //    "iconUrl": obj.iconUrl,
    //    "homepageUrl": obj.homepageUrl,
    //    "registInterfaceUrl": obj.registInterfaceUrl,
    
    NSArray *resultlist = [super responseObjectForResponse:response
                                                      data:data
                                                     error:error];
    
    
    NSMutableArray * portalArray = [NSMutableArray array];
    if (resultlist != nil)
    {
        [resultlist enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [portalArray addObject:[[[PortalModel alloc] initWithDictionary:obj] autorelease]];
        }];
    }
    return portalArray;
}

@end
