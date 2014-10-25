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

// Views for Array
@property (strong, nonatomic) UIViewController *oneView;
@property (strong, nonatomic) UIViewController *twoView;
@property (strong, nonatomic) UIViewController *threeView;
@property (strong, nonatomic) UIViewController *fourView;

@end

@implementation MMTabController

@synthesize movieName = _movieName;

-(void)viewDidLoad {

    // Add the center Add Button to TabBar
    [self addCenterButtonWithImage:[UIImage imageNamed:@"add_button"] highlightImage:nil];
    
    // Change TabBar tint color to custom red
    self.tabBar.tintColor = [UIColor colorWithRed:0.922 green:0.196 blue:0.192 alpha:1.000];
    
    //[self performSegueWithIdentifier:@"openFirstOpen" sender:self];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults boolForKey:MMIsNotFirstOpen]) {
        [self setUpFirstView];
        // [self performSegueWithIdentifier:@"openFirstOpen" sender:self];
        [defaults setBool:YES forKey:MMIsNotFirstOpen];
        [defaults setBool:NO forKey:MMAutoAddIsEnabled];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissFirstOpenViewController) name:MMDismissFirstViewNotification object:nil];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    
    // First open view controller dismissal
}

-(void)viewDidAppear:(BOOL)animated {
    
    // Listen for notification from MMScanBarcodeViewController with the scanned movie's name
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(barcodeWasScanned:) name:MMDidScanBarCodeNotification object:nil];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults boolForKey:MMAlreadyOpenedAddMovie]) {
        if ([defaults boolForKey:MMAutoAddIsEnabled]) {
            [self performSegueWithIdentifier:@"addManual" sender:self];
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
    [self.view bringSubviewToFront:self.blurredView];
}

// Runs when MMBarcodeScannedViewController scans a barcode and dismisses itself
-(void)barcodeWasScanned:(NSNotification *)notification {
    
    // Listen for notification
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MMDidScanBarCodeNotification object:nil];
    
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

#pragma mark - First View Shit

- (void)setUpFirstView
{
    [self setUpViews];
    
    // Set up blurred background of first open view controller
    self.blurredView = [[FXBlurView alloc] initWithFrame:self.view.frame];
    self.blurredView.tintColor = [UIColor clearColor];
    self.blurredView.blurRadius = 15.0;
    self.blurredView.alpha = 0;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.blurredView.frame];
    self.scrollView.pagingEnabled = TRUE;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.alpha = 0;
    
    NSArray *viewArray = [NSArray arrayWithObjects:self.oneView, self.twoView, self.threeView, self.fourView, nil];
    
    // self.pageControl.numberOfPages = viewArray.count;
    
    for (int i = 0; i < viewArray.count; i++) {
        
        CGRect frame;
        frame.origin.x = self.scrollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.scrollView.frame.size;
        
        UIViewController *controller = [viewArray objectAtIndex:i];
        UIView *subview = controller.view;
        
        subview.frame = frame;
        
        [self.scrollView addSubview:subview];
    }
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * viewArray.count, self.scrollView.frame.size.height);
    
    [self.view addSubview:self.blurredView];
    [self.view bringSubviewToFront:self.blurredView];
    
    [self.blurredView addSubview:self.scrollView];
    [self.blurredView bringSubviewToFront:self.scrollView];
    
    [UIView animateWithDuration:1.0 animations:^{
        self.blurredView.alpha = 1;
        self.scrollView.alpha = 1;
    }];
}

- (void)setUpViews {
    [self setUpFirstViewController];
    [self setUpSecondViewController];
    [self setUpThirdViewController];
    [self setUpFourthViewController];
}

- (void)setUpFirstViewController {
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"MMFirstOpenOneViewController" owner:self options:nil];
    self.oneView = [nibs objectAtIndex:0];
}

- (void)setUpSecondViewController {
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"MMFirstOpenTwoViewController" owner:self options:nil];
    self.twoView = [nibs objectAtIndex:0];
}

- (void)setUpThirdViewController {
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"MMFirstOpenThreeViewController" owner:self options:nil];
    self.threeView = [nibs objectAtIndex:0];
}

- (void)setUpFourthViewController {
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"MMFirstOpenFourViewController" owner:self options:nil];
    self.fourView = [nibs objectAtIndex:0];
}

#pragma mark - First Open View Functions

- (void)dismissFirstOpenViewController {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:MMAlreadyOpenedAddMovie];
    [UIView animateWithDuration:0.5 animations:^{
        self.blurredView.alpha = 0;
    }];
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
