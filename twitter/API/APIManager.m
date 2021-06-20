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
    //Code to get the consumer key and secret from keys.plist
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Keys" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
    NSString *secret = [dict objectForKey: @"consumerSecret"];
    NSString *key= [dict objectForKey: @"consumerKey"];
    
    self = [super initWithBaseURL:baseURL consumerKey:key consumerSecret:secret];
    if (self) {
        
    }
    return self;
}

- (void)getHomeTimelineWithCompletion:(void(^)(NSArray *tweets, NSError *error))completion {
    
    [self GET:@"1.1/statuses/home_timeline.json"
   parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray *  _Nullable tweetDictionaries) {
    
       // Manually cache the tweets. If the request fails, restore from cache if possible.
       //NSData *data = [NSKeyedArchiver archivedDataWithRootObject:tweetDictionaries];
        NSMutableArray *tweets  = [Tweet tweetsWithArray:tweetDictionaries];
        
       // [[NSUserDefaults standardUserDefaults] setValue:data forKey:@"hometimeline_tweets"];
        //[[NSUserDefaults standardUserDefaults] setValue:self.tweets forKey:@"hometimeline_tweets"];
        
       //completion(tweetDictionaries, nil);
        completion(tweets, nil);
    
   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
       NSMutableArray *tweets = nil;
       
       // Fetch tweets from cache if possible
       //NSData *data = [[NSUserDefaults standardUserDefaults] valueForKey:@"hometimeline_tweets"];
      /* self.tweets  = [[NSUserDefaults standardUserDefaults] valueForKey:@"hometimeline_tweets"];
       if (self.tweets != nil) {
           tweetDictionaries = [NSKeyedUnarchiver unarchiveObjectWithData:self.tweets];
       }*/
       
       completion(tweets, error);
   }];
    
}

- (void)postStatusWithText:(NSString *)text completion:(void (^)(Tweet *, NSError *))completion{
    NSString *urlString = @"1.1/statuses/update.json";
    NSDictionary *parameters = @{@"status": text};
    
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

// TODO: Send a POST request to the POST favorites/create endpoint
- (void)favorite:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion{

    NSString *urlString = @"1.1/favorites/create.json";
    NSDictionary *parameters = @{@"id": tweet.idStr};
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

- (void)unfavorite:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion{

    NSString *urlString = @"1.1/favorites/destroy.json";
    NSDictionary *parameters = @{@"id": tweet.idStr};
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

- (void)retweet:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion{

    NSString *baseURL = @"1.1/statuses/retweet/";
    NSString *idURL = [baseURL stringByAppendingString:tweet.idStr];
    NSString *fullURL = [idURL stringByAppendingString:@".json"];
    NSDictionary *parameters = @{@"id": tweet.idStr};
    [self POST:fullURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        NSLog(@"%@",tweet);
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

- (void)unretweet:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion{

    NSString *baseURL = @"1.1/statuses/unretweet/";
    NSString *idURL = [baseURL stringByAppendingString:tweet.idStr];
    NSString *fullURL = [idURL stringByAppendingString:@".json"];
    NSDictionary *parameters = @{@"id": tweet.idStr};
    [self POST:fullURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

@end
