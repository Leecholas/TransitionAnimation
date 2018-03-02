//
//  LMViewControllerTransition.m
//  TransitionAnimation
//
//  Created by Leecholas on 2018/2/6.
//  Copyright © 2018年 Leecholas. All rights reserved.
//

#import "LMViewControllerTransition.h"

@interface LMViewControllerTransition ()

@property (nonatomic, assign) LMViewControllerTransitionType transitionType;

@end

@implementation LMViewControllerTransition

- (instancetype)initWithTransitionType:(LMViewControllerTransitionType)transitionType {
    self = [super init];
    if (self) {
        _transitionType = transitionType;
    }
    return self;
}

+ (instancetype)transitionWithTransitionType:(LMViewControllerTransitionType)transitionType {
    return [[LMViewControllerTransition alloc] initWithTransitionType:transitionType];
}

#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    if (_transitionType == LMViewControllerTransitionTypePush) {
        [self pushAnimation:transitionContext];
    }
    else if (_transitionType == LMViewControllerTransitionTypePop) {
        [self popAnimation:transitionContext];
    }
    else if (_transitionType == LMViewControllerTransitionTypePresent) {
        [self presentAnimation:transitionContext];
    }
    else if (_transitionType == LMViewControllerTransitionTypeDismiss) {
        [self dismissAnimation:transitionContext];
    }
}

#pragma mark - Private
- (void)presentAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    //通过viewControllerForKey取出转场前后的两个控制器，fromVC就是VC，toVC就是secondVC
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //snapshotViewAfterScreenUpdates可以对某个视图截图，这里采用对这个截图做动画代替直接对VC做动画，因为在手势过渡中直接使用VC动画会和手势有冲突， 如果不需要实现手势的话，可以不用截图
    UIView *tempView = [fromVC.view snapshotViewAfterScreenUpdates:NO];
    tempView.frame = fromVC.view.frame;
    fromVC.view.hidden = YES;
    
    //设置secondVC动画开始前的初始位置，finalFrameForViewController可以获得切换结束时secondVC应在的frame
    toVC.view.frame = CGRectOffset([transitionContext finalFrameForViewController:toVC], 0, [UIScreen mainScreen].bounds.size.height);
    
    //如果要对视图做转场动画，视图就必须要加入containerView中才能进行，可以理解containerView管理着所有做转场动画的视图
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:tempView];
    [containerView addSubview:toVC.view];
    
    //动画实现
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        //secondVC上移
        toVC.view.transform = CGAffineTransformMakeTranslation(0, -0.85 * containerView.height);
        //原先VC的截图缩小
        tempView.transform = CGAffineTransformMakeScale(0.85, 0.85);
    } completion:^(BOOL finished) {
        //标记整个转场过程是否完成。[transitionContext transitionWasCancelled]代表手势是否取消了，如果取消了就传NO表示转场失败，反之亦然，如果不用手势present的话直接传YES也是可以的，但是无论如何我们都必须标记转场的状态，系统才知道处理转场后的操作，否者认为你一直还在转场中，会出现无法交互的情况
        
        //转场失败后的处理
        if ([transitionContext transitionWasCancelled]) {
            fromVC.view.hidden = NO;
            [tempView removeFromSuperview];
            [transitionContext completeTransition:NO];
            return ;
        }
        
        [transitionContext completeTransition:YES];
    }];
}

- (void)dismissAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    //通过viewControllerForKey取出转场前后的两个控制器，注意，这里fromVC是secondVC，toVC是VC
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //取出之前的截图
    UIView *tempView = [transitionContext containerView].subviews[0];
    
    //动画实现
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        //因为present的时候都是使用的transform，这里的动画只需要将transform恢复就可以了
        fromVC.view.transform = CGAffineTransformIdentity;
        tempView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        //转场失败后的处理
        if ([transitionContext transitionWasCancelled]) {
            [transitionContext completeTransition:NO];
            return ;
        }
        
        //成功处理
        [transitionContext completeTransition:YES];
        toVC.view.hidden = NO;
        [tempView removeFromSuperview];
    }];
}

