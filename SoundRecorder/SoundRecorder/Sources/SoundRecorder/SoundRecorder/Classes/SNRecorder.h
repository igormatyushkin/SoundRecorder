//
//  SNRecorder.h
//  SoundRecorder
//
//  Created by Igor Matyushkin on 03.02.14.
//  Copyright (c) 2014 NoCompany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SNRecorderDelegate.h"
#import "SNRecorderState.h"

#define SNRecorder_SoundFileName @"sound"
#define SNRecorder_SoundFileExtension @"caf"

@interface SNRecorder : NSObject

@property (assign, nonatomic) id<SNRecorderDelegate> delegate;

@property (readonly) SNRecorderState currentState;

@property (readonly) NSString *soundFilePath;

- (id)initWithSettings:(NSDictionary *)settings;

- (void)start;

- (void)stop;

@end
