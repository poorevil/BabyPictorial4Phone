//
//  CustomTabBarController.m
//  BabyPictorial4Phone
//
//  Created by hanchao on 14-3-7.
//  Copyright (c) 2014年 hanchao. All rights reserved.
//

#import "CustomTabBarController.h"
#import "MainViewController.h"
#import "HotViewController.h"
#import "MeViewController.h"
#import "CustomNavigationController.h"

@interface CustomTabBarController ()

@property (nonatomic,retain) NSArray *iconNameArray;
@property (nonatomic,retain) NSArray *iconSelectedNameArray;
@property (nonatomic,retain) UIView *baseBtnGroup;

@property (nonatomic,retain) NSMutableArray *tabBarStack;//tabbar堆栈
@property (nonatomic,retain) NSMutableArray *buttons;
@property (nonatomic,assign) int currentSelectedIndex;
@property (nonatomic,retain) NSArray *iconTitleArray;//图标对应的标题
@property (nonatomic,retain) NSMutableArray *iconTitleLabelArray;//图标对应的标题的label


@end

@implementation CustomTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidLoad{
    
    self.mainViewController = [[[MainViewController alloc] init] autorelease];
    //创建导航
    CustomNavigationController *nav1 = [[[CustomNavigationController alloc]
                                   initWithRootViewController:self.mainViewController] autorelease];
    
    self.hotViewController = [[[HotViewController alloc] initWithNibName:@"HotViewController" bundle:nil] autorelease];
    //创建导航
    CustomNavigationController *nav2 = [[[CustomNavigationController alloc]
                                    initWithRootViewController:self.hotViewController] autorelease];
    
    self.meViewController = [[[MeViewController alloc] initWithNibName:@"MeViewController" bundle:nil] autorelease];
    //创建导航
    CustomNavigationController *nav3 = [[[CustomNavigationController alloc]
                                     initWithRootViewController:self.meViewController] autorelease];
    
    self.viewControllers = @[nav1,nav2,nav3];
    self.selectedIndex = 0;
    
    self.iconNameArray = @[@"sale_btn",@"search_btn",@"categoary_btn"];
    self.iconSelectedNameArray = @[@"sale_btn_focus",@"search_btn_focus",@"categoary_btn_focus"];
    
    self.iconTitleArray = @[@"最新",@"最热",@"我的"];
    
    self.iconTitleLabelArray = [NSMutableArray array];//初始化label数组
    
    [self hideRealTabBar];
    [self customTabBar];
    
}

- (void)hideRealTabBar{
    for(UIView *view in self.view.subviews){
        if([view isKindOfClass:[UITabBar class]]){
            view.hidden = YES;
            break;
        }
    }
}

- (void)customTabBar{
    self.tabBarStack = [[[NSMutableArray alloc] init] autorelease];
    
    //背景颜色
    UIImageView *imgView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"tabBarBackground"]];
    imgView.frame = CGRectMake(0,
                               self.view.frame.size.height - imgView.frame.size.height,
                               imgView.frame.size.width,
                               imgView.frame.size.height);
    [self.view addSubview:imgView];
    
    //创建按钮
    UIView *_viewGroup = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - imgView.frame.size.height + 8,
                                                                  imgView.frame.size.width, imgView.frame.size.height - 8)];
    self.baseBtnGroup = _viewGroup;
    self.baseBtnGroup.userInteractionEnabled = YES;
    [_viewGroup release];
    [self.view addSubview:self.baseBtnGroup];
    [self.tabBarStack addObject:self.baseBtnGroup];//将tabbar添加到tabbar栈中
    
    int viewCount = 3;
    self.buttons = [NSMutableArray arrayWithCapacity:viewCount];
    double _width = self.baseBtnGroup.frame.size.width / viewCount;
    double _height = self.baseBtnGroup.frame.size.height;
    
    for (int i = 0; i < viewCount; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.userInteractionEnabled = YES;
        UIImage *icon = [UIImage imageNamed:[self.iconNameArray objectAtIndex:i]];
        UIImage *iconSelected = [UIImage imageNamed:[self.iconSelectedNameArray objectAtIndex:i]];
        
        [btn setImage:iconSelected forState:UIControlStateHighlighted];
        [btn setImage:iconSelected forState:UIControlStateSelected];
        [btn setImage:icon forState:UIControlStateNormal];
        
        btn.frame = CGRectMake(i*_width + (_width - icon.size.width) / 2
                               , (_height - icon.size.height) / 2
                               , icon.size.width
                               , icon.size.height);
        
        [btn addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchDown];
        [btn addTarget:self action:@selector(setSelectedTab:) forControlEvents:UIControlEventTouchUpInside];
        [btn addTarget:self action:@selector(setSelectedTab:) forControlEvents:UIControlEventTouchUpOutside];
        
        btn.tag = i;
        
        UILabel *titleLabel = [[UILabel alloc]
                               initWithFrame:CGRectMake(btn.frame.origin.x
                                                        , btn.frame.origin.y + btn.frame.size.height - 5
                                                        , btn.frame.size.width
                                                        , 14)];
        titleLabel.text = [self.iconTitleArray objectAtIndex:i];
        titleLabel.font = [UIFont boldSystemFontOfSize:10];
        titleLabel.textColor = [UIColor darkGrayColor];
        titleLabel.alpha = 0;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.iconTitleLabelArray addObject:titleLabel];
        
        
        [self.buttons addObject:btn];
        [self.baseBtnGroup  addSubview:btn];
        [self.baseBtnGroup addSubview:titleLabel];
        
        [titleLabel release];
    }
    
    [imgView release];
    
}

