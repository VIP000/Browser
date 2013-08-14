//
//  BrowserWindowController.h
//  Browser
//
//  Created by Dave Eddy on 8/14/13.
//  Copyright (c) 2013 Dave Eddy. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface BrowserWindowController : NSWindowController

@property (assign) IBOutlet WebView *webView;
@property (assign) IBOutlet NSTextField *urlBar;
@property (assign) IBOutlet NSButton *backButton;
@property (assign) IBOutlet NSButton *forwardButton;
@property (assign) IBOutlet NSImageView *faviconImage;

- (IBAction)go:(id)sender;

@end
