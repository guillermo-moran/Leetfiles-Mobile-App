//
//  ViewController.h
//  Leetfiles
//
//  Created by Guillermo Moran on 1/23/15.
//  Copyright (c) 2015 Fr0st Development. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LFAAccountViewController : UIViewController {
    IBOutlet UIView* topBarView;
    IBOutlet UIView* bottomBarView;
    
    IBOutlet UILabel* usernameLabel;
    
    IBOutlet UIProgressView* fileBar;
    IBOutlet UIProgressView* imageBar;
    IBOutlet UIProgressView* pastesBar;
    
    
    
}

-(void)updateProgressBars;

-(IBAction)dismissAccountView:(id)sender;
-(IBAction)logOut:(id)sender;


@end

