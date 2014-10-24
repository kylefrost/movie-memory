//
//  MMSettingsTableViewController.m
//  Movie-Memory
//
//  Created by Kyle Frost on 5/24/14.
//  Copyright (c) 2014 Kyle Frost. All rights reserved.
//

#import "MMSettingsTableViewController.h"
#import <Social/Social.h>

@interface MMSettingsTableViewController ()

@property (strong, nonatomic) IBOutlet UIBarButtonItem *resetFirstOpen;

@end

@implementation MMSettingsTableViewController

-(id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    NSIndexPath *tableSelection = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:tableSelection animated:NO];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:MMAutoAddIsEnabled]) {
        self.autoAddSwitch.on = YES;
    } else {
        self.autoAddSwitch.on = NO;
    }

    if ([defaults boolForKey:MMDiagnosticsAreEnabled]) {
        self.usageDataSwitch.on = YES;
    } else {
        self.usageDataSwitch.on = NO;
    }
}

- (IBAction)pressedResetButton:(id)sender {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:MMIsNotFirstOpen];
}

#pragma mark - UISwitches

-(IBAction)didSwitchAutoAddSwitch:(id)sender {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (self.autoAddSwitch.on) {
        [defaults setBool:YES forKey:MMAutoAddIsEnabled];
    } else {
        [defaults setBool:NO forKey:MMAutoAddIsEnabled];
    }
}

-(IBAction)didSwitchUsageDataSwitch:(id)sender {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (self.usageDataSwitch.on) {
        [defaults setBool:YES forKey:MMDiagnosticsAreEnabled];
    } else {
        [defaults setBool:NO forKey:MMDiagnosticsAreEnabled];
    }
}

