//
//  SNMainViewController.h
//  SoundRecorder
//
//  Created by Igor Matyushkin on 03.02.14.
//  Copyright (c) 2014 NoCompany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNRecorderDelegate.h"
#import "SNMainViewControllerState.h"

@interface SNMainViewController : UIViewController<UIActionSheetDelegate, SNRecorderDelegate, DBRestClientDelegate>

@property (readonly) SNMainViewControllerState currentState;

+ (SNMainViewController *)defaultMainViewController;

@end
