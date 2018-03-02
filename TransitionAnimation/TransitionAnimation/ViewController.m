//
//  ViewController.m
//  TransitionAnimation
//
//  Created by Leecholas on 2018/2/6.
//  Copyright © 2018年 Leecholas. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"
#import "LMViewControllerTransition.h"
#import "LMViewControllerInteractiveTransition.h"

@interface ViewController ()<UIViewControllerTransitioningDelegate,UINavigationControllerDelegate,SecondViewControllerDelegate>

@property (nonatomic, strong) LMViewControllerInteractiveTransition *interactiveTransition;
@property (nonatomic, strong) LMViewControllerInteractiveTransition *dismissInteractiveTransition;
@property (nonatomic, strong) LMViewControllerInteractiveTransition *popInteractiveTransition;

@property (nonatomic, strong) LMViewControllerTransition *pushTransition;
@property (nonatomic, strong) LMViewControllerTransition *popTransition;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kRandomColor;
    self.navigationController.delegate = self; //push转场动画要实现UINavigationControllerDelegate方法
    
    UIButton *pushBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    pushBtn.frame = CGRectMake(100, 100, kScreenWith - 200, 200);
    [pushBtn setBackgroundColor:[UIColor greenColor]];
    [pushBtn setTitle:@"PUSH" forState:UIControlStateNormal];
    [pushBtn addTarget:self action:@selector(pushBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pushBtn];
    
    UIButton *presentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    presentBtn.frame = CGRectMake(100, pushBtn.bottom + 20, kScreenWith - 200, 200);
    [presentBtn setBackgroundColor:[UIColor greenColor]];
    [presentBtn setTitle:@"PRESENT" forState:UIControlStateNormal];
    [presentBtn addTarget:self action:@selector(presentBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:presentBtn];
    
    // 添加present和push手势
    typeof(self) weakSelf = self;
    _interactiveTransition = [LMViewControllerInteractiveTransition interactiveTransitionWithTypeOption:InteractiveTransitionTypePresent | InteractiveTransitionTypePush] ;
    _interactiveTransition.presentAction = ^{
        [weakSelf presentBtnAction:nil];
    };
    _interactiveTransition.pushAction = ^{
        [weakSelf pushBtnAction:nil];
    };
    [_interactiveTransition addPanGestureForViewController:self];
}

#pragma mark - Action
- (void)pushBtnAction:(UIButton *)sender {
    SecondViewController *secVC = [SecondViewController new];
    secVC.delegate = self;
    [self.navigationController pushViewController:secVC animated:YES];
    
    // 添加pop手势
    typeof(self) weakSelf = self;
    _popInteractiveTransition = [LMViewControllerInteractiveTransition interactiveTransitionWithTypeOption:InteractiveTransitionTypePop];
    _popInteractiveTransition.popAction = ^{
        [weakSelf secondViewControllerDidClickBack];
    };
    [_popInteractiveTransition addPanGestureForViewController:self.navigationController];
}

- (void)presentBtnAction:(UIButton *)sender {
    SecondViewController *secVC = [SecondViewController new];
    secVC.transitioningDelegate = self;
    secVC.delegate = self;
    [self presentViewController:secVC animated:YES completion:NULL];
    
    [_interactiveTransition addPanGestureForViewController:secVC];
    
    // 添加dismiss手势
    typeof(self) weakSelf = self;
    _dismissInteractiveTransition = [LMViewControllerInteractiveTransition interactiveTransitionWithTypeOption:InteractiveTransitionTypeDismiss];
    _dismissInteractiveTransition.dismissAction = ^{
        [weakSelf secondViewControllerDidClickDismiss];
    };
    [_dismissInteractiveTransition addPanGestureForViewController:secVC];
}

// present转场动画要实现UIViewControllerTransitioningDelegate方法
#pragma mark - UIViewControllerTransitioningDelegate
// present转场动画实现
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [LMViewControllerTransition transitionWithTransitionType:LMViewControllerTransitionTypePresent];
}

// dismiss转场动画实现
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [LMViewControllerTransition transitionWithTransitionType:LMViewControllerTransitionTypeDismiss];
}

// present手势
- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator {
    return _interactiveTransition.doesBeginInteraction ? _interactiveTransition : nil;
}

// dismiss手势
- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    return _dismissInteractiveTransition.doesBeginInteraction ? _dismissInteractiveTransition : nil;
}

// push转场动画要实现UINavigationControllerDelegate方法
#pragma mark - UINavigationControllerDelegate
// push和pop转场动画实现
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if (operation == UINavigationControllerOperationPush) {
        _pushTransition = [LMViewControllerTransition transitionWithTransitionType:LMViewControllerTransitionTypePush];
        return _pushTransition;
    }
    _popTransition = [LMViewControllerTransition transitionWithTransitionType:LMViewControllerTransitionTypePop];
    return _popTransition;
}

// push和pop手势
- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    if (animationController == _pushTransition) {
        return _interactiveTransition.doesBeginInteraction ? _interactiveTransition : nil;
    }
    return _popInteractiveTransition.doesBeginInteraction ? _popInteractiveTransition : nil;
}

//将secondVC的dismiss或者pop交给VC来做
#pragma mark - SecondViewControllerDelegate
- (void)secondViewControllerDidClickDismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)secondViewControllerDidClickBack {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
