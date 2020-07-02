//
//  Tweet.m
//  twitter
//
//  Created by Mercy Bickell on 6/29/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "Tweet.h"
#import "User.h"
#import "DateTools.h"

@implementation Tweet

- (instancetype)initWithDictionary:(NSDictionary *) dictionary {
    self = [super init];
    if(self) {
        
        // Checks for retweeted
        NSDictionary *originalTweet = dictionary[@"retweeted_status"];
        if(originalTweet != nil) {
            NSDictionary *userDictionary = dictionary[@"user"];
            self.retweetedByUser = [[User alloc] initWithDictionary:userDictionary];
            
            // Change tweet to original tweet
            // This simplifies unretweeting functionality
            dictionary = originalTweet;
        }
        self.idStr = dictionary[@"id_str"];
        self.text = dictionary[@"full_text"];
        self.favoriteCount = [dictionary[@"favorite_count"] intValue];
        self.favorited = [dictionary[@"favorited"] boolValue];
        self.retweetCount = [dictionary[@"retweet_count"] intValue];
        self.retweeted = [dictionary[@"retweeted"] boolValue];
        
        
        // Initialize user
        NSDictionary *user = dictionary[@"user"];
        self.user = [[User alloc] initWithDictionary:user];
        
        // Format createdAt date string
        NSString *createdAtOriginalString = dictionary[@"created_at"];
        self.createdAtString = [self formatCreatedAtDate:createdAtOriginalString];
        self.timeSinceString = [self formatTimeSinceDate:createdAtOriginalString];
        
    }
    return self;
}

/**
 * Given an array of Tweet dictionaries, return the tweets in them
 */
+ (NSMutableArray *)tweetsWithArray:(NSArray *)dictionaries{
    NSMutableArray *tweets = [NSMutableArray array];
    for (NSDictionary *dictionary in dictionaries){
        Tweet *tweet = [[Tweet alloc] initWithDictionary:dictionary];
        [tweets addObject:tweet];
    }
    return tweets;
}

/**
 * Returns a formatted version of the date the tweet was created
 */
- (NSString *)formatCreatedAtDate:(NSString *) createdAtOriginalString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // Configure the input format to parse the date string
    formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
    
    // Convert String to Date
    NSDate *date = [formatter dateFromString:createdAtOriginalString];
    
    // Configure output format
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterNoStyle;
    
    // Convert date to String and return
    return [formatter stringFromDate:date];
}

/**
 * Returns the time since the tweet was created as a string
 */
- (NSString *)formatTimeSinceDate:(NSString *) createdAtOriginalString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // Configure the input format to parse the date string
    formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
    
    // Convert String to Date and format as time since date
    NSDate *date = [formatter dateFromString:createdAtOriginalString];
    NSString *timeSinceDate = [date shortTimeAgoSinceNow];
    
    return timeSinceDate;
}

@end
