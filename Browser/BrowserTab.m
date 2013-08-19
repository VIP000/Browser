//
//  BrowserTab.m
//  Browser
//
//  Created by Dave Eddy on 8/15/13.
//  Copyright (c) 2013 Dave Eddy. All rights reserved.
//

#import "BrowserTab.h"

@implementation BrowserTab

+ (id)newBrowserTabWithURL:(NSURL *)URL
{
    return [[self alloc] initWithURL:URL];
}

- (id)initWithURL:(NSURL *)URL
{
    self = [super init];
    if (self) {
        self.webView = [[WebView alloc] init];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        [self.webView.mainFrame loadRequest:request];
    }
    return self;
}

@end
