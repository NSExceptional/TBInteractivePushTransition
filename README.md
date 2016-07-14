# TBInteractivePushTransition

[![Version](https://img.shields.io/cocoapods/v/TBInteractivePushTransition.svg?style=flat)](http://cocoapods.org/pods/TBInteractivePushTransition)
[![License](https://img.shields.io/cocoapods/l/TBInteractivePushTransition.svg?style=flat)](http://cocoapods.org/pods/TBInteractivePushTransition)
[![Platform](https://img.shields.io/cocoapods/p/TBInteractivePushTransition.svg?style=flat)](http://cocoapods.org/pods/TBInteractivePushTransition)

TBInteractivePushTransition enables the ability to swipe "forward" to push a view controller onto the navigation stack via a screen edge pan gesture, akin to `UINavigationController`'s `interactivePopGestureRecognizer`.

To use it, simply create and hold a reference to the transition object in a view controller on the navigation stack. **The view controller must be on the navigation stack when the transition object is created.** Similarly, if you use the same view controller in more than one navigation controller, you must recreate the transition object each time.

```objc
@interface SomeViewController : UIViewController <TBPushTransitionDataSource>
@property (nonatomic) TBInteractivePushTransition *transition;
@end

@implementation SomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Assuming we have a .navigationController at this point
    self.transition = [TBInteractivePushTransition viewController:self delegate:self];
}

- (UIViewController *)viewControllerForPushTransition {
    return [[self class] new]; // whatever
}

@end
```

## Example Project

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

iOS 7 or later.

## Installation

Add the following line to your Podfile:

```ruby
pod 'TBInteractivePushTransition'
```

## Author

ThePantsThief, tannerbennett@me.com

## License

TBInteractivePushTransition is available under the MIT license. See the LICENSE file for more info.
