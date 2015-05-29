//
//  CreateProfileViewController.m
//  FFS
//
//  Created by vinh ha on 5/28/15.
//  Copyright (c) 2015 Vinh Ha. All rights reserved.
//

#import "CreateProfileViewController.h"
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>


@interface CreateProfileViewController ()

@end

@implementation CreateProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES  completion:nil];
}

- (IBAction)FBSignUp:(id)sender {
    
    NSArray *permissions = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location"]; //Arbitrary Permissions
    [PFFacebookUtils logInInBackgroundWithReadPermissions:permissions block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in through Facebook!");
        } else {
            NSLog(@"User logged in through Facebook!");
        }
    }];
    
}



@end
