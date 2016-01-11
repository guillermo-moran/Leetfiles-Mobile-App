//
//  ViewController.m
//  Leetfiles
//
//  Created by Guillermo Moran on 1/23/15.
//  Copyright (c) 2015 Fr0st Development. All rights reserved.
//

#import "LFAAccountViewController.h"
#import "LFAMacros.h"

#import "NSString+LFAEncrypt.h"

#import <QuartzCore/QuartzCore.h>

@interface LFAAccountViewController () {
    NSString* secretKey;
}

@end

@implementation LFAAccountViewController

-(IBAction)logOut:(id)sender {
    [LFAConnector logOut];
    [self dismissAccountView:nil];
}

-(void)updateProgressBars {
    NSArray* userInfo = [LFAConnector userInfo:keyForUser(LFA_KEYCHAIN_USER, LFA_KEYCHAIN_PASS)];
    
    float fileLimit = [[[userInfo valueForKey:F_STORAGE] objectAtIndex:0] intValue];
    float fileLimitUsed = [[[userInfo valueForKey:F_STORAGE_USED] objectAtIndex:1] intValue];
    
    float imageLimit = [[[userInfo valueForKey:I_STORAGE] objectAtIndex:0] intValue];
    float imageLimitUsed = [[[userInfo valueForKey:I_STORAGE_USED] objectAtIndex:1] intValue];
    
    float pasteLimit = [[[userInfo valueForKey:P_LIMIT] objectAtIndex:0] intValue];
    float pasteLimitUsed = [[[userInfo valueForKey:P_LIMIT_USED] objectAtIndex:1] intValue];
    
    float filePercentage = (fileLimitUsed / fileLimit);
    float imagePercentage = (imageLimitUsed / imageLimit);
    float pastePercentage = (pasteLimitUsed / pasteLimit);
    
    fileBar.progress = filePercentage;
    imageBar.progress = imagePercentage;
    pastesBar.progress = pastePercentage;
    
    
}

-(IBAction)dismissAccountView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    
    [usernameLabel setText:[NSString stringWithFormat:@"%@",LFA_KEYCHAIN_USER]];
    
    [self updateProgressBars];
    
    topBarView.layer.cornerRadius = 5;
    topBarView.layer.masksToBounds = YES;
    
    if (!internetAvailable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection!"
                                                        message:@"Please connect to the internet."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
