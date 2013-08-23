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
#import "NSSplitView+DMAdditions.h"

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
        selectedIndex = -1;
        
        tabs = [NSMutableArray new];
        
        [self addBrowserTab:@"http://www.daveeddy.com"];
        [self addBrowserTab:@"http://lightsandshapes.com"];
        
        [self.tableView reloadData];
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Colors
    self.tabView.backgroundColor = [NSColor colorWithCalibratedWhite:.2 alpha:1];
    
    // XXX Gross
    [self tableViewSelectionDidChange:nil];
    // END XXX
    
    [self.urlBar becomeFirstResponder];
    
    // Doesn't work!
    [self.splitView setPosition:SPLIT_VIEW_INITIAL_POSITION ofDividerAtIndex:0 animated:YES];
}

#pragma mark - IBAction
- (IBAction)go:(id)sender
{
    NSString *urlString = self.urlBar.stringValue;
    if ([urlString isEqualToString:@""])
        return;
    
    NSLog(@"go called with %@", urlString);
    
    if ([urlString hasPrefix:@"http"] || [urlString rangeOfString:@"."].location != NSNotFound) {
        // period found, is URL
        if (![urlString hasPrefix:@"http"])
            urlString = [NSString stringWithFormat:@"http://%@", urlString];
    } else {
        urlString = [NSString stringWithFormat:@"https://duckduckgo.com/?q=%@", [urlString urlEncodedString]];
    }
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.currentWebView.mainFrame loadRequest:request];
}

- (IBAction)backOrForwardButtonPressed:(NSSegmentedControl *)sender
{
    switch (sender.selectedSegment) {
        case SEGMENT_BACK_BUTTON:
            [self.currentWebView goBack];
            break;
        case SEGMENT_FORWARD_BUTTON:
            [self.currentWebView goForward];
            break;
    }
}

- (IBAction)addTabButtonPressed:(id)sender
{
    [self addBrowserTab:@"http://duckduckgo.com"];
    [self.tableView reloadData];
}

- (IBAction)deleteTabButtonPressed:(id)sender
{
    [tabs removeObjectAtIndex:selectedIndex];
    [self.tableView reloadData];
}

- (IBAction)refreshButtonPressed:(id)sender
{
    [self.currentWebView reload:nil];
}

- (IBAction)menuButtonPressed:(id)sender
{
    CGFloat position = [self.splitView positionOfDividerAtIndex:0];
    NSLog(@"%lf", position);
    if (position > SPLIT_VIEW_INITIAL_POSITION)
        [self.splitView setPosition:SPLIT_VIEW_INITIAL_POSITION ofDividerAtIndex:0 animated:YES];
    else if (position > SPLIT_VIEW_FAVICON_POSITION)
        [self.splitView setPosition:SPLIT_VIEW_FAVICON_POSITION ofDividerAtIndex:0 animated:YES];
    else if (position > 0)
        [self.splitView setPosition:0 ofDividerAtIndex:0 animated:YES];
    else
        [self.splitView setPosition:SPLIT_VIEW_INITIAL_POSITION ofDividerAtIndex:0 animated:YES];
}

#pragma mark - UI
- (void)resetBackAndForwardButtonsForWebview:(WebView *)webView
{
    [self.backOrForwardButtonControl setEnabled:webView.canGoBack forSegment:SEGMENT_BACK_BUTTON];
    [self.backOrForwardButtonControl setEnabled:webView.canGoForward forSegment:SEGMENT_FORWARD_BUTTON];
}

#pragma mark - Tab Helpers
- (WebView *)currentWebView
{
    return selectedIndex < 0 ? nil : [tabs[selectedIndex] webView];
}

- (NSInteger)addBrowserTab:(NSString *)URLString
{
    NSInteger index = tabs.count;
    BrowserTab *tab = [BrowserTab newBrowserTabWithURL:[NSURL URLWithString:URLString]];
    tab.webView.frameLoadDelegate = self;
    tab.webView.resourceLoadDelegate = self;
    tab.webView.identifier = [NSString stringWithFormat:@"%ld", index];
    [tabs addObject:tab];
    return index;
}

