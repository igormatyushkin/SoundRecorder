//
//  SNRecorderDelegate.h
//  SoundRecorder
//
//  Created by Igor Matyushkin on 03.02.14.
//  Copyright (c) 2014 NoCompany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SNRecorderState.h"

@class SNRecorder;

@protocol SNRecorderDelegate <NSObject>

- (void)recorder:(SNRecorder *)recorder changedStateWithValue:(SNRecorderState)stateValue;

@end
