//
//  JeremyUIController.h
//  jeremy
//
//  Created by Xander Gomez on 06/07/2026.
//  Copyright 2026 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JeremyPanel.h"

@interface JeremyUIController : NSObject {
	IBOutlet NSWindow* theWindow;
	IBOutlet JeremyPanel* leftPanel;
	IBOutlet JeremyPanel* rightPanel;
	
	IBOutlet NSView* topDisplay;
	
	IBOutlet NSTextField* userInput;
	IBOutlet NSTextView* gameLogs;
	IBOutlet NSButton* logClearButton;
	IBOutlet NSImageView* mainDisplay;
	
	NSString* currentUserInput;
	NSMutableArray *displays, *printQueue, *playingSounds;
	BOOL isPrinting;
	id game;
}

- (void)clearLogs;
- (IBAction)clearLogs:(id)sender;
- (NSString*)getUserInput; 
- (void)log:(NSString*)text;
- (void)typeWrite:(NSString*)text;
- (void)setImage:(NSImage*)image;

+ (NSTextField*)newLabel;
- (void)addLabel:(NSTextField*)field;
- (void)removeLabel:(int)label;
- (int)labelCount;
- (NSTextField*)getField:(int)number;
- (NSArray*)allLabels;
- (void)removeAllLabels;

- (JeremyPanel*)getPanel:(JeremyUIPosition)position;
@end
