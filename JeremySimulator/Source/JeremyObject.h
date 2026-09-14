//
//  JeremyObject.h
//  JeremySimulator
//
//  Created by Xander Gomez on 9/13/26.
//  Copyright © 2026 Ornithorynque Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JeremyObject : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, readonly) NSMutableDictionary *assets;

@end
