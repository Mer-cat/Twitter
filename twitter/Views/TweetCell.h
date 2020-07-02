//
//  TweetCell.h
//  twitter
//
//  Created by Mercy Bickell on 6/29/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * The tableview cell which represents a tweet
 */
@interface TweetCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *tweeterNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweeterScreenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetTimeAgoLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;
@property (nonatomic, strong) Tweet *tweet;

- (void)refreshData;

@end

NS_ASSUME_NONNULL_END
