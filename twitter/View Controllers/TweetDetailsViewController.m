//
//  TweetDetailsViewController.m
//  twitter
//
//  Created by Mercy Bickell on 7/2/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "TweetDetailsViewController.h"
#import "Tweet.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"
#import "ComposeViewController.h"

/**
 * Users may tap on a tweet cell in the timeline to get to this view controller, which shows the tweet details
 */
@interface TweetDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *tweeterNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweeterScreenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;

@end

@implementation TweetDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadTweet];
}

- (void)loadTweet {
    
    // Set labels
    self.tweetTextLabel.text = self.tweet.text;
    self.tweeterNameLabel.text = self.tweet.user.name;
    self.tweeterScreenNameLabel.text = [@"@" stringByAppendingString:self.tweet.user.screenName];
    self.tweetDateLabel.text = self.tweet.createdAtString;
    self.favoriteCountLabel.text = [NSString stringWithFormat:@"%d Likes", self.tweet.favoriteCount];
    self.retweetCountLabel.text =[NSString stringWithFormat:@"%d Retweets", self.tweet.retweetCount];
    
    // Set profile picture for user who tweeted
    NSURL *profileImageURL = [NSURL URLWithString:self.tweet.user.profileImageUrl];
    
    // Prevent any possible flickering effects by clearing out previous image
    self.profileImage.image = nil;
    
    // Assign the image from the profile picture URL to the profile image for this tweet
    [self.profileImage setImageWithURL: profileImageURL];
    
}

/**
 *  Allows user to favorite or un-favorite a tweet by tapping the favorite symbol
 */
- (IBAction)didTapFavorite:(id)sender {
    
    // Tweet is not currently favorited by user
    if(!self.tweet.favorited){
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if (error){
                NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            } else {
                self.tweet.favorited = YES;
                self.tweet.favoriteCount += 1;
                
                // Update tweet labels
                [self loadTweet];
                
                NSLog(@"Successfully favorited the following Tweet: %@", self.tweet.text);
            }
        }];
    } else {  // When trying to unfavorite
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if (error){
                NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
            } else {
                self.tweet.favorited = NO;
                self.tweet.favoriteCount -= 1;
                [self loadTweet];
                NSLog(@"Successfully unfavorited the following Tweet: %@", self.tweet.text);
            }
        }];
    }
}

/**
 * Allows user to retweet or un-retweet a tweet by tapping the retweet symbol
 */
- (IBAction)didTapRetweet:(id)sender {
    
    // Tweet has not already been retweeted by user
    if(!self.tweet.retweeted) {
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if (error){
                NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
            } else {
                self.tweet.retweeted = YES;
                self.tweet.retweetCount += 1;
                [self loadTweet];
                NSLog(@"Successfully retweeted the following Tweet: %@", self.tweet.text);
            }
        }];
    } else {  // When trying to un-retweet
        [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if (error){
                NSLog(@"Error un-retweeting tweet: %@", error.localizedDescription);
            } else {
                self.tweet.retweeted = NO;
                self.tweet.retweetCount -= 1;
                [self loadTweet];
                NSLog(@"Successfully un-retweeted the following Tweet: %@", self.tweet.text);
            }
        }];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // Pass in the tweet being looked at so we know who to reply to
    UINavigationController *navigationController = [segue destinationViewController];
    ComposeViewController *composeController = (ComposeViewController *)navigationController.topViewController;
    composeController.inReplyToTweet = self.tweet;
    composeController.replyingTo = YES;
}

@end
