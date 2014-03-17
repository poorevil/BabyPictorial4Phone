//
//  PhotosOfAlbunmViewCell.h
//  BabyPictorial4Phone
//
//  Created by hanchao on 14-3-17.
//  Copyright (c) 2014年 hanchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PicDetailModel;

@protocol PhotosOfAlbunmViewCellDelegate <NSObject>

-(void)needNotifyDatasetUpdate;

@end

@interface PhotosOfAlbunmViewCell : UITableViewCell

@property (nonatomic,assign) id<PhotosOfAlbunmViewCellDelegate> delegate;
@property (nonatomic,retain) PicDetailModel *picDetailModel;

-(CGSize)cellSize;

@end
