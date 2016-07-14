//
//  TBInteractivePushTransition.m
//  TBInteractivePushTransition
//
//  Created by Tanner Bennett on 7/14/16.
//
//

#import "TBInteractivePushTransition.h"


/// Educated guess after some testing
static const CGFloat kMinimumPushVelocityThreshold = 700.0;
/// Pulled from _UINavigationInteractiveTransition at runtime
static const CGFloat kPushAnimationDuration = 0.35;
/// Duh
static const CGFloat kMinimumPushDistanceThreshold = 0.5;

@interface TBInteractivePushTransition () <UIGestureRecognizerDelegate>
@property (nonatomic, weak, readonly) UIViewController *sourceViewController;
@property (nonatomic, weak, readonly) id<TBPushTransitionDataSource> delegate;
@property (nonatomic) BOOL interactive;
@end

@implementation TBInteractivePushTransition

+ (instancetype)sourceViewController:(UIViewController *)viewController delegate:(id<TBPushTransitionDataSource>)delegate {
    TBInteractivePushTransition *me = [self new];
    me->_sourceViewController = viewController;
    me->_delegate = delegate;
    me->_interactivePushGestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:me action:@selector(handleSwipeForward:)];
    
    me.sourceViewController.navigationController.delegate = me;
    me.sourceViewController.navigationController.interactivePopGestureRecognizer.delegate = nil;
    me.interactivePushGestureRecognizer.edges = UIRectEdgeRight;
    [me.interactivePushGestureRecognizer requireGestureRecognizerToFail:viewController.navigationController.interactivePopGestureRecognizer];
    [viewController.view addGestureRecognizer:me.interactivePushGestureRecognizer];
    
    return me;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gesture shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)other {
    // So we don't interfere with the interactive pop gesture recognizer
    return YES;
}

#pragma mark Triggering the push, updating the transition

- (void)handleSwipeForward:(UIPanGestureRecognizer *)gesture {
    self.interactive = YES;
    // could maybe also use gesture.view here instead of sourceViewController.view
    CGPoint velocity = [gesture velocityInView:self.sourceViewController.view];
    CGPoint translation = [gesture translationInView:self.sourceViewController.view];
    CGFloat dx = -translation.x / CGRectGetWidth(self.sourceViewController.view.bounds);
    CGFloat vx = -velocity.x;
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            UIViewController *viewController = self.delegate.viewControllerForPushTransition;
            [self.sourceViewController.navigationController pushViewController:viewController animated:YES];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            [self updateInteractiveTransition:dx];
            break;
        }
        case UIGestureRecognizerStateEnded: {
            self.interactive = NO;
            // Only finish the transition if we make it halfway across the screen
            if (dx > kMinimumPushDistanceThreshold || vx > kMinimumPushVelocityThreshold) {
                [self finishInteractiveTransition];
            } else {
                [self cancelInteractiveTransition];
            }
            break;
        }
        default: {
            self.interactive = NO;
            [self cancelInteractiveTransition];
            break;
        }
    }
}

#pragma mark Push / pop transition

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
    // We only want to handle the forward animation
    if (operation == UINavigationControllerOperationPush) {
        return self.interactive ? self : nil;
    }
    
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navController
                         interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animController {
    return self.interactive ? self : nil;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return kPushAnimationDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    // Grab the view controllers and setup the transition
    UIView *toView   = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    [[transitionContext containerView] addSubview:toView];
    
    // Modify frame of presented view to go from x = [screen width] to x = 0
    CGRect frame   = fromView.frame;
    frame.origin.x = frame.size.width;
    toView.frame   = frame;
    frame.origin.x = 0;
    
    // We want it linear while interactive, but we want the "ease out" animation
    // if the user flicks the screen hard enough to finish the transition without interaction.
    UIViewAnimationOptions options = self.interactive ? UIViewAnimationOptionCurveLinear : UIViewAnimationOptionCurveEaseOut;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:options animations:^{
        // Here, we animate the translation and the final frame
        CGFloat translationDistance = -frame.size.width;
        fromView.transform = CGAffineTransformMakeTranslation(translationDistance, 0);
        toView.frame       = frame;
    } completion:^(BOOL finished) {
        // Remove transform, complete transition
        fromView.transform = CGAffineTransformIdentity;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end
