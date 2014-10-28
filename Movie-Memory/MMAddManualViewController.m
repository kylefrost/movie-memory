//
//  MMAddManualViewController.m
//  Movie-Memory
//
//  Created by Kyle Frost on 5/24/14.
//  Copyright (c) 2014 Kyle Frost. All rights reserved.
//

#import "MMAddManualViewController.h"
#import "MMWatchedTableViewController.h"
#import "FXBlurView.h"
#import <QuartzCore/QuartzCore.h>

@interface MMAddManualViewController () {
    // Date picker for the alertview that shows when date is tapped
    UIDatePicker *datePicker;
    
    // Keep track of which search button is pressed
    NSInteger searchButton;
}

@property (strong, nonatomic) IBOutlet UIImageView *indicatorBackground;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation MMAddManualViewController

@synthesize titleField = _titleField;
@synthesize releaseField = _releaseField;
@synthesize watchedLabel = _watchedLabel;
@synthesize commentSection = _commentSection;
@synthesize movieName = _movieName;
@synthesize myDelegate = _myDelegate;

@synthesize movies = _movies;

// Register view to access the Core Data from the App Delegate
-(NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    // Initialize the search button to 0
    searchButton = 0;
    // Set all the information for the navigation bar
    [self setNeedsStatusBarAppearanceUpdate];
    self.addManualBar.delegate = self;
    self.addManualBar.barTintColor = [UIColor colorWithRed:0.890 green:0.100 blue:0.148 alpha:1.000];
    self.addManualBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil];
    [self.activityIndicator setHidden:YES];
    [self.indicatorBackground setHidden:YES];
    
    // Already opened add view
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:MMAlreadyOpenedAddMovie];
    
    // Set cover image to not change size.
    self.coverImage.contentMode = UIViewContentModeScaleAspectFit;
    
    // Button borders
    UIView *starTopBorderView = [[UIView alloc] initWithFrame:CGRectMake(-5, 0, self.bigStarButton.frame.size.width+5, 1)];
    UIView *starBottomBorderView = [[UIView alloc] initWithFrame:CGRectMake(-5, self.bigStarButton.frame.size.height-1, self.bigStarButton.frame.size.width+5, 1)];
    starTopBorderView.backgroundColor = [UIColor lightGrayColor];
    starBottomBorderView.backgroundColor = [UIColor lightGrayColor];
    [self.bigStarButton addSubview:starTopBorderView];
    [self.bigStarButton addSubview:starBottomBorderView];
    
    UIView *dateBottomBorderView = [[UIView alloc] initWithFrame:CGRectMake(-5, self.dateButton.frame.size.height-1, self.dateButton.frame.size.width+5, 1)];
    dateBottomBorderView.backgroundColor = [UIColor lightGrayColor];
    [self.dateButton addSubview:dateBottomBorderView];
    
    // If user selected a movie, load that info, if not, set up view for new/blank movie
    if (_movies) {
        UIImage *coverDataImage = [UIImage imageWithData:[_movies valueForKey:@"cover"]];
        [self.titleField setText:[NSString stringWithFormat:@"%@", [_movies valueForKey:@"title"]]];
        [self.releaseField setText:[NSString stringWithFormat:@"%@", [_movies valueForKey:@"releaseYear"]]];
        [self.watchedLabel setText:[NSString stringWithFormat:@"%@", [_movies valueForKey:@"watchedDate"]]];
        [self.coverImage setImage:coverDataImage];
        [self.commentSection setText:[NSString stringWithFormat:@"%@", [_movies valueForKey:@"comments"]]];
        [self addRating];
        self.addManualBar.topItem.title = @"Edit Movie";
        
        if ([_movies valueForKey:@"cover"] == NULL) {
            [self.coverImage setImage:[UIImage imageNamed:@"no_cover"]];
        }
        if ([_movies valueForKey:@"comments"] == NULL) {
            self.commentSection.text = @"";
        }
    } else {
        self.addManualBar.topItem.title = @"Add Watched Movie";
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"M/d/yyyy"];
        self.watchedLabel.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[NSDate date]]];
    }
    
    // Set ALL the delegates
    self.titleField.delegate = self;
    self.releaseField.delegate = self;
    self.commentSection.delegate = self;
    
    // Add "Done" ToolBar to the top of the keyboard if the user selects the comments section
    [self addDoneToolBarToKeyboard:self.commentSection];
    
    // Determine if the user is coming from a scanned movie
    if (self.isBarcode == 1) {
        [self addBarcodeTitle];
    }
    
    // Hide the search buttons if the title is not filled in, show them if it is
    if ([self.titleField.text length] == 0) {
        self.searchCoverButton.alpha = 0.0;
        self.searchCoverButton.enabled = NO;
        self.searchCoverButton.userInteractionEnabled = FALSE;
        self.searchReleaseYear.alpha = 0.0;
        self.searchReleaseYear.enabled = NO;
        self.searchReleaseYear.userInteractionEnabled = FALSE;
    } else  {
        self.searchCoverButton.alpha = 1.0;
        self.searchCoverButton.enabled = YES;
        self.searchCoverButton.userInteractionEnabled = TRUE;
        self.searchReleaseYear.alpha = 1.0;
        self.searchReleaseYear.enabled = YES;
        self.searchReleaseYear.userInteractionEnabled = TRUE;
    }
    
    // Recieve notification to change the cover image if a user is coming from the search view and has selected to set the cover
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchViewControllerDismissed:) name:@"changeImage" object:nil];
}

