//
//  MainViewCell.m
//  BabyPictorial4Phone
//
//  Created by hanchao on 14-3-10.
//  Copyright (c) 2014年 hanchao. All rights reserved.
//

#import "MainViewCell.h"
#import "EGOImageView.h"
#import "MainViewCellAlbunmOtherPhotosView.h"
#import "MainViewCellAlbunmPhotoCommentsView.h"
#import "PicDetailModel.h"
#import "CommentModel.h"

@interface MainViewCell() <EGOImageViewDelegate>

@property (nonatomic,retain) EGOImageView *photoView;
@property (nonatomic,retain) MainViewCellAlbunmOtherPhotosView *otherPhotosView;//图集其他图片view group
@property (nonatomic,retain) MainViewCellAlbunmPhotoCommentsView *commentsView;//评论view group

@end

@implementation MainViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:@"cell"];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)initViews
{
    //cell frame
    CGRect cellFrame = self.frame;
    
    [self.photoView removeFromSuperview];
    self.photoView = [[[EGOImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.width)] autorelease];
    self.photoView.clipsToBounds = YES;
    [self.photoView setContentMode:UIViewContentModeScaleAspectFill];
    self.photoView.delegate = self;
    //TODO:默认图片
    if (self.albunmModel.photoArray.count>0) {
        self.photoView.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@_640x640.jpg",
                                                         [[self.albunmModel.photoArray objectAtIndex:0] picUrl]
                                                        ]];
    }
    [self addSubview:self.photoView];
    
    cellFrame.size.height = self.photoView.frame.size.height;
    
    /*
     * 图集其他图片
     */
    [self.otherPhotosView removeFromSuperview];
    self.otherPhotosView = [[[MainViewCellAlbunmOtherPhotosView alloc]
                            initWithFrame:CGRectMake(0, cellFrame.size.height,
                                                     self.bounds.size.width,80)] autorelease];// 320/5
    self.otherPhotosView.photoArray = self.albunmModel.photoArray;
    [self addSubview:self.otherPhotosView];
    if (self.albunmModel.photoArray.count == 0) {
        self.otherPhotosView.hidden = YES;
    }else{
        cellFrame.size.height = self.otherPhotosView.frame.size.height
                                + self.otherPhotosView.frame.origin.y;
    }
    
    /*
     * 评论
     */
    [self.commentsView removeFromSuperview];
    self.commentsView = [[[MainViewCellAlbunmPhotoCommentsView alloc] initWithFrame:CGRectMake(0, cellFrame.size.height+4, self.bounds.size.width, 100)] autorelease];
    self.commentsView.commentArray = self.albunmModel.commentArray;
    [self addSubview:self.commentsView];
    if (self.albunmModel.commentArray.count == 0) {
        self.commentsView.hidden = YES;
    }else{
        cellFrame.size.height = self.commentsView.frame.size.height + self.commentsView.frame.origin.y;
    }
    
    self.frame = cellFrame;
}

-(void)setAlbunmModel:(AlbunmModel *)albunmModel
{
    if (self.albunmModel != albunmModel) {
        [_albunmModel release];
        _albunmModel = nil;
        _albunmModel = [albunmModel retain];
        
        [self initViews];
    }
    
}

/*
 * 获取整个cell的高度
 */
-(CGSize)cellSize{
    
    return self.frame.size;
}

-(void)dealloc{
    self.delegate = nil;
    self.albunmModel = nil;
    self.photoView = nil;
    self.otherPhotosView = nil;
    self.commentsView = nil;
    
    [super dealloc];
}

#pragma mark - EGOImageViewDelegate
- (void)imageViewLoadedImage:(EGOImageView*)imageView{
    
    /*
     * 重新计算自身高度
     */
    CGSize imageSize = self.photoView.image.size;
    CGRect photViewFrame = self.photoView.frame;
    CGFloat diffY = photViewFrame.size.width/imageSize.width*imageSize.height - photViewFrame.size.height;//图片高度差值
    
    //photoView frame
    photViewFrame.size.height -= diffY;
    self.photoView.frame = photViewFrame;
    //otherPhotosView frame
    CGRect otherPhotosViewFrame = self.otherPhotosView.frame;
    otherPhotosViewFrame.origin.y -= diffY;
    self.otherPhotosView.frame = otherPhotosViewFrame;
    //commentsView frame
    CGRect commentViewFrame = self.commentsView.frame;
    commentViewFrame.origin.y -= diffY;
    self.commentsView.frame = commentViewFrame;
    //cell frame
    CGRect cellFrame = self.frame;
    cellFrame.size.height -= diffY;
    self.frame = cellFrame;
    
    NSLog(@"------needNotifyDatasetUpdate--------");
    
    [self.delegate needNotifyDatasetUpdate];
}

- (void)imageViewFailedToLoadImage:(EGOImageView*)imageView error:(NSError*)error
{
    NSLog(@"MainViewCell  %@",[error localizedDescription]);
}

@end
