//
//  MMFirstOpenOneViewController.m
//  Movie-Memory
//
//  Created by Kyle Frost on 7/24/14.
//  Copyright (c) 2014 Kyle Frost. All rights reserved.
//

#import "MMFirstOpenOneViewController.h"
#import <Social/Social.h>

@interface MMFirstOpenOneViewController ()

@property (strong, nonatomic) IBOutlet UIButton *twitterButton;

@end

@implementation MMFirstOpenOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)pressTwitterButton:(id)sender {
    SLComposeViewController *postSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [postSheet setInitialText:@"I just bought #MovieMemory by @KyleFrostDesign! Check it out!"];
    [self presentViewController:postSheet animated:YES completion:nil];
}

@end
