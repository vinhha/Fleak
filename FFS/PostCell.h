//
//  PostCell.h
//  FFS
//
//  Created by vinh ha on 10/18/15.
//  Copyright © 2015 Vinh Ha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *postDescription;
@property (strong, nonatomic) IBOutlet UILabel *employer;
@property (strong, nonatomic) IBOutlet UILabel *price;

@end
