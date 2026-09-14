//
//  JeremyPet.h
//  JeremySimulator
//
//  Created by Xander Gomez on 9/12/26.
//  Copyright © 2026 Ornithorynque Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JeremyObject.h"

typedef enum { // normally i'm on the side of "anyone can identify as what they want" but a fucking rat doesn't need more than 2 genders, devour feculence
    JeremyGenderMale,
    JeremyGenderFemale
} JeremyGender;

@interface JeremyPet : JeremyObject {
    int daysOld;
    BOOL pregnant;
}

@property (nonatomic, assign) JeremyGender gender;

@property (nonatomic, assign) double health;
@property (nonatomic, assign) double stamina;
@property (nonatomic, assign) double disease;
@property (nonatomic, assign) double filth;
@property (nonatomic, assign) double happiness;
@property (nonatomic, assign) double anger;
@property (nonatomic, assign) double mental;
@property (nonatomic, assign) double hunger;
@end
