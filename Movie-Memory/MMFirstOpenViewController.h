//
//  MMFirstOpenViewController.h
//  Movie-Memory
//
//  Created by Kyle Frost on 7/19/14.
//  Copyright (c) 2014 Kyle Frost. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMTabController.h"

@interface MMFirstOpenViewController : UIViewController <UIScrollViewDelegate>

@property (strong, nonatomic) MMTabController *tabController;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;

@end
