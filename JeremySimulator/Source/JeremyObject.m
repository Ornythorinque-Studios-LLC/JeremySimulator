//
//  JeremyObject.m
//  JeremySimulator
//
//  Created by Xander Gomez on 9/13/26.
//  Copyright © 2026 Ornithorynque Studios. All rights reserved.
//

#import "JeremyObject.h"

@implementation JeremyObject
- (void)dealloc {
    [_name release];
    [_assets release];
    [super dealloc];
}
@end