#pragma mark - Twitter button

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Determine what Twitter apps are installed
    BOOL tweetbotInstalled = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot://"]];
    BOOL twitterInstalled = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter://"]];
    BOOL twitterrificInstalled = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitterrific://"]];
    
    if ([indexPath isEqual:[tableView indexPathForCell:self.moreAppsCell]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.com/apps/kylefrost"]];
    }
    
    // Decide what URL Scheme to follow when @twitter names are selected in
    
    // Open Tweetbot
    if (tweetbotInstalled) {
        
        if ([indexPath isEqual:[tableView indexPathForCell:self.kyleFrostCell]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tweetbot:///user_profile/_kylefrost"]];
        }
        if ([indexPath isEqual:[tableView indexPathForCell:self.supportCell]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tweetbot:///user_profile/kylefrostdesign"]];
        }
    }
    
    // Open Twitterrific
    else if (twitterrificInstalled) {
        
        if ([indexPath isEqual:[tableView indexPathForCell:self.kyleFrostCell]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"twitterrific:///profile?screen_name=_kylefrost"]];
        }
        if ([indexPath isEqual:[tableView indexPathForCell:self.supportCell]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"twitterrific:///profile?screen_name=kylefrostdesign"]];
        }
    }
    
    // Open Twitter app
    else if (twitterInstalled) {
        
        if ([indexPath isEqual:[tableView indexPathForCell:self.kyleFrostCell]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"twitter:///user?screen_name=_kylefrost"]];
        }
        if ([indexPath isEqual:[tableView indexPathForCell:self.supportCell]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"twitter:///user?screen_name=kylefrostdesign"]];
        }
    }
    
    // Open in Safari
    else {
        
        if ([indexPath isEqual:[tableView indexPathForCell:self.kyleFrostCell]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.twitter.com/_kylefrost"]];
        }
        if ([indexPath isEqual:[tableView indexPathForCell:self.supportCell]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.twitter.com/kylefrostdesign"]];
        }
    }
}

#pragma mark - Share Sheet

-(IBAction)pressShare:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"How are you liking Movie Memory?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"I love it!", @"I like it.", @"It could be better.", @"I hate it.", nil];
    
    [actionSheet setTag:1];
    [actionSheet showInView:self.view];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if ([actionSheet tag] == 1) {
        
        if (buttonIndex == 0) {
            // I love it!
            UIActionSheet *loveActionSheet = [[UIActionSheet alloc] initWithTitle:@"We're glad to hear that!" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Share to Twitter", @"Share to Facebook", @"Rate on App Store", nil];
            [loveActionSheet setTag:2];
            [loveActionSheet showInView:self.view];
        }
        else if (buttonIndex == 1) {
            // I like it. I love it. I want some more of it.
            // I mean, just "I like it."
            UIActionSheet *likeActionSheet = [[UIActionSheet alloc] initWithTitle:@"We're glad you like it, but we can do better." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Email Us", @"Share on Twitter", @"Share on Facebook", nil];
            [likeActionSheet setTag:3];
            [likeActionSheet showInView:self.view];
            
        }
        else if (buttonIndex == 2) {
            // It could be better.
            UIActionSheet *betterActionSheet = [[UIActionSheet alloc] initWithTitle:@"We really want to do better. What can you suggest?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Email Us", @"Tweet Support", @"Visit Our Site", nil];
            [betterActionSheet setTag:4];
            [betterActionSheet showInView:self.view];
        }
        else if (buttonIndex == 3) {
            // I hate it.
            UIActionSheet *hateActionSheet = [[UIActionSheet alloc] initWithTitle:@"We're sorry to hear that. Let us know what we can do better." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Tell Us Why", @"Request Refund", nil];
            [hateActionSheet setTag:5];
            [hateActionSheet showInView:self.view];
        }
    }
    
    // I love it!
    else if ([actionSheet tag] == 2) {
        
        if (buttonIndex == 0) {
            
            SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            [tweetSheet setInitialText:@"I'm loving #MovieMemory by @KyleFrostDesign! Check it out! #moviememory"];
            
            [self presentViewController:tweetSheet animated:YES completion:nil];
        }
        else if (buttonIndex == 1) {
            
            SLComposeViewController *shareSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            [shareSheet setInitialText:@"I'm loving Movie Memory! Check it out! #moviememory"];
            
            [self presentViewController:shareSheet animated:YES completion:nil];
        }
        else if (buttonIndex == 2) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.com/apps/moviememory"]];
        }
    }
    
    // I like it.
    else if ([actionSheet tag] == 3) {
        
        if (buttonIndex == 0) {
            NSString *messageBody = [NSString stringWithFormat:@"\n\n%@, %@", [UIDevice currentDevice].model, [UIDevice currentDevice].systemVersion];
            
            MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
            controller.mailComposeDelegate = self;
            [controller setSubject:@"Movie Memory Feedback"];
            [controller setToRecipients:[NSArray arrayWithObjects:[NSString stringWithFormat:@"support@kylefrostdesign.com"], nil]];
            [controller setMessageBody:messageBody isHTML:NO];
            if (controller) [self presentViewController:controller animated:YES completion:nil];
        }
        else if (buttonIndex == 1) {
            
            SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            [tweetSheet setInitialText:@"I'm loving #MovieMemory by @KyleFrostDesign! Check it out! #moviememory"];
            
            [self presentViewController:tweetSheet animated:YES completion:nil];
        }
        else if (buttonIndex == 2) {
            
            SLComposeViewController *shareSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            [shareSheet setInitialText:@"I'm loving Movie Memory! Check it out! #moviememory"];
            
            [self presentViewController:shareSheet animated:YES completion:nil];
        }
    }
    
    // It could be better.
    else if ([actionSheet tag] == 4) {
        
        if (buttonIndex == 0) {
            NSString *messageBody = [NSString stringWithFormat:@"\n\n%@, %@", [UIDevice currentDevice].model, [UIDevice currentDevice].systemVersion];
            
            MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
            controller.mailComposeDelegate = self;
            [controller setSubject:@"Movie Memory Feedback"];
            [controller setToRecipients:[NSArray arrayWithObjects:[NSString stringWithFormat:@"support@kylefrostdesign.com"], nil]];
            [controller setMessageBody:messageBody isHTML:NO];
            if (controller) [self presentViewController:controller animated:YES completion:nil];
        }
        else if (buttonIndex == 1) {
            
            SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            [tweetSheet setInitialText:@"@KyleFrostDesign"];
            
            [self presentViewController:tweetSheet animated:YES completion:nil];
        }
        else if (buttonIndex == 2) {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.kylefrostdesign.com"]];
        }
    }
    
    // I hate it.
    else if ([actionSheet tag] == 5) {
        
        if (buttonIndex == 0) {
            NSString *messageBody = [NSString stringWithFormat:@"\n\n%@, %@", [UIDevice currentDevice].model, [UIDevice currentDevice].systemVersion];
            
            MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
            controller.mailComposeDelegate = self;
            [controller setSubject:@"I don't like Movie Memory"];
            [controller setToRecipients:[NSArray arrayWithObjects:[NSString stringWithFormat:@"support@kylefrostdesign.com"], nil]];
            [controller setMessageBody:messageBody isHTML:NO];
            if (controller) [self presentViewController:controller animated:YES completion:nil];
        }
        else if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://reportaproblem.apple.com"]];
        }
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        NSLog(@"It's away!");
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/


@end
