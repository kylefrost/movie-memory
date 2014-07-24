//
//  MMTabController.h
//  Movie-Memory
//
//  Created by Kyle Frost on 5/23/14.
//  Copyright (c) 2014 Kyle Frost. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMAddManualViewController.h"
#import "FXBlurView.h"

@interface MMTabController : UITabBarController <UIActionSheetDelegate, UIAlertViewDelegate>

// Method to add Center "Add" Button to TabBar
-(void)addCenterButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage;

// Blurred view for First Start screen
@property (strong, nonatomic) FXBlurView *blurredView;

// String that is recieved from MMScanBarcodeViewController after it has dismissed
@property (weak, nonatomic) NSString *movieName;

@end
