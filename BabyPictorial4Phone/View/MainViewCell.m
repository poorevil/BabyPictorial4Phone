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
#import "PhotosOfAlbunmViewController.h"

#import "CustomTabBarController.h"
#import "AppDelegate.h"
#import "MainViewController.h"

#import <QuartzCore/QuartzCore.h>

@interface MainViewCell() <EGOImageViewDelegate>

@property (nonatomic,retain) EGOImageView *photoView;
@property (nonatomic,retain) UIView *descTitleViewGroup;//图片描述

@property (nonatomic,retain) UIButton *favoriteBtn;//收藏
@property (nonatomic,retain) UIButton *shareBtn;//分享
@property (nonatomic,retain) UIButton *otherBtn;//其他
@property (nonatomic,retain) UIView *picAmountView;//图片数量view

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
    self.photoView.userInteractionEnabled = YES;
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
    //点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.photoView addGestureRecognizer:tap];
    [tap release];
    
    cellFrame.size.height = self.photoView.frame.size.height;
    
    //图片数量
    [self.picAmountView removeFromSuperview];
    self.picAmountView = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.size.width - 10 - 50,
                                                                     self.photoView.frame.size.height - 5 - 25,
                                                                     50, 25)];
    self.picAmountView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
//    self.picAmountView.layer.borderColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.15].CGColor;
//    self.picAmountView.layer.borderWidth = 0.5f;
    self.picAmountView.layer.cornerRadius = 2;
    UILabel *picAmountLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0,
                                                                         self.picAmountView.frame.size.width,
                                                                         self.picAmountView.frame.size.height)] autorelease];
    picAmountLabel.text = [NSString stringWithFormat:@"%d pics",self.albunmModel.pic_amount];
    picAmountLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:13.0f];
    picAmountLabel.textAlignment = NSTextAlignmentCenter;
    picAmountLabel.textColor = [UIColor whiteColor];
    [self.picAmountView addSubview:picAmountLabel];
    [self addSubview:self.picAmountView];
    
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
    
    //图片描述
    [self.descTitleViewGroup removeFromSuperview];
    self.descTitleViewGroup = [[UIView alloc] initWithFrame:CGRectMake(0, cellFrame.size.height+8,
                                                                       self.bounds.size.width, 40)];
    [self addSubview:self.descTitleViewGroup];
    if (self.albunmModel.photoArray.count == 0) {
        self.descTitleViewGroup.hidden = YES;
    }else{
        //初始化图片描述label
        UILabel *descTitleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 0,
                                                                            self.bounds.size.width-20,
                                                                            40)] autorelease];
        PicDetailModel *pic = [self.albunmModel.photoArray objectAtIndex:0];
        descTitleLabel.text = pic.descTitle;
        descTitleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f];
        descTitleLabel.textColor = [UIColor grayColor];
        descTitleLabel.numberOfLines = 2;
        [self.descTitleViewGroup addSubview:descTitleLabel];
        
        cellFrame.size.height = self.descTitleViewGroup.frame.size.height
        + self.descTitleViewGroup.frame.origin.y;
    }
    
    //点击事件
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.photoView addGestureRecognizer:tap];
    [self.otherPhotosView addGestureRecognizer:tap];
    [tap release];
    
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
    
    //收藏
    [self.favoriteBtn removeFromSuperview];
    self.favoriteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.favoriteBtn.frame = CGRectMake(10, cellFrame.size.height + 10,50, 25);
    //TODO:用图片做背景，普通、点击，两套
    self.favoriteBtn.backgroundColor = [UIColor lightGrayColor];
    [self.favoriteBtn setAdjustsImageWhenHighlighted:NO];
    [self.favoriteBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [self.favoriteBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f]];
    self.favoriteBtn.layer.cornerRadius = 4;
    [self.favoriteBtn addTarget:self
                         action:@selector(favoriteBtnAction:)
               forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.favoriteBtn];
    //分享
    [self.shareBtn removeFromSuperview];
    self.shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.shareBtn.frame = CGRectMake(self.favoriteBtn.frame.size.width + self.favoriteBtn.frame.origin.x +16,
                                     cellFrame.size.height + 10,50, 25);
    //TODO:用图片做背景，普通、点击，两套
    self.shareBtn.backgroundColor = [UIColor lightGrayColor];
    [self.shareBtn setAdjustsImageWhenHighlighted:NO];
    [self.shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    [self.shareBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f]];
    self.shareBtn.layer.cornerRadius = 4;
    [self.shareBtn addTarget:self
                         action:@selector(shareBtnAction:)
               forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.shareBtn];
    //其他btn
    [self.otherBtn removeFromSuperview];
    self.otherBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.otherBtn.frame = CGRectMake(self.bounds.size.width - 10 - 50,
                                     cellFrame.size.height + 10,50, 25);
    //TODO:用图片做背景，普通、点击，两套
    self.otherBtn.backgroundColor = [UIColor lightGrayColor];
    [self.otherBtn setAdjustsImageWhenHighlighted:YES];
    [self.otherBtn setTitle:@"..." forState:UIControlStateNormal];
    [self.otherBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f]];
    self.otherBtn.layer.cornerRadius = 4;
    [self.otherBtn addTarget:self
                         action:@selector(otherBtnAction:)
               forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.otherBtn];
    
    cellFrame.size.height = self.shareBtn.frame.size.height + self.shareBtn.frame.origin.y +24;
    
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
    self.descTitleViewGroup = nil;
    self.favoriteBtn = nil;
    self.shareBtn = nil;
    self.otherBtn = nil;
    self.picAmountView = nil;
    
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
    //picAmountView
    CGRect picAmountViewFrame = self.picAmountView.frame;
    picAmountViewFrame.origin.y -= diffY;
    self.picAmountView.frame = picAmountViewFrame;
    //otherPhotosView frame
    CGRect otherPhotosViewFrame = self.otherPhotosView.frame;
    otherPhotosViewFrame.origin.y -= diffY;
    self.otherPhotosView.frame = otherPhotosViewFrame;
    //图片描述
    CGRect descTitleViewGroupFrame = self.descTitleViewGroup.frame;
    descTitleViewGroupFrame.origin.y -= diffY;
    self.descTitleViewGroup.frame = descTitleViewGroupFrame;
    //commentsView frame
    CGRect commentViewFrame = self.commentsView.frame;
    commentViewFrame.origin.y -= diffY;
    self.commentsView.frame = commentViewFrame;
    //按钮
    CGRect fbtnFrame = self.favoriteBtn.frame;
    fbtnFrame.origin.y -= diffY;
    self.favoriteBtn.frame = fbtnFrame;
    CGRect sbtnFrame = self.shareBtn.frame;
    sbtnFrame.origin.y -= diffY;
    self.shareBtn.frame = sbtnFrame;
    CGRect obtnFrame = self.otherBtn.frame;
    obtnFrame.origin.y -= diffY;
    self.otherBtn.frame = obtnFrame;
    
    //cell frame
    CGRect cellFrame = self.frame;
    cellFrame.size.height -= diffY;
    self.frame = cellFrame;
    
    [self.delegate needNotifyDatasetUpdate];
}

- (void)imageViewFailedToLoadImage:(EGOImageView*)imageView error:(NSError*)error
{
    NSLog(@"MainViewCell  %@",[error localizedDescription]);
}

#pragma mark - UITapGestureRecognizer action
-(void)tapAction:(UIGestureRecognizer *)sender
{
    PhotosOfAlbunmViewController *photoOfAlbunmVC = [[[PhotosOfAlbunmViewController alloc] init] autorelease];
    photoOfAlbunmVC.albunmModel = self.albunmModel;
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate.tabBarController.mainViewController.navigationController pushViewController:photoOfAlbunmVC
                                                                                    animated:YES];
}

#pragma mark - Button action
-(void)favoriteBtnAction:(id)sender
{
    
}

-(void)shareBtnAction:(id)sender
{
    
}

-(void)otherBtnAction:(id)sender
{
    
}

@end
