//
//  FancySegue.m
//  PresentationTest
//
//  Created by Kamil Szostakowski on 18.02.2015.
//  Copyright (c) 2015 Kamil Szostakowski. All rights reserved.
//

#import "FancySegue.h"
#import "PresentationController.h"
#import "TransitioningDelegate.h"

@interface FancySegue () <UIViewControllerTransitioningDelegate>

@end

@implementation FancySegue

-(void)perform
{
    static TransitioningDelegate* transitioningDelegate = nil;
    static dispatch_once_t onceQueue;
    
    dispatch_once(&onceQueue, ^{
        transitioningDelegate = [[TransitioningDelegate alloc] init];
    });
    
    UIViewController* destinationController = self.destinationViewController;
    destinationController.modalPresentationStyle = UIModalPresentationCustom;
    destinationController.transitioningDelegate = transitioningDelegate;
    
    [self.sourceViewController presentViewController:destinationController animated:YES completion:nil];
}

@end
