//
//  PicDetailModel.m
//  BabyPictorial4Phone
//
//  Created by hanchao on 14-3-11.
//  Copyright (c) 2014年 hanchao. All rights reserved.
//

#import "PicDetailModel.h"

@implementation PicDetailModel


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
