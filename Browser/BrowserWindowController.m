//
//  BrowserWindowController.m
//  Browser
//
//  Created by Dave Eddy on 8/14/13.
//  Copyright (c) 2013 Dave Eddy. All rights reserved.
//

#import "BrowserWindowController.h"

@interface BrowserWindowController ()

@end

@implementation BrowserWindowController

#pragma mark -
#pragma mark Initialize
- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
}

#pragma mark -
#pragma mark IBAction
- (IBAction)go:(id)sender {
    NSURL *url = [NSURL URLWithString:self.urlBar.stringValue];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSLog(@"%@", url);
    [self.webView.mainFrame loadRequest:request];
}

@end
