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

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
        self.imagePicker.allowsEditing = NO;
        self.imagePicker.navigationController.navigationBar.translucent = NO;
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:self.imagePicker animated:NO completion:nil];
    }
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillAppear:(BOOL)animated{
    
    PFUser *user = [PFUser currentUser];
    
    if (!user) {
        self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
        //***********************
        // Create Account STUB!!!
        //***********************
    }
    else{
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.delegate = self;
        self.imagePicker.allowsEditing = NO;
        self.imagePicker.navigationController.navigationBar.translucent = NO;
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:self.imagePicker animated:NO completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    [mediaType isEqualToString:(NSString *)kUTTypeImage];
    // A photo was taken/selected!
    self.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.postPic.image = self.image;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self uploadMessage];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:NO completion:nil];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
}

- (void)uploadMessage;{
    
    NSData *fileData;
    NSString *fileName;
    NSString *fileType;
    
    UIImage *newImage = self.image;
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
            
            PFObject *image = [PFObject objectWithClassName:@"Posts"];
            [image setObject:[[PFUser currentUser] objectId] forKey:@"Poster"];
            //***********************
            //Append location/contact preferences STUB!!!!
            //***********************
            [image setObject:file forKey:@"file"];
            [image setObject:fileType forKey:@"fileType"];
            [image saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (error) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occurred!"
                                                                        message:@"Please try sending your message again."
                                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alertView show];
                }
                else {
                    // Everything was successful!
                }
            }];
        }
    }];
    
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