-(void)addRating {
    // Initialize int of what the rating is
    int rating = [[_movies valueForKey:@"rating"] intValue];
    // Show correct label and image based on what the rating of the movie is, if there is one
    switch (rating) {
        case 1:
            self.ratingLabel.text = @"1 Star";
            [self.starButton setImage:[UIImage imageNamed:@"stars_one"] forState:UIControlStateNormal];
            break;
        case 2:
            self.ratingLabel.text = @"2 Stars";
            [self.starButton setImage:[UIImage imageNamed:@"stars_two"] forState:UIControlStateNormal];
            break;
        case 3:
            self.ratingLabel.text = @"3 Stars";
            [self.starButton setImage:[UIImage imageNamed:@"stars_three"] forState:UIControlStateNormal];
            break;
        case 4:
            self.ratingLabel.text = @"4 Stars";
            [self.starButton setImage:[UIImage imageNamed:@"stars_four"] forState:UIControlStateNormal];
            break;
        case 5:
            self.ratingLabel.text = @"5 Stars";
            [self.starButton setImage:[UIImage imageNamed:@"stars_five"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    if (!_movies) {
        [self.titleField becomeFirstResponder];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // Add notification observers for if the keyboard is hidden or showing in order to move view for comments section
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)viewWillDisappear:(BOOL)animated {
    // Remove observers for the notifications of the keyboard showing and dimissing when exiting a view
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    [self resignFirstResponder];
    [self.myDelegate updateTableView];
}

-(void)addBarcodeTitle {
    // If the view is being shown after scanning a barcode, fill in with the barcode information
    NSString *titleName = [[self.movieName lowercaseString] capitalizedString];
    self.titleField.text = titleName;
    NSLog(@"MMAddManualViewController titleName = %@", titleName);
}

-(IBAction)showButtons {
    // Show or hide buttons based on whether or not there is text in the title name field
    if ([self.titleField.text length] == 0) {
        self.searchCoverButton.alpha = 0.0;
        self.searchCoverButton.enabled = NO;
        self.searchCoverButton.userInteractionEnabled = FALSE;
        self.searchReleaseYear.alpha = 0.0;
        self.searchReleaseYear.enabled = NO;
        self.searchReleaseYear.userInteractionEnabled = FALSE;
    } else  {
        self.searchCoverButton.alpha = 1.0;
        self.searchCoverButton.enabled = YES;
        self.searchCoverButton.userInteractionEnabled = TRUE;
        self.searchReleaseYear.alpha = 1.0;
        self.searchReleaseYear.enabled = YES;
        self.searchReleaseYear.userInteractionEnabled = TRUE;
    }
}

-(void)searchViewControllerDismissed:(NSNotification *)notification {
    // If the search view is dismissed and the user has selected to set the cover
    NSData *recievedData = [NSData dataWithData:notification.object];
    UIImage *newCoverImage = [UIImage imageWithData:recievedData];
    self.coverImage.image = newCoverImage;
}

-(IBAction)pressSearchCover:(id)sender {
    // If the user pressing search for cover, set the sender and the searchButton integer respectively
    [self performSegueWithIdentifier:@"LoadSearch" sender:self.searchCoverButton];
    searchButton = 1;
}

-(IBAction)pressSearchYear:(id)sender {
    // If the user pressing search for year, set the sender and the searchButton integer respectively
    [self performSegueWithIdentifier:@"LoadSearch" sender:self.searchReleaseYear];
    searchButton = 2;
}

-(IBAction)starsPressed:(id)sender {
    // If the users taps to change the stars, show the alert view with the stars to choose
    UIAlertView *starAlert = [[UIAlertView alloc] initWithTitle:@"Rating"
                                                        message:@"How many stars would you give this movie?"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"1", @"2", @"3", @"4", @"5", nil];
    [starAlert setTag:1];
    [starAlert show];
    
    // Dismiss keyboard if typing when tapping on stars
    [self.view endEditing:YES];
}

-(IBAction)datePressed:(id)sender {
    // If the date is pressed, show the alert view with datePicker inside of the view
    UIAlertView *dateAlert = [[UIAlertView alloc] initWithTitle:@"Date Watched"
                                                        message:@"What date did you watch this movie?"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Set", nil];
    
    // Initialize the view that the datePicker will be added to
    UIView *alertView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, 320, 200)];
    
    // Initialize the datePicker and set the mode
    datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    
    if ([UIApplication isIOS8]) {
        datePicker.frame = CGRectMake(0, -35, alertView.bounds.size.width-35, alertView.bounds.size.height);
    }
    
    // Set the date of the picker and set the date picker as the date of the label, also make datePicker not accept date after current date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"M/d/yyyy"];
    NSDate *labelDate = [dateFormatter dateFromString:self.watchedLabel.text];
    datePicker.date = labelDate;
    [datePicker setMaximumDate:[NSDate date]];
    
    // Add the datepicker to the view, and the view to the alert, and show the alert
    [alertView addSubview:datePicker];
    [dateAlert setValue:alertView forKey:@"accessoryView"];
    [dateAlert setTag:2];
    [dateAlert becomeFirstResponder];
    [dateAlert show];
    
    // Dismiss keyboard if editing was occuring when tapped
    [self.view endEditing:YES];
}

-(IBAction)changePress:(id)sender {
    // If the user taps the cover to change it, show the image picker
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.delegate = self;
    [self presentViewController:pickerController animated:YES completion:NULL];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    // When the user selects an image, change the image to the selected image and dismiss the view
    self.coverImage.image = image;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [self dismissModalViewControllerAnimated:YES];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // If the alert view is the one about the stars, set the stars when the button is pressed
    if ([alertView tag] == 1) {
        if (buttonIndex == 1) {
            self.ratingLabel.text = @"1 Star";
            [self.starButton setImage:[UIImage imageNamed:@"stars_one"] forState:UIControlStateNormal];
        } else if (buttonIndex == 2) {
            self.ratingLabel.text = @"2 Stars";
            [self.starButton setImage:[UIImage imageNamed:@"stars_two"] forState:UIControlStateNormal];
        } else if (buttonIndex == 3) {
            self.ratingLabel.text = @"3 Stars";
            [self.starButton setImage:[UIImage imageNamed:@"stars_three"] forState:UIControlStateNormal];
        } else if (buttonIndex == 4) {
            self.ratingLabel.text = @"4 Stars";
            [self.starButton setImage:[UIImage imageNamed:@"stars_four"] forState:UIControlStateNormal];
        } else if (buttonIndex == 5) {
            self.ratingLabel.text = @"5 Stars";
            [self.starButton setImage:[UIImage imageNamed:@"stars_five"] forState:UIControlStateNormal];
        }
    }
    // If the alert is the date picker, change the date if Set is pressed
    else if ([alertView tag] == 2) {
        if (buttonIndex == 1) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"M/d/yyyy"];
            NSString *dateString = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:datePicker.date]];
            self.watchedLabel.text = dateString;
        }
    }
}

