//
//  JeremyJob.h
//  JeremySimulator
//
//  Created by Xander Gomez on 9/12/26.
//  Copyright © 2026 Ornithorynque Studios. All rights reserved.
//

#import "JeremyLocation.h"

@interface JeremyJob : JeremyLocation {
    double hourlyPay;
    NSRange hoursWorked;
    BOOL workedDays[7];
    
}

@end
