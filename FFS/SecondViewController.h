//
//  SecondViewController.h
//  FFS
//
//  Created by vinh ha on 5/28/15.
//  Copyright (c) 2015 Vinh Ha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "FeedViewController.h"


@interface SecondViewController : UIViewController <UINavigationControllerDelegate>

//@property (strong, nonatomic) PostsViewController *posts;
@property (strong, nonatomic) IBOutlet UILabel *characterCount;
@property (strong, nonatomic) IBOutlet UITextView *taskDesc;
@property (strong, nonatomic) IBOutlet UITextField *price;
- (IBAction)createPost:(id)sender;

//@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) PFGeoPoint *myLocation;

- (void)updateCharacterCount:(UITextView *)aTextView;
- (void)textInputChanged:(NSNotification *)note;

@end

