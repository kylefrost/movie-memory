//
//  MMScanBarcodeViewController.h
//  Movie-Memory
//
//  Created by Kyle Frost on 5/27/14.
//  Copyright (c) 2014 Kyle Frost. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMAddManualViewController.h"

@interface MMScanBarcodeViewController : UIViewController

// Property for the cancel button
@property (weak, nonatomic) IBOutlet UIButton *cancel;

// Property for information sent to other controllers
@property (weak, nonatomic) NSString *movieTitle;

// Properties for activity inidicator when looking for name
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *findingBarcode;
@property (weak, nonatomic) IBOutlet UIImageView *indicatorBackground;

// Properties for AFNetworking operation to find name from JSON
@property (retain, nonatomic) AFHTTPRequestOperation *operation;
@property (weak, nonatomic) NSOperationQueue *queue;

// Property for beep scanning sound
@property (assign) SystemSoundID beepSound;

@end
