//
//  MMWatchedViewController.m
//  Movie-Memory
//
//  Created by Kyle Frost on 5/23/14.
//  Copyright (c) 2014 Kyle Frost. All rights reserved.
//

#import "MMWatchedViewController.h"

@implementation MMWatchedViewController

-(void)viewDidLoad {
    // Make the navigation bar custom red with white text
    self.navigationBar.barTintColor = [UIColor colorWithRed:0.890 green:0.100 blue:0.148 alpha:1.000];
    self.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil];
    [self setNeedsStatusBarAppearanceUpdate];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    // Make the status bar show light content
    return UIStatusBarStyleLightContent;
}

@end
