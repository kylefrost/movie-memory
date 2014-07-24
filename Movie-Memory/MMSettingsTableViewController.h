//
//  MMSettingsTableViewController.h
//  Movie-Memory
//
//  Created by Kyle Frost on 5/24/14.
//  Copyright (c) 2014 Kyle Frost. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface MMSettingsTableViewController : UITableViewController <UIActionSheetDelegate, MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableViewCell *kyleFrostCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *moreAppsCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *supportCell;

@property (weak, nonatomic) IBOutlet UISwitch *autoAddSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *usageDataSwitch;

@end
