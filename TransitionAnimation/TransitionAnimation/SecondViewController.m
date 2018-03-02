//
//  SecondViewController.m
//  TransitionAnimation
//
//  Created by Leecholas on 2018/2/6.
//  Copyright © 2018年 Leecholas. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kRandomColor;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(popAction)];
        
    UIButton *dismissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dismissBtn.frame = CGRectMake(100, 100, kScreenWith - 200, 200);
    [dismissBtn setBackgroundColor:[UIColor greenColor]];
    [dismissBtn setTitle:@"DISMISS" forState:UIControlStateNormal];
    [dismissBtn addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dismissBtn];
}

- (void)popAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(secondViewControllerDidClickBack)]) {
        [self.delegate secondViewControllerDidClickBack];
    }
}

- (void)dismissAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(secondViewControllerDidClickDismiss)]) {
        [self.delegate secondViewControllerDidClickDismiss];
    }
}


@end
