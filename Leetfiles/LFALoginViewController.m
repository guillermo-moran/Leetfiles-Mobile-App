//
//  ViewController.m
//  Leetfiles
//
//  Created by Guillermo Moran on 1/23/15.
//  Copyright (c) 2015 Fr0st Development. All rights reserved.
//

#import "LFALoginViewController.h"
#import "LFAMacros.h"

#import "NSString+LFAEncrypt.h"

#import <QuartzCore/QuartzCore.h>

@interface LFALoginViewController () {
    NSString* secretKey;
}

@end

@implementation LFALoginViewController

-(IBAction)attemptLogin:(id)sender {

    if (!internetAvailable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection!"
                                                        message:@"Please connect to the internet."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if (![keyForUser(usernameField.text, passwordField.text) isEqualToString:@"Invalid Login"]) {
        NSLog(@"Login Successful");
        [KeychainManager saveString:usernameField.text forKey:Obfuscate.l.e.e.t.f.i.l.e.s.u.s.e.r];
        [KeychainManager saveString:passwordField.text forKey:Obfuscate.l.e.e.t.f.i.l.e.s.p.a.s.s];
        
        [self dismissLoginView:nil];
    }
    else {
        NSLog(@"Login Failure");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Login"
                                                        message:@"Your Username/Password is incorrect"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}
-(IBAction)dismissLoginView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    
    usernameField.delegate = self;
    passwordField.delegate = self;
    
    originalPoint = self.view.center;
    
    [usernameField setReturnKeyType:UIReturnKeyDone];
    [passwordField setReturnKeyType:UIReturnKeyDone];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    topBarView.layer.cornerRadius = 5;
    topBarView.layer.masksToBounds = YES;
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)keyboardDidShow:(NSNotification *)note
{
    
    [UIView animateWithDuration:0.3f animations:^{
        
        self.view.center = CGPointMake(originalPoint.x, originalPoint.y - 120);
        
    } completion:nil];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    [UIView animateWithDuration:0.3f animations:^{
        
        self.view.center = CGPointMake(originalPoint.x, originalPoint.y);
        
    } completion:nil];
    
    return YES;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
