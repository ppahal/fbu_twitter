//
//  User.m
//  twitter
//
//  Created by Priya Pahal on 5/30/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "User.h"

@implementation User

// TODO: Define User Dictionary
// MARK: User Dictionary
- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
        self.screenName = dictionary[@"screen_name"];
        self.profilePicture = dictionary[@"profile_image_url_https"];
      // Initialize any other properties
    }
    return self;
}

@end
