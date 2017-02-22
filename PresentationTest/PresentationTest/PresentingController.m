//
//  PresentingController.m
//  PresentationTest
//
//  Created by Kamil Szostakowski on 17.02.2015.
//  Copyright (c) 2015 Kamil Szostakowski. All rights reserved.
//

#import "PresentingController.h"
#import "PresentationController.h"
#import "TransitioningDelegate.h"

@interface PresentingController ()

@property (nonatomic, strong) id<UIViewControllerTransitioningDelegate> transitioningDelegate;
@end

@implementation PresentingController

- (void)viewDidLoad
{
    self.transitioningDelegate = [[TransitioningDelegate alloc] init];
    [super viewDidLoad];
}

- (IBAction)onPresentControllerBtnTouchAction:(UIButton *)sender
{
    UIViewController* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"PresentedController"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.transitioningDelegate = self.transitioningDelegate;

    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)onPresentControllerWithSegueBtnTouchAction:(UIButton *)sender
{
}

@end
