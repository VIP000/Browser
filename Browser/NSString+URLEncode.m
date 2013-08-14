//
//  NSString+URLEncode.m
//  Browser
//
//  Created by David Eddy on 8/14/13.
//  Copyright (c) 2013 Dave Eddy. All rights reserved.
//

#import "NSString+URLEncode.h"

@implementation NSString(URLEncode)
- (NSString *)urlEncodedString
{
    CFStringRef urlString = CFURLCreateStringByAddingPercentEscapes(
                                                                    NULL,
                                                                    (CFStringRef)self,
                                                                    NULL,
                                                                    (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                    kCFStringEncodingUTF8 );
    return (NSString *)CFBridgingRelease(urlString);
}
@end
