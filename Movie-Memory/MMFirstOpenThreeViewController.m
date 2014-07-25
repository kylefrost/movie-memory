//
//  MMFirstOpenThreeViewController.m
//  Movie-Memory
//
//  Created by Kyle Frost on 7/24/14.
//  Copyright (c) 2014 Kyle Frost. All rights reserved.
//

#import "MMFirstOpenThreeViewController.h"

@interface MMFirstOpenThreeViewController ()

@property (strong, nonatomic) IBOutlet UIButton *yesButton;
@property (strong, nonatomic) IBOutlet UIButton *noButton;

@end

@implementation MMFirstOpenThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)pressYesButton:(id)sender {
    [self.yesButton setBackgroundImage:[[UIImage imageNamed:@"yes_add_button_pressed"] imageWithOverlayColor:[UIColor greenColor]] forState:UIControlStateNormal];
    [self.noButton setBackgroundImage:[UIImage imageNamed:@"no_add_button"] forState:UIControlStateNormal];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"autoAddSwitch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)pressNoButton:(id)sender {
    [self.noButton setBackgroundImage:[[UIImage imageNamed:@"no_add_button_pressed"] imageWithOverlayColor:[UIColor redColor]] forState:UIControlStateNormal];
    [self.yesButton setBackgroundImage:[UIImage imageNamed:@"yes_add_button"] forState:UIControlStateNormal];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"autoAddSwitch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
