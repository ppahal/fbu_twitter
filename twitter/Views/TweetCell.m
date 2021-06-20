//
//  TweetCell.m
//  twitter
//
//  Created by Priya Pahal on 6/2/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "APIManager.h"

@implementation TweetCell
- (IBAction)didTapFavorite:(id)sender {
    if(self.tweet.favorited){
        // TODO: Send a POST request to the POST favorites/create endpoint
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
            }
            else{
                // TODO: Update the local tweet model
                self.tweet.favorited = NO;
                self.tweet.favoriteCount -= 1;
                // TODO: Update cell UI
                [self refreshData];
                NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
            }
        }];
    }else{
        // TODO: Send a POST request to the POST favorites/create endpoint
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                // TODO: Update the local tweet model
                self.tweet.favorited = YES;
                self.tweet.favoriteCount += 1;
                // TODO: Update cell UI
                [self refreshData];
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
            }
        }];
    }
}
- (IBAction)didTapRetweet:(id)sender {
    if(self.tweet.retweeted){
        // TODO: Send a POST request to the POST favorites/create endpoint
        [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error unretweeting tweet: %@", error.localizedDescription);
            }
            else{
                // TODO: Update the local tweet model
                self.tweet.retweeted = NO;
                self.tweet.retweetCount -= 1;
                // TODO: Update cell UI
                [self refreshData];
                NSLog(@"Successfully unretweeted the following Tweet: %@", tweet.text);
            }
        }];
    }else{
        // TODO: Send a POST request to the POST favorites/create endpoint
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
            }
            else{
                // TODO: Update the local tweet model
                self.tweet.retweeted = YES;
                self.tweet.retweetCount += 1;
                // TODO: Update cell UI
                [self refreshData];
                NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
            }
        }];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshData {
    //Favorited Update
    if(self.tweet.favorited){
    [self.favoriteButton setImage:[UIImage imageNamed: @"favor-icon-red"] forState:UIControlStateNormal];
        self.likeLabel.text = [NSString stringWithFormat:@"%i", self.tweet.favoriteCount];
    }else{
        [self.favoriteButton setImage:[UIImage imageNamed: @"favor-icon"] forState:UIControlStateNormal];
        self.likeLabel.text = [NSString stringWithFormat:@"%i", self.tweet.favoriteCount];
    }
    if(self.tweet.favoriteCount > 0){
        self.likeLabel.alpha = 1;
    }else{
        self.likeLabel.alpha = 0;
    }
    //Retweeted Update
    if(self.tweet.retweeted){
        [self.retweetButton setImage:[UIImage imageNamed: @"retweet-icon-green"] forState:UIControlStateNormal];
        self.retweetLabel.text = [NSString stringWithFormat:@"%i", self.tweet.retweetCount];
    }else{
        [self.retweetButton setImage:[UIImage imageNamed: @"retweet-icon"] forState:UIControlStateNormal];
        self.retweetLabel.text = [NSString stringWithFormat:@"%i", self.tweet.retweetCount];
    }
    //Retweets
    if(self.tweet.retweetCount > 0){
        self.retweetLabel.alpha = 1;
    }else{
        self.retweetLabel.alpha = 0;
    }
}

@end
