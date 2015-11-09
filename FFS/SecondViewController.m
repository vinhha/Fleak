//
//  SecondViewController.m
//  FFS
//
//  Created by vinh ha on 5/28/15.
//  Copyright (c) 2015 Vinh Ha. All rights reserved.
//

#import "SecondViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface SecondViewController ()

@property(strong) NSNumber* tag;

@end
@implementation SecondViewController

//@synthesize locationManager = _locationManager;
@synthesize currentLocation = _currentLocation;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.taskDesc becomeFirstResponder];

    _tag = [NSNumber numberWithInt:0];
    PFUser *user = [PFUser currentUser];
    if (!user) {
        [self performSegueWithIdentifier:@"createProfile" sender:self];
        //***********************
        // Create Account STUB!!!
        //***********************
    }
    // Do any additional setup after loading the view, typically from a nib.
    
    self.characterCount = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 154.0f, 21.0f)];
    self.characterCount.backgroundColor = [UIColor clearColor];
    self.characterCount.textColor = [UIColor whiteColor];
    self.characterCount.text = @"0/140";
    
    [self.taskDesc setInputAccessoryView:self.characterCount];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textInputChanged:) name:UITextViewTextDidChangeNotification object:self.taskDesc];
    [self updateCharacterCount:self.taskDesc];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    _currentLocation = [FeedViewController location];
    PFUser *user = [PFUser currentUser];
    if (!user) {
        self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];

    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES]; 
    PFUser *user = [PFUser currentUser];
    if (!user) {
        [self performSegueWithIdentifier:@"createProfile" sender:self];
    }
    _tag = [NSNumber numberWithInt:0];
    [self.taskDesc becomeFirstResponder];

}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.taskDesc.text = nil;
    self.price.text = nil;
    _tag = [NSNumber numberWithInt:0];
}


- (void)uploadMessage;{
    

    NSLog(@"sent the data");
    NSString *timeStampString =[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    self.myLocation = [PFGeoPoint geoPointWithLocation:_currentLocation];
    PFObject *task = [PFObject objectWithClassName:@"Posts"];
    [task setObject:[[PFUser currentUser] objectId] forKey:@"UserId"];
    [task setObject:[[PFUser currentUser] objectForKey:@"Name"] forKey:@"UserName"];
    [task setObject:self.myLocation forKey:@"Location"];
    [task setObject:self.taskDesc.text forKey:@"Description"];
    [task setObject:self.price.text forKey:@"Price"];
    [task setObject:timeStampString forKey:@"Date"];
    [task saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occurred!"
                                                                        message:@"Please try sending your message again."
                                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
        else {
            // Everything was successful!
            self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
        }
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mar - Location Services!!!
//
//- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
//    
//    NSLog(@"%@", [locations lastObject]);
//    
//    self.currentLocation  = [locations lastObject];
//    //
//    //    PFGeoPoint *myLocation =  [PFGeoPoint geoPointWithLocation:self.currentLocation];
//    //    PFUser *currentUser = [PFUser currentUser];
//    //    [currentUser setObject:myLocation forKey:@"location"];
//    //    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//    //        if (!error) {
//    //            NSLog(@"Got Location");
//    //            [self stopLocationManager];
//    //        }
//    //    }];
//    if (self.currentLocation) {
//        [_locationManager stopUpdatingLocation];
//    }
//}
//
//- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
//    NSLog(@"%@", error);
//    
//    if ([error code] !=kCLErrorLocationUnknown) {
//        [_locationManager stopUpdatingLocation];
//    }
//    
//}

- (IBAction)createPost:(id)sender {
    
    if([self.taskDesc.text length] != 0 && [self.price.text length] != 0)
        [self uploadMessage];

}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.taskDesc resignFirstResponder];
    [self.price resignFirstResponder];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

#pragma mark Check character count

- (void)updateCharacterCount:(UITextView *)aTextView {
    NSUInteger count = aTextView.text.length;
    self.characterCount.text = [NSString stringWithFormat:@"%lu/140", (unsigned long)count];
    if (count > 160 || count == 0) {
        self.characterCount.font = [UIFont boldSystemFontOfSize:self.characterCount.font.pointSize];
    } else {
        self.characterCount.font = [UIFont systemFontOfSize:self.characterCount.font.pointSize];
    }
}

- (void)textInputChanged:(NSNotification *)note {
    //Send notification
    UITextView *localTextView = [note object];
    [self updateCharacterCount:localTextView];
}



@end
