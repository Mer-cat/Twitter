//
//  ComposeViewController.m
//  twitter
//
//  Created by Mercy Bickell on 6/30/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"

/**
 * View controller where users may type out a tweet, either as a reply to another tweet or as a new tweet
 */
@interface ComposeViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *composeTweetTextView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *closeComposeButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *finishTweetButton;
@property (weak, nonatomic) IBOutlet UILabel *charactersRemainingLabel;
@property (nonatomic) NSInteger characterLimit;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.composeTweetTextView.delegate = self;
    
    self.characterLimit = 280;
    //[self setCharactersRemaining];
    self.charactersRemainingLabel.text = [NSString stringWithFormat:@"%ld", self.characterLimit];

}

//- (void)setCharactersRemaining {
//    NSInteger charactersRemaining = self.characterLimit - self.composeTweetTextView.text.length;
//    self.charactersRemainingLabel.text = [NSString stringWithFormat:@"%lu/%ld", charactersRemaining, self.characterLimit];
//}

// Cancel tweet or reply upon close button press
- (IBAction)didTapCloseComposeView:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

// Finish tweet and post it upon tweet button press
- (IBAction)didTapPostTweet:(id)sender {
    NSString *tweetText = self.composeTweetTextView.text;
    
    // If posting new tweet
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
    } else {  // If replying to a tweet
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

/**
 * Prevents users from exceeding the 280 character limit on tweets
 * Method is called every time the user edits the text view
 */
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    // Construct what the new text would be if user's latest edit is allowed
    NSString *newText = [self.composeTweetTextView.text stringByReplacingCharactersInRange:range withString:text];
    
    // Update Character Count Label
    NSUInteger charactersRemaining = self.characterLimit - newText.length;
    
    // Quick fix for overflow issues
    if(charactersRemaining < 0 || charactersRemaining > 280) {
        charactersRemaining = 0;
    }
    
    self.charactersRemainingLabel.text = [NSString stringWithFormat:@"%lu/%ld", charactersRemaining, self.characterLimit];;
    
    // Returns YES as long as user has not exceeded character limit
    return newText.length <= self.characterLimit;
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


