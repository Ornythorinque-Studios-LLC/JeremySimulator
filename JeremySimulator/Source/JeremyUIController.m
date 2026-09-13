//
//  JeremyUIController.m
//  jeremy
//
//  Created by Xander Gomez on 06/07/2026.
//  Copyright 2026 __MyCompanyName__. All rights reserved.
//

#import "JeremyUIController.h"
#include <unistd.h>
#include "SIMASRuntime.h"
#include "SIMASStandardLibrary.h"
#include "SIMASList.h"

static inline JeremyUIController **theController() {
    static JeremyUIController *controller;
    return &controller;
}

@implementation JeremyUIController
+ (JeremyUIController*)theController {
    return *theController();
}

- (void)awakeFromNib {
    [SIMASRuntime runtime];
	[userInput setDelegate:self];
	currentUserInput = nil;
	displays = [NSMutableArray new];
	printQueue = [NSMutableArray new];
    *theController() = self;
    NSAutoreleasePool *pool = [NSAutoreleasePool new];
    [[SIMASRuntime runtime] runFromString:@"set in letarg; print letarg;"];
    [pool release];
}

- (void)clearLogs {
	[gameLogs setString:@""];
	[logClearButton setEnabled:NO];
}

- (IBAction)clearLogs:(id)sender {
	[gameLogs setString:@""];
	[sender setEnabled:NO];
}

- (NSString*)getUserInput {
	currentUserInput = nil;
	[userInput setStringValue:@""];
	[userInput setEnabled:YES];
	[userInput setEditable:YES];
	[userInput setNeedsDisplay:YES];

	[theWindow makeFirstResponder:userInput];
	NSModalSession inputSession = [NSApp beginModalSessionForWindow:theWindow];
	
	while ([NSApp runModalSession:inputSession] == NSRunContinuesResponse) {
		if (currentUserInput != nil) break;
		NSEvent *event = [NSApp nextEventMatchingMask:NSAnyEventMask untilDate:[NSDate distantFuture]
								inMode:NSDefaultRunLoopMode dequeue:YES];
		if (event) [NSApp sendEvent:event];
	}
	
	[NSApp endModalSession:inputSession];

	[userInput setEditable:NO];
	[userInput setEnabled:NO];
	[theWindow makeFirstResponder:nil];
	return currentUserInput;
}

- (void)checkPrintQueue:(NSTimer*)timer {
	NSString* printedString; SEL printFunc;
	if ([printQueue count] < 2) {isPrinting = NO; [logClearButton setEnabled:YES]; return;}
	printedString = [[printQueue objectAtIndex:0] retain];
	[printQueue removeObjectAtIndex:0];
	printFunc = (SEL)[[printQueue objectAtIndex:0] pointerValue];
	[printQueue removeObjectAtIndex:0];
	isPrinting = NO;
	[self performSelector:printFunc withObject:printedString];
	[printedString release];
}

- (void)pushToPrintQueue:(NSString*)string forSelector:(SEL)selector {
	[printQueue addObject:string];
	[printQueue addObject:[NSValue valueWithPointer:(void*)selector]];
}

- (void)log:(NSString*)text {
	if (isPrinting) { [self pushToPrintQueue:text forSelector:_cmd]; return; }
	isPrinting = YES;
	[gameLogs setString:[NSString stringWithFormat:@"%@%@%@", [gameLogs string], ([[gameLogs string] isEqualToString:@""] ? @"" : @"\n"), text]];
	[gameLogs scrollRangeToVisible:NSMakeRange([[gameLogs string] length], 0)];
	[NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(checkPrintQueue:) userInfo:nil repeats:NO];
}

- (void)typeWrite:(NSString*)text {
	if (isPrinting) { [self pushToPrintQueue:text forSelector:_cmd]; return; }
	isPrinting = YES;
	[gameLogs setString:[NSString stringWithFormat:@"%@%@", [gameLogs string], ([[gameLogs string] isEqualToString:@""] ? @"" : @"\n")]];
	NSMutableString *newCopy = [text mutableCopy];
	[NSTimer scheduledTimerWithTimeInterval:0.025 target:self selector:@selector(typeWriteHelper:) userInfo:newCopy repeats:YES];
	[newCopy release];
}

- (void)typeWriteHelper:(NSTimer*)timer {
	NSMutableString* string = [timer userInfo];
	[gameLogs setString:[NSString stringWithFormat:@"%@%@", [gameLogs string], [string substringToIndex:1]]];
	[gameLogs scrollRangeToVisible:NSMakeRange([[gameLogs string] length], 0)];
	[string deleteCharactersInRange:NSMakeRange(0, 1)];
	if ([string length] < 1) {
		[timer invalidate];
		[NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(checkPrintQueue:) userInfo:nil repeats:NO];
	}	
}

- (void)setImage:(NSImage*)image {
	[mainDisplay setImage:image];
}

- (JeremyPanel*)getPanel:(JeremyUIPosition)position {
	switch (position) {
		case JeremyLeft: return leftPanel;
		case JeremyRight: return rightPanel;
		default: return nil;
	}
}

+ (NSTextField*)newLabel {
	NSTextField* new = [NSTextField new];
	[new setEditable:NO];
	[new setBezelStyle:NSTextFieldRoundedBezel];
	return new;
}

- (NSTextField*)getField:(int)number {
	if (number < 0 || number >= [displays count]) return nil;
	return [displays objectAtIndex:number];
}

- (void)controlTextDidEndEditing:(NSNotification*)aNotification {
	currentUserInput = [userInput stringValue];
}

- (void)resizeLabels {
	NSInteger labelCount = [displays count], i = 0;
	float padding = 9.0f, currentX = padding, buttonSize = (([topDisplay frame]).size.width - (padding * (labelCount + 1))) / labelCount;
	unsigned int theReferenceMask = NSViewMinXMargin | NSViewWidthSizable | NSViewMaxXMargin | NSViewMinYMargin;
	for (; i < labelCount; i++) {
		NSView *theTarget = [displays objectAtIndex:i];
		[[theTarget retain] removeFromSuperview]; // retain count goes from 2 (in superview) to 3 (retained) to 2 (removed)
		NSRect theRect = NSMakeRect(currentX, 0.0f, buttonSize, ([topDisplay frame]).size.height);
		[theTarget setFrame:theRect];
		currentX += padding + buttonSize;
		[theTarget setAutoresizingMask:theReferenceMask];
		[topDisplay addSubview:theTarget]; // retain count goes to 3
		[theTarget release]; // retain count back to 2
		[theTarget setNeedsDisplay:YES];
	}
}

- (void)addLabel:(NSTextField*)field {
	[[theWindow contentView] addSubview:field]; // retain count (in the scope of this class, this class owns it now) 1
	[displays addObject:field]; // retain count 2
	[self resizeLabels];
}

- (void)removeLabel:(int)label {
	[[displays objectAtIndex:label] removeFromSuperview]; // retain count now 1
	[displays removeObjectAtIndex:label]; // nuked
	[self resizeLabels];
}

- (NSInteger)labelCount {
	return [displays count];
}

- (NSArray*)allLabels {
	return [NSArray arrayWithArray:displays];
}

- (void)removeAllLabels {
	NSInteger i = 0, count = [displays count];
	for (; i < count; i++) [[displays objectAtIndex:i] removeFromSuperview]; // retain counts: 1
	[displays removeAllObjects]; // all is nuked
}

- (void)dealloc {
	[displays release];
 	[game release];
	[super dealloc];
}
@end
