//
//  TransitioningDelegate.m
//  PresentationTest
//
//  Created by Kamil Szostakowski on 18.02.2015.
//  Copyright (c) 2015 Kamil Szostakowski. All rights reserved.
//

#import "PresentationController.h"
#import "TransitioningDelegate.h"

@implementation TransitioningDelegate

#pragma mark - UIViewControllerTransitioningDelegate methods

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self;
}

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented
                                                      presentingViewController:(UIViewController *)presenting
                                                          sourceViewController:(UIViewController *)source
{
    return [[PresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
}

#pragma mark - UIViewControllerAnimatedTransitioning methods

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 1;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{ }
                     completion:^(BOOL finished){ [transitionContext completeTransition:finished]; }];
}

@end
