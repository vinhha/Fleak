//
//  FeedViewController.h
//  FFS
//
//  Created by vinh ha on 10/17/15.
//  Copyright © 2015 Vinh Ha. All rights reserved.
//

#import <ParseUI/ParseUI.h>
#import <Parse/Parse.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "PostCell.h"

@interface FeedViewController : PFQueryTableViewController <CLLocationManagerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) NSMutableArray *entry;
@property (strong, nonatomic) NSNumber *counter2;
@property (strong, nonatomic) NSNumber *totalHeight;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) PFGeoPoint *myLocation;
+(CLLocation*)location;

@property (strong, nonatomic) PostCell *cell;

@end