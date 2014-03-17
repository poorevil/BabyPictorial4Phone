//
//  PhotosOfAlbunmViewController.m
//  BabyPictorial4Phone
//
//  Created by hanchao on 14-3-17.
//  Copyright (c) 2014年 hanchao. All rights reserved.
//

#import "PhotosOfAlbunmViewController.h"
#import "PhotosOfAlbunmViewCell.h"
#import "NSDate+DynamicDateString.h"
#import "AFHTTPRequestOperationManager.h"
#import "PhotosOfAlbunmInterfaceJSONSerializer.h"
#import "PicDetailModel.h"
#import "AlbunmModel.h"

#import "CustomTabBarController.h"
#import "TabBarShareView.h"

#define kSectionViewHeight      40

@interface PhotosOfAlbunmViewController ()<UITableViewDataSource,UITableViewDelegate,PhotosOfAlbunmViewCellDelegate>{
    NSInteger currpage;
    NSInteger totalCount;//图片总数
}

@property (nonatomic,retain) UITableView *mtableview;
@property (nonatomic,retain) NSMutableArray *picDetailArray;
@property (nonatomic,retain) CustomTabBarController *tabbar;
@property (nonatomic,retain) TabBarShareView *tabBarView;

@end

@implementation PhotosOfAlbunmViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        currpage = 1;
        self.picDetailArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.albunmModel.albunm_name;
    [self.navigationController.navigationBar setTranslucent:NO];
    
    //处理tab bar
    self.tabbar = (CustomTabBarController *)self.tabBarController;
    
    NSArray *arr1 = [[NSBundle mainBundle] loadNibNamed:@"TabBarShareView" owner:self options:nil];
    self.tabBarView = (TabBarShareView*)[arr1 objectAtIndex:0];
    [self.tabBarView.backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBarView.homeBtn addTarget:self action:@selector(homeAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tabbar pushTabBar:self.tabBarView];
    
    //TODO:考虑挪到父类里面
    CGFloat h = self.tabBarController.tabBar.frame.size.height;
    CGRect windowFrame = [[UIScreen mainScreen] bounds];
    self.view.frame = CGRectMake(0, 0,
                                 windowFrame.size.width,
                                 windowFrame.size.height-self.navigationController.navigationBar.frame.size.height-25);
    
    self.mtableview = [[[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                    0,
                                                                    self.view.bounds.size.width,
                                                                    self.view.bounds.size.height)] autorelease];
    self.mtableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mtableview.allowsSelection = NO;
    self.mtableview.delegate = self;
    self.mtableview.dataSource = self;
    
    [self.view addSubview:self.mtableview];
    
    // Set the barTintColor. This will determine the overlay that fades in and out upon scrolling.
	[self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    //[UIColor colorWithRed:60.0/255.0 green:1 blue:150.0/255.0 alpha:1]
	[self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
	
	// Just call this line to enable the scrolling navbar
	[self followScrollView:self.mtableview];
    
    [self getNextPage];
    
//    CGRect navigationBarFrame = self.navigationController.navigationBar.frame;
//    navigationBarFrame.origin.y = 20;
//    self.navigationController.navigationBar.frame = navigationBarFrame;
}

- (void) viewWillAppear:(BOOL)animated
{
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES ];
    
    CGFloat h = self.tabBarController.tabBar.frame.size.height;
    CGRect windowFrame = [[UIScreen mainScreen] bounds];
    self.mtableview.layer.frame = CGRectMake(0, 0,
                                             windowFrame.size.width,
                                             windowFrame.size.height-self.navigationController.navigationBar.frame.size.height-25);
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    CGRect navigationBarFrame = self.navigationController.navigationBar.frame;
    navigationBarFrame.origin.y = 20;
    self.navigationController.navigationBar.frame = navigationBarFrame;
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
    self.picDetailArray = nil;
    self.albunmModel = nil;
    self.tabBarView = nil;
    
    self.tabbar = nil;
    
    [super dealloc];
}

#pragma mark - private method
//最新图片
-(void)getNextPage
{
    //http://vps.taoxiaoxian.com/interface4phone/picDetailList?currpage=1&albunmid=4
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"currpage": [NSString stringWithFormat:@"%d",currpage],
                                 @"albunmid":self.albunmModel.aid};
    manager.responseSerializer = [PhotosOfAlbunmInterfaceJSONSerializer serializer];
    
    [manager GET:[NSString stringWithFormat:@"%@/interface4phone/picDetailList",kBaseInterfaceDomain]
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSDictionary *resultDict = (NSDictionary *)responseObject;
             
             if ([[resultDict objectForKey:@"result_code"] integerValue] == 200 ) {
                 totalCount = [[resultDict objectForKey:@"total_count"] integerValue];
                 
                 [self.picDetailArray addObjectsFromArray:[NSArray arrayWithArray:[resultDict objectForKey:@"picDetail_items"]]];
                 currpage++;
                 
                 [self.mtableview reloadData];
             }
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"request interface interface4phone/newestPicDetailList did failed : %@",[error localizedDescription]);
         }];
}

