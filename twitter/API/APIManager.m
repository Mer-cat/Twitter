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

- (void)getHomeTimelineWithCompletion:(void(^)(NSArray *tweets, NSError *error))completion {
    
    [self GET:@"1.1/statuses/home_timeline.json"
   parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray *  _Nullable tweetDictionaries) {
        
        // Success, returns array of Tweet objects
        NSMutableArray *tweets = [Tweet tweetsWithArray:tweetDictionaries];
        
        /* this code was causing errors
        // Manually cache the tweets. If the request fails, restore from cache if possible.
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:tweets];
        [[NSUserDefaults standardUserDefaults] setValue:data forKey:@"hometimeline_tweets"];
         */
        
        completion(tweets, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSMutableArray *tweets = nil;
        
        /* this code was causing errors
        // Fetch tweets from cache if possible
        NSData *data = [[NSUserDefaults standardUserDefaults] valueForKey:@"hometimeline_tweets"];
        if (data != nil) {
            tweets = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
         */
        
        completion(tweets, error);
    }];
}

@end
