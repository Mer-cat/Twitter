//
//  TweetCell.h
//  twitter
//
//  Created by Mercy Bickell on 6/29/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TweetCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *tweeterName;
@property (weak, nonatomic) IBOutlet UILabel *tweetText;
@property (weak, nonatomic) IBOutlet UILabel *tweeterScreenName;
@property (weak, nonatomic) IBOutlet UILabel *tweetDate;
@property (weak, nonatomic) IBOutlet UILabel *retweetCount;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCount;

@property (nonatomic, strong) NSString *tweet;

@end

NS_ASSUME_NONNULL_END
