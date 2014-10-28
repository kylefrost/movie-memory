//
//  MMAddManualViewController.h
//  Movie-Memory
//
//  Created by Kyle Frost on 5/24/14.
//  Copyright (c) 2014 Kyle Frost. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMSearchViewController.h"

// Delegate
@protocol MMAddManualViewControllerDelegate <NSObject>

-(void)updateTableView;

@end

@interface MMAddManualViewController : UIViewController <UIAlertViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UITextViewDelegate, UINavigationBarDelegate> {
    // TextView of the comment section
    UITextView *commentSection;
    id myDelegate;
}

// Delegate
@property (strong, nonatomic) IBOutlet id<MMAddManualViewControllerDelegate> myDelegate;

// Properties of the navigation bar
@property (weak, nonatomic) IBOutlet UINavigationBar *addManualBar;
@property (nonatomic,readonly) UIBarPosition barPosition;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelButton;

// Properties/Actions for the rating stars/label
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UIButton *starButton;
@property (weak, nonatomic) IBOutlet UIButton *bigStarButton;
-(IBAction)starsPressed:(id)sender;

// Properties/Actions for the watched date option
@property (strong, nonatomic) IBOutlet UILabel *watchedLabel;
@property (weak, nonatomic) IBOutlet UIButton *dateButton;
-(IBAction)datePressed:(id)sender;

// Properties for the Title and Release Year
@property (strong, nonatomic) IBOutlet UITextField *titleField;
@property (strong, nonatomic) IBOutlet UITextField *releaseField;

// Properties/Actions for the Cover Image
@property (strong, nonatomic) IBOutlet UIImageView *coverImage;
-(IBAction)changePress:(id)sender;
-(void)searchViewControllerDismissed:(NSData *)coverImagePassed;

// Properties for the comment section
@property (retain, nonatomic) IBOutlet UITextView *commentSection;

// Properties/Actions for searching for the cover and the year
@property (strong, nonatomic) IBOutlet UIButton *searchCoverButton;
@property (strong, nonatomic) IBOutlet UIButton *searchReleaseYear;
-(IBAction)pressSearchCover:(id)sender;
-(IBAction)pressSearchYear:(id)sender;
-(IBAction)showButtons;

// Properties for information passed from other views
@property (strong, nonatomic) NSString *movieName;
@property (nonatomic) NSInteger isBarcode;

// Array of objects that are included in Core Data database
@property (strong) NSManagedObject *movies;

@end
