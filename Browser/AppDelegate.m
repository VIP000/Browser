//
//  AppDelegate.m
//  Browser
//
//  Created by Dave Eddy on 8/14/13.
//  Copyright (c) 2013 Dave Eddy. All rights reserved.
//

#import "AppDelegate.h"
#import "BrowserWindowController.h"

@implementation AppDelegate {
    BrowserWindowController *browserWindow;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    if  (!browserWindow)
        browserWindow = [[BrowserWindowController alloc] init];
    [browserWindow showWindow:self];
}

@end
