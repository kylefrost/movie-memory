//
//  MMConstants.h
//  Movie-Memory
//
//  Created by Kyle Frost on 10/23/14.
//  Copyright (c) 2014 Kyle Frost. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMConstants : NSObject

// NSUserDefaults
extern NSString *const MMDiagnosticsAreEnabled;
extern NSString *const MMAutoAddIsEnabled;
extern NSString *const MMIsNotFirstOpen;
extern NSString *const MMAlreadyOpenedAddMovie;

// Notifications
extern NSString *const MMDismissFirstViewNotification;
extern NSString *const MMDidScanBarCodeNotification;

@end
