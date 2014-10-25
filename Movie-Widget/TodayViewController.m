//
//  TodayViewController.m
//  Movie-Widget
//
//  Created by Kyle Frost on 10/24/14.
//  Copyright (c) 2014 Kyle Frost. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>

@property (strong, nonatomic) IBOutlet UIButton *addMovieButton;
@property (strong, nonatomic) IBOutlet UIButton *scanMovieButton;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setPreferredContentSize:CGSizeMake(320.0, 75.0)];
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets {
    return UIEdgeInsetsZero;
}

- (IBAction)addMovie:(id)sender {
    NSURL *url = [NSURL URLWithString:@"moviememory://addMovie"];
    [self.extensionContext openURL:url completionHandler:nil];
}

- (IBAction)scanMovie:(id)sender {
    NSURL *url = [NSURL URLWithString:@"moviememory://scanBarcode"];
    [self.extensionContext openURL:url completionHandler:nil];
}

@end
