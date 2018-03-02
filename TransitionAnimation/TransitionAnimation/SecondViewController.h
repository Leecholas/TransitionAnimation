//
//  SecondViewController.h
//  TransitionAnimation
//
//  Created by Leecholas on 2018/2/6.
//  Copyright © 2018年 Leecholas. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SecondViewController;

@protocol SecondViewControllerDelegate <NSObject>
@optional
- (void)secondViewControllerDidClickDismiss;
- (void)secondViewControllerDidClickBack;
@end

@interface SecondViewController : UIViewController
@property (nonatomic, assign) id<SecondViewControllerDelegate> delegate;
@end
