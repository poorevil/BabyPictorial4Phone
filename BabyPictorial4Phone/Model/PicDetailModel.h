//
//  PicDetailModel.h
//  BabyPictorial4Phone
//
//  Created by hanchao on 14-3-11.
//  Copyright (c) 2014年 hanchao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AlbunmModel;

@interface PicDetailModel : NSObject

@property (nonatomic,retain) NSString *pid;
@property (nonatomic,retain) NSString *picUrl;
@property (nonatomic,retain) NSString *userId;
@property (nonatomic,retain) NSString *descTitle;
@property (nonatomic,retain) NSDate *time;
@property (nonatomic,retain) NSString *taokeTitle;
@property (nonatomic,retain) NSString *taokePrice;
@property (nonatomic,retain) NSString *taokeNumiid;
@property (nonatomic,retain) NSString *taokeUrl;//淘客地址
@property (nonatomic,assign) NSInteger customTag;//是否手动添加

@property (nonatomic,retain) NSMutableArray *commentArray;//评论列表，用于“最热图片"页面
@property (nonatomic,retain) AlbunmModel *ownerAlbunm;//所属图集，用于“最热图片"页面

-(id)initWithDictionary:(NSDictionary *)dict;

@end
