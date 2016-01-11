//
//  ViewController.h
//  Leetfiles
//
//  Created by Guillermo Moran on 1/23/15.
//  Copyright (c) 2015 Fr0st Development. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LFALoginViewController : UIViewController <UITextFieldDelegate> {
    IBOutlet UIView* topBarView;
    IBOutlet UIView* bottomBarView;
    
    CGPoint originalPoint;
    
    IBOutlet UIButton* cancelButton;
    
    IBOutlet UITextField* usernameField;
    IBOutlet UITextField* passwordField;
}

-(IBAction)attemptLogin:(id)sender;
-(IBAction)dismissLoginView:(id)sender;


@end

