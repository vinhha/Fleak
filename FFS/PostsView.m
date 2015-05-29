//
//  PostsView.m
//  FFS
//
//  Created by vinh ha on 5/28/15.
//  Copyright (c) 2015 Vinh Ha. All rights reserved.
//

#import "PostsView.h"

@implementation PostsView

- (id) initWithCoder:(NSCoder *)aCoder {
    
    self = [super initWithCoder:aCoder];
    if (self) {
        
        self.parseClassName = @"_User";
        self.textKey = @"_post";
        self.pullToRefreshEnabled = YES;
    }
    
    return self;
}


@end
