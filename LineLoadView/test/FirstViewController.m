//
//  FirstViewController.m
//  test
//
//  Created by 三开（北京） on 15/11/17.
//  Copyright © 2015年 北京三开科技股份有限公司. All rights reserved.
//

#import "FirstViewController.h"
#import "SecondViewController.h"
#import "PingTransition.h"
@interface FirstViewController () <UINavigationControllerDelegate>

@end

@implementation FirstViewController
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.delegate = self;
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor clearColor];
    
    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"page1"]];
    image.frame = [UIScreen mainScreen].bounds;
    image.userInteractionEnabled = YES;
    [self.view addSubview:image];
    
    _button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_button addTarget:self action:@selector(buttonAction) forControlEvents:(UIControlEventTouchUpInside)];
    [_button setTitle:@"" forState:(UIControlStateNormal)];
    _button.frame =CGRectMake(self.view.bounds.size.width - 70, 15, 50, 50);
//    _button.backgroundColor = [UIColor redColor];
    [image addSubview:_button];
    
    
    
}
-(void)buttonAction{
    NSLog(@"tag");
    SecondViewController *second = [[SecondViewController alloc]init];
    [self.navigationController pushViewController:second animated:YES];
}

#pragma mark - UINavigationControllerDelegate
- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC{
    if (operation == UINavigationControllerOperationPush) {
        
        PingTransition *ping = [PingTransition new];
        return ping;
    }else{
        return nil;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