#pragma mark - WebView Delegate
- (void)webView:(WebView *)sender didStartProvisionalLoadForFrame:(WebFrame *)frame
{
    if (frame != sender.mainFrame)
        return;
    
    NSInteger index = [sender.identifier integerValue];
    [self.tableView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:index] columnIndexes:[NSIndexSet indexSetWithIndex:0]];
    
    if (index != selectedIndex)
        return;
    
    // NOT SAFE
    titleSet = NO;
    
    self.urlBar.stringValue = frame.provisionalDataSource.request.URL.absoluteString;
    sender.window.title = @"Loading...";
}

- (void)webView:(WebView *)sender didReceiveTitle:(NSString *)title forFrame:(WebFrame *)frame
{
    if (frame != sender.mainFrame)
        return;
    
    NSInteger index = [sender.identifier integerValue];
    [self.tableView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:index] columnIndexes:[NSIndexSet indexSetWithIndex:0]];
    
    if (index != selectedIndex)
        return;
    
    if (title) {
        titleSet = YES;
        sender.window.title = title;
    }
}

- (void)webView:(WebView *)sender didReceiveIcon:(NSImage *)image forFrame:(WebFrame *)frame
{
    if (frame != sender.mainFrame)
        return;
    
    NSInteger index = [sender.identifier integerValue];
    
    [self.tableView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:index] columnIndexes:[NSIndexSet indexSetWithIndex:0]];
}

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame
{
    if (frame != sender.mainFrame)
        return;
    
    // NOT SAFE
    if (!titleSet)
        sender.window.title = frame.provisionalDataSource.request.URL.absoluteString;
    
    NSInteger index = [sender.identifier integerValue];
    [self.tableView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:index] columnIndexes:[NSIndexSet indexSetWithIndex:0]];
    
    if (index != selectedIndex)
        return;
    
    [self resetBackAndForwardButtonsForWebview:sender];
}

#pragma mark - Table View Data Source Delegate
- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
    return tabs.count;
}

- (BOOL)tableView:(NSTableView *)aTableView shouldSelectRow:(NSInteger)rowIndex {
    return YES;
}

- (id)tableView:(NSTableView *)aTableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    static NSString *cellIdentifier = @"MyCell";
    
    TabCellView *result = [aTableView makeViewWithIdentifier:cellIdentifier owner:self];
    
    if (!result) {
        result = [[TabCellView alloc] init];
        result.identifier = cellIdentifier;
        //result.highlightColor = TAB_HIGHLIGHTED_COLOR;
    }
    
    WebView *tabWebView = [tabs[row] webView];
    
    result.title.stringValue = tabWebView.mainFrameTitle;
    result.url.stringValue = tabWebView.mainFrameURL;
    result.favicon.image = tabWebView.mainFrameIcon;
    if (tabWebView.isLoading)
        [result.progressIndicator startAnimation:nil];
    else
        [result.progressIndicator stopAnimation:nil];
    
    if ([result.title.stringValue isEqualToString:@""])
        result.title.stringValue = result.url.stringValue.lastPathComponent;
    
    return result;
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
{
    NSInteger index = self.tableView.selectedRow;
    
    if (index < 0 || selectedIndex == index)
        return;
    
    selectedIndex = index;
    
    WebView *tabWebView = [tabs[index] webView];
    
    // load the webview into view
    tabWebView.frame = self.webViewContainer.bounds;
    self.webViewContainer.subviews = @[tabWebView];
    
    self.window.title = tabWebView.mainFrameTitle;
    self.urlBar.stringValue = tabWebView.mainFrameURL;
    
    [self resetBackAndForwardButtonsForWebview:tabWebView];
}

@end