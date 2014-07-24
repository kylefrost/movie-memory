//
//  MMSearchViewController.h
//  Movie-Memory
//
//  Created by Kyle Frost on 5/25/14.
//  Copyright (c) 2014 Kyle Frost. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMAddManualViewController.h"

@interface MMSearchViewController : UIViewController <UIGestureRecognizerDelegate, UIActionSheetDelegate, UIWebViewDelegate, UINavigationBarDelegate> {
    
}

// Properties for bar buttons
@property (weak, nonatomic) IBOutlet UIBarButtonItem *helpButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *back;
-(IBAction)pressBack:(id)sender;

// Properties for progress indicator
@property (weak, nonatomic) IBOutlet UIImageView *indicatorBackground;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

// Properties for information recieved
@property (weak, nonatomic) NSString *titleString;
@property (nonatomic) NSInteger searchButtonInt;

// Property for webview
@property (strong, nonatomic) IBOutlet UIWebView *searchView;

// Properties for navigation bar
@property (weak, nonatomic) IBOutlet UINavigationBar *searchBar;
@property (nonatomic, readonly) UIBarPosition barPosition;

@end
