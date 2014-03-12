//
//  MainViewCellAlbunmOtherPhotosView.m
//  BabyPictorial4Phone
//
//  Created by hanchao on 14-3-10.
//  Copyright (c) 2014年 hanchao. All rights reserved.
//

#import "MainViewCellAlbunmOtherPhotosView.h"

@implementation MainViewCellAlbunmOtherPhotosView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)dealloc
{
    self.photoArray = nil;
    [super dealloc];
}

@end
