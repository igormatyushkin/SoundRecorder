//
//  SNRecorder.m
//  SoundRecorder
//
//  Created by Igor Matyushkin on 03.02.14.
//  Copyright (c) 2014 NoCompany. All rights reserved.
//

#import "SNRecorder.h"
#import <AVFoundation/AVFoundation.h>

@interface SNRecorder ()

@property (strong, nonatomic) AVAudioRecorder *audioRecorder;

@end

@implementation SNRecorder

@synthesize currentState = _currentState;

- (id)init
{
    self = [super init];
    
    if(self)
    {
        self.currentState = SNRecorderState_NotInitialized;
        
        NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        NSString *docsDir = dirPaths[0];
        dirPaths = nil;
        
        _soundFilePath = [docsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", SNRecorder_SoundFileName, SNRecorder_SoundFileExtension]];
    }
    
    return self;
}

- (id)initWithSettings:(NSDictionary *)settings
{
    self = [self init];
    
    if(self)
    {
        NSError *error = nil;
        
        _audioRecorder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:_soundFilePath]
                                                     settings:settings
                                                        error:&error];
        
        self.currentState = SNRecorderState_Paused;
        
        error = nil;
    }
    
    return self;
}

+ (SNRecorder *)defaultRecorder
{
    static SNRecorder *recorder;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        recorder = [[SNRecorder alloc] init];
    });
    
    return recorder;
}

- (SNRecorderState)currentState
{
    return _currentState;
}

- (void)setCurrentState:(SNRecorderState)currentState
{
    if(_currentState == currentState)
    {
        return;
    }
    
    _currentState = currentState;
    
    if([_delegate respondsToSelector:@selector(recorder:changedStateWithValue:)])
    {
        [_delegate recorder:self changedStateWithValue:currentState];
    }
}

- (void)start
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *err = nil;
    [audioSession setCategory :AVAudioSessionCategoryPlayAndRecord error:&err];
    
    if(err)
    {
        return;
    }
    
    err = nil;
    
    [audioSession setActive:YES error:&err];
    
    if(err)
    {
        return;
    }
    
    if([_audioRecorder record])
    {
        self.currentState = SNRecorderState_Recording;
    }
}

- (void)stop
{
    [_audioRecorder stop];
    
    self.currentState = SNRecorderState_Paused;
}

@end
