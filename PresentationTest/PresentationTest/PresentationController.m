//
//  PresentationController.m
//  PresentationTest
//
//  Created by Kamil Szostakowski on 17.02.2015.
//  Copyright (c) 2015 Kamil Szostakowski. All rights reserved.
//

#import "PresentationController.h"

CGFloat const kMargin = 20;
CGFloat const kButtonHeight = 40;

@interface PresentationController ()

@property (nonatomic, strong) UIView* dimmingView;
@property (nonatomic, strong) UIButton* dismissalButton;
@end

@implementation PresentationController
{
    NSDictionary* _views;
}

-(instancetype)initWithPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting
{
    self = [super initWithPresentedViewController:presented presentingViewController:presenting];
    
    if(self)
    {
        [self setupDimmingView];
        [self setupDismissButton];
    }
    
    return self;
}

#pragma mark - Setup methods

-(void)setupDimmingView
{
    self.dimmingView = [[UIView alloc] init];
    self.dimmingView.translatesAutoresizingMaskIntoConstraints = NO;
    self.dimmingView.backgroundColor = [UIColor colorWithRed:119.0/255 green:170.0/255 blue:119.0/255 alpha:0.5];
}

-(void)setupDismissButton
{
    self.dismissalButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.dismissalButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.dismissalButton.backgroundColor = [UIColor darkGrayColor];
    
    [self.dismissalButton setTitle:@"Dismiss" forState:UIControlStateNormal];
    [self.dismissalButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.dismissalButton addTarget:self action:@selector(onDismissBtnTouchAction:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)setupHierarchy
{
    self.presentedView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.containerView addSubview:self.dimmingView];
    [self.containerView addSubview:self.dismissalButton];
    [self.containerView addSubview:self.presentedView];
}

-(void)addConstraintsWithMetrics:(NSDictionary*)metrics
{
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[dimmingView]|" options:0 metrics:metrics views:_views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[dimmingView]|" options:0 metrics:metrics views:_views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-margin-[presentedView]-margin-|" options:0 metrics:metrics views:_views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-topMargin-[presentedView(==contentHeight)]" options:0 metrics:metrics views:_views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-margin-[dismissalButton]-margin-|" options:0 metrics:metrics views:_views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[dismissalButton(==buttonHeight)]-bottomMargin-|" options:0 metrics:metrics views:_views]];
}

#pragma mark - Overrided methods

-(void)presentationTransitionWillBegin
{
    _views = @{@"dimmingView": self.dimmingView, @"dismissalButton": self.dismissalButton, @"presentedView": self.presentedView};

    [self setupHierarchy];
    [self addConstraintsWithMetrics:[self offscreenMetrics]];
    
    [self.containerView layoutIfNeeded];
    [self.containerView removeConstraints:self.containerView.constraints];
    
    [self addConstraintsWithMetrics:[self onscreenMetrics]];
        
    id<UIViewControllerTransitionCoordinator> coordinator = self.presentingViewController.transitionCoordinator;
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context){ self.dimmingView.alpha = 1; [self.containerView layoutIfNeeded]; }
                                 completion:^(id<UIViewControllerTransitionCoordinatorContext> context){}];    
}

-(void)dismissalTransitionWillBegin
{
    [self.containerView removeConstraints:self.containerView.constraints];
    [self addConstraintsWithMetrics:[self offscreenMetrics]];
    
    id<UIViewControllerTransitionCoordinator> coordinator = self.presentingViewController.transitionCoordinator;
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context){ self.dimmingView.alpha = 0; [self.containerView layoutIfNeeded]; }
                                 completion:^(id<UIViewControllerTransitionCoordinatorContext> context){}];
}

-(void)dismissalTransitionDidEnd:(BOOL)completed
{
    [self.containerView removeConstraints:self.containerView.constraints];
    
    [self.dimmingView removeFromSuperview];
    [self.dismissalButton removeFromSuperview];
    [self.presentedView removeFromSuperview];
}

-(CGRect)frameOfPresentedViewInContainerView
{
    CGFloat width = self.containerView.bounds.size.width-2*kMargin;
    CGFloat height = self.containerView.bounds.size.height-3*kMargin-kButtonHeight;
    
    return CGRectMake(kMargin, kMargin, width, height);
}

#pragma mark - Helper methods

-(NSDictionary*)onscreenMetrics
{
    CGFloat height = self.containerView.bounds.size.height-3*kMargin-kButtonHeight;
    return @{@"buttonHeight": @(kButtonHeight), @"margin": @(kMargin), @"topMargin": @(kMargin), @"bottomMargin": @(kMargin), @"contentHeight": @(height)};
}

-(NSDictionary*)offscreenMetrics
{
    CGFloat height = self.containerView.bounds.size.height-3*kMargin-kButtonHeight;
    return @{@"buttonHeight": @(kButtonHeight), @"margin": @(kMargin), @"topMargin": @(-height-2*kMargin), @"bottomMargin": @(-kButtonHeight-2*kMargin), @"contentHeight": @(height)};
}

-(void)onDismissBtnTouchAction:(UIButton*)sender
{
    NSLog(@"Source: %@", self.presentingViewController);
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
