//
//  Tweet.h
//  twitter
//
//  Created by Mercy Bickell on 6/29/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface Tweet : NSObject

// MARK: Properties
@property (nonatomic, strong) NSString *idStr;
@property (nonatomic, strong) NSString *text;  // Text content of Tweet
@property (nonatomic) int favoriteCount;  // Number of favorites
@property (nonatomic) BOOL favorited;  // Configure favorite button
@property (nonatomic) int retweetCount;  // Number of retweets
@property (nonatomic) BOOL retweeted;  // Configure retweet button
@property (nonatomic, strong) User *user;  // Contains Tweet author's name, screenname, etc.
@property (nonatomic, strong) NSString *createdAtString;  // Display date
@property (nonatomic, strong) User *retweetedByUser; // User who retweeted, if any



@end

NS_ASSUME_NONNULL_END
