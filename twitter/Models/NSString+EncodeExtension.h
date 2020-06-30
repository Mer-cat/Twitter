//
//  NSString+EncodeExtension.h
//  twitter
//
//  Created by Mercy Bickell on 6/30/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface NSString (URLEncoding)

- (nullable NSString *)stringByAddingPercentEncodingForRFC3986;

@end

NS_ASSUME_NONNULL_END
