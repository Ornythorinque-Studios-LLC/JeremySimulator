//
//  main.m
//  JeremySimulator
//
//  Created by Xander Gomez on 9/12/26.
//  Copyright © 2026 Ornithorynque Studios. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SIMASRuntime.h"
#import "SIMASStandardLibrary.h"
#import "SIMASList.h"

int main(int argc, const char * argv[]) {
    NSAutoreleasePool *pool = [NSAutoreleasePool new];
    [[SIMASRuntime runtime] registerLibrary:[SIMASStandardLibrary class] withPrefix:@""];
    [[SIMASRuntime runtime] registerLibrary:[SIMASListLibrary class] withPrefix:@"List"];
    [pool release];
    return NSApplicationMain(argc, argv);
}
