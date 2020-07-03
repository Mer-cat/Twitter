//
//  APIManager.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "APIManager.h"
#import "Tweet.h"

static NSString * const baseURLString = @"https://api.twitter.com";
static NSString * const consumerKey = @"rPoBdMQFDrvs8LSvMvS0UfvDb";
static NSString * const consumerSecret = @"5WVncDw3puJcJrcNVy337udVYT9KvQ00cWyGjtSOEkElISR1r2";

/**
 * This class handles network calls to the Twitter API
 */
@interface APIManager()

@end

@implementation APIManager

+ (instancetype)shared {
    static APIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    
    NSURL *baseURL = [NSURL URLWithString:baseURLString];
    NSString *key = consumerKey;
    NSString *secret = consumerSecret;
    
    // Check for launch arguments override
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-key"]) {
        key = [[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-key"];
    }
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-secret"]) {
        secret = [[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-secret"];
    }
    
    self = [super initWithBaseURL:baseURL consumerKey:key consumerSecret:secret];
    if (self) {
        
    }
    return self;
}

/**
 * Acquires data (i.e. tweets) for home timeline
 */
- (void)getHomeTimelineWithCompletion:(void(^)(NSArray *tweets, NSError *error))completion {
    [self GET:@"1.1/statuses/home_timeline.json?tweet_mode=extended"
   parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray *  _Nullable tweetDictionaries) {
        
        // Success, returns array of Tweet objects
        NSMutableArray *tweets = [Tweet tweetsWithArray:tweetDictionaries];
        completion(tweets, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSMutableArray *tweets = nil;
        completion(tweets, error);
    }];
}

/**
 * Allows user to compose and post tweet to Twitter
 */
- (void)postStatusWithText:(NSString *)text completion:(void (^)(Tweet *, NSError *))completion {
    NSString *urlString = @"1.1/statuses/update.json?tweet_mode=extended";
    NSDictionary *parameters = @{@"status": text};
    
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

/**
 * Allows user to favorite a tweet
 */
- (void)favorite:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion {
    NSString *urlString = @"1.1/favorites/create.json";
    NSDictionary *parameters = @{@"id": tweet.idStr};
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

/**
 * Allows user to un-favorite a tweet
 */
- (void)unfavorite:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion {
    NSString *urlString = @"1.1/favorites/destroy.json";
    NSDictionary *parameters = @{@"id": tweet.idStr};
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

/**
 * Allows user to retweet a tweet
 */
- (void)retweet:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion {
    NSString *urlString = [NSString stringWithFormat: @"1.1/statuses/retweet/%@.json", tweet.idStr];
    [self POST:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

/**
 * Allows user to un-retweet a tweet
 */
- (void)unretweet:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion {
    NSString *urlString = [NSString stringWithFormat: @"1.1/statuses/unretweet/%@.json", tweet.idStr];
    [self POST:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

/**
 * Allows user to reply to a certain tweet
 */
- (void)reply:(NSString *)text inReplyTo:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion {
    NSString *urlString = @"1.1/statuses/update.json?tweet_mode=extended";
    
    // Tweet must begin with @username of person replied to for Twitter API to recognize it as reply
    NSString *userReplyingTo = [@"@" stringByAppendingString:tweet.user.screenName];
    NSString *textWithWhitespace = [@" " stringByAppendingString:text];
    NSString *textWithUsername = [userReplyingTo stringByAppendingString:textWithWhitespace];
    
    NSDictionary *parameters = @{@"status": textWithUsername, @"in_reply_to_status_id": tweet.idStr};
    
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

@end
