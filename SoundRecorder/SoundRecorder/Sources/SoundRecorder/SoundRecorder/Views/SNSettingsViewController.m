//
//  SNSettingsViewController.m
//  SoundRecorder
//
//  Created by Igor Matyushkin on 03.02.14.
//  Copyright (c) 2014 NoCompany. All rights reserved.
//

#import "SNSettingsViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface SNSettingsViewController ()

@property (strong, nonatomic) void (^completionBlock)(NSDictionary *settings);

@property (strong, nonatomic) NSNumber *audioQuality;

@property (strong, nonatomic) NSNumber *encoderBitRate;

@property (strong, nonatomic) NSNumber *numberOfChannels;

@property (strong, nonatomic) NSNumber *sampleRate;

@property (strong, nonatomic) IBOutlet UIButton *buttonAudioQuality;

@end

@implementation SNSettingsViewController

@synthesize audioQuality = _audioQuality;
@synthesize encoderBitRate = _encoderBitRate;
@synthesize numberOfChannels = _numberOfChannels;
@synthesize sampleRate = _sampleRate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.audioQuality = [NSNumber numberWithInt:AVAudioQualityMin];
    self.encoderBitRate = [NSNumber numberWithInt:16];
    self.numberOfChannels = [NSNumber numberWithInt:2];
    self.sampleRate = [NSNumber numberWithFloat:44100.0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (SNSettingsViewController *)defaultSettingsViewController
{
    static SNSettingsViewController *settingsViewController;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        settingsViewController = [[SNSettingsViewController alloc] initWithNibName:@"SNSettingsViewController" bundle:nil];
    });
    
    return settingsViewController;
}

- (NSString *)stringRepresentationForSoundQuality:(int)soundQuality
{
    NSString *result = nil;
    
    switch(soundQuality)
    {
        case AVAudioQualityMin:
            result = @"Minimum";
            break;
        case AVAudioQualityLow:
            result = @"Low";
            break;
        case AVAudioQualityMedium:
            result = @"Medium";
            break;
        case AVAudioQualityHigh:
            result = @"High";
            break;
        case AVAudioQualityMax:
            result = @"Maximum";
            break;
        default:
            result = [NSString stringWithFormat:@"%d", soundQuality];
            break;
    }
    
    return result;
}

- (NSArray *)soundQualityValues
{
    return @[
             [NSNumber numberWithInt:AVAudioQualityMin],
             [NSNumber numberWithInt:AVAudioQualityLow],
             [NSNumber numberWithInt:AVAudioQualityMedium],
             [NSNumber numberWithInt:AVAudioQualityHigh],
             [NSNumber numberWithInt:AVAudioQualityMax]
             ];
}

- (NSDictionary *)settings
{
    return @{
             AVEncoderAudioQualityKey: _audioQuality,
             AVEncoderBitRateKey: _encoderBitRate,
             AVNumberOfChannelsKey: _numberOfChannels,
             AVSampleRateKey: _sampleRate
             };
}

- (IBAction)buttonSaveTapped:(id)sender
{
    __block NSDictionary *settings = [self settings];
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^
    {
        if(_completionBlock)
        {
            _completionBlock(settings);
        }
        
        settings = nil;
    }];
}

- (IBAction)buttonCancelTapped:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^
    {
        if(_completionBlock)
        {
            _completionBlock(nil);
        }
    }];
}

- (IBAction)buttonAudioQualityTapped:(id)sender
{
    [[[UIActionSheet alloc] initWithTitle:@"Choose audio quality"
                                 delegate:self
                        cancelButtonTitle:@"Cancel"
                   destructiveButtonTitle:nil
                        otherButtonTitles:@"Minimum", @"Low", @"Medium", @"High", @"Maximum", nil]
     showInView:self.view];
}

- (NSNumber *)audioQuality
{
    return _audioQuality;
}

- (void)setAudioQuality:(NSNumber *)audioQuality
{
    _audioQuality = audioQuality;
    
    [_buttonAudioQuality setTitle:[self stringRepresentationForSoundQuality:audioQuality.intValue]
                         forState:UIControlStateNormal];
}

- (NSNumber *)encoderBitRate
{
    return _encoderBitRate;
}

- (void)setEncoderBitRate:(NSNumber *)encoderBitRate
{
    _encoderBitRate = encoderBitRate;
}

- (NSNumber *)numberOfChannels
{
    return _numberOfChannels;
}

- (void)setNumberOfChannels:(NSNumber *)numberOfChannels
{
    _numberOfChannels = numberOfChannels;
}

- (NSNumber *)sampleRate
{
    return _sampleRate;
}

- (void)setSampleRate:(NSNumber *)sampleRate
{
    _sampleRate = sampleRate;
}

- (void)changeSettingsWithPresentingViewController:(UIViewController *)presentingViewController completion:(void (^)(NSDictionary *))completion
{
    _completionBlock = [completion copy];
    
    [presentingViewController presentViewController:self animated:YES completion:^
    {
    }];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == actionSheet.cancelButtonIndex)
    {
        return;
    }
    
    int selectedIndex = buttonIndex - actionSheet.firstOtherButtonIndex;
    self.audioQuality = [self soundQualityValues][selectedIndex];
}

@end
