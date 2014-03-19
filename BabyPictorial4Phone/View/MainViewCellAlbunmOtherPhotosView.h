//
//  MainViewCellAlbunmOtherPhotosView.h
//  BabyPictorial4Phone
//
//  Created by hanchao on 14-3-10.
//  Copyright (c) 2014年 hanchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewCellAlbunmOtherPhotosView : UIView

@property (nonatomic,retain) NSMutableArray *photoArray;

-(void)cancelAllImageLoadThread;

@end
