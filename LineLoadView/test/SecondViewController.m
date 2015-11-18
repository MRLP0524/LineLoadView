//
//  SecondViewController.m
//  test
//
//  Created by 三开（北京） on 15/11/17.
//  Copyright © 2015年 北京三开科技股份有限公司. All rights reserved.
//

#import "SecondViewController.h"
#import "FirstViewController.h"
#import "PingInvertTransition.h"
@interface SecondViewController () <UINavigationControllerDelegate>{
    
    UIPercentDrivenInteractiveTransition *percentTransition;
}

@end

@implementation SecondViewController
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.delegate = self;
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor clearColor];
    
    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"page2"]];
    image.frame = [UIScreen mainScreen].bounds;
    image.userInteractionEnabled = YES;
    [self.view addSubview:image];
    
    
    UIScreenEdgePanGestureRecognizer *edgeGes = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(edgePan:)];
    edgeGes.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:edgeGes];
    
    
    _button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_button addTarget:self action:@selector(buttonAction) forControlEvents:(UIControlEventTouchUpInside)];
    [_button setTitle:@"" forState:(UIControlStateNormal)];
    _button.frame = image.frame;
    [image addSubview:_button];
    

    
}
-(void)buttonAction{
    NSLog(@"tag");

    [self.navigationController popViewControllerAnimated:YES];
}


- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController {
    return percentTransition;
}
-(void)edgePan:(UIPanGestureRecognizer *)recognizer{
    CGFloat per = [recognizer translationInView:self.view].x / (self.view.bounds.size.width);
    per = MIN(1.0,(MAX(0.0, per)));
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        percentTransition = [[UIPercentDrivenInteractiveTransition alloc]init];
        [self.navigationController popViewControllerAnimated:YES];
    }else if (recognizer.state == UIGestureRecognizerStateChanged){
        [percentTransition updateInteractiveTransition:per];
    }else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled){
        if (per > 0.3) {
            [percentTransition finishInteractiveTransition];
        }else{
            [percentTransition cancelInteractiveTransition];
        }
        percentTransition = nil;
    }
}


- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC{
    if (operation == UINavigationControllerOperationPop) {
        PingInvertTransition *pingInvert = [PingInvertTransition new];
        return pingInvert;
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
