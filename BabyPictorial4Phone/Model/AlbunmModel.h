//
//  AlbunmModel.h
//  BabyPictorial4Phone
//
//  Created by hanchao on 14-3-10.
//  Copyright (c) 2014年 hanchao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlbunmModel : NSObject

@property (nonatomic,retain) NSString *aid;
@property (nonatomic,retain) NSString *albunm_name;
@property (nonatomic,retain) NSDate *last_add_time;//最后添加时间
@property (nonatomic,assign) NSInteger pic_amount;//图片数量
@property (nonatomic,assign) NSInteger custom_tag;//手否自己添加的

@property (nonatomic,retain) NSMutableArray *photoArray;//相册包含的所有图片

@property (nonatomic,retain) NSMutableArray *commentArray;//相册中图片的部分评论，用于首页显示

-(id)initWithDictionary:(NSDictionary *)dict;
@end
