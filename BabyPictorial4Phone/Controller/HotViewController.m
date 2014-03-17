//
//  HotViewController.m
//  BabyPictorial4Phone
//
//  Created by hanchao on 14-3-7.
//  Copyright (c) 2014年 hanchao. All rights reserved.
//

#import "HotViewController.h"
#import "HotViewCell.h"
#import "NSDate+DynamicDateString.h"
#import "AFHTTPRequestOperationManager.h"
#import "HotInterfaceJSONSerializer.h"
#import "PicDetailModel.h"
#import "AlbunmModel.h"

#define kSectionViewHeight      40

@interface HotViewController () <UITableViewDataSource,UITableViewDelegate,HotViewCellDelegate>{
    NSInteger currpage;
    NSInteger totalCount;//图集总数
}

@property (nonatomic,retain) UITableView *mtableview;
@property (nonatomic,retain) NSMutableArray *picDetailArray;

@end

@implementation HotViewController

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
    
    self.title = @"名牌宝贝";
    
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
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    
    [super dealloc];
}

#pragma mark - private method
//最新图片
-(void)getNextPage
{
    //http://vps.taoxiaoxian.com/interface4phone/newestPicDetailList?currpage=1&appid=4
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"currpage": [NSString stringWithFormat:@"%d",currpage],
                                 @"appid":kAppId};
    manager.responseSerializer = [HotInterfaceJSONSerializer serializer];
    
    [manager GET:[NSString stringWithFormat:@"%@/interface4phone/newestPicDetailList",kBaseInterfaceDomain]
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
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.picDetailArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HotViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[[HotViewCell alloc] initWithFrame:CGRectMake(0, 0,
                                                              self.view.bounds.size.width,
                                                              self.view.bounds.size.width)] autorelease];
        cell.delegate = self;
    }
    
    cell.picDetailModel = [self.picDetailArray objectAtIndex:indexPath.section];
    
    return cell;
}

#pragma mark - UITableViewDelegate<NSObject, UIScrollViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HotViewCell *cell = (HotViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return [cell cellSize].height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kSectionViewHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    PicDetailModel *picDetail = [self.picDetailArray objectAtIndex:section];
    
    UIView *sectionView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,kSectionViewHeight)] autorelease];
    sectionView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9f];
    UILabel *titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10,
                                                                     9,
                                                                     self.view.bounds.size.width - 100,
                                                                     20)] autorelease];
    titleLabel.textColor = [UIColor blueColor];
    titleLabel.text = picDetail.ownerAlbunm.albunm_name;
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f];
    [sectionView addSubview:titleLabel];
    
    UIImageView *clockImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 95, 10, 5, 5)] autorelease];
    //TODO:钟表形状图片
    [sectionView addSubview:clockImageView];
    
    UILabel *timeLabel = [[[UILabel alloc] initWithFrame:CGRectMake(clockImageView.frame.size.width+clockImageView.frame.origin.x+5,
                                                                    11,
                                                                    75,
                                                                    20)] autorelease];
    timeLabel.textColor = [UIColor grayColor];
    timeLabel.textAlignment = NSTextAlignmentRight;
    timeLabel.text = [picDetail.ownerAlbunm.last_add_time getDynamicDateStringFromNow];//计算时间
    timeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0f];
    [sectionView addSubview:timeLabel];
    
    UIView *lineView = [[[UIView alloc] initWithFrame:CGRectMake(0, sectionView.frame.size.height-0.5f,
                                                                 sectionView.frame.size.width,0.5f)] autorelease];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [sectionView addSubview:lineView];
    
    return sectionView;
}

#pragma mark - HotViewCellDelegate

-(void)needNotifyDatasetUpdate
{
    [self.mtableview reloadData];
}

@end
