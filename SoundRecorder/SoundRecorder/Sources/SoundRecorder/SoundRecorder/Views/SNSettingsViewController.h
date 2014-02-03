//
//  SNSettingsViewController.h
//  SoundRecorder
//
//  Created by Igor Matyushkin on 03.02.14.
//  Copyright (c) 2014 NoCompany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SNSettingsViewController : UIViewController<UIActionSheetDelegate>

+ (SNSettingsViewController *)defaultSettingsViewController;

- (void)changeSettingsWithPresentingViewController:(UIViewController *)presentingViewController completion:(void (^)(NSDictionary *settings))completion;

@end
