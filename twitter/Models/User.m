//
//  User.m
//  twitter
//
//  Created by Mercy Bickell on 6/29/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "User.h"

@implementation User

// Initializes user properties
- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
        self.screenName = dictionary[@"screen_name"];
        
        NSString *originalProfileImageURL = dictionary[@"profile_image_url_https"];
        
        // Gives images better resolution
        self.profileImageUrl = [originalProfileImageURL stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
    }
    return self;
}

@end