- (void)pushAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    //取到转场前后的两个控制器，这里fromVC是VC，toVC是secondVC
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //对VC截图，对截图做动画，避免bug;
    UIView *tempView = [fromVC.view snapshotViewAfterScreenUpdates:NO];
    tempView.frame = fromVC.view.frame;
    fromVC.view.hidden = YES;
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:tempView];
    [containerView addSubview:toVC.view];
    
    //设置灭点位置
    //当在透视角度绘图的时候，远离相机视角的物体将会变小变远，当远离到一个极限距离，它们可能就缩成了一个点，于是所有的物体最后都汇聚消失在同一个点，Core Animation定义了这个点位于变换图层的anchorPoint。这就是说，当图层发生变换时，这个点永远位于图层变换之前anchorPoint的位置
    CGPoint point = CGPointMake(0, 0.5);
    tempView.frame = CGRectOffset(tempView.frame, (point.x - tempView.layer.anchorPoint.x) * tempView.frame.size.width, (point.y - tempView.layer.anchorPoint.y) * tempView.frame.size.height); //由于会更改锚点位置，要调整frame
    tempView.frame = CGRectMake(-107, 0, 414, 736);
    tempView.layer.anchorPoint = point;
    
    //可以通过设置m34为-1/d来应用透视效果，d代表了想象中视角相机和屏幕之间的距离，以像素为单位，一般取500~1000
    CATransform3D transfrom3d = CATransform3DIdentity;
    transfrom3d.m34 = -1/1000; //-1/D,D是观察者到投射面的距离;
    containerView.layer.sublayerTransform = transfrom3d; //sublayerTransform也是CATransform3D类型，使用它将影响所有的子图层
    
    //VC上的翻页阴影绘图layer，绘制梯度图层
    CAGradientLayer *fromGradient = [CAGradientLayer layer];
    fromGradient.frame = fromVC.view.bounds;
    fromGradient.colors = @[(id)[UIColor blackColor].CGColor,(id)[UIColor blackColor].CGColor]; //由于阴影，只要黑色就行
    fromGradient.startPoint = CGPointMake(0.0, 0.5); //从横向0.0开始绘制
    fromGradient.endPoint = CGPointMake(0.8, 0.5); //到横向0.8结束绘制
    
    //VC上的翻页阴影
    UIView *fromShadow = [[UIView alloc] initWithFrame:fromVC.view.bounds];
    fromShadow.backgroundColor = [UIColor clearColor];
    [fromShadow.layer addSublayer:fromGradient];
    fromShadow.alpha = 0.0;
    [tempView addSubview:fromShadow];
    
    //secondVC上的翻页阴影绘图layer
    CAGradientLayer *toGradient = [CAGradientLayer layer];
    toGradient.frame = toVC.view.bounds;
    toGradient.colors = @[(id)[UIColor blackColor].CGColor,(id)[UIColor blackColor].CGColor];
    toGradient.startPoint = CGPointMake(0.0, 0.5);
    toGradient.endPoint = CGPointMake(0.8, 0.5);
    
    //secondVC上的翻页阴影绘图layer
    UIView *toShadow = [[UIView alloc]initWithFrame:toVC.view.bounds];
    toShadow.backgroundColor = [UIColor clearColor];
    [toShadow.layer addSublayer:toGradient];
    toShadow.alpha = 1.0;
    [toVC.view addSubview:toShadow];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        tempView.layer.transform = CATransform3DMakeRotation(-M_PI_2, 0, 1, 0);
        fromShadow.alpha = 1.0;
        toShadow.alpha = 0.0;
    } completion:^(BOOL finished) {
        if ([transitionContext transitionWasCancelled]) {
            fromVC.view.hidden = NO;
            [tempView removeFromSuperview];
            [transitionContext completeTransition:NO];
            return ;
        }
        
        [transitionContext completeTransition:YES];
    }];
}

- (void)popAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    //通过viewControllerForKey取出转场前后的两个控制器，注意，这里fromVC是secondVC，toVC是VC
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    UIView *tempView = containerView.subviews.lastObject; // 取出tempView
    [containerView addSubview:toVC.view];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        tempView.layer.transform = CATransform3DIdentity;
        fromVC.view.subviews.lastObject.alpha = 1.0;
        tempView.subviews.lastObject.alpha = 0.0;
    } completion:^(BOOL finished) {
        if ([transitionContext transitionWasCancelled]) {
            [transitionContext completeTransition:NO];
            return ;
        }
        
        toVC.view.hidden = NO;
        [tempView removeFromSuperview];
        [transitionContext completeTransition:YES];
    }];
}

@end
