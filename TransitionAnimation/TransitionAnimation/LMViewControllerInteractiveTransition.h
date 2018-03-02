//
//  LMViewControllerInteractiveTransition.h
//  TransitionAnimation
//
//  Created by Leecholas on 2018/2/6.
//  Copyright © 2018年 Leecholas. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GestureAction)(void);

//typedef NS_ENUM(NSUInteger, InteractiveTransitionType) {
//    InteractiveTransitionTypePush        = 0,
//    InteractiveTransitionTypePop         = 1,
//    InteractiveTransitionTypePresent     = 2,
//    InteractiveTransitionTypeDismiss     = 3,
//};

// 左移位运算，可以选多个枚举值
typedef NS_OPTIONS(NSUInteger, InteractiveTransitionType) {
    InteractiveTransitionTypePresent        = 1 << 0, //0001 1
    InteractiveTransitionTypeDismiss        = 1 << 1, //0010 2
    InteractiveTransitionTypePush           = 1 << 2, //0100 4
    InteractiveTransitionTypePop            = 1 << 3, //1000 8
};

@interface LMViewControllerInteractiveTransition : UIPercentDrivenInteractiveTransition

@property (nonatomic, copy) GestureAction presentAction;
@property (nonatomic, copy) GestureAction dismissAction;
@property (nonatomic, copy) GestureAction pushAction;
@property (nonatomic, copy) GestureAction popAction;
@property (nonatomic, assign) BOOL doesBeginInteraction; //记录手势是否开始状态

//- (instancetype)initWithInteractiveTransitionType:(InteractiveTransitionType)type;
//+ (instancetype)interactiveTransitionWithType:(InteractiveTransitionType)type;

- (instancetype)initWithInteractiveTransitionTypeOption:(InteractiveTransitionType)type;
+ (instancetype)interactiveTransitionWithTypeOption:(InteractiveTransitionType)type;

- (void)addPanGestureForViewController:(UIViewController *)viewController;

@end
