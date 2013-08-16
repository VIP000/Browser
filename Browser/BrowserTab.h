//
//  BrowserTab.h
//  Browser
//
//  Created by Dave Eddy on 8/15/13.
//  Copyright (c) 2013 Dave Eddy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@interface BrowserTab : NSObject

@property (strong, nonatomic) WebView *webView;

+ (id)newBrowserTabWithURL:(NSURL *)URL;
- (id)initWithURL:(NSURL *)URL;

@end
