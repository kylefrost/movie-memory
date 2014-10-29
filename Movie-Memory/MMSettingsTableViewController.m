//
//  MMSettingsTableViewController.m
//  Movie-Memory
//
//  Created by Kyle Frost on 5/24/14.
//  Copyright (c) 2014 Kyle Frost. All rights reserved.
//

#import "MMSettingsTableViewController.h"
#import "FXBlurView.h"
#import "UIDevicePlatform.h"
#import <Social/Social.h>

@interface MMSettingsTableViewController ()

@property (strong, nonatomic) IBOutlet UIBarButtonItem *resetFirstOpen;
@property (strong, nonatomic) UIButton *twitterButton;
@property (strong, nonatomic) UIButton *facebookButton;
@property (strong, nonatomic) UIButton *emailButton;
@property (strong, nonatomic) UIButton *doneButton;
@property (strong, nonatomic) FXBlurView *blurView;

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
    
    NSString *versionString = [NSString stringWithFormat:@"Version %@ (%@)", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"], [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
    self.versionLabel.text = versionString;
    
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
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    self.clearsSelectionOnViewWillAppear = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
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
    
    BOOL facebookInstalled = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://"]];
    
    if ([indexPath isEqual:[tableView indexPathForCell:self.moreAppsCell]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.com/apps/kylefrost"]];
    }
    
    if ([indexPath isEqual:[tableView indexPathForCell:self.privacyPolicyCell]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://try.crashlytics.com/terms/privacy-policy.pdf"]];
    }
    
    if ([indexPath isEqual:[tableView indexPathForCell:self.facebookCell]]) {
        if (facebookInstalled) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"fb://profile/141620992629122"]];
        }
        else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.facebook.com/141620992629122"]];
        }
    }
    
    if ([indexPath isEqual:[tableView indexPathForCell:self.emailCell]]) {
        UIDevicePlatform *platform = [[UIDevicePlatform alloc] init];
        NSString *myDevicePlatform = [platform platformString];
        NSString *messageBody = [NSString stringWithFormat:@"\n\nPlease do not delete the following information, it will help us better assess your problem.\n\n%@, %@\nVersion %@ (%@)", myDevicePlatform, [UIDevice currentDevice].systemVersion, [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"], [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
        
        MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        [controller setSubject:@"Movie Memory Feedback"];
        [controller setToRecipients:[NSArray arrayWithObjects:[NSString stringWithFormat:@"support@kylefrostdesign.com"], nil]];
        [controller setMessageBody:messageBody isHTML:NO];
        if (controller) [self presentViewController:controller animated:YES completion:nil];
    }
    
    /***** Decide what URL Scheme to follow when @twitter names are selected in *****/
    
    // Open Tweetbot
    if (tweetbotInstalled) {
        if ([indexPath isEqual:[tableView indexPathForCell:self.twitterCell]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tweetbot:///user_profile/kylefrostdesign"]];
        }
    }
    
    // Open Twitterrific
    else if (twitterrificInstalled) {
        if ([indexPath isEqual:[tableView indexPathForCell:self.twitterCell]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"twitterrific:///profile?screen_name=kylefrostdesign"]];
        }
    }
    
    // Open Twitter app
    else if (twitterInstalled) {
        if ([indexPath isEqual:[tableView indexPathForCell:self.twitterCell]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"twitter:///user?screen_name=kylefrostdesign"]];
        }
    }
    
    // Open in Safari
    else {
        if ([indexPath isEqual:[tableView indexPathForCell:self.twitterCell]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.twitter.com/kylefrostdesign"]];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Share Sheet

-(IBAction)pressShare:(id)sender {
    
    // UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"How are you liking Movie Memory?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"I love it!", @"I like it.", @"It could be better.", @"I hate it.", nil];
    
    // [actionSheet setTag:1];
    // [actionSheet showInView:self.view];
    
    self.blurView = [[FXBlurView alloc] initWithFrame:self.view.frame];
    self.blurView.alpha = 0.0;
    self.blurView.blurRadius = 15.0;
    self.blurView.tintColor = [UIColor clearColor];
    [self.parentViewController.parentViewController.view addSubview:self.blurView];
    
    self.twitterButton = [[UIButton alloc] init];
    self.twitterButton.frame = CGRectMake(self.twitterButton.center.x, self.twitterButton.center.y, 80.0, 80.0);
    //self.twitterButton.center = CGPointMake(self.view.center.x + 90, self.view.center.y + 80);
    self.twitterButton.center = CGPointMake(self.view.center.x + 20, self.view.center.y + 20);
    self.twitterButton.layer.backgroundColor = [UIColor colorWithRed:0.212 green:0.849 blue:1.000 alpha:1.000].CGColor;
    self.twitterButton.layer.cornerRadius = self.twitterButton.bounds.size.width/2;
    self.twitterButton.alpha = 0.0;
    [self.twitterButton setBackgroundImage:[UIImage imageNamed:@"twitter_button_image"] forState:UIControlStateNormal];
    self.twitterButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.twitterButton addTarget:self action:@selector(didPressTwitterButton) forControlEvents:UIControlEventTouchUpInside];
    [self.blurView addSubview:self.twitterButton];
    
    self.facebookButton = [[UIButton alloc] init];
    self.facebookButton.frame = CGRectMake(self.facebookButton.center.x, self.facebookButton.center.y, 80.0, 80.0);
    //self.facebookButton.center = CGPointMake(self.view.center.x - 90, self.view.center.y + 80);
    self.facebookButton.center = CGPointMake(self.view.center.x - 20, self.view.center.y + 20);
    self.facebookButton.layer.backgroundColor = [UIColor colorWithRed:0.001 green:0.336 blue:1.000 alpha:1.000].CGColor;
    self.facebookButton.layer.cornerRadius = self.facebookButton.bounds.size.width/2;
    self.facebookButton.alpha = 0.0;
    [self.facebookButton setBackgroundImage:[UIImage imageNamed:@"facebook_button_image"] forState:UIControlStateNormal];
    self.facebookButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.facebookButton addTarget:self action:@selector(didPressFacebookButton) forControlEvents:UIControlEventTouchUpInside];
    [self.blurView addSubview:self.facebookButton];
    
    self.emailButton = [[UIButton alloc] init];
    self.emailButton.frame = CGRectMake(self.emailButton.center.x, self.emailButton.center.y, 80.0, 80.0);
    //self.emailButton.center = CGPointMake(self.view.center.x, self.view.center.y - 80);
    self.emailButton.center = CGPointMake(self.view.center.x, self.view.center.y + 20);
    self.emailButton.layer.backgroundColor = [UIColor colorWithRed:0.001 green:0.336 blue:1.000 alpha:1.000].CGColor;
    self.emailButton.layer.cornerRadius = self.emailButton.bounds.size.width/2;
    self.emailButton.alpha = 0.0;
    [self.emailButton setBackgroundImage:[UIImage imageNamed:@"email_button_image"] forState:UIControlStateNormal];
    self.emailButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.emailButton addTarget:self action:@selector(didPressEmailButton) forControlEvents:UIControlEventTouchUpInside];
    [self.blurView addSubview:self.emailButton];
    
    self.doneButton = [[UIButton alloc] init];
    self.doneButton.frame = CGRectMake(self.doneButton.center.x, self.doneButton.center.y, 20.0, 20.0);
    //self.doneButton.center = CGPointMake(self.view.center.x, self.view.center.y+25);
    self.doneButton.center = CGPointMake(self.view.center.x, self.view.center.y+25);
    self.doneButton.layer.backgroundColor = [UIColor colorWithRed:0.001 green:0.336 blue:1.000 alpha:1.000].CGColor;
    self.doneButton.layer.cornerRadius = self.doneButton.bounds.size.width/3;
    self.doneButton.alpha = 0.0;
    [self.doneButton setBackgroundImage:[UIImage imageNamed:@"done_button_image"] forState:UIControlStateNormal];
    self.doneButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.doneButton addTarget:self action:@selector(didPressDoneButton) forControlEvents:UIControlEventTouchUpInside];
    [self.blurView addSubview:self.doneButton];
    
    [UIView animateWithDuration:0.3 animations:^{

        self.blurView.alpha = 1.0;
        self.twitterButton.alpha = 1.0;
        self.facebookButton.alpha = 1.0;
        self.emailButton.alpha = 1.0;
        self.doneButton.alpha = 1.0;
        
    }];
    
    [UIView animateWithDuration:1.2 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:1.0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        
        self.twitterButton.center = CGPointMake(self.view.center.x + 90, self.view.center.y + 80);
        //self.twitterButton.layer.cornerRadius = self.twitterButton.bounds.size.width/2;
        
        self.facebookButton.center = CGPointMake(self.view.center.x - 90, self.view.center.y + 80);
        //self.facebookButton.layer.cornerRadius = self.facebookButton.bounds.size.width/2;
        
        self.emailButton.center = CGPointMake(self.view.center.x, self.view.center.y - 80);
        //self.emailButton.layer.cornerRadius = self.emailButton.bounds.size.width/2;
        
        self.doneButton.frame = CGRectMake(self.doneButton.center.x, self.doneButton.center.y, 60.0, 60.0);
        self.doneButton.center = CGPointMake(self.view.center.x, self.view.center.y+25);
        self.doneButton.layer.cornerRadius = self.doneButton.bounds.size.width/2;
    } completion:nil];
}