-(IBAction)pressSave:(id)sender {
    // Set the context for when the user taps to save the movie that is being created
    NSManagedObjectContext *context = [self managedObjectContext];
    
    // Convert the cover image into NSData for saving
    NSData *coverData = UIImagePNGRepresentation(self.coverImage.image);
    
    // If we are editing a current movie, set all of the fields' keys to the new ones
    if (_movies) {
        [_movies setValue:self.titleField.text forKey:@"title"];
        [_movies setValue:self.releaseField.text forKey:@"releaseYear"];
        [_movies setValue:[self.ratingLabel.text substringWithRange:NSMakeRange(0, 1)] forKey:@"rating"];
        [_movies setValue:self.watchedLabel.text forKey:@"watchedDate"];
        [_movies setValue:coverData forKey:@"cover"];
        [_movies setValue:self.commentSection.text forKey:@"comments"];
    }
    // If we are creating a new one, create a new object in the Movie database and add all the fields
    else {
        NSManagedObject *newMovie = [NSEntityDescription insertNewObjectForEntityForName:@"Movie" inManagedObjectContext:context];
        [newMovie setValue:self.titleField.text forKeyPath:@"title"];
        [newMovie setValue:self.releaseField.text forKeyPath:@"releaseYear"];
        [newMovie setValue:[self.ratingLabel.text substringWithRange:NSMakeRange(0, 1)] forKeyPath:@"rating"];
        [newMovie setValue:self.watchedLabel.text forKeyPath:@"watchedDate"];
        [newMovie setValue:coverData forKey:@"cover"];
        [newMovie setValue:self.commentSection.text forKey:@"comments"];
    }
    
    // Commit the save to Core Data database
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Save failed!\nError: %@\nDescription: %@", error, [error localizedDescription]);
    }
    
    [self.myDelegate updateTableView];
    
    UINavigationController *navController = [self.presentingViewController.childViewControllers objectAtIndex:0];
    UITableViewController *tableController = [navController.childViewControllers objectAtIndex:0];
    [tableController.tableView reloadData];
    NSLog(@"%@", tableController.tableView);
    
    [self viewWillAppear:NO];
    
    [self.myDelegate updateTableView];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateTableView" object:nil];
    
    
    FXBlurView *blurView = [[FXBlurView alloc] initWithFrame:self.view.frame];
    blurView.tintColor = [UIColor clearColor];
    blurView.alpha = 0.0;
    blurView.blurRadius = 5.0;
    [self.view addSubview:blurView];
    [self.activityIndicator startAnimating];
    [self.activityIndicator setHidden:NO];
    self.indicatorBackground.layer.backgroundColor = [UIColor blackColor].CGColor;
    self.indicatorBackground.layer.opacity = 0.5f;
    self.indicatorBackground.layer.cornerRadius = self.indicatorBackground.bounds.size.width/2;
    [self.indicatorBackground setHidden:NO];
    [self.view bringSubviewToFront:self.indicatorBackground];
    [self.view bringSubviewToFront:self.activityIndicator];
    [self resignFirstResponder];

    [UIView animateWithDuration:0.2 animations:^{
        blurView.alpha = 1.0;
    }];
    
    [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(showCheckmark) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:1.9 target:self selector:@selector(makeCheckmark) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(dismissView) userInfo:nil repeats:NO];
}

