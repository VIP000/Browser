//
//  BrowserWindowController.m
//  Browser
//
//  Created by Dave Eddy on 8/14/13.
//  Copyright (c) 2013 Dave Eddy. All rights reserved.
//

#import "BrowserWindowController.h"
#import "NSString+URLEncode.h"

@interface BrowserWindowController ()

@end

@implementation BrowserWindowController

#pragma mark -
#pragma mark Initialize
- (id)init
{
    return [super initWithWindowNibName:@"BrowserWindowController"];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    [self.urlBar becomeFirstResponder];
    self.backButton.enabled = NO;
    self.forwardButton.enabled = NO;
}

#pragma mark -
#pragma mark IBAction
- (IBAction)go:(id)sender {
    NSString *urlString = self.urlBar.stringValue;
    if ([urlString isEqualToString:@""]) return;
    
    NSLog(@"go called with %@", urlString);
    
    if ([urlString rangeOfString:@"http"].location == 0 || [urlString rangeOfString:@"."].location != NSNotFound) {
        // period found, is URL
        if ([urlString rangeOfString:@"http"].location != 0)
            urlString = [NSString stringWithFormat:@"http://%@", urlString];
    } else {
        urlString = [NSString stringWithFormat:@"https://duckduckgo.com/?q=%@", [urlString urlEncodedString]];
    }
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView.mainFrame loadRequest:request];
}

#pragma mark -
#pragma mark WebView Delegates
- (void)webView:(WebView *)sender didStartProvisionalLoadForFrame:(WebFrame *)frame
{
    if (frame != sender.mainFrame)
        return;
    
    self.urlBar.stringValue = frame.provisionalDataSource.request.URL.absoluteString;
    sender.window.title = nil;
    self.faviconImage.image = nil;
}

- (void)webView:(WebView *)sender didReceiveTitle:(NSString *)title forFrame:(WebFrame *)frame
{
    if (frame != sender.mainFrame)
        return;
    
    sender.window.title = title;
}

- (void)webView:(WebView *)sender didReceiveIcon:(NSImage *)image forFrame:(WebFrame *)frame
{
    if (frame != sender.mainFrame)
        return;
    
    self.faviconImage.image = image;
}

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame
{
    if (frame != sender.mainFrame)
        return;
    
    if (!sender.window.title)
        sender.window.title = @"(no title)";
    
    self.backButton.enabled = sender.canGoBack;
    self.forwardButton.enabled = sender.canGoForward;
}

@end
