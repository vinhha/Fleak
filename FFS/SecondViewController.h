//
//  SecondViewController.h
//  FFS
//
//  Created by vinh ha on 5/28/15.
//  Copyright (c) 2015 Vinh Ha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface SecondViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>


@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) IBOutlet UIImageView *postPic;



@end

