//
//  BrowserWindowController.h
//  Browser
//
//  Created by Dave Eddy on 8/14/13.
//  Copyright (c) 2013 Dave Eddy. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

#import "BackgroundView.h"

enum {
    SEGMENT_BACK_BUTTON = 0,
    SEGMENT_FORWARD_BUTTON
};
#define SPLIT_VIEW_INITIAL_POSITION 200
#define SPLIT_VIEW_FAVICON_POSITION 41

// Colors
#define TAB_HIGHLIGHTED_COLOR [NSColor colorWithCalibratedWhite:.2 alpha:1]

@interface BrowserWindowController : NSWindowController

@property (assign) IBOutlet NSSegmentedControl *backOrForwardButtonControl;
@property (assign) IBOutlet NSTextField *urlBar;

@property (assign) IBOutlet NSView *splitViewContainer;
@property (assign) IBOutlet NSSplitView *splitView;
@property (assign) IBOutlet NSView *webViewContainer;
@property (assign) IBOutlet BackgroundView *tabView;
@property (assign) IBOutlet NSTableView *tableView;
@property (assign) IBOutlet NSTableColumn *tableColumn;

- (IBAction)go:(id)sender;
- (IBAction)backOrForwardButtonPressed:(NSSegmentedControl *)sender;
- (IBAction)addTabButtonPressed:(id)sender;
- (IBAction)deleteTabButtonPressed:(id)sender;
- (IBAction)refreshButtonPressed:(id)sender;
- (IBAction)menuButtonPressed:(id)sender;

@end
