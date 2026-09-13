//
//  JeremyRuntime.m
//  JeremySimulator
//
//  Created by Xander Gomez on 9/12/26.
//  Copyright © 2026 Ornithorynque Studios. All rights reserved.
//

#import "JeremyRuntime.h"

@implementation JeremyRuntime
+ (JeremyRuntime*)beginJeremyRuntime {
    JeremyRuntime *runtime = [JeremyRuntime runtime];
    return runtime;
}

+ (JeremyRuntime*)runtime {
    return (JeremyRuntime*)[super runtime];
}
@end
