//
//  MainViewController.m
//  BabyPictorial4Phone
//
//  Created by hanchao on 14-3-7.
//  Copyright (c) 2014年 hanchao. All rights reserved.
//

#import "MainViewController.h"
#import "CustomNavigationController.h"
#import "MainViewCell.h"
#import "NSDate+DynamicDateString.h"


#define kReasonableDistance 4

@interface MainViewController () <UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,MainViewCellDelegate>{
    CGPoint lastScrollPoint;
    NSInteger lastDirection;
}

//@property (nonatomic,retain) UIScrollView *mscrollView;

@property (nonatomic,retain) UITableView *mtableview;

@property (nonatomic,retain) NSMutableArray *albunmArray;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"名牌宝贝";
    [self.navigationController.navigationBar setTranslucent:YES];
    
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-55-40);
    
//    self.mscrollView = [[[UIScrollView alloc] init] autorelease];
//    self.mscrollView.frame = self.view.bounds;
//    //TODO:
//    self.mscrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height*2);
//    self.mscrollView.delegate = self;
//    self.mscrollView.scrollsToTop = YES;
//    [self.view addSubview:self.mscrollView];
//    
//    //TODO:测试代码
//    UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(100, 0, 100, self.view.bounds.size.height*2)] autorelease];
//    view.backgroundColor = [UIColor redColor];
//    [self.mscrollView addSubview:view];
    
//    lastScrollPoint = self.mscrollView.contentOffset;
//    lastDirection = 0;

    
    self.mtableview = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.mtableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mtableview.delegate = self;
    self.mtableview.dataSource = self;
    
    [self.view addSubview:self.mtableview];
    
    lastScrollPoint = self.mtableview.contentOffset;
    lastDirection = 0;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
//    self.mscrollView = nil;
    self.mtableview = nil;
    
    [super dealloc];
}

#pragma mark - UIScrollViewDelegate<NSObject>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.frame.size.height >= scrollView.contentSize.height)
        return;
    
    CustomNavigationController *nav = (CustomNavigationController *)self.navigationController;
    
    if (scrollView.contentOffset.y <= -(self.navigationController.navigationBar.frame.size.height+self.navigationController.navigationBar.frame.origin.y)) {
        [nav changeNavigationBar2Normal];
    }else if(scrollView.contentOffset.y >= (self.navigationController.navigationBar.frame.size.height+self.navigationController.navigationBar.frame.origin.y+scrollView.contentSize.height-scrollView.frame.size.height)){
        [nav changeNavigationBar2Small];
    }else{
        
        CGFloat distance = lastScrollPoint.y - scrollView.contentOffset.y;
        NSInteger direction = distance > 0 ? 1 : -1;//大于0向上滚动
        
        if (abs(distance) > kReasonableDistance && direction != lastDirection) {
            if (direction>0) {//向上滚动
                CustomNavigationController *nav = (CustomNavigationController *)self.navigationController;
                [nav changeNavigationBar2Normal];
            }else{//向下滚动
                CustomNavigationController *nav = (CustomNavigationController *)self.navigationController;
                [nav changeNavigationBar2Small];
            }
            
            lastDirection = direction;
        }
    }
    
    lastScrollPoint = scrollView.contentOffset;
    
}

#pragma mark - UITableViewDataSource<NSObject>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.albunmArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MainViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[[MainViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width)] autorelease];
    }
    
    cell.albunmModel = [self.albunmArray objectAtIndex:indexPath.section];
    
    return cell;
}

#pragma mark - UITableViewDelegate<NSObject, UIScrollViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MainViewCell *cell = (MainViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    return [cell cellSize].height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    AlbunmModel *albunm = [self.albunmArray objectAtIndex:section];
    
    
    UIView *sectionView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,30)] autorelease];
    UILabel *titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(20,
                                                                     5,
                                                                     self.view.bounds.size.width - 80,
                                                                     20)] autorelease];
    titleLabel.text = albunm.albunm_name;
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17.0f];
    [sectionView addSubview:titleLabel];
    
    UIImageView *clockImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 65, 10, 5, 5)] autorelease];
    //TODO:钟表形状图片
    [sectionView addSubview:clockImageView];
    
    UILabel *timeLabel = [[[UILabel alloc] initWithFrame:CGRectMake(clockImageView.frame.size.width+clockImageView.frame.origin.x+5,
                                                                     5,
                                                                     self.view.bounds.size.width - 50,
                                                                     20)] autorelease];
    timeLabel.text = [albunm.last_add_time getDynamicDateStringFromNow];//计算时间
    timeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17.0f];
    [sectionView addSubview:timeLabel];
    
    return sectionView;
}

#pragma mark - MainViewCellDelegate

-(void)needNotifyDatasetUpdate
{
    [self.mtableview reloadData];
}

@end
