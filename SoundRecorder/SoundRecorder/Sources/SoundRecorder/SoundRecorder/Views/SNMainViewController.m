//
//  SNMainViewController.m
//  SoundRecorder
//
//  Created by Igor Matyushkin on 03.02.14.
//  Copyright (c) 2014 NoCompany. All rights reserved.
//

#import "SNMainViewController.h"
#import "SNRecorder.h"
#import "SNSettingsViewController.h"

@interface SNMainViewController ()

@property (strong, nonatomic) SNRecorder *recorder;

@property (nonatomic, readonly) DBRestClient *restClient;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *buttonRecord;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *buttonUpload;

@property (strong, nonatomic) IBOutlet UILabel *labelOperation;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *processIndicator;

@end

@implementation SNMainViewController

@synthesize currentState = _currentState;
@synthesize restClient = _restClient;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        if (![[DBSession sharedSession] isLinked])
        {
            [[DBSession sharedSession] linkFromController:self];
        }
        
        self.currentState = SNMainViewControllerState_DoNothing;
    });
}

+ (SNMainViewController *)defaultMainViewController
{
    static SNMainViewController *mainViewController;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        mainViewController = [[SNMainViewController alloc] initWithNibName:@"SNMainViewController" bundle:nil];
    });
    
    return mainViewController;
}

- (SNMainViewControllerState)currentState
{
    return _currentState;
}

- (void)setCurrentState:(SNMainViewControllerState)currentState
{
    _currentState = currentState;
    
    switch(currentState)
    {
        case SNMainViewControllerState_DoNothing:
            _labelOperation.hidden = NO;
            _labelOperation.text = @"Press Start to record";
            [_processIndicator stopAnimating];
            _buttonRecord.enabled = YES;
            _buttonUpload.enabled = NO;
            break;
        case SNMainViewControllerState_Recording:
            _labelOperation.hidden = NO;
            _labelOperation.text = @"Recording audio...";
            [_processIndicator startAnimating];
            _buttonRecord.enabled = YES;
            _buttonUpload.enabled = NO;
            break;
        case SNMainViewControllerState_StoppedRecording:
            _labelOperation.hidden = NO;
            _labelOperation.text = @"Now you can upload audio or continue to record";
            [_processIndicator stopAnimating];
            _buttonRecord.enabled = YES;
            _buttonUpload.enabled = YES;
            break;
        case SNMainViewControllerState_Uploading:
            _labelOperation.hidden = NO;
            _labelOperation.text = @"Uploading audio to Dropbox";
            [_processIndicator startAnimating];
            _buttonRecord.enabled = NO;
            _buttonUpload.enabled = NO;
            break;
        case SNMainViewControllerState_FinishedUploading:
            _labelOperation.hidden = NO;
            _labelOperation.text = @"Now you can record again";
            [_processIndicator stopAnimating];
            _buttonRecord.enabled = YES;
            _buttonUpload.enabled = NO;
            break;
    }
}

- (DBRestClient *)restClient
{
    if (!_restClient)
    {
        _restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        _restClient.delegate = self;
    }
    
    return _restClient;
}

- (NSString *)recordButtonTitleWithRecorderState:(SNRecorderState)recorderState
{
    switch(recorderState)
    {
        case SNRecorderState_NotInitialized:
            return @"Start";
        case SNRecorderState_Recording:
            return @"Stop";
        case SNRecorderState_Paused:
            return @"Start";
        default:
            return @"Start";
    }
}

- (IBAction)buttonRecordTapped:(id)sender
{
    if(_recorder.currentState == SNRecorderState_Recording)
    {
        [_recorder stop];
        self.currentState = SNMainViewControllerState_StoppedRecording;
        return;
    }
    
    [[SNSettingsViewController defaultSettingsViewController] changeSettingsWithPresentingViewController:self completion:^(NSDictionary *settings)
    {
        if(!settings)
        {
            return;
        }
        
        _recorder = [[SNRecorder alloc] initWithSettings:settings];
        
        _recorder.delegate = self;
        
        [_recorder start];
        
        self.currentState = SNMainViewControllerState_Recording;
    }];
}

- (IBAction)buttonUploadTapped:(id)sender
{
    if(![[DBSession sharedSession] isLinked])
    {
        [[DBSession sharedSession] linkFromController:self];
        
        return;
    }
    
    NSString *localPath = [NSString stringWithString:_recorder.soundFilePath];
    NSString *filename = [NSString stringWithFormat:@"%@.%@", SNRecorder_SoundFileName, SNRecorder_SoundFileExtension];
    NSString *destDir = @"/";
    
    [[self restClient] uploadFile:filename
                           toPath:destDir
                    withParentRev:nil
                         fromPath:localPath];
    filename = nil;
    destDir = nil;
    localPath = nil;
    
    self.currentState = SNMainViewControllerState_Uploading;
}

- (void)recorder:(SNRecorder *)recorder changedStateWithValue:(SNRecorderState)stateValue
{
    [_buttonRecord setTitle:[self recordButtonTitleWithRecorderState:stateValue]];
}

- (void)restClient:(DBRestClient*)client uploadedFile:(NSString*)destPath from:(NSString*)srcPath metadata:(DBMetadata*)metadata
{
    [[[UIAlertView alloc] initWithTitle:@"SoundRecorder"
                               message:@"Uploaded file to the Dropbox."
                              delegate:nil
                     cancelButtonTitle:@"Ok"
                      otherButtonTitles:nil]
     show];
    
    self.currentState = SNMainViewControllerState_FinishedUploading;
}

- (void)restClient:(DBRestClient*)client uploadFileFailedWithError:(NSError*)error
{
    [[[UIAlertView alloc] initWithTitle:@"SoundRecorder"
                                message:@"Failed to upload file to the Dropbox."
                               delegate:nil
                      cancelButtonTitle:@"Ok"
                      otherButtonTitles:nil]
     show];
    
    _labelOperation.hidden = YES;
}

@end
