//
//  MMFadeInSegue.m
//  Movie-Memory
//
//  Created by Kyle Frost on 7/19/14.
//  Copyright (c) 2014 Kyle Frost. All rights reserved.
//

#import "MMFadeInSegue.h"
#import "MMTabController.h"

@implementation MMFadeInSegue

- (void)perform
{
    MMTabController *source = (MMTabController *)self.sourceViewController;
    UIViewController *destination = (UIViewController *)self.destinationViewController;
    
    [source.view addSubview:source.blurredView];
    
    destination.view.alpha = 0;
    [source.view addSubview:destination.view];
    
    [UIView animateWithDuration:0.5 animations:^{
        source.blurredView.alpha = 1;
        destination.view.alpha = 1;
    } completion:^(BOOL finished) {
    }];
}

@end
