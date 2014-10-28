//
//  MMFirstOpenViewController.m
//  Movie-Memory
//
//  Created by Kyle Frost on 7/19/14.
//  Copyright (c) 2014 Kyle Frost. All rights reserved.
//

#import "MMFirstOpenViewController.h"

@interface MMFirstOpenViewController ()

// Views for Array
@property (strong, nonatomic) UIViewController *oneView;
@property (strong, nonatomic) UIViewController *twoView;
@property (strong, nonatomic) UIViewController *threeView;
@property (strong, nonatomic) UIViewController *fourView;

@end

@implementation MMFirstOpenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpViews];
    
    NSArray *viewArray = [NSArray arrayWithObjects:self.oneView, self.twoView, self.threeView, self.fourView, nil];
    
    // self.pageControl.numberOfPages = viewArray.count;
    
    for (int i = 0; i < viewArray.count; i++) {

        CGRect frame;
        frame.origin.x = self.scrollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.scrollView.frame.size;
        
        UIViewController *controller = [viewArray objectAtIndex:i];
        UIView *subview = controller.view;
        
        subview.frame = frame;
        
        [self.scrollView addSubview:subview];
    }
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * viewArray.count, self.scrollView.frame.size.height);
}

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissFirstOpenViewController) name:@"dismissFirstOpenViewController" object:nil];
}

- (void)dismissFirstOpenViewController {
    
    // NSLog(@"Dismiss got called");
    
    [UIView animateWithDuration:0.5 animations:^{
        self.tabController.blurredView.alpha = 0;
        self.view.alpha = 0;
    } completion:^(BOOL finished){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissFirstOpen" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"removeFirstOpenBlur" object:nil];
    }];
}

- (void)setUpViews {
    [self setUpFirstView];
    [self setUpSecondView];
    [self setUpThirdView];
    [self setUpFourthView];
}

- (void)setUpFirstView {
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"MMFirstOpenOneViewController" owner:self options:nil];
    self.oneView = [nibs objectAtIndex:0];
}

- (void)setUpSecondView {
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"MMFirstOpenTwoViewController" owner:self options:nil];
    self.twoView = [nibs objectAtIndex:0];
}

- (void)setUpThirdView {
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"MMFirstOpenThreeViewController" owner:self options:nil];
    self.threeView = [nibs objectAtIndex:0];
}

- (void)setUpFourthView {
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"MMFirstOpenFourViewController" owner:self options:nil];
    self.fourView = [nibs objectAtIndex:0];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}

- (IBAction)changePage {
    // update the scroll view to the appropriate page
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    [self.scrollView scrollRectToVisible:frame animated:YES];
}

@end
