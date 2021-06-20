//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "UIImageView+AFNetworking.h"
#import <UIKit/UIKit.h>
#import "APIManager.h"
#import "TweetCell.h"
#import "Tweet.h"
#import "ComposeViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"

@interface TimelineViewController () <UITableViewDataSource, UITableViewDelegate, ComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *homeTableView;
@property (nonatomic, strong) NSMutableArray *tweets;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end
@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.homeTableView.delegate = self;
    self.homeTableView.dataSource = self;
    [self fetchTweets];
    //Initialize Refresh
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchTweets) forControlEvents:UIControlEventValueChanged];
    [self.homeTableView insertSubview:self.refreshControl atIndex:0];
}

- (void)fetchTweets{
    // Get timeline
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            self.tweets = tweets;
            [self.homeTableView reloadData];
            [self.refreshControl endRefreshing];
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapLogout:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    
    [[APIManager shared] logout];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UINavigationController *navigationController = [segue destinationViewController];
    ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
    composeController.delegate = self;
    
}



- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    Tweet *tweet = self.tweets[indexPath.row];
    cell.tweet = tweet;
    //Label Stuff
    cell.nameLabel.text = tweet.user.name;
    cell.usernameLabel.text = tweet.user.screenName;
    cell.captionLabel.text = tweet.text;
    cell.dateLabel.text = tweet.createdAtString;
    //Favorites
    if(tweet.favoriteCount > 0){
        cell.likeLabel.text = [@(tweet.favoriteCount) stringValue];
        cell.likeLabel.alpha = 1;
    }else{
        cell.likeLabel.alpha = 0;
    }
    //Replies
    cell.commentLabel.alpha=0;
/*    if(tweet.commentCount > 0){
        cell.commentLabel.text = [@(tweet.commentCount) stringValue];
        cell.commentLabel.alpha = 1;
    }else{
        cell.commentLabel.alpha = 0;
    }*/
    //Retweets
    if(tweet.retweetCount > 0){
        cell.retweetLabel.text = [@(tweet.retweetCount) stringValue];
        cell.retweetLabel.alpha = 1;
    }else{
        cell.retweetLabel.alpha = 0;
    }
    //Profile Image stuff
    NSString *URLString = tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    cell.profileImage.layer.cornerRadius = cell.profileImage.frame.size.width/2;
    cell.profileImage.clipsToBounds = YES;
    cell.profileImage.image = [UIImage imageWithData:urlData];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 15;
}

- (void)didTweet:(Tweet *)tweet{
    //[self.tweets addObject:tweet];
    [self.tweets insertObject:tweet atIndex:0];
    [self.homeTableView reloadData];
}

@end