- (void)didPressTwitterButton {
    SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [tweetSheet setInitialText:@"I'm loving Movie Memory by @KyleFrostDesign! Check it out! #moviememory"];
    
    [self presentViewController:tweetSheet animated:YES completion:^{
        [self didPressDoneButton];
    }];
}

- (void)didPressFacebookButton {
    SLComposeViewController *shareSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    [shareSheet setInitialText:@"I'm loving Movie Memory! Check it out! #moviememory"];
    
    [self presentViewController:shareSheet animated:YES completion:^{
        [self didPressDoneButton];
    }];
}

- (void)didPressEmailButton {
    NSString *messageBody = [NSString stringWithFormat:@"\n\n%@, %@", [UIDevice currentDevice].model, [UIDevice currentDevice].systemVersion];
    
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    [controller setSubject:@"Movie Memory Feedback"];
    [controller setToRecipients:[NSArray arrayWithObjects:[NSString stringWithFormat:@"support@kylefrostdesign.com"], nil]];
    [controller setMessageBody:messageBody isHTML:NO];
    if (controller) [self presentViewController:controller animated:YES completion:^{
        [self didPressDoneButton];
    }];
}

- (void)didPressDoneButton {
    [UIView animateWithDuration:0.3 animations:^{
        
        self.blurView.alpha = 0.0;
        self.twitterButton.alpha = 0.0;
        self.facebookButton.alpha = 0.0;
        self.emailButton.alpha = 0.0;
        self.doneButton.alpha = 1.0;
        
    }];
    
    [UIView animateWithDuration:1.2 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:1.0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
        
        self.twitterButton.center = CGPointMake(self.view.center.x, self.view.center.y);
        //self.twitterButton.layer.cornerRadius = self.twitterButton.bounds.size.width/2;
        
        self.facebookButton.center = CGPointMake(self.view.center.x, self.view.center.y);
        //self.facebookButton.layer.cornerRadius = self.facebookButton.bounds.size.width/2;
        
        self.emailButton.center = CGPointMake(self.view.center.x, self.view.center.y);
        //self.emailButton.layer.cornerRadius = self.emailButton.bounds.size.width/2;
        
        self.doneButton.frame = CGRectMake(self.doneButton.center.x, self.doneButton.center.y, 20.0, 20.0);
        self.doneButton.center = CGPointMake(self.view.center.x, self.view.center.y+25);
    } completion:nil];
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
            [tweetSheet setInitialText:@"I'm loving Movie Memory by @KyleFrostDesign! Check it out! #moviememory"];
            
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
            NSString *messageBody = [NSString stringWithFormat:@"\n\nPlease do not delete the following information, it will help us better assess your problem.\n\n%@, %@\nVersion %@ (%@)", [UIDevice currentDevice].model, [UIDevice currentDevice].systemVersion, [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"], [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
            
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
            NSString *messageBody = [NSString stringWithFormat:@"\n\nPlease do not delete the following information, it will help us better assess your problem.\n\n%@, %@\nVersion %@ (%@)", [UIDevice currentDevice].model, [UIDevice currentDevice].systemVersion, [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"], [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
            
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
        // NSLog(@"It's away!");
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
