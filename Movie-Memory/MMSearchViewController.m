//
//  MMSearchViewController.m
//  Movie-Memory
//
//  Created by Kyle Frost on 5/25/14.
//  Copyright (c) 2014 Kyle Frost. All rights reserved.
//

#import "MMSearchViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface MMSearchViewController () {
    MMAddManualViewController *controller;
    UIImage *savedImage;
}

@end

@implementation MMSearchViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    // Update status bar and set navigation bar properties
    [self setNeedsStatusBarAppearanceUpdate];
    self.searchBar.delegate = self;
    self.searchBar.barTintColor = [UIColor colorWithRed:0.890 green:0.100 blue:0.148 alpha:1.000];
    self.searchBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil];
    
    // Determine what I'm searching for and load navigation bar respectively
    if (self.searchButtonInt == 1) {
        self.searchBar.topItem.title = @"Search Cover";
        self.back.title = @"Cancel";
        self.helpButton.title = @"Help";
        self.helpButton.enabled = YES;
    } else if (self.searchButtonInt == 2) {
        self.searchBar.topItem.title = @"Search Release Year";
        self.back.title = @"Back";
        self.helpButton.title = nil;
        self.helpButton.enabled = NO;
    }
    
    // Add tap recognizer to detect double tap by user
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    doubleTap.numberOfTouchesRequired = 1;
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.delegate = self;
    [self.searchView addGestureRecognizer:doubleTap];
    self.searchView.delegate = self;
    
    // Load the web view with the correct information
    [self loadSearchView];
}

-(IBAction)pressHelp:(id)sender {
    // Show help if the user taps help button
    UIAlertView *helpView = [[UIAlertView alloc] initWithTitle:@"Steps to Set Cover:\n"
                                                       message:@"1. Look for appropriate cover.\n2. Double tap image you want as cover.\n3. Select preferred option."
                                                      delegate:nil
                                             cancelButtonTitle:@"Okay"
                                             otherButtonTitles:nil];
    [helpView show];
}

-(void)doubleTap:(UIGestureRecognizer *)gesture {
    
    // Run this if user double taps
    if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
        // Determine the tapped point
        CGPoint touchPoint = [gesture locationInView:self.view];
        // NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        // bool pageFlag = [userDefaults boolForKey:@"pageDirectionRTLFlag"];
        // NSLog(@"pageFlag tapbtnRight %d", pageFlag);
        
        // Get the URL of the image and set the image as the data found
        NSString *imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", touchPoint.x, touchPoint.y];
        NSString *urlToSave = [self.searchView stringByEvaluatingJavaScriptFromString:imgURL];
        NSURL *imageURL = [NSURL URLWithString:urlToSave];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        savedImage = [UIImage imageWithData:imageData];
        
        // Show action sheet asking user what they want to do with the image
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Save and Set Cover", @"Save to Camera Roll", @"Set Cover Only", nil];
        [actionSheet showInView:self.view];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // Determine what button was selected for the action sheet
    if (buttonIndex == 0) {
        // Save and Set Cover - Save image to camera roll and set the cover
        NSData *sendData = UIImagePNGRepresentation(savedImage);
        UIImageWriteToSavedPhotosAlbum(savedImage, nil, nil, nil);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeImage" object:sendData];
        [self dismissViewControllerAnimated:YES completion:NULL];
    } else if (buttonIndex == 1) {
        // Save to Camera Roll - Save the image to the camera roll
        UIImageWriteToSavedPhotosAlbum(savedImage, nil, nil, nil);
        [self dismissViewControllerAnimated:YES completion:NULL];
    } else if (buttonIndex == 2) {
        // Set Cover Only - Only set the cover, don't save to camera roll
        NSData *sendData = UIImagePNGRepresentation(savedImage);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeImage" object:sendData];
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

-(void)loadSearchView {
    // Start the activity indicator to show that loading is happenning
    [self.activityIndicator startAnimating];
    [self.activityIndicator setHidden:NO];
    self.indicatorBackground.layer.backgroundColor = [UIColor blackColor].CGColor;
    self.indicatorBackground.layer.opacity = 0.5f;
    self.indicatorBackground.layer.cornerRadius = self.indicatorBackground.bounds.size.width/2;
    [self.indicatorBackground setHidden:NO];
    
    // Determine which page to load, cover or year search
    // 1 = Cover, 2 = Year
    if (self.searchButtonInt == 1) {
        NSString *string = [[[self.titleString componentsSeparatedByCharactersInSet:[[NSCharacterSet letterCharacterSet] invertedSet]] componentsJoinedByString:@"%20"] lowercaseString];
        NSString *url = [NSString stringWithFormat:@"https://www.google.com/search?tbm=isch&q=%@%%20movie%%20cover", string];
        [self.searchView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    }
    else if (self.searchButtonInt == 2) {
        NSString *string = [[[self.titleString componentsSeparatedByCharactersInSet:[[NSCharacterSet letterCharacterSet] invertedSet]] componentsJoinedByString:@"%20"] lowercaseString];
        NSString *url = [NSString stringWithFormat:@"https://www.google.com/search?&q=what%%20year%%20did%%20%@%%20movie%%20come%%20out", string];
        [self.searchView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    }
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    // Stop activity indicator when the webview is done loading
    [self.activityIndicator stopAnimating];
    [self.activityIndicator setHidden:YES];
    [self.indicatorBackground setHidden:YES];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    // Allow gesture recognizer to be used in conjunction with the UIWebView default one
    return YES;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    // Let custom gesture recognizer accept the touches
    return YES;
}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

-(IBAction)pressBack:(id)sender {
    // Dismiss the view if the user presses back/cancel
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(UIBarPosition)positionForBar:(id <UIBarPositioning>)bar {
    // Set bar to be under status bar
    return UIBarPositionTopAttached;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    // Colorful 
    return UIStatusBarStyleLightContent;
}

@end
