//
//  MainViewCellAlbunmOtherPhotosView.m
//  BabyPictorial4Phone
//
//  Created by hanchao on 14-3-10.
//  Copyright (c) 2014年 hanchao. All rights reserved.
//

#import "MainViewCellAlbunmOtherPhotosView.h"
#import "PicDetailModel.h"
#import "EGOImageView.h"


#define kMaxCellNumber          4
@interface MainViewCellAlbunmOtherPhotosView()

@property (nonatomic,retain) NSMutableArray *photoImageViewArray;

@end

@implementation MainViewCellAlbunmOtherPhotosView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        self.backgroundColor = [UIColor redColor];
        
        self.photoImageViewArray = [NSMutableArray array];
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

-(void)initViews
{
    //舍弃第一张图片
    NSInteger photoMaxIndex = self.photoArray.count > (kMaxCellNumber+1) ? kMaxCellNumber+1 : self.photoArray.count;
    //遍历1-4
    for (int i=1 ; i<photoMaxIndex ; i++) {
        PicDetailModel *picDetailModel = [self.photoArray objectAtIndex:i];
        
        CGRect cellRect = CGRectMake(0, 0,
                                     self.bounds.size.width/kMaxCellNumber,
                                     self.bounds.size.width/kMaxCellNumber);
        if (i == 1) {
            cellRect = CGRectMake(0, 0,
                                  self.bounds.size.width/kMaxCellNumber * (kMaxCellNumber+1-(photoMaxIndex-1)),
                                  self.bounds.size.width/kMaxCellNumber);
        }else{
            cellRect.origin.x = [[self.photoImageViewArray objectAtIndex:(i-2)] frame].origin.x+[[self.photoImageViewArray objectAtIndex:(i-2)] frame].size.width;
        }
        
        EGOImageView *imageView = [[[EGOImageView alloc] initWithFrame:cellRect] autorelease];
        imageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        imageView.layer.borderWidth = 0.5f;
        imageView.clipsToBounds = YES;
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        imageView.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@_%dx%d.jpg",
                                                   picDetailModel.picUrl,
                                                   (NSInteger)cellRect.size.width * 2,
                                                   (NSInteger)cellRect.size.width * 2]];
        //TODO:点击事件
        
        [self.photoImageViewArray addObject:imageView];
        [self addSubview:imageView];
        
    }
}

-(void)setPhotoArray:(NSMutableArray *)photoArray
{
    if (self.photoArray != photoArray) {
        [_photoArray release];
        _photoArray = nil;
        _photoArray = [photoArray retain];
        
        [self initViews];
    }
}

-(void)dealloc
{
    self.photoArray = nil;
    self.photoImageViewArray = nil;
    
    [super dealloc];
}

@end
