//
//  PostCell.m
//  FFS
//
//  Created by vinh ha on 10/18/15.
//  Copyright © 2015 Vinh Ha. All rights reserved.
//

#import "PostCell.h"

@implementation PostCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.employer];
        [self addSubview:self.postDescription];
        // Initialization code
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void) prepareForReuse {
    //[self.complimentButton setEnabled:YES];
}


@end
