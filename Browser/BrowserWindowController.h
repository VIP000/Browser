//
//  BrowserWindowController.h
//  Browser
//
//  Created by Dave Eddy on 8/14/13.
//  Copyright (c) 2013 Dave Eddy. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

enum {
    SEGMENT_BACK_BUTTON = 0,
    SEGMENT_FORWARD_BUTTON
};

@interface BrowserWindowController : NSWindowController

@property (assign) IBOutlet NSView *webViewContainer;
@property (assign) IBOutlet WebView *webView;
@property (assign) IBOutlet NSTextField *urlBar;
@property (assign) IBOutlet NSSegmentedControl *backOrForwardButtonControl;
@property (assign) IBOutlet NSTableView *tableView;
@property (assign) IBOutlet NSTableColumn *tableColumn;

- (IBAction)go:(id)sender;
- (IBAction)backOrForwardButtonPressed:(NSSegmentedControl *)sender;
- (IBAction)refreshButtonPressed:(id)sender;

@end
