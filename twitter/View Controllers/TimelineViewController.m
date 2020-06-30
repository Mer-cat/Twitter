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

@interface TimelineViewController () <UITableViewDataSource, UITableViewDelegate>

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
    // For changing color of refresh spinner
    //[self.refreshControl setTintColor:[UIColor whiteColor]];
    
    // Refreshes the tweets each time the user pulls down on screen
    [self.refreshControl addTarget:self action:@selector(beginRefresh) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (void)beginRefresh {
    // Get timeline
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            self.tweetArray = (NSMutableArray *) tweets;
//            for (Tweet *tweet in self.tweetArray) {
//                NSString *text = tweet.text;
//                NSLog(@"%@", text);
//            }
            [self.tableView reloadData];
            
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
        
        [self.refreshControl endRefreshing];
    }];
}

// Configures TweetCells
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    // Creates TweetCell and uses cells with identifier MovieCell
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    
    // Associates correct tweet with correct row
    Tweet *tweet = self.tweetArray[indexPath.row];
    
    
    // Set labels
    cell.tweetTextLabel.text = tweet.text;
    cell.tweeterNameLabel.text = tweet.user.name;
    cell.tweeterScreenNameLabel.text = [@"@" stringByAppendingString:tweet.user.screenName];
    cell.tweetDateLabel.text = tweet.createdAtString;
    
    
    cell.favoriteCountLabel.text = [NSString stringWithFormat:@"Favorites: %d", tweet.favoriteCount];
    cell.retweetCountLabel.text =[NSString stringWithFormat:@"Retweets: %d", tweet.retweetCount];
    
    // Set profile picture for user who tweeted

    NSURL *profileImageURL = [NSURL URLWithString:tweet.user.profileImageUrl];
    
    // Prevent any possible flickering effects by clearing out previous image
    cell.profileImage.image = nil;
    
    // Assign the image from the profile picture URL to the profile image for each cell
    [cell.profileImage setImageWithURL:profileImageURL];
    
    return cell;
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweetArray.count;
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


@end
