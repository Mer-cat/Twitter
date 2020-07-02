//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "TweetCell.h"
#import "Tweet.h"
#import "UIImageView+AFNetworking.h"
#import "ComposeViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "TweetDetailsViewController.h"

/**
 * View controller for the user's main timeline, where they can see 20 tweets and navigate to other views
 */
@interface TimelineViewController () <ComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *tweetArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // Make initial network call to load timeline
    [self beginRefresh];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl setTintColor:[UIColor blueColor]];
    
    // Refreshes the tweets each time the user pulls down on screen
    [self.refreshControl addTarget:self action:@selector(beginRefresh) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

/**
 * Re-load the user's timeline
 */
- (void)beginRefresh {
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"Successfully loaded home timeline");
            self.tweetArray = (NSMutableArray *) tweets;
            [self.tableView reloadData];
            
        } else {
            NSLog(@"Error getting home timeline: %@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
    }];
}

/**
 * Configures TweetCells
 */
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    // Creates TweetCell and uses cells with identifier MovieCell
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    
    // Associates correct tweet with correct row and cell
    Tweet *tweet = self.tweetArray[indexPath.row];
    cell.tweet = tweet;
    
    [cell refreshData];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweetArray.count;
}

/**
 * Adds newly composed tweet to timeline tweets
 */
- (void)didTweet:(nonnull Tweet *)tweet {
    [self.tweetArray insertObject:tweet atIndex:0];
    [self.tableView reloadData];
}

- (IBAction)didTapLogout:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    
    // Clear out the access tokens
    [[APIManager shared] logout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // Uses segue indentifiers to decide what information to pass
    if([segue.identifier isEqualToString:@"ComposeViewSegue"]){
        
        // Designates this view controller as composeViewController's delegate such that
        // we may call methods from this view controller
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController *)navigationController.topViewController;
        composeController.delegate = self;
    } else if([segue.identifier isEqualToString:@"TweetDetailsViewSegue"]){
        
        // For Tweet Details View Controller
        TweetCell *tappedCell = sender;
        Tweet *tweet = tappedCell.tweet;
        TweetDetailsViewController *tweetDetailsViewController = [segue destinationViewController];
        tweetDetailsViewController.tweet = tweet;
    }
}

@end
