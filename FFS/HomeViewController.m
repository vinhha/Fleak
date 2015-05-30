//
//  HomeViewController.m
//  FFS
//
//  Created by vinh ha on 5/28/15.
//  Copyright (c) 2015 Vinh Ha. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (id) initWithCoder:(NSCoder *)aCoder {
    
    self = [super initWithCoder:aCoder];
    if (self) {
        
        self.parseClassName = @"_User";
        self.textKey = @"_post";
        self.pullToRefreshEnabled = YES;
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.0/255.0 green: 191.0/255.0 blue:143.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.topItem.title = @"m y   p o s t s";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont fontWithName:@"Avenir" size:23.0]};
    // Do any additional setup after loading the view.
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    if (NSClassFromString(@"UIRefreshControl")) {
        [self.refreshControl endRefreshing];
    }
}

- (void)objectsWillLoad {
    [super objectsWillLoad];
}

- (PFQuery *) queryForTable {
    if([PFUser currentUser]){
    PFQuery *posts = [PFQuery queryWithClassName:@"Posts"];
    [posts whereKey:@"Poster" equalTo:[[PFUser currentUser] objectId]];

    return posts;
    }
    else
        return nil; 
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.objects count];
}

-(UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [object objectForKey:@"title"];
    cell.detailTextLabel.text = [object objectForKey:@"price"];
    if([cell.detailTextLabel.text isEqualToString:@"sold"])
        cell.detailTextLabel.textColor = [UIColor redColor];
    PFFile *imageFile = [object objectForKey:@"file"];
    if (imageFile == nil) {
        cell.imageView.image = nil; 
    }
    [imageFile getDataInBackgroundWithBlock:^(NSData *result, NSError *error) {
        if (!error) {
            cell.imageView.image = [UIImage imageWithData:result];
        }
    }];

    
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Mark as sold?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:nil];
    [alertView addButtonWithTitle:@"Yes"];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"Button Index =%ld",(long)buttonIndex);
    if (buttonIndex == 0)
    {
        NSLog(@"You have clicked Cancel");
    }
    else if(buttonIndex == 1)
    {
        NSLog(@"You have clicked GOO");
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PFObject *soldObject = [self.objects objectAtIndex:indexPath.row];
        NSString *sold = @"sold";
        soldObject[@"price"] = sold;
        [soldObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }
            else {
                [self objectsWillLoad]; 
                //Sign up the user.
                }
            
        }];

    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
