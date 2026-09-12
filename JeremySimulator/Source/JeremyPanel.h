//
//  JeremyPanel.h
//  jeremy
//
//  Created by Xander Gomez on 07/07/2026.
//  Copyright 2026 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JeremyAPI.h"

@interface JeremyPanel : NSBox {
	IBOutlet NSTextField* title;
}

+ (NSButton*)newButton;

- (void)setTitle:(NSString*)newTitle;

- (void)addButton:(NSButton*)button;
- (void)addButtons:(NSArray*)array;
- (void)makeButton:(NSString*)buttonTitle withAction:(SEL)action forTarget:(id)target;

- (void)removeButton:(int)index;

- (void)resizeButtons;

- (void)removeAllButtons;
- (void)disableAllButtons;
- (void)enableAllButtons;

- (NSArray*)allButtons;
@end
