//
//  BrowserWindowController.m
//  Browser
//
//  Created by Dave Eddy on 8/14/13.
//  Copyright (c) 2013 Dave Eddy. All rights reserved.
//

#import "BrowserWindowController.h"
#import "BrowserTab.h"
#import "TabCellView.h"
#import "NSString+URLEncode.h"

@interface BrowserWindowController ()

@end

@implementation BrowserWindowController {
    BOOL titleSet;
    NSMutableArray *tabs;
    NSInteger selectedIndex;
}

#pragma mark - Initialize
- (id)init
{
    self = [super initWithWindowNibName:@"BrowserWindowController"];
    if (self) {
        tabs = [NSMutableArray new];
        
        BrowserTab *initialTab = [BrowserTab newBrowserTabWithURL:[NSURL URLWithString:@"http://www.daveeddy.com"]];
        initialTab.webView.frameLoadDelegate = self;
        initialTab.webView.resourceLoadDelegate = self;
        [tabs addObject:initialTab];
        
        [self.tableView reloadData];
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    [self.urlBar becomeFirstResponder];
    [self resetBackAndForwardButtonsForWebview:self.webView];
    selectedIndex = -1;
}

#pragma mark - IBAction
- (IBAction)go:(id)sender
{
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

- (IBAction)backOrForwardButtonPressed:(NSSegmentedControl *)sender
{
    switch (sender.selectedSegment) {
        case SEGMENT_BACK_BUTTON:
            [self.webView goBack];
            break;
        case SEGMENT_FORWARD_BUTTON:
            [self.webView goForward];
            break;
    }
}

- (IBAction)refreshButtonPressed:(id)sender
{
    [self.webView reload:nil];
}

#pragma mark - UI
- (void)resetBackAndForwardButtonsForWebview:(WebView *)webView
{
    [self.backOrForwardButtonControl setEnabled:webView.canGoBack forSegment:SEGMENT_BACK_BUTTON];
    [self.backOrForwardButtonControl setEnabled:webView.canGoForward forSegment:SEGMENT_FORWARD_BUTTON];
}

#pragma mark - WebView Delegates
- (void)webView:(WebView *)sender didStartProvisionalLoadForFrame:(WebFrame *)frame
{
    //NSLog(@"didStartProvisionalLoadForFrame");
    if (frame != sender.mainFrame)
        return;
    
    titleSet = NO;
    
    self.urlBar.stringValue = frame.provisionalDataSource.request.URL.absoluteString;
    sender.window.title = @"Loading...";
    //self.faviconImage.image = nil;
}

- (void)webView:(WebView *)sender didReceiveTitle:(NSString *)title forFrame:(WebFrame *)frame
{
    //NSLog(@"didReceiveTitle");
    if (frame != sender.mainFrame)
        return;
    
    sender.window.title = title;
    titleSet = YES;
}

- (void)webView:(WebView *)sender didReceiveIcon:(NSImage *)image forFrame:(WebFrame *)frame
{
    //NSLog(@"didReceiveIcon");
    if (frame != sender.mainFrame)
        return;
    
    //self.faviconImage.image = image;
}

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame
{
    //NSLog(@"didFinishLoadForFrame");
    if (frame != sender.mainFrame)
        return;
    
    if (!titleSet)
        sender.window.title = frame.provisionalDataSource.request.URL.absoluteString;
    
    [self.tableView reloadData];
    [self resetBackAndForwardButtonsForWebview:sender];
}

#pragma mark - Table View Data Source
- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
    NSLog(@"tabs.count = %ld", tabs.count);
    return tabs.count;
}

- (id)tableView:(NSTableView *)aTableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSLog(@"viewForTableColumn");
    static NSString *cellIdentifier = @"MyCell";
    
    TabCellView *result = [aTableView makeViewWithIdentifier:cellIdentifier owner:self];
    
    if (!result) {
        result = [[TabCellView alloc] init];
        result.identifier = cellIdentifier;
    }
    
    result.title.stringValue = [tabs[row] webView].mainFrameTitle;
    result.url.stringValue = [tabs[row] webView].mainFrameURL;
    result.favicon.image = [tabs[row] webView].mainFrameIcon;
    
    return result;
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
{
    // ensure index is set
    NSInteger index = self.tableView.selectedRow;
    NSLog(@"index = %ld", index);
    
    if (index < 0) return;
    
    selectedIndex = index;
    
    WebView *tabWebView = [tabs[index] webView];
    tabWebView.frame = self.webViewContainer.frame;
    
    self.webViewContainer.subviews = @[tabWebView];
}

@end