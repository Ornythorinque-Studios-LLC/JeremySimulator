//
//  JeremyUIController.h
//  jeremy
//
//  Created by Xander Gomez on 06/07/2026.
//  Copyright 2026 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef enum { // used to reference ui elements, e.g. Left = the left panel, Right = the right panel
    JeremyLeft,
    JeremyRight
} JeremyUIPosition;

@interface JeremyOption : NSButton
- (void)toggle;
@end

@interface JeremyPanel : NSBox {
    NSMutableString *_heading;
}
@property (nonatomic, readonly) NSMutableArray *options;
@property (nonatomic, retain) NSTextField *header;
@property (nonatomic, copy) NSString *heading;

+ (JeremyPanel*)newPanel:(NSArray*)buttons;

- (void)addButton:(JeremyOption*)button;
- (void)addButtons:(NSArray*)array;
- (JeremyOption*)makeButton:(NSString*)buttonTitle withAction:(SEL)action forTarget:(id)target;

- (void)removeButton:(int)index;

- (void)removeAllButtons;
- (void)disableAllButtons;
- (void)enableAllButtons;
@end

@interface JeremyUIController : NSObject <NSTextFieldDelegate> {
	IBOutlet NSWindow* theWindow;
    
    IBOutlet NSTextField* leftTitle;
    IBOutlet NSTextField* rightTitle;
    
    JeremyPanel *_leftPanel;
    JeremyPanel *_rightPanel;
    
	IBOutlet NSView* left;
	IBOutlet NSView* right;
	
	IBOutlet NSView* topDisplay;
	
	IBOutlet NSTextField* userInput;
	IBOutlet NSTextView* gameLogs;
	IBOutlet NSButton* logClearButton;
	IBOutlet NSImageView* mainDisplay;
	
	NSString* currentUserInput;
	NSMutableArray *displays, *printQueue;
	BOOL isPrinting;
	id game;
}

@property (nonatomic, retain) JeremyPanel *leftPanel;
@property (nonatomic, retain) JeremyPanel *rightPanel;

+ (JeremyUIController*)theController;

- (IBAction)clearLogs:(id)sender;
- (NSString*)getUserInput; 
- (void)log:(NSString*)text;
- (void)typeWrite:(NSString*)text;
- (void)setImage:(NSImage*)image;

+ (NSTextField*)newLabel;
- (void)addLabel:(NSTextField*)field;
- (void)removeLabel:(int)label;
- (NSInteger)labelCount;
- (NSTextField*)getField:(int)number;
- (NSArray*)allLabels;
- (void)removeAllLabels;
@end
