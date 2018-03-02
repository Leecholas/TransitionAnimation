//
//  LMViewControllerTransition.h
//  TransitionAnimation
//
//  Created by Leecholas on 2018/2/6.
//  Copyright © 2018年 Leecholas. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LMViewControllerTransitionType) {
    LMViewControllerTransitionTypePresent   = 0,
    LMViewControllerTransitionTypeDismiss   = 1,
    LMViewControllerTransitionTypePush      = 2,
    LMViewControllerTransitionTypePop       = 3,
};

@interface LMViewControllerTransition : NSObject <UIViewControllerAnimatedTransitioning>

- (instancetype)initWithTransitionType:(LMViewControllerTransitionType)type;
+ (instancetype)transitionWithTransitionType:(LMViewControllerTransitionType)transitionType;

@end
