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


#define kReasonableDistance 4

@interface MainViewController () <UITableViewDataSource,UITableViewDelegate,MainViewCellDelegate>{
//    CGPoint lastScrollPoint;
//    NSInteger lastDirection;
    
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
        // Custom initialization
        currpage = 1;
        self.albunmArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"名牌宝贝";
    [self.navigationController.navigationBar setTranslucent:NO];
    
    CGFloat h = self.tabBarController.tabBar.frame.size.height;
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-115-h*2);

    [self.mtableview setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    self.mtableview = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                    0,
                                                                    self.view.bounds.size.width, self.view.bounds.size.height)];
    self.mtableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mtableview.delegate = self;
    self.mtableview.dataSource = self;
    
    [self.view addSubview:self.mtableview];
    
//    lastScrollPoint = self.mtableview.contentOffset;
//    lastDirection = 0;

    // Set the barTintColor. This will determine the overlay that fades in and out upon scrolling.
	[self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:60.0/255.0
                                                                             green:1
                                                                              blue:150.0/255.0
                                                                             alpha:1]];
	[self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
	
	// Just call this line to enable the scrolling navbar
	[self followScrollView:self.mtableview];
    
    [self getNextPage];
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
    }
    
    cell.albunmModel = [self.albunmArray objectAtIndex:indexPath.section];
    
    return cell;
}

#pragma mark - UITableViewDelegate<NSObject, UIScrollViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"%d   %d",indexPath.section,indexPath.row);
    
    MainViewCell *cell = (MainViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return [cell cellSize].height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    AlbunmModel *albunm = [self.albunmArray objectAtIndex:section];
    
    
    UIView *sectionView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,30)] autorelease];
    UILabel *titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10,
                                                                     5,
                                                                     self.view.bounds.size.width - 100,
                                                                     20)] autorelease];
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.text = albunm.albunm_name;
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0f];
    [sectionView addSubview:titleLabel];
    
    UIImageView *clockImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 95, 10, 5, 5)] autorelease];
    //TODO:钟表形状图片
    [sectionView addSubview:clockImageView];
    
    UILabel *timeLabel = [[[UILabel alloc] initWithFrame:CGRectMake(clockImageView.frame.size.width+clockImageView.frame.origin.x+5,
                                                                     5,
                                                                     self.view.bounds.size.width - 50,
                                                                     20)] autorelease];
    timeLabel.textColor = [UIColor grayColor];
    timeLabel.text = [albunm.last_add_time getDynamicDateStringFromNow];//计算时间
    timeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0f];
    [sectionView addSubview:timeLabel];
    
    return sectionView;
}

#pragma mark - MainViewCellDelegate

-(void)needNotifyDatasetUpdate
{
    [self.mtableview reloadData];
}

//#pragma mark - UIScrollViewDelegate<NSObject>
////用于控制navigation bar高度
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if(scrollView.frame.size.height >= scrollView.contentSize.height)
//        return;
//    
//    CustomNavigationController *nav = (CustomNavigationController *)self.navigationController;
//    
//    if (scrollView.contentOffset.y <= -(self.navigationController.navigationBar.frame.size.height+self.navigationController.navigationBar.frame.origin.y)) {
//        [nav changeNavigationBar2Normal];
//    }else if(scrollView.contentOffset.y >= (self.navigationController.navigationBar.frame.size.height+self.navigationController.navigationBar.frame.origin.y+scrollView.contentSize.height-scrollView.frame.size.height)){
//        [nav changeNavigationBar2Small];
//    }else{
//        
//        CGFloat distance = lastScrollPoint.y - scrollView.contentOffset.y;
//        NSInteger direction = distance > 0 ? 1 : -1;//大于0向上滚动
//        
//        if (abs(distance) > kReasonableDistance && direction != lastDirection) {
//            if (direction>0) {//向上滚动
//                CustomNavigationController *nav = (CustomNavigationController *)self.navigationController;
//                [nav changeNavigationBar2Normal];
//            }else{//向下滚动
//                CustomNavigationController *nav = (CustomNavigationController *)self.navigationController;
//                [nav changeNavigationBar2Small];
//            }
//            
//            lastDirection = direction;
//        }
//    }
//    
//    lastScrollPoint = scrollView.contentOffset;
//    
//}

@end
