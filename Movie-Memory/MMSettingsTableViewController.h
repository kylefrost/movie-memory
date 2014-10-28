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


@property (weak, nonatomic) IBOutlet UITableViewCell *moreAppsCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *twitterCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *privacyPolicyCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *facebookCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *emailCell;

@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@property (weak, nonatomic) IBOutlet UISwitch *autoAddSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *usageDataSwitch;

@end
