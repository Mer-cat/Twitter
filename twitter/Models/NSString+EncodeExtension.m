//
//  EncodeExtension.m
//  twitter
//
//  Created by Mercy Bickell on 6/30/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+EncodeExtension.h"

@implementation NSString (URLEncoding) - (nullable NSString *)stringByAddingPercentEncodingForRFC3986 {   NSString *unreserved = @"-._~/?";   NSMutableCharacterSet *allowed = [NSMutableCharacterSet                                     alphanumericCharacterSet];   [allowed addCharactersInString:unreserved];   return [self           stringByAddingPercentEncodingWithAllowedCharacters:           allowed]; }

@end
