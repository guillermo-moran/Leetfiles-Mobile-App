//
//  ViewController.h
//  Leetfiles
//
//  Created by Guillermo Moran on 1/23/15.
//  Copyright (c) 2015 Fr0st Development. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    IBOutlet UIView* topBarView;
    IBOutlet UILabel* leetfilesTitle;
    IBOutlet UIView* bottomBarView;
    CGPoint originalPoint;
    
    IBOutlet UIButton* accountButton;
    
    IBOutlet UISegmentedControl* uploadOptionsControl;
    IBOutlet UIButton* uploadButton;
    IBOutlet UIButton* linkButton;
    IBOutlet UIButton* hideKBButton;
    
    IBOutlet UIButton* imageButton;
    IBOutlet UIImageView* imagePreview;
    
    IBOutlet UITextView* pasteTextView;
    
    
    IBOutlet UIActivityIndicatorView* loadingView;
    
    UIImage* _selectedImage;
    NSString* uploadLink;
}
@property(nonatomic, retain)UIImage* selectedImage;


-(IBAction)manageAccount:(id)sender;
-(IBAction)switchUploadMethod:(id)sender;

-(IBAction)hideKeyboard;

-(IBAction)pickImage:(id)sender;
-(void)showImagePicker;
-(void)showCamera;

-(IBAction)uploadData:(id)sender;
-(IBAction)share:(id)sender;

-(void)copyLink;
-(void)openInSafari;

-(void)didStartUpload:(NSNotification*)notification;
-(void)didFinishUpload:(NSNotification*)notification;

@end

