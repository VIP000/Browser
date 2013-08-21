//
//  TabCellView.h
//  Browser
//
//  Created by Dave Eddy on 8/15/13.
//  Copyright (c) 2013 Dave Eddy. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TabCellView : NSTableCellView

@property (assign) IBOutlet NSTextField *title;
@property (assign) IBOutlet NSTextField *url;
@property (assign) IBOutlet NSImageView *favicon;
@property (assign) IBOutlet NSProgressIndicator *progressIndicator;

@end
