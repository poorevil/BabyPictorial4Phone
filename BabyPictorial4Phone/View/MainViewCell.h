//
//  MainViewCell.h
//  BabyPictorial4Phone
//
//  Created by hanchao on 14-3-10.
//  Copyright (c) 2014年 hanchao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AlbunmModel.h"

@protocol MainViewCellDelegate <NSObject>

-(void)needNotifyDatasetUpdate;

@end

@interface MainViewCell : UITableViewCell

@property (nonatomic,assign) id<MainViewCellDelegate> delegate;
@property (nonatomic,retain) AlbunmModel *albunmModel;


-(CGSize)cellSize;//获取整个cell的高度

@end
