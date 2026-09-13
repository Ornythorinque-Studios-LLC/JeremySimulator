//
//  JeremyPanel.m
//  jeremy
//
//  Created by Xander Gomez on 07/07/2026.
//  Copyright 2026 __MyCompanyName__. All rights reserved.
//

#import "JeremyPanel.h"


@implementation JeremyPanel
+ (NSButton*)newButton {
	NSButton *new = [NSButton new];
	[new setBezelStyle:NSRoundedBezelStyle];
	return new;
}

- (void)setTitle:(NSString*)newTitle {
	[title setStringValue:newTitle];
}

- (void)resizeButtons {
	NSArray* buttons = [[self contentView] subviews];
	NSInteger count = [buttons count], i = 0;
	if (!count) return;
	
	NSRect bounds = [[self contentView] bounds];

	float buttonHeight = (bounds.size.height - (4.0f * (count - 1))) / count, currentY = 0.0f;
	
	for (; i < count; i++) {
		[[buttons objectAtIndex:i] setFrame:NSMakeRect(0.0f, currentY, bounds.size.width, buttonHeight)];
		currentY += buttonHeight + 4.0f;
		[[buttons objectAtIndex:i] setNeedsDisplay:YES];
	}	
}

- (void)addButton:(NSButton*)button {
	[[self contentView] addSubview:button];
	[self resizeButtons];
}

- (void)addButtons:(NSArray*)array {
	NSInteger i = [array count] - 1;
	for (; i >= 0; i--) [[self contentView] addSubview:[array objectAtIndex:i]];
	[self resizeButtons];
}

- (void)makeButton:(NSString*)buttonTitle withAction:(SEL)action forTarget:(id)target {
	NSButton *new = [JeremyPanel newButton]; // retain count: 1
	[new setTarget:target]; [new setAction:action];
	[new setTitle:buttonTitle];
	[self addButton:new]; // retain count: 2
	[new release]; // retain count: 1
}

- (void)removeButton:(int)index {
	[[[[self contentView] subviews] objectAtIndex:index] removeFromSuperview]; // square
	[self resizeButtons];
}

- (void)removeAllButtons {
	NSArray* buttons = [[self contentView] subviews];
	NSInteger buttonCount = [buttons count], i = 0;
	for (; i < buttonCount; i++) [[buttons objectAtIndex:i] removeFromSuperview]; // retain count zero, button dead :)
}
- (void)disableAllButtons {
	NSArray* buttons = [[self contentView] subviews];
	NSInteger buttonCount = [buttons count], i = 0;
	for (; i < buttonCount; i++) [[buttons objectAtIndex:i] setEnabled:NO];
}
- (void)enableAllButtons {
	NSArray* buttons = [[self contentView] subviews];
	NSInteger buttonCount = [buttons count], i = 0;
	for (; i < buttonCount; i++) [[buttons objectAtIndex:i] setEnabled:YES];
}

- (NSArray*)allButtons {
	return [[self contentView] subviews];
}
@end
