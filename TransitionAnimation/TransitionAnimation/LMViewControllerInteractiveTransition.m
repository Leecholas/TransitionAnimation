//
//  LMViewControllerInteractiveTransition.m
//  TransitionAnimation
//
//  Created by Leecholas on 2018/2/6.
//  Copyright © 2018年 Leecholas. All rights reserved.
//

#import "LMViewControllerInteractiveTransition.h"

@interface LMViewControllerInteractiveTransition ()

@property (nonatomic, assign) InteractiveTransitionType type;

@property (nonatomic, assign) NSInteger times;

@end

@implementation LMViewControllerInteractiveTransition

//- (instancetype)initWithInteractiveTransitionType:(InteractiveTransitionType)type {
//    self = [super init];
//    if (self) {
//        _type = type;
//    }
//    return self;
//}
//
//+ (instancetype)interactiveTransitionWithType:(InteractiveTransitionType)type {
//    return [[self alloc] initWithInteractiveTransitionType:type];
//}

- (instancetype)initWithInteractiveTransitionTypeOption:(InteractiveTransitionType)type {
    self = [super init];
    if (self) {
        _type = type;
    }
    return self;
}

+ (instancetype)interactiveTransitionWithTypeOption:(InteractiveTransitionType)type {
    return [[self alloc] initWithInteractiveTransitionTypeOption:type];
}

- (void)addPanGestureForViewController:(UIViewController *)viewController {
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [viewController.view addGestureRecognizer:pan];    
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)panGesture {
    
    CGFloat percent = 0;
    CGPoint translationPoint = [panGesture translationInView:panGesture.view];
    
//    switch (_type) {
//        case InteractiveTransitionTypePresent:
//            percent = -translationPoint.y / panGesture.view.height;
//            break;
//        case InteractiveTransitionTypeDismiss:
//            percent = translationPoint.y / panGesture.view.height;
//            break;
//        case InteractiveTransitionTypePush:
//            percent = -translationPoint.x / panGesture.view.width;
//            break;
//        case InteractiveTransitionTypePop:
//            percent = translationPoint.x / panGesture.view.width;
//            break;
//        default:
//            break;
//    }
    
    // 选择多个枚举值时，使用按位与运算
    if (_type & InteractiveTransitionTypePresent) {
        if (translationPoint.y <= 0 && fabs(translationPoint.y) >= fabs(translationPoint.x)) {
            percent = -translationPoint.y / panGesture.view.height;
        }
    }
    if (_type & InteractiveTransitionTypeDismiss) {
        if (translationPoint.y >= 0 && fabs(translationPoint.y) > fabs(translationPoint.x)) {
            percent = translationPoint.y / panGesture.view.height;
        }
    }
    if (_type & InteractiveTransitionTypePush) {
        if (translationPoint.x <= 0 && fabs(translationPoint.x) > fabs(translationPoint.y)) {
            percent = -translationPoint.x / panGesture.view.width;
        }
    }
    if (_type & InteractiveTransitionTypePop) {
        if (translationPoint.x >= 0 && fabs(translationPoint.x) > fabs(translationPoint.y)) {
            percent = translationPoint.x / panGesture.view.width;
        }
    }
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan: //滑动手势开始执行，一次手势只执行一次
            _doesBeginInteraction = YES;
            
//            switch (_type) {
//                case InteractiveTransitionTypePresent:
//                    if (_presentAction) {
//                        _presentAction();
//                    }
//                    break;
//                case InteractiveTransitionTypeDismiss:
//                    if (_dismissAction) {
//                        _dismissAction();
//                    }
//                    break;
//                case InteractiveTransitionTypePush:
//                    if (_pushAction) {
//                        _pushAction();
//                    }
//                    break;
//                case InteractiveTransitionTypePop:
//                    if (_popAction) {
//                        _popAction();
//                    }
//                    break;
//                default:
//                    break;
//            }
            
            // 选择多个枚举值时，使用按位与运算
            if (_type & InteractiveTransitionTypePresent) {
                if (translationPoint.y <= 0 && fabs(translationPoint.y) >= fabs(translationPoint.x)) {
                    if (_presentAction) {
                        _presentAction();
                        return;
                    }
                }
            }
            if (_type & InteractiveTransitionTypeDismiss) {
                if (_dismissAction) {
                    _dismissAction();
                    return;
                }
            }
            if (_type & InteractiveTransitionTypePush) {
                if (translationPoint.x <= 0 && fabs(translationPoint.x) > fabs(translationPoint.y)) {
                    if (_pushAction) {
                        _pushAction();
                        return;
                    }
                }
            }
            if (_type & InteractiveTransitionTypePop) {
                if (_popAction) {
                    _popAction();
                    return;
                }
            }
            
            break;
        case UIGestureRecognizerStateChanged: //手指位置改变时执行，一次手势执行多次
            [self updateInteractiveTransition:percent];
            break;
        case UIGestureRecognizerStateEnded:
            _doesBeginInteraction = NO;
            if (percent > 0.5) {
                [self finishInteractiveTransition];
            }else {
                [self cancelInteractiveTransition];
            }
            break;
        default:
            break;
    }
}

@end
