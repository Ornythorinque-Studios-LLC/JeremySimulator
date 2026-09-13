//
//  JeremyRuntime.h
//  JeremySimulator
//
//  Created by Xander Gomez on 9/12/26.
//  Copyright © 2026 Ornithorynque Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SIMASRuntime.h>

@interface JeremyRuntime : SIMASRuntime {
    NSMutableDictionary *globalLocations;
    NSMutableDictionary *globalEvents;
    
}

+ (JeremyRuntime*)beginJeremyRuntime;
+ (JeremyRuntime*)runtime; // override to avoid having to cast every damn call
@end
