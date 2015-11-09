//
//  FeedViewController.m
//  FFS
//
//  Created by vinh ha on 10/17/15.
//  Copyright © 2015 Vinh Ha. All rights reserved.
//

#import "FeedViewController.h"


@interface FeedViewController ()

@end

static CLLocation *location = nil;

@implementation FeedViewController

- (id) initWithCoder:(NSCoder *)aCoder {
    
    self = [super initWithCoder:aCoder];
    if (self) {
        
        self.parseClassName = @"_Posts";
        self.textKey = @"_Description";
        self.pullToRefreshEnabled = YES;
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    UIImageView *navImage = [[UIImageView alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width/2 - 16.5, 25, 33, 35)];
    //navImage.image = [UIImage imageNamed:@"bumblefleak-1"];
    [self.navigationController.view addSubview:navImage];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithRed:74.0/255.0 green:144.0/255.0 blue:226.0/255.0 alpha:1.0], NSFontAttributeName: [UIFont fontWithName:@"Avenir" size:23.0]};
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:74.0/255.0 green:144.0/255.0 blue:226.0/255.0 alpha:1.0];//colorWithRed:248.0/255.0 green: 231.0/255.0 blue:28.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.topItem.title = @"f l e a k";

    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    // Do any additional setup after loading the view.
}


-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [_locationManager startUpdatingLocation];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    // This method is called every time objects are loaded from Parse via the PFQuery
    self.counter2 = [NSNumber numberWithInt:0];
    if (self.entry != nil) {
        [self.entry removeAllObjects];
    }
    if (NSClassFromString(@"UIRefreshControl")) {
        [self.refreshControl endRefreshing];
    }
}

- (void)objectsWillLoad {
    [super objectsWillLoad];
    self.counter2 = [NSNumber numberWithInt:0];
    self.totalHeight = [NSNumber numberWithInt:0];
    
    if (self.entry != nil) {
        [self.entry removeAllObjects];
    }
    
    if (!self.entry) {
        [self refreshControl];
    }
    // This method is called before a PFQuery is fired to get more objects
}


- (PFQuery *) queryForTable {
    
    if (!self.myLocation) {
        return nil;
    }
    
    PFQuery *posts = [PFQuery queryWithClassName:@"Posts"];
    
//    if ([self.objects count] == 0) {
//    }
    
    [posts whereKey:@"Location" nearGeoPoint:self.myLocation withinKilometers:20.0];
    [posts includeKey:@"objectId"];
    [posts includeKey:self.textKey];
    [posts includeKey:@"_Price"];
    
    return posts;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.objects count];
    
}

-(UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object{
    
    static NSString *CellIdentifier = @"Cell";
    self.cell = (PostCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (self.cell == nil) {
        self.cell  = [[PostCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    self.cell.postDescription.text = [object objectForKey:@"Description"];
    self.cell.employer.text = [object objectForKey:@"UserName"];
    self.cell.price.text = [object objectForKey:@"Price"];
    return self.cell;
    
}


- (CGFloat) tableView: (UITableView *) tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath {
    
    CGFloat height = 0.0;
//    if ([self.counter2 intValue] == 0) {
//
//        NSArray *objects = self.objects;
//        NSLog(@"hey");
//        
//        for (PFObject *post in objects) {
//
//            NSString *p = [post objectForKey:@"Description"];
    PFObject *post = [self.objects objectAtIndex:indexPath.row];
    NSString *p = [post objectForKey:@"Description"];
                height = [self getHeightArray:p];
            
//            NSNumber *height1 = [NSNumber numberWithFloat:height];
//            
//            if (self.entry == nil) {
//                self.entry = [NSMutableArray arrayWithObject:height1];
//            }
//            else {
//                [self.entry addObject:height1];
//            }
//            
//        }
//    }
//    
//    if ([self.counter2 intValue] <= self.entry.count - 1) {
//        NSLog(@"hi");
//        height = [[self.entry objectAtIndex:[self.counter2 intValue]] floatValue];
//        int c = [self.counter2 intValue];
//        self.counter2 = [NSNumber numberWithInt:c + 1];
//    }
//    
//    CGFloat i = [self.totalHeight floatValue];
//    
//    self.totalHeight = [NSNumber numberWithFloat:(i + height)];
    return height;
}

#pragma marks - Getting Post Height

- (CGFloat) getHeightArray: (NSString *) post {
    
    CGSize labelSize = CGSizeMake(260.0, 28.0);
    
    UILabel *gettingSizeLabel = [[UILabel alloc] init];
    gettingSizeLabel.font = [UIFont fontWithName:@"Avenir" size:16];
    gettingSizeLabel.text = post;
    gettingSizeLabel.numberOfLines = 0;
    gettingSizeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize maximumLabelSize = CGSizeMake(260, 9999);
    
    labelSize = [gettingSizeLabel sizeThatFits:maximumLabelSize];
    //labelSize = [post sizeWithFont: [UIFont systemFontOfSize: 17.0] constrainedToSize: CGSizeMake(labelSize.width, 1000) lineBreakMode: UILineBreakModeWordWrap];
    
    //    if ([post length] > 250){
    //        CGSize labelSize = CGSizeMake(245.0, 28.0);
    //
    //        labelSize = [post sizeWithFont: [UIFont systemFontOfSize: 17.0] constrainedToSize: CGSizeMake(labelSize.width, 1000) lineBreakMode: UILineBreakModeWordWrap];
    //        
    //        return 60 + labelSize.height;
    //    }
    //
    
    return 60 + labelSize.height;
}


//-------------------------------------Location Manager-------------------------------------------------
- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    

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
    
    if ([error code] !=kCLErrorLocationUnknown) {
        [_locationManager stopUpdatingLocation];
    }
    
}

+(CLLocation*)location {
    return location;
}

@end


