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
#import "AFHTTPRequestOperationManager.h"
#import "MainInterfaceJSONSerializer.h"


#define kSectionViewHeight      40

@interface MainViewController () <UITableViewDataSource,UITableViewDelegate,MainViewCellDelegate>{
    NSInteger currpage;
    NSInteger totalCount;//图集总数
}

@property (nonatomic,retain) UITableView *mtableview;
@property (nonatomic,retain) NSMutableArray *albunmArray;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        currpage = 1;
        self.albunmArray = [NSMutableArray array];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //TODO:考虑挪到父类里面
    CGFloat h = self.tabBarController.tabBar.frame.size.height;
    CGRect windowFrame = [[UIScreen mainScreen] bounds];
    self.view.frame = CGRectMake(0, 20,
                                 windowFrame.size.width,
                                 windowFrame.size.height-self.navigationController.navigationBar.frame.size.height-25-h);
    
    self.title = @"名牌宝贝";
//    [self.navigationController.navigationBar setTranslucent:NO];

    self.mtableview = [[[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                    0,
                                                                    self.view.bounds.size.width, self.view.bounds.size.height)] autorelease];
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
                                                 windowFrame.size.height-self.navigationController.navigationBar.frame.size.height-25-h);

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
    self.albunmArray = nil;
    
    [super dealloc];
}

#pragma mark - private method
-(void)getNextPage
{
    //http://vps.taoxiaoxian.com/interface4phone/albunmlistForMainView?currpage=1&appid=4
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"currpage": [NSString stringWithFormat:@"%d",currpage],
                                 @"appid":kAppId};
    manager.responseSerializer = [MainInterfaceJSONSerializer serializer];
    
    [manager GET:[NSString stringWithFormat:@"%@/interface4phone/albunmlistForMainView",kBaseInterfaceDomain]
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSDictionary *resultDict = (NSDictionary *)responseObject;
             
             if ([[resultDict objectForKey:@"result_code"] integerValue] == 200 ) {
                 totalCount = [[resultDict objectForKey:@"total_count"] integerValue];
                 
                 [self.albunmArray addObjectsFromArray:[NSArray arrayWithArray:[resultDict objectForKey:@"albunm_items"]]];
                 currpage++;
                 
                 [self.mtableview reloadData];
             }
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"request interface interface4phone/albunmlistForMainView did failed : %@",[error localizedDescription]);
         }];
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
        cell.delegate = self;
    }
    
    cell.albunmModel = [self.albunmArray objectAtIndex:indexPath.section];
    
    return cell;
}

#pragma mark - UITableViewDelegate<NSObject, UIScrollViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MainViewCell *cell = (MainViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return [cell cellSize].height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kSectionViewHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    AlbunmModel *albunm = [self.albunmArray objectAtIndex:section];
    
    UIView *sectionView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,kSectionViewHeight)] autorelease];
    sectionView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9f];
    UILabel *titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10,
                                                                     9,
                                                                     self.view.bounds.size.width - 100,
                                                                     20)] autorelease];
    titleLabel.textColor = [UIColor blueColor];
    titleLabel.text = albunm.albunm_name;
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
    timeLabel.text = [albunm.last_add_time getDynamicDateStringFromNow];//计算时间
    timeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0f];
    [sectionView addSubview:timeLabel];
    
    UIView *lineView = [[[UIView alloc] initWithFrame:CGRectMake(0, sectionView.frame.size.height-0.5f,
                                                                sectionView.frame.size.width,0.5f)] autorelease];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [sectionView addSubview:lineView];
    
    return sectionView;
}

#pragma mark - MainViewCellDelegate

-(void)needNotifyDatasetUpdate
{
    [self.mtableview reloadData];
}

@end
