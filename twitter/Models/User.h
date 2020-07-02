//
//  User.h
//  twitter
//
//  Created by Mercy Bickell on 6/29/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * The encapsulation of a Twitter user's basic properties
 */
@interface User : NSObject

// MARK: Properties
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) NSString *profileImageUrl;

// MARK: Methods
- (instancetype)initWithDictionary:(NSDictionary *) dictionary;

@end

NS_ASSUME_NONNULL_END
