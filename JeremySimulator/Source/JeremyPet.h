//
//  JeremyPet.h
//  JeremySimulator
//
//  Created by Xander Gomez on 9/12/26.
//  Copyright © 2026 Ornithorynque Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SIMASVariable.h>

typedef uint16_t JeremyStatSelector;

typedef enum {
    JeremyStatHealth = 1,
    JeremyStatStamina = 2,
    JeremyStatDisease = 4,
    JeremyStatFilth = 8,
    JeremyStatHappiness = 16,
    JeremyStatAnger = 32,
    JeremyStatMental = 64,
    JeremyStatHunger = 128,
    JeremyStatHeat = 256,
    JeremyStatQuality = 512,
    JeremyStatAge = 1024,
    JeremyStatPregnancy = 2048,
    JeremyStatGender = 4096,
    JeremyStatStageOfLife = 8192
} JeremyStats;

typedef enum { // normally i'm on the side of "anyone can identify as what they want" but a fucking rat doesn't need more than 2 genders, devour feculence
    JeremyGenderMale,
    JeremyGenderFemale
} JeremyGender;

typedef enum {
    JeremyAgeInfant,
    JeremyAgeChild,
    JeremyAgeAdolescent,
    JeremyAgeAdult,
    JeremyAgeMiddleAged,
    JeremyAgeSenior,
    JeremyAgeYouShouldBeDeadByNow,
    JeremyAgeIQuiteLiterallyAmImmortal
} JeremyAgeingStage;

@interface JeremyPetClass : NSObject
@property (nonatomic, assign) int ageingInterval; // in days
+ (NSString*)name;
@end

@interface JeremyPet : SIMASData {
    JeremyPetClass *type;
    NSString *name;
    NSMutableArray *applicableMoods;
    int daysOld;
    BOOL pregnant;
}

@property (nonatomic, assign) double health;
@property (nonatomic, assign) double stamina;
@property (nonatomic, assign) double disease;
@property (nonatomic, assign) double filth;
@property (nonatomic, assign) double happiness;
@end
