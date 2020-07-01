//
//  TweetCell.m
//  twitter
//
//  Created by Mercy Bickell on 6/29/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "Tweet.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

/**
 * Sets the labels and image for a tweet cell
 */
- (void)refreshData {
    
    // Set labels
    self.tweetTextLabel.text = self.tweet.text;
    self.tweeterNameLabel.text = self.tweet.user.name;
    self.tweeterScreenNameLabel.text = [@"@" stringByAppendingString:self.tweet.user.screenName];
    self.tweetDateLabel.text = self.tweet.createdAtString;
    self.favoriteCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    self.retweetCountLabel.text =[NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    
    // Set profile picture for user who tweeted
    NSURL *profileImageURL = [NSURL URLWithString:self.tweet.user.profileImageUrl];
    
    // Prevent any possible flickering effects by clearing out previous image
    self.profileImage.image = nil;
    
    // Assign the image from the profile picture URL to the profile image for each cell
    [self.profileImage setImageWithURL: profileImageURL];
}

- (IBAction)didTapFavorite:(id)sender {
    
    // Tweet is not currently favorited by user
    if(!self.tweet.favorited){
        // Send a POST request to the POST favorites/create endpoint
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if (error){
                NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            } else {
                self.tweet.favorited = YES;
                self.tweet.favoriteCount += 1;
                
                //Update cell UI
                [self refreshData];
                
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
            }
        }];
    } else {  // When trying to unfavorite
        // Send a POST request to unfavorite
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if (error){
                NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
            } else {
                self.tweet.favorited = NO;
                self.tweet.favoriteCount -= 1;
                [self refreshData];
                NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
            }
        }];
    }
}

- (IBAction)didTapRetweet:(id)sender {
    // Tweet has not already been retweeted by user
    if(!self.tweet.retweeted) {
        // Send a POST request to the POST retweets endpoint
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if (error){
                NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
            } else {
                self.tweet.retweeted = YES;
                self.tweet.retweetCount += 1;
                [self refreshData];
                NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
            }
        }];
    } else {  // When trying to un-retweet
        //Temporarily disabled until API request is fixed
//        // Send a POST request to un-retweet
//        [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
//            if (error){
//                NSLog(@"Error un-retweeting tweet: %@", error.localizedDescription);
//            } else {
//                self.tweet.retweeted = NO;
//                self.tweet.retweetCount -= 1;
//                [self refreshData];
//                NSLog(@"Successfully un-retweeted the following Tweet: %@", tweet.text);
//            }
//        }];
    }
}

@end
