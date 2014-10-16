//
//  MMFirstOpenFourViewController.m
//  Movie-Memory
//
//  Created by Kyle Frost on 7/24/14.
//  Copyright (c) 2014 Kyle Frost. All rights reserved.
//

#import "MMFirstOpenFourViewController.h"
#import "MMFirstOpenViewController.h"

@interface MMFirstOpenFourViewController ()

@property (strong, nonatomic) MMFirstOpenViewController *controller;

@property (strong, nonatomic) IBOutlet UIButton *done;

@end

@implementation MMFirstOpenFourViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.controller = [[MMFirstOpenViewController alloc] init];
    
    self.done.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (IBAction)pressDoneButton:(id)sender {
    // [self.controller dismissFirstOpenViewController];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.controller.tabController.blurredView.alpha = 0;
        self.controller.view.alpha = 0;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissFirstOpen" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"removeFirstOpenBlur" object:nil];
    } completion:^(BOOL finished){
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"dismissFirstOpen" object:nil];
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"removeFirstOpenBlur" object:nil];
    }];
}

@end
