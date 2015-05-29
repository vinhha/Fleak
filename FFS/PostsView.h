//
//  PostsView.h
//  FFS
//
//  Created by vinh ha on 5/28/15.
//  Copyright (c) 2015 Vinh Ha. All rights reserved.
//

#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "Post_Cell.h"


@interface PostsView : PFQueryTableViewController <CLLocationManagerDelegate>

@property (strong, nonatomic) Post_Cell *cell;

@end