#pragma mark - UITableViewDataSource<NSObject>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.picDetailArray.count;
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PhotosOfAlbunmViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[[PhotosOfAlbunmViewCell alloc] initWithFrame:CGRectMake(0, 0,
                                                              self.view.bounds.size.width,
                                                              self.view.bounds.size.width)] autorelease];
        cell.delegate = self;
    }
    
    cell.picDetailModel = [self.picDetailArray objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate<NSObject, UIScrollViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    PhotosOfAlbunmViewCell *cell = (PhotosOfAlbunmViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return [cell cellSize].height;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return kSectionViewHeight;
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
////    PicDetailModel *picDetail = [self.picDetailArray objectAtIndex:section];
//    
//    UIView *sectionView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,kSectionViewHeight)] autorelease];
//    sectionView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9f];
//    UILabel *titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10,
//                                                                     9,
//                                                                     self.view.bounds.size.width - 100,
//                                                                     20)] autorelease];
//    titleLabel.textColor = [UIColor blueColor];
//    titleLabel.text = self.albunmModel.albunm_name;
//    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f];
//    [sectionView addSubview:titleLabel];
//    
//    UIImageView *clockImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 95, 10, 5, 5)] autorelease];
//    //TODO:钟表形状图片
//    [sectionView addSubview:clockImageView];
//    
//    UILabel *timeLabel = [[[UILabel alloc] initWithFrame:CGRectMake(clockImageView.frame.size.width+clockImageView.frame.origin.x+5,
//                                                                    11,
//                                                                    75,
//                                                                    20)] autorelease];
//    timeLabel.textColor = [UIColor grayColor];
//    timeLabel.textAlignment = NSTextAlignmentRight;
//    timeLabel.text = [self.albunmModel.last_add_time getDynamicDateStringFromNow];//计算时间
//    timeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0f];
//    [sectionView addSubview:timeLabel];
//    
//    UIView *lineView = [[[UIView alloc] initWithFrame:CGRectMake(0, sectionView.frame.size.height-0.5f,
//                                                                 sectionView.frame.size.width,0.5f)] autorelease];
//    lineView.backgroundColor = [UIColor lightGrayColor];
//    [sectionView addSubview:lineView];
//    
//    return sectionView;
//}

#pragma mark - HotViewCellDelegate

-(void)needNotifyDatasetUpdate
{
    [self.mtableview reloadData];
}

#pragma mark - TabBar button action
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
    
    [self.tabbar popTabBar];//移除当前tabbar
    
}

-(void)homeAction{
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    //    CustomTabBarController *mCustomTabBarController = (CustomTabBarController *)self.tabBarController;
    //移除当前tabbar
    [self.tabbar popToRootTabBar];//移除当前tabbar
    
}

- (void)animationDidStop:(NSString *) animationID finished:(NSNumber *) finished context:(void *) context {
	[self.tabBarView removeFromSuperview];
}


@end
