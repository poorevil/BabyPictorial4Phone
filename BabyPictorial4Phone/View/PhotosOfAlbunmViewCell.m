//
//  PhotosOfAlbunmViewCell.m
//  BabyPictorial4Phone
//
//  Created by hanchao on 14-3-17.
//  Copyright (c) 2014年 hanchao. All rights reserved.
//

#import "PhotosOfAlbunmViewCell.h"

#import "EGOImageView.h"
#import "MainViewCellAlbunmPhotoCommentsView.h"
#import "PicDetailModel.h"
#import "AlbunmModel.h"
#import "CommentModel.h"

@interface PhotosOfAlbunmViewCell() <EGOImageViewDelegate>

@property (nonatomic,retain) EGOImageView *photoView;
@property (nonatomic,retain) MainViewCellAlbunmPhotoCommentsView *commentsView;//评论view group

@end

@implementation PhotosOfAlbunmViewCell

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
    if (self.picDetailModel.picUrl != nil) {
        self.photoView.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@_640x640.jpg",
                                                        self.picDetailModel.picUrl]];
    }
    [self addSubview:self.photoView];
    
    cellFrame.size.height = self.photoView.frame.size.height;
    
    /*
     * 评论
     */
    [self.commentsView removeFromSuperview];
    self.commentsView = [[[MainViewCellAlbunmPhotoCommentsView alloc] initWithFrame:CGRectMake(0, cellFrame.size.height+4, self.bounds.size.width, 100)] autorelease];
    self.commentsView.commentArray = self.picDetailModel.commentArray;
    [self addSubview:self.commentsView];
    if (self.picDetailModel.commentArray.count == 0) {
        self.commentsView.hidden = YES;
    }else{
        cellFrame.size.height = self.commentsView.frame.size.height + self.commentsView.frame.origin.y;
    }
    
    self.frame = cellFrame;
}

-(void)setPicDetailModel:(PicDetailModel *)picDetailModel
{
    if (self.picDetailModel != picDetailModel) {
        [_picDetailModel release];
        _picDetailModel = nil;
        _picDetailModel = [picDetailModel retain];
        
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
    self.picDetailModel = nil;
    self.photoView = nil;
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
    //commentsView frame
    CGRect commentViewFrame = self.commentsView.frame;
    commentViewFrame.origin.y -= diffY;
    self.commentsView.frame = commentViewFrame;
    //cell frame
    CGRect cellFrame = self.frame;
    cellFrame.size.height -= diffY;
    self.frame = cellFrame;
    
    //    NSLog(@"------needNotifyDatasetUpdate--------");
    
    if ([self.delegate respondsToSelector:@selector(needNotifyDatasetUpdate)]) {
        [self.delegate needNotifyDatasetUpdate];
    }

}

- (void)imageViewFailedToLoadImage:(EGOImageView*)imageView error:(NSError*)error
{
    NSLog(@"PhotosOfAlbunmViewCell  %@",[error localizedDescription]);
}


@end
