//
//  MMTabController.m
//  Movie-Memory
//
//  Created by Kyle Frost on 5/23/14.
//  Copyright (c) 2014 Kyle Frost. All rights reserved.
//

#import "MMTabController.h"
#import "MMFirstOpenViewController.h"

@interface MMTabController ()

@property (strong, nonatomic) MMFirstOpenViewController *firstOpenViewController;

@end

@implementation MMTabController

@synthesize movieName = _movieName;

-(void)viewDidLoad {

    // Add the center Add Button to TabBar
    [self addCenterButtonWithImage:[UIImage imageNamed:@"add_button"] highlightImage:nil];
    
    // Change TabBar tint color to custom red
    self.tabBar.tintColor = [UIColor colorWithRed:0.922 green:0.196 blue:0.192 alpha:1.000];
    
    // Set up blurred background of first open view controller
    self.blurredView = [[FXBlurView alloc] initWithFrame:self.view.frame];
    self.blurredView.tintColor = [UIColor clearColor];
    self.blurredView.blurRadius = 15.0;
    self.blurredView.alpha = 0;
    
    // [self performSegueWithIdentifier:@"openFirstOpen" sender:self];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:@"isFirstOpen"]) {
        [self performSegueWithIdentifier:@"openFirstOpen" sender:self];
        [defaults setBool:NO forKey:@"isFirstOpen"];
        [defaults setBool:NO forKey:@"autoAddSwitch"];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    
    // First open view controller dismissal
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissFirstOpenViewController:) name:@"dismissFirstOpen" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeFirstOpenViewControllerBlur:) name:@"removeFirstOpenBlur" object:nil];
}

-(void)viewDidAppear:(BOOL)animated {
    
    // Listen for notification from MMScanBarcodeViewController with the scanned movie's name
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(barcodeWasScanned:) name:@"scannedBarcode" object:nil];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults boolForKey:@"alreadyOpenedAddMovie"]) {
        if ([defaults boolForKey:@"autoAddSwitch"]) {
            [self performSegueWithIdentifier:@"addManual" sender:self];
            [defaults setBool:YES forKey:@"alreadyOpenedAddMovie"];
        }
    }
}

// Add center button to TabBar
-(void)addCenterButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage {
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    
    CGFloat heightDifference = buttonImage.size.height - self.tabBar.frame.size.height;
    if (heightDifference < 0)
        button.center = self.tabBar.center;
    else
    {
        CGPoint center = self.tabBar.center;
        center.y = center.y - 6;
        button.center = center;
    }
    
    // When Add button is pressed run -(void)pressAdd
    [button addTarget:self action:@selector(pressAdd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

// Runs when MMBarcodeScannedViewController scans a barcode and dismisses itself
-(void)barcodeWasScanned:(NSNotification *)notification {
    
    // Listen for notification
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"scannedBarcode" object:nil];
    
    // Set the movieName to the object of the notification being recieved
    self.movieName = notification.object;
    
    // In the case the movie name can't be found, as user if they want to add it manually
    if ([self.movieName isEqualToString:@"(null)"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Uh Oh"
                                                            message:@"We couldn't find that movie. Would you like to add it manually?"
                                                           delegate:self
                                                  cancelButtonTitle:@"No"
                                                  otherButtonTitles:@"Yes", nil];
        [alertView show];
    }
    // If it is found, launch the addScannedMovie segue
    else {
        [self performSegueWithIdentifier:@"addScannedMovie" sender:self];
    }
}

#pragma mark - First Open View Functions

- (void)dismissFirstOpenViewController:(NSNotification *)notification
{
    [self.blurredView removeFromSuperview];
    [self.firstOpenViewController.view removeFromSuperview];
}

- (void)removeFirstOpenViewControllerBlur:(NSNotification *)notification
{
    if (self.firstOpenViewController.view.superview) {
        [self.blurredView removeFromSuperview];
        [self.firstOpenViewController.view removeFromSuperview];
    }
    [self.firstOpenViewController willMoveToParentViewController:nil];
    [self.firstOpenViewController removeFromParentViewController];
}

#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        // If the user selects "Yes" when no movie title is found, launch the addManual segue
        [self performSegueWithIdentifier:@"addManual" sender:self];
    }
}

-(void)pressAdd {
    // When the Add button is pressed, present an UIActionSheet to scan barcode or manually add movie
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Scan Barcode", @"Add Manually", nil];
    [actionSheet showInView:self.view];
}

// Make the UIActionSheet text color red so that it matches the rest of the app
- (void)willPresentActionSheet:(UIActionSheet *)actionSheet {
    for (UIView *subview in actionSheet.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subview;
            [button setTitleColor:[UIColor colorWithRed:0.922 green:0.196 blue:0.192 alpha:1.000] forState:UIControlStateNormal];
        }
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"addScannedMovie"]) {
        // If a scanned movie title is found, send that movie title to the MMAddManualViewController and launch that view
        MMAddManualViewController *controller = (MMAddManualViewController *)segue.destinationViewController;
        NSString *sendString = [[self.movieName lowercaseString] capitalizedString];
        controller.movieName = sendString;
        controller.isBarcode = 1;
        NSLog(@"sendString: %@", sendString);
    } else if ([segue.identifier isEqualToString:@"openFirstOpen"]) {
        self.firstOpenViewController = segue.destinationViewController;
        self.firstOpenViewController.tabController = self;
        [self addChildViewController:self.firstOpenViewController];
        [self.firstOpenViewController didMoveToParentViewController:self];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // Scan Barcode
        [self performSegueWithIdentifier:@"scanBarcode" sender:self];
    }
    else if (buttonIndex == 1) {
        // Add Manually
        [self performSegueWithIdentifier:@"addManual" sender:self];
    }
}

@end
