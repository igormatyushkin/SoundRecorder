//
//  SNSplashViewController.m
//  SoundRecorder
//
//  Created by Igor Matyushkin on 03.02.14.
//  Copyright (c) 2014 NoCompany. All rights reserved.
//

#import "SNSplashViewController.h"

@interface SNSplashViewController ()

@end

@implementation SNSplashViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (SNSplashViewController *)defaultSplashViewController
{
    static SNSplashViewController *splashViewController;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        splashViewController = [[SNSplashViewController alloc] initWithNibName:@"SNSplashViewController" bundle:nil];
    });
    
    return splashViewController;
}

@end
