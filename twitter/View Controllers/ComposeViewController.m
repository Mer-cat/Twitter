//
//  ComposeViewController.m
//  twitter
//
//  Created by Mercy Bickell on 6/30/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"

@interface ComposeViewController ()
@property (weak, nonatomic) IBOutlet UITextView *composeTweetTextView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *closeComposeButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *finishTweetButton;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

// Cancel tweet upon close button press
- (IBAction)didTapCloseComposeView:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

// Finish tweet and post it upon tweet button press
- (IBAction)didTapPostTweet:(id)sender {
    NSString *tweetText = self.composeTweetTextView.text;
    if(!self.replyingTo) {
        [[APIManager shared] postStatusWithText:tweetText completion:^(Tweet *tweet, NSError *error) {
            if(tweet) {
                [self.delegate didTweet:tweet];
                [self dismissViewControllerAnimated:true completion:nil];
                NSLog(@"Successfully tweeted");
            }
            else {
                NSLog(@"Error posting tweet: %@", error.localizedDescription);
            }
        }];
    } else {
        //if replying to a tweet
        [[APIManager shared] reply:tweetText inReplyTo:self.inReplyToTweet completion:^(Tweet *tweet, NSError *error) {
            if(tweet) {
                [self.delegate didTweet:tweet];
                [self dismissViewControllerAnimated:true completion:nil];
                NSLog(@"Successfully replied to tweet");
            }
            else {
                NSLog(@"Error replying to tweet: %@", error.localizedDescription);
            }
        }];
    }
}

@end

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


