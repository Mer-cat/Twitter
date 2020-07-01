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
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
    
    // If trying to favorite
    if(!self.tweet.favorited){
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
        
        // Send a POST request to the POST favorites/create endpoint
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if (error){
                NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            } else {
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
            }
        }];
    } else {  // When trying to unfavorite
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
        
        // Send a POST request to unfavorite
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if (error){
                NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
            } else {
                NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
            }
        }];
    }
    // Update cell UI
    [self refreshData];
}

@end
