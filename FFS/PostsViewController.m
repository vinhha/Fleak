//
//  PostsViewController.m
//  FFS
//
//  Created by vinh ha on 5/29/15.
//  Copyright (c) 2015 Vinh Ha. All rights reserved.
//

#import "PostsViewController.h"
#import "ZLSwipeableView.h"
#import "CardView.h"

@interface PostsViewController () <ZLSwipeableViewDataSource,
                                    ZLSwipeableViewDelegate, UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet ZLSwipeableView *swipeableView;
@property (nonatomic, strong) NSArray *colors;
@property (nonatomic) NSUInteger colorIndex;

@property (nonatomic) BOOL loadCardFromXib;

@end

@implementation PostsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    // Do any additional setup after loading the view.
}

- (void)viewDidLayoutSubviews {
    // Required Data Source
    self.swipeableView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex {
    self.loadCardFromXib = buttonIndex == 1;
    
    self.colorIndex = 0;
    
    [self.swipeableView discardAllSwipeableViews];
    [self.swipeableView loadNextSwipeableViewsIfNeeded];
}

#pragma mark - ZLSwipeableViewDelegate

- (void)swipeableView:(ZLSwipeableView *)swipeableView
         didSwipeView:(UIView *)view
          inDirection:(ZLSwipeableViewDirection)direction {
    NSLog(@"did swipe in direction: %zd", direction);
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
       didCancelSwipe:(UIView *)view {
    NSLog(@"did cancel swipe");
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
  didStartSwipingView:(UIView *)view
           atLocation:(CGPoint)location {
    NSLog(@"did start swiping at location: x %f, y %f", location.x, location.y);
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
          swipingView:(UIView *)view
           atLocation:(CGPoint)location
          translation:(CGPoint)translation {
    NSLog(@"swiping at location: x %f, y %f, translation: x %f, y %f",
          location.x, location.y, translation.x, translation.y);
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
    didEndSwipingView:(UIView *)view
           atLocation:(CGPoint)location {
    NSLog(@"did end swiping at location: x %f, y %f", location.x, location.y);
}

#pragma mark - ZLSwipeableViewDataSource

- (UIView *)nextViewForSwipeableView:(ZLSwipeableView *)swipeableView {
    
        CardView *view = [[CardView alloc] initWithFrame:swipeableView.bounds];
        //if (self.loadCardFromXib) {
        UIView *contentView =
        [[[NSBundle mainBundle] loadNibNamed:@"CardContentView"
                                        owner:self
                                        options:nil] objectAtIndex:0];
        contentView.translatesAutoresizingMaskIntoConstraints = NO;
        [view addSubview:contentView];
    
        //**********************
        // ADD UIIMAGEVIEW TO CONTENTVIEW AS SUBVIEW WITH OTHER USER INFORMATION.
        //**********************
    
        // This is important:
        // https://github.com/zhxnlai/ZLSwipeableView/issues/9
        NSDictionary *metrics = @{
                                    @"height" : @(view.bounds.size.height),
                                    @"width" : @(view.bounds.size.width)
                                    };
        NSDictionary *views = NSDictionaryOfVariableBindings(contentView);
        [view addConstraints:
            [NSLayoutConstraint
            constraintsWithVisualFormat:@"H:|[contentView(width)]"
            options:0
            metrics:metrics
            views:views]];
        [view addConstraints:[NSLayoutConstraint
                                constraintsWithVisualFormat:
                                @"V:|[contentView(height)]"
                                options:0
                                metrics:metrics
                            views:views]];
    [view setBackgroundColor:[UIColor whiteColor]];

    return view;
}




@end
