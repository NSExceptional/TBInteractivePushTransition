//
//  TBInteractivePushTransition.h
//  TBInteractivePushTransition
//
//  Created by Tanner Bennett on 7/14/16.
//
//

#import <UIKit/UIKit.h>


/// Used to provide a view controller for a push transition.
@protocol TBPushTransitionDataSource <NSObject>
@property (nonatomic, readonly) UIViewController *viewControllerForPushTransition;
@end

/// @discussion This class takes a view controller and a delegate and
/// manages an interactive push transition between the view controller
/// and the view controller provided by the delegate which is initiated
/// by a screen edge pan gesture from the right.
///
/// This class makes itself the delegate of the view controller's
/// navigation controller, and of that navigation controller's
/// `interactivePopGestureRecognizer`. It also adds the appropriate gesture
/// recognizer to the view controller's view to initiate the transition.
///
/// @note Designed to be used on a per-view controller basis (one for each view controller on the navigation stack)
@interface TBInteractivePushTransition : UIPercentDrivenInteractiveTransition <UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate, UIViewControllerInteractiveTransitioning, UINavigationControllerDelegate>

/// Holds weak references to the view controller and the delegate.
+ (instancetype)sourceViewController:(UIViewController *)viewController delegate:(id<TBPushTransitionDataSource>)delegate;

/// @warning Modifying the delegate of this gesture recognizer could result in the push or pop gestures not working.
@property (nonatomic, readonly) UIScreenEdgePanGestureRecognizer *interactivePushGestureRecognizer;

@end
