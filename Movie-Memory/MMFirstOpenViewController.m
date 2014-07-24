//
//  MMFirstOpenViewController.m
//  Movie-Memory
//
//  Created by Kyle Frost on 7/19/14.
//  Copyright (c) 2014 Kyle Frost. All rights reserved.
//

#import "MMFirstOpenViewController.h"

@interface MMFirstOpenViewController ()

@property (strong, nonatomic) UIView *firstView;
@property (strong, nonatomic) UIView *secondView;
@property (strong, nonatomic) UIView *thirdView;
@property (strong, nonatomic) UIView *fourthView;

@end

@implementation MMFirstOpenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpViews];
    
    NSArray *viewArray = [NSArray arrayWithObjects:self.firstView, self.secondView, self.thirdView, self.fourthView, nil];
    
    self.pageControl.numberOfPages = viewArray.count;
    
    for (int i = 0; i < viewArray.count; i++) {

        CGRect frame;
        frame.origin.x = self.scrollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.scrollView.frame.size;
        
        UIView *subview = [viewArray objectAtIndex:i];
        
        subview.frame = frame;
        
        [self.scrollView addSubview:subview];
    }
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * viewArray.count, self.scrollView.frame.size.height);
}

- (void)dismissFirstOpenViewController {
    
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
    self.firstView = [[UIView alloc] initWithFrame:self.view.frame];
    self.firstView.backgroundColor = [UIColor clearColor];
}

- (void)setUpSecondView {
    self.secondView = [[UIView alloc] initWithFrame:self.view.frame];
    self.secondView.backgroundColor = [UIColor clearColor];
}

- (void)setUpThirdView {
    self.thirdView = [[UIView alloc] initWithFrame:self.view.frame];
    self.thirdView.backgroundColor = [UIColor clearColor];
}

- (void)setUpFourthView {
    self.fourthView = [[UIView alloc] initWithFrame:self.view.frame];
    self.fourthView.backgroundColor = [UIColor clearColor];
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
    doneButton.frame = CGRectMake(self.view.bounds.size.width-55, 30, 45, 20);
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(dismissFirstOpenViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.fourthView addSubview:doneButton];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
