//
//  HotViewCell.h
//  BabyPictorial4Phone
//
//  Created by han chao on 14-3-14.
//  Copyright (c) 2014年 hanchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PicDetailModel;

@protocol HotViewCellDelegate <NSObject>

-(void)needNotifyDatasetUpdate;

@end

@interface HotViewCell : UITableViewCell

@property (nonatomic,assign) id<HotViewCellDelegate> delegate;
@property (nonatomic,retain) PicDetailModel *picDetailModel;

-(CGSize)cellSize;

@end
