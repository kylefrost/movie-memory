//
//  MMWatchedTableViewController.h
//  Movie-Memory
//
//  Created by Kyle Frost on 5/24/14.
//  Copyright (c) 2014 Kyle Frost. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMAddManualViewController.h"

@interface MMWatchedTableViewController : UITableViewController <MMAddManualViewControllerDelegate>

// Array for the movies that have been saved in Core Data
@property (strong) NSMutableArray *movies;

@end
