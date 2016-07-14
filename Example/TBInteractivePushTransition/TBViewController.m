//
//  TBViewController.m
//  TBInteractivePushTransition
//
//  Created by ThePantsThief on 07/14/2016.
//  Copyright (c) 2016 ThePantsThief. All rights reserved.
//

#import "TBViewController.h"
#import "TBInteractivePushTransition.h"


UIColor *randomColor() {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

@interface TBViewController () <TBPushTransitionDataSource>
@property (nonatomic) UIPercentDrivenInteractiveTransition *interactionController;
@end

@implementation TBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = randomColor();
    self.interactionController = [TBInteractivePushTransition sourceViewController:self delegate:self];
}

- (UIViewController *)viewControllerForPushTransition {
    return [[self class] new];
}

@end
