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
//@property (nonatomic, strong) NSArray *colors;
//@property (nonatomic) NSUInteger colorIndex;

@property (nonatomic) BOOL loadCardFromXib;



@end

static CLLocation *location = nil;

@implementation PostsViewController

@synthesize locationManager = _locationManager;
@synthesize currentLocation = _currentLocation;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.swipeableView.delegate = self;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    
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
    
    self.objectIndex = 0;
    
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
    if (self.objectIndex < self.objects.count) {
        
        CardView *view = [[CardView alloc] initWithFrame:swipeableView.bounds];
        //if (self.loadCardFromXib) {
        self.objectIndex++;
        UIView *contentView =
        [[[NSBundle mainBundle] loadNibNamed:@"CardContentView"
                                        owner:self
                                        options:nil] objectAtIndex:0];
        contentView.translatesAutoresizingMaskIntoConstraints = NO;
        PFFile *imageFile = [[self.objects objectAtIndex:self.objectIndex] objectForKey:@"file"];
        if (imageFile == nil) {
        }
        [imageFile getDataInBackgroundWithBlock:^(NSData *result, NSError *error) {
            if (!error) {
                UIImage *img = [UIImage imageWithData:result];
                UIImageView *postImage = [[UIImageView alloc] initWithImage:img];
                postImage.frame = CGRectMake(14,14, 372, 372);
                [contentView addSubview:postImage];
            }
        }];

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
    return nil;
}

+(CLLocation*)location {
    return location;
}


#pragma mark - Location Services!!!

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    NSLog(@"%@", [locations lastObject]);
    
    self.currentLocation  = [locations lastObject];
    location = self.currentLocation;
    self.myLocation = [PFGeoPoint geoPointWithLocation:self.currentLocation];
//    
//    PFGeoPoint *myLocation =  [PFGeoPoint geoPointWithLocation:self.currentLocation];
//    PFUser *currentUser = [PFUser currentUser];
//    [currentUser setObject:myLocation forKey:@"location"];
//    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (!error) {
//            NSLog(@"Got Location");
//            [self stopLocationManager];
//        }
//    }];
    if (self.currentLocation) {
        [_locationManager stopUpdatingLocation];
        [self loadObjects];
    }
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
    
    if ([error code] !=kCLErrorLocationUnknown) {
        [_locationManager stopUpdatingLocation];
    }
    
}

#pragma mark - Load objects

-(void)loadObjects{
    self.objectIndex = 0;
    PFQuery *query = [PFQuery queryWithClassName:@"Posts"];
    // Interested in locations near user.
    [query whereKey:@"location" nearGeoPoint:self.myLocation];
    // Limit what could be a lot of points.
    query.limit = 250;
    // Final list of objects
    self.objects = [query findObjects];
    [self.swipeableView discardAllSwipeableViews];
    [self.swipeableView loadNextSwipeableViewsIfNeeded];

}
@end
