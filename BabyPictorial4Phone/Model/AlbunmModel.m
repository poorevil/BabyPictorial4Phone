//
//  AlbunmModel.m
//  BabyPictorial4Phone
//
//  Created by hanchao on 14-3-10.
//  Copyright (c) 2014年 hanchao. All rights reserved.
//

#import "AlbunmModel.h"

@implementation AlbunmModel

-(void)dealloc
{ 
    self.aid = nil;
    self.albunm_name = nil;
    self.last_add_time = nil;
    
    [super dealloc];
}

@end
