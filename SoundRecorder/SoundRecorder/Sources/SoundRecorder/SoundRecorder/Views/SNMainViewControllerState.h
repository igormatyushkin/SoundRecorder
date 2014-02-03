//
//  SNMainViewControllerState.h
//  SoundRecorder
//
//  Created by Igor Matyushkin on 03.02.14.
//  Copyright (c) 2014 NoCompany. All rights reserved.
//

#ifndef SoundRecorder_SNMainViewControllerState_h
#define SoundRecorder_SNMainViewControllerState_h

typedef enum
{
    SNMainViewControllerState_DoNothing,
    SNMainViewControllerState_Recording,
    SNMainViewControllerState_StoppedRecording,
    SNMainViewControllerState_Uploading,
    SNMainViewControllerState_FinishedUploading
}SNMainViewControllerState;

#endif
