//
//  BackgroundView.m
//  Browser
//
//  Created by Dave Eddy on 8/23/13.
//  Copyright (c) 2013 Dave Eddy. All rights reserved.
//

#import "BackgroundView.h"

@implementation BackgroundView

- (void)drawRect:(NSRect)rect
{
    if (self.backgroundColor) {
        [self.backgroundColor set];
        NSRectFill([self bounds]);
    }
}

@end
