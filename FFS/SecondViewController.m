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
@end
@implementation SecondViewController

@synthesize locationManager = _locationManager;
@synthesize currentLocation = _currentLocation;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    self.postPic.frame = CGRectMake(0, 0, 0, 0); 
    
    PFUser *user = [PFUser currentUser];
    if (!user) {
        [self performSegueWithIdentifier:@"createProfile" sender:self];
        //***********************
        // Create Account STUB!!!
        //***********************
    }
    else{
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.delegate = self;
        self.imagePicker.allowsEditing = YES;
        self.imagePicker.navigationController.navigationBar.translucent = NO;
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:self.imagePicker animated:NO completion:nil];
    }
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    _currentLocation = [PostsViewController location];
    PFUser *user = [PFUser currentUser];
    if (!user) {
        self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
        //***********************
        // Create Account STUB!!!
        //***********************
    }
    else if (!self.postPic){
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.delegate = self;
        self.imagePicker.allowsEditing = YES;
        self.imagePicker.navigationController.navigationBar.translucent = NO;
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:self.imagePicker animated:NO completion:nil];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES]; 
    PFUser *user = [PFUser currentUser];
    if (!user) {
        [self performSegueWithIdentifier:@"createProfile" sender:self];
        //***********************
        // Create Account STUB!!!
        //***********************
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    [mediaType isEqualToString:(NSString *)kUTTypeImage];
    // A photo was taken/selected!
    self.image = [info objectForKey:UIImagePickerControllerEditedImage];
    self.postPic.image = self.image;
    [self dismissViewControllerAnimated:YES completion:nil];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //[self uploadMessage];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:NO completion:nil];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
}

- (void)uploadMessage;{
    
    NSData *fileData;
    NSString *fileName;
    NSString *fileType;
    
    UIImage *newImage = [self resizeImage:self.image toWidth:320.0f andHeight:320.0f];
    fileData = UIImagePNGRepresentation(newImage);
    fileName = @"image.png";
    fileType = @"image";
    
    PFFile *file = [PFFile fileWithName:fileName data:fileData];
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occurred!"
                                                                message:@"Please try sending your message again."
                                                               delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
        else {
            self.myLocation = [PFGeoPoint geoPointWithLocation:_currentLocation];
            PFObject *image = [PFObject objectWithClassName:@"Posts"];
            [image setObject:[[PFUser currentUser] objectId] forKey:@"Poster"];
            //***********************
            //Append location/contact preferences STUB!!!!
            //***********************
            [image setObject:file forKey:@"file"];
            [image setObject:fileType forKey:@"fileType"];
            [image setObject:self.myLocation forKey:@"location"];
            [image setObject:self.titulo.text forKey:@"title"];
            [image setObject:self.price.text forKey:@"price"];
            [image saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
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
    }];
    
}

- (UIImage *)resizeImage:(UIImage *)image toWidth:(float)width andHeight:(float)height;{
    
    CGSize newSize = CGSizeMake(width, height);
    CGRect newRectangle = CGRectMake(0, 0, width, height);
    UIGraphicsBeginImageContext(newSize);
    [self.image drawInRect:newRectangle];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizedImage;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mar - Location Services!!!

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    NSLog(@"%@", [locations lastObject]);
    
    self.currentLocation  = [locations lastObject];
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
    }
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
    
    if ([error code] !=kCLErrorLocationUnknown) {
        [_locationManager stopUpdatingLocation];
    }
    
}

- (IBAction)createPost:(id)sender {
    
    if([self.titulo.text length] != 0 && [self.price.text length] != 0)
        [self uploadMessage];

}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.titulo resignFirstResponder];
    [self.price resignFirstResponder];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

@end