#pragma mark - tabbar 按钮点击事件
-(void)setSelectedIndex:(NSUInteger)selectedIndex
{
    super.selectedIndex = selectedIndex;
    
    UIButton *btn = [self.buttons objectAtIndex:selectedIndex];
    btn.highlighted = YES;
    
    
    __block UIView *labelView = [self.iconTitleLabelArray objectAtIndex:selectedIndex];
    [UIView animateWithDuration:0.4
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         labelView.alpha = 1;
                         
                     } completion:^(BOOL finished) {
                         __block UIView *labelView = [self.iconTitleLabelArray objectAtIndex:selectedIndex];
                         [UIView animateWithDuration:0.4
                                               delay:1
                                             options:UIViewAnimationOptionCurveEaseInOut
                                          animations:^{
                                              
                                              labelView.alpha = 0;
                                              
                                          } completion:nil];
                     }];
}

- (void)setSelectedTab:(UIButton *)button{
    button.selected = YES;
}

- (void)selectedTab:(UIButton *)button{
    
    self.currentSelectedIndex = button.tag;
    
    self.selectedIndex = self.currentSelectedIndex;
    
    [self performSelector:@selector(slideTabBg:) withObject:button];
}

- (void)slideTabBg:(UIButton *)btn{
    
    for (UIButton *_btn in self.buttons) {
        _btn.selected = NO;
        _btn.highlighted = NO;
    }
    btn.highlighted = YES;
}

- (void) dealloc{
    self.mainViewController = nil;
    self.hotViewController = nil;
    self.meViewController = nil;
    
    self.iconNameArray = nil;
    self.baseBtnGroup = nil;
    self.tabBarStack = nil;
    self.buttons = nil;
    self.iconTitleArray = nil;
    self.iconTitleLabelArray = nil;
    
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 处理tabbar
-(void)pushTabBar:(UIView *)tabBarView//push tabbar
{
    if (tabBarView) {
        [self.tabBarStack addObject:tabBarView];
        UIView *lastTabBar = [self.baseBtnGroup retain];//当前还未隐藏的tabbar
        self.baseBtnGroup = tabBarView;
        
        CGRect groupFrame = lastTabBar.frame;
        tabBarView.frame = CGRectMake(groupFrame.size.width,
                                      groupFrame.origin.y,
                                      tabBarView.frame.size.width,
                                      tabBarView.frame.size.height);
        
        [self.view addSubview:tabBarView];
        
        [UIView beginAnimations:nil context:nil];
        //    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDuration:0.38];
        lastTabBar.alpha = 0;
        lastTabBar.frame = CGRectMake(-self.view.frame.size.width / 2,
                                      lastTabBar.frame.origin.y,
                                      lastTabBar.frame.size.width,
                                      lastTabBar.frame.size.height);
        
        tabBarView.frame = CGRectMake(0,
                                      groupFrame.origin.y,
                                      tabBarView.frame.size.width,
                                      tabBarView.frame.size.height);
        
        tabBarView.frame = groupFrame;
        tabBarView.alpha = 1;
        
        [UIView commitAnimations];
        
        [lastTabBar release];
    }
}

-(void)popTabBar//pop tabbar
{
    if ([self.tabBarStack count]>1) {
        UIView *currentTabBar = [self.baseBtnGroup retain];//当前即将退出的tabbar
        UIView *needShowTabBar = [self.tabBarStack objectAtIndex:self.tabBarStack.count - 2];//即将显示的tabbar
        self.baseBtnGroup = needShowTabBar;
        
        [UIView beginAnimations:nil context:nil];
        //    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDuration:0.38];
        currentTabBar.alpha = 0;
        currentTabBar.frame = CGRectMake(self.view.frame.size.width / 2,
                                         currentTabBar.frame.origin.y,
                                         currentTabBar.frame.size.width,
                                         currentTabBar.frame.size.height);
        
        needShowTabBar.frame = CGRectMake(0,
                                          needShowTabBar.frame.origin.y,
                                          needShowTabBar.frame.size.width,
                                          needShowTabBar.frame.size.height);
        needShowTabBar.alpha = 1;
        
        [UIView commitAnimations];
        
        [currentTabBar release];
        [self.tabBarStack removeObjectAtIndex:self.tabBarStack.count - 1];
    }
}

-(void)popToRootTabBar
{
    if ([self.tabBarStack count]>1) {
        UIView *currentTabBar = [self.baseBtnGroup retain];//当前即将退出的tabbar
        UIView *needShowTabBar = [self.tabBarStack objectAtIndex:0];//即将显示的tabbar
        self.baseBtnGroup = needShowTabBar;
        
        [UIView beginAnimations:nil context:nil];
        //    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDuration:0.38];
        currentTabBar.alpha = 0;
        currentTabBar.frame = CGRectMake(self.view.frame.size.width / 2,
                                         currentTabBar.frame.origin.y,
                                         currentTabBar.frame.size.width,
                                         currentTabBar.frame.size.height);
        
        needShowTabBar.frame = CGRectMake(0,
                                          needShowTabBar.frame.origin.y,
                                          needShowTabBar.frame.size.width,
                                          needShowTabBar.frame.size.height);
        needShowTabBar.alpha = 1;
        
        [UIView commitAnimations];
        
        [currentTabBar release];
        
        [self.tabBarStack removeAllObjects];
        [self.tabBarStack addObject:self.baseBtnGroup];
    }
}


@end
