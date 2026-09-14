//
//  JeremyUIController.m
//  jeremy
//
//  Created by Xander Gomez on 06/07/2026.
//  Copyright 2026 __MyCompanyName__. All rights reserved.
//

#import <unistd.h>
#import <SIMASRuntime.h>
#import "SIMASStandardLibrary.h"
#import "SIMASList.h"
#import "JeremyRuntime.h"
#import "JeremyUIController.h"

@implementation JeremyOption
- (id)init {
    self = [super init];
    if (self) {
        [self setBezelStyle:NSRoundedBezelStyle];
        [self setAutoresizingMask:(NSViewMaxXMargin | NSViewMinXMargin | NSViewWidthSizable | NSViewMinYMargin | NSViewMaxYMargin | NSViewHeightSizable)];
    }
    return self;
}

- (void)toggle {
    [self setEnabled:![self isEnabled]];
}
@end

@implementation JeremyPanel
- (id)init {
    self = [super init];
    if (self) {
        [self setBoxType:NSBoxPrimary];
        [self setTitlePosition:NSNoTitle];
        _heading = [NSMutableString new];
        [self setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
        [self setAutoresizesSubviews:YES];
        _options = [NSMutableArray new];
    }
    return self;
}

+ (JeremyPanel*)newPanel:(NSArray*)buttons {
    JeremyPanel *panel = [JeremyPanel new];
    [panel addButtons:buttons];
    return panel;
}

- (void)setHeading:(NSString*)heading {
    [_heading setString:heading];
    [_header setStringValue:_heading];
}

- (void)setHeader:(NSTextField*)header {
    if (header != _header) {
        [_header release];
        _header = [header retain];
    }
    [header setStringValue:_heading];
}

- (NSString*)heading {
    return [NSString stringWithString:_heading];
}

- (void)resizeButtons {
    NSInteger count = [_options count], i = 0;
    if (!count) return;
    
    NSRect bounds = [[self contentView] bounds];
    
    float buttonHeight = (bounds.size.height - (4.0f * (count - 1))) / count, currentY = 0.0f;
    
    for (; i < count; i++) {
        [[_options objectAtIndex:(count - i - 1)] setFrame:NSMakeRect(0.0f, currentY, bounds.size.width, buttonHeight)];
        currentY += buttonHeight + 4.0f;
        [[_options objectAtIndex:(count - i - 1)] setNeedsDisplay:YES];
    }
}

- (void)addButton:(JeremyOption*)button {
    [_options addObject:button];
    [[self contentView] addSubview:button];
    [self resizeButtons];
}

- (void)addButtons:(NSArray*)array {
    [_options addObjectsFromArray:array];
    for (NSView* view in array) [[self contentView] addSubview:view];
    [self resizeButtons];
}

- (JeremyOption*)makeButton:(NSString*)buttonTitle withAction:(SEL)action forTarget:(id)target {
    JeremyOption *new = [JeremyOption new];
    [new setTarget:target]; [new setAction:action];
    [new setTitle:buttonTitle];
    [self addButton:new];
    [new release];
    return new;
}

- (void)removeButton:(int)index {
    [[_options objectAtIndex:index] removeFromSuperview];
    [_options removeObjectAtIndex:index];
    [self resizeButtons];
}

- (void)removeAllButtons {
    for (NSView* view in _options) [view removeFromSuperview];
    [_options removeAllObjects];
}
- (void)disableAllButtons {
    for (JeremyOption* view in _options) [view setEnabled:NO];
}
- (void)enableAllButtons {
    for (JeremyOption* view in _options) [view setEnabled:YES];
}

- (void)dealloc {
    [_options release];
    [_header release];
    [_heading release];
    [super dealloc];
}
@end

static inline JeremyUIController **theController(void) {
    static JeremyUIController *controller;
    return &controller;
}

@implementation JeremyUIController
+ (JeremyUIController*)theController {
    return *theController();
}

- (void)setLeftPanel:(JeremyPanel*)leftPanel {
    [_leftPanel setHeader:nil];
    [_leftPanel removeFromSuperview];
    [left addSubview:leftPanel];
    [leftPanel setFrame:NSMakeRect(0, 0, [left frame].size.width, [left frame].size.height)];
    [leftPanel setHeader:leftTitle];
    _leftPanel = leftPanel;
}

- (void)setRightPanel:(JeremyPanel*)rightPanel {
    [_rightPanel setHeader:nil];
    [_rightPanel removeFromSuperview];
    [right addSubview:rightPanel];
    [rightPanel setFrame:NSMakeRect(0, 0, [right frame].size.width, [right frame].size.height)];
    [rightPanel setHeader:rightTitle];
    _rightPanel = rightPanel;
}

- (void)awakeFromNib {
    [SIMASRuntime runtime];
	[userInput setDelegate:self];
	currentUserInput = nil;
	displays = [NSMutableArray new];
	printQueue = [NSMutableArray new];
    game = [JeremyRuntime beginJeremyRuntime];
}

- (IBAction)clearLogs:(id)sender {
	[gameLogs setString:@""];
	[logClearButton setEnabled:NO];
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
	float padding = 9.0f, currentX = 0.0f, buttonSize = (([topDisplay frame]).size.width - (padding * ([displays count] - 1))) / [displays count];
	unsigned int theReferenceMask = NSViewMinXMargin | NSViewWidthSizable | NSViewMaxXMargin;
	for (NSView *theTarget in displays) {
		[[theTarget retain] removeFromSuperview]; // retain count goes from 2 (in superview) to 3 (retained) to 2 (removed)
		NSRect theRect = NSMakeRect(currentX, 0.0f, buttonSize, ([topDisplay frame]).size.height);
		[theTarget setFrame:theRect];
		currentX += padding + buttonSize;
		[theTarget setAutoresizingMask:theReferenceMask];
		[topDisplay addSubview:theTarget]; // retain count goes to 3
		[theTarget release]; // retain count back to 2
		[theTarget setNeedsDisplay:YES];
	}
    if ([displays count] > 1) {
        [(NSView*)[displays objectAtIndex:0] setAutoresizingMask:(NSViewWidthSizable | NSViewMaxXMargin)];
        [(NSView*)[displays lastObject] setAutoresizingMask:(NSViewMinXMargin | NSViewWidthSizable)];
    } else if ([displays count]) {
        [(NSView*)[displays lastObject] setAutoresizingMask:NSViewWidthSizable];
    }
}

- (void)addLabel:(NSTextField*)field {
	[topDisplay addSubview:field]; // retain count (in the scope of this class, this class owns it now) 1
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
    for (NSTextField* display in displays) [display removeFromSuperview];
	[displays removeAllObjects]; // all is nuked
}

- (void)dealloc {
	[displays release];
 	[game release];
	[super dealloc];
}
@end
