//
//  ComposeViewController.h
//  twitter
//
//  Created by Mercy Bickell on 6/30/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN


@protocol ComposeViewControllerDelegate;

@interface ComposeViewController : UIViewController
@property (nonatomic, weak) id<ComposeViewControllerDelegate> delegate;
@property (nonatomic, strong) Tweet *inReplyToTweet;
@property (nonatomic) BOOL replyingTo;
@end

@protocol ComposeViewControllerDelegate
- (void)didTweet:(Tweet *) tweet;

@end

NS_ASSUME_NONNULL_END
