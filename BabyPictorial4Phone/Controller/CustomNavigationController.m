//
//  CustomNavigationController.m
//  BabyPictorial4Phone
//
//  Created by hanchao on 14-3-10.
//  Copyright (c) 2014年 hanchao. All rights reserved.
//

#import "CustomNavigationController.h"

@interface CustomNavigationController ()

@end

@implementation CustomNavigationController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)changeNavigationBar2Small
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self.navigationBar setFrame:CGRectMake(0,20, 320, 20)];
                         //TODO:修改title字体
                     } completion:^(BOOL finished) {
                         [self.view setNeedsLayout];
                     }];
}

-(void)changeNavigationBar2Normal
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self.navigationBar setFrame:CGRectMake(0,20, 320, 40)];
                         //TODO:修改title字体
                     } completion:^(BOOL finished) {
                         [self.view setNeedsLayout];
                     }];
}

@end
