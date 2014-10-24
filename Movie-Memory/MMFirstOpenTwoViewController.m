//
//  MMFirstOpenTwoViewController.m
//  Movie-Memory
//
//  Created by Kyle Frost on 7/24/14.
//  Copyright (c) 2014 Kyle Frost. All rights reserved.
//

#import "MMFirstOpenTwoViewController.h"

@interface MMFirstOpenTwoViewController ()

@property (strong, nonatomic) IBOutlet UIButton *yesButton;
@property (strong, nonatomic) IBOutlet UIButton *noButton;

@end

@implementation MMFirstOpenTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)pressYesButton:(id)sender {
    [self.yesButton setBackgroundImage:[[UIImage imageNamed:@"yes_button_pressed"] imageWithOverlayColor:[UIColor greenColor]] forState:UIControlStateNormal];
    [self.noButton setBackgroundImage:[UIImage imageNamed:@"no_button"] forState:UIControlStateNormal];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:MMDiagnosticsAreEnabled];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)pressNoButton:(id)sender {
    [self.noButton setBackgroundImage:[[UIImage imageNamed:@"no_button_pressed"] imageWithOverlayColor:[UIColor redColor]] forState:UIControlStateNormal];
    [self.yesButton setBackgroundImage:[UIImage imageNamed:@"yes_button"] forState:UIControlStateNormal];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:MMDiagnosticsAreEnabled];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
