//
//  InboxViewController.m
//  TaleRecursion
//
//  Created by Hing Huynh on 7/27/14.
//  Copyright (c) 2014 Appcoders. All rights reserved.
//

#import "InboxViewController.h"
#import "ContinueViewController.h"

@interface InboxViewController ()

@end

@implementation InboxViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        self.array = [[NSMutableArray alloc] init];
        NSLog(@"Current user: %@", currentUser.username);
    }
    else {
        [self performSegueWithIdentifier:@"showLogin" sender:self];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    PFUser *currentUser = [PFUser currentUser];
    NSString *userChannel = (@"%@", currentUser.username);
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation addUniqueObject:userChannel forKey:@"channels"];
    [currentInstallation saveInBackground];

    PFQuery *query = [PFQuery queryWithClassName:@"Story"];
    
    [query orderByAscending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        else {
            ;
            
            [self.array removeAllObjects];
            for(PFObject *story in objects){
                PFQuery *postQuery = [PFQuery queryWithClassName:@"Sentence"];
                [postQuery whereKey:@"story" equalTo:story];
                [postQuery findObjectsInBackgroundWithBlock:^(NSArray *sentences, NSError *error) {

                    if ([sentences count] < 12){
                        [self.array insertObject:story atIndex:[self.array count]];
                        NSLog(@"test %d", [self.array count]);
                    }
        
                }];
             
            }
        }
    }];
    
        self.messages = self.array;
        NSLog(@"%d", [self.array count]);
        [self.tableView reloadData];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    PFObject *message = [self.messages objectAtIndex:indexPath.row];

    PFQuery *query = [PFQuery queryWithClassName:@"Sentence"];
    [query whereKey:@"story" equalTo:message];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSUInteger count = 12 - [objects count];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%d remaining", count];
        }
    }];
    cell.textLabel.text = [message objectForKey:@"title"];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedMessage = [self.messages objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:@"showContinue" sender:self];
}

- (IBAction)logout:(id)sender {
    [PFUser logOut];
    [self performSegueWithIdentifier:@"showLogin" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showLogin"]) {
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
    }
    else if ([segue.identifier isEqualToString:@"showContinue"]) {
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
        ContinueViewController *continueViewController = (ContinueViewController *)segue.destinationViewController;
        continueViewController.message = self.selectedMessage;
    }
}

@end
