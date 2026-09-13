//
//  JeremyGame.h
//  JeremySimulator
//
//  Created by Xander Gomez on 9/12/26.
//  Copyright © 2026 Ornithorynque Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JeremyGame : NSObject {
    NSTimer *gameTimer;
}

- (void)tickTime:(NSTimer*)timer;
@end