-(void)dismissView {
    [self.indicatorBackground setHidden:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showCheckmark {
    NSArray *images = [NSArray arrayWithObjects:[UIImage imageNamed:@"checkmark_0"], [UIImage imageNamed:@"checkmark_1"], [UIImage imageNamed:@"checkmark_2"], [UIImage imageNamed:@"checkmark_3"], [UIImage imageNamed:@"checkmark_4"], [UIImage imageNamed:@"checkmark_5"], [UIImage imageNamed:@"checkmark_6"], [UIImage imageNamed:@"checkmark_7"], nil];
    self.indicatorBackground.animationImages = images;
    self.indicatorBackground.animationDuration = 0.5;
    self.indicatorBackground.animationRepeatCount = 1;
    self.indicatorBackground.contentMode = UIViewContentModeCenter;
    [self.indicatorBackground startAnimating];
    [self.activityIndicator setHidden:YES];
}

- (void)makeCheckmark {
    [self.indicatorBackground stopAnimating];
    self.indicatorBackground.image = [UIImage imageNamed:@"checkmark_7"];
}

-(IBAction)pressCancel:(id)sender {
    // If the user selected cancel, do nothing and return to main list view
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // If the user taps outside the textfield then dismiss the keyboard
    [self.view endEditing:YES];
    [self.commentSection resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    // Make it so the text field does not allow a return key in title and year, instead dismiss keyboard
    [textField resignFirstResponder];
    return NO;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView {
    // Make the keyboard dismiss when the user is done typing in the comments section
    [textView resignFirstResponder];
    [self.commentSection resignFirstResponder];
    return YES;
}

-(void)addDoneToolBarToKeyboard:(UITextView *)textView {
    // Add a Toolbar to the top of the keyboard if editing inside the comments field
    UIToolbar* doneToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    doneToolbar.barStyle = UIBarStyleDefault;
    doneToolbar.items = [NSArray arrayWithObjects:
                         [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                       target:nil
                                                                       action:nil],
                         [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                          style:UIBarButtonItemStyleDone
                                                         target:self
                                                         action:@selector(doneButtonClickedDismissKeyboard)], nil];
    [doneToolbar sizeToFit];
    doneToolbar.tintColor = [UIColor colorWithRed:0.890 green:0.100 blue:0.148 alpha:1.000];;
    textView.inputAccessoryView = doneToolbar;
}

-(void)textViewDidBeginEditing:(UITextView *)textView {
    // Set the comment section as the textview we are manipulating
    self.commentSection = textView;
    
    if ([textView isEqual:self.commentSection]) {
        // Move the main view so that the keyboard does not hide it
        if  (self.view.frame.origin.y >= 0) {
            [self setViewMovedUp:YES];
        }
    } else {
        [self setViewMovedUp:NO];
    }
}

-(void)doneButtonClickedDismissKeyboard {
    // When done is pressed then dismiss the keyboard
    [self.commentSection resignFirstResponder];
}

#pragma mark - TextView Moving

#define kOFFSET_FOR_KEYBOARD 220.0

-(void)keyboardWillShow {
    // Move the view up if the keyboard is showing, move down if not
    if ([self.commentSection isFirstResponder]) {
        if (self.view.frame.origin.y >= 0){
            [self setViewMovedUp:YES];
        } else if (self.view.frame.origin.y < 0) {
            [self setViewMovedUp:NO];
        }
    }
}

-(void)keyboardWillHide {
    // Move the view up if the keyboard is showing, move down if not
    if ([self.commentSection isFirstResponder]) {
        if (self.view.frame.origin.y >= 0){
            [self setViewMovedUp:YES];
        } else if (self.view.frame.origin.y < 0) {
            [self setViewMovedUp:NO];
        }
    }
}

// Method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp {
    // Begin animation of the view moving up or down and set duration
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    CGRect rect = self.view.frame;
    if (movedUp) {
        // Move the view's origin up so that the text field that will be hidden come above the keyboard
        // Increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    } else {
        // Revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    }
    self.view.frame = rect;
    
    // Commit and show the animations
    [UIView commitAnimations];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // If the user selects to search for cover or title
    if ([[segue identifier] isEqualToString:@"LoadSearch"]) {
        // Set string as the current title's field
        NSString *string = [NSString stringWithFormat:@"%@", self.titleField.text];
        MMSearchViewController *destination = (MMSearchViewController *)segue.destinationViewController;
        // Send the title to the search view
        destination.titleString = string;
        
        // Determine which type of search button was tapped
        if (sender == self.searchCoverButton) {
            searchButton = 1;
        } else if (sender == self.searchReleaseYear) {
            searchButton = 2;
        }
        // Send the view what button was tapped in order to load correct information
        destination.searchButtonInt = searchButton;
    }
}

-(UIBarPosition)positionForBar:(id <UIBarPositioning>)bar {
    // Attach the navigation bar to the top of the view (under status bar)
    return UIBarPositionTopAttached;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    // Set the status bar as light content instead of dark
    return UIStatusBarStyleLightContent;
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
