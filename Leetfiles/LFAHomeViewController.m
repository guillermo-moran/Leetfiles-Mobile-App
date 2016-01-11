//
//  ViewController.m
//  Leetfiles
//
//  Created by Guillermo Moran on 1/23/15.
//  Copyright (c) 2015 Fr0st Development. All rights reserved.
//
#import "LFAMacros.h"
#import "LFAHomeViewController.h"
#import "LFAConnector.h"

#import "LFALoginViewController.h"

#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface ViewController ()

@end

@implementation ViewController
@synthesize selectedImage = _selectedImage;

-(IBAction)switchUploadMethod:(id)sender {
    
    [self hideKeyboard];
    
    if (uploadOptionsControl.selectedSegmentIndex == 0) {
        
        [UIView animateWithDuration:0.3f animations:^{
            //Hide shit First
            [pasteTextView setAlpha:0.0f];
            
        } completion:^(BOOL finished) {
            
            //Now show other shit
            [UIView animateWithDuration:0.3f animations:^{
                
                [imageButton setAlpha:1.0];
                [imagePreview setAlpha:1.0];
                
            } completion:nil];
            
        }];
    }
    
    else {
        
        [UIView animateWithDuration:0.3f animations:^{
            //Hide shit First
            [imageButton setAlpha:0.0];
            [imagePreview setAlpha:0.0];
            
        } completion:^(BOOL finished) {
            
            //Now show other shit
            [UIView animateWithDuration:0.3f animations:^{
                
                [pasteTextView setAlpha:1.0];
                
            } completion:nil];
            
        }];
        
    }
}

-(IBAction)share:(UIButton*)sender {
   
    UIActionSheet *popupQuery = [[UIActionSheet alloc]
                                 initWithTitle:@"Share"
                                 delegate:self cancelButtonTitle:@"Cancel"
                                 destructiveButtonTitle:nil
                                 otherButtonTitles:@"Copy Link", @"Open in Safari", nil];
    
    popupQuery.tag = 21;
    
    [popupQuery showInView:self.view];
    
}

-(void)copyLink {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = linkButton.titleLabel.text;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Copied Link!"
                                                    message:@"Link has been copied to clipboard."
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

-(void)openInSafari {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",uploadLink]]];
}

-(void)didStartUpload:(NSNotification*)notification {
    
    NSLog(@"Upload Starting");
    
    linkButton.hidden = YES;
    uploadButton.hidden = YES;
    loadingView.hidden = NO;
    [loadingView startAnimating];
}

-(void)didFinishUpload:(NSNotification*) notification {
    
    NSLog(@"Upload Finished");
    
    [linkButton setHidden:NO];
    [linkButton setTitle:uploadLink forState:UIControlStateNormal];
    
    loadingView.hidden = YES;
    uploadButton.hidden = NO;
}

-(IBAction)manageAccount:(id)sender {
    
    if (!internetAvailable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection!"
                                                        message:@"This page is not available. Please connect to the internet."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if (!LFA_IS_LOGGED_IN) {
        
        [self performSegueWithIdentifier:@"presentLoginView" sender:self];
    }
    else {
        [self performSegueWithIdentifier:@"presentAccountView" sender:self];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didStartUpload:)
                                                 name:@"Upload Started"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didFinishUpload:)
                                                 name:@"Upload Finished"
                                               object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    
    [hideKBButton setHidden:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    originalPoint = self.view.center;
    
    self.selectedImage = nil;
    loadingView.hidden = YES;
    
    topBarView.layer.cornerRadius = 5;
    topBarView.layer.masksToBounds = YES;
    
    if (!internetAvailable) {
        leetfilesTitle.text = @"Offline";
    }
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)keyboardDidShow:(NSNotification *)note
{
    
    [UIView animateWithDuration:0.3f animations:^{
        
        [hideKBButton setHidden:NO];
        self.view.center = CGPointMake(originalPoint.x, originalPoint.y - 90);
        
    } completion:nil];
    
    
}

-(IBAction)hideKeyboard {
    [UIView animateWithDuration:0.3f animations:^{
        
        self.view.center = CGPointMake(originalPoint.x, originalPoint.y);
        [hideKBButton setHidden:YES];
        
    } completion:nil];
    
    [pasteTextView resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

//Picker

-(IBAction)uploadData:(id)sender {
    
    if (!internetAvailable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection!"
                                                        message:@"Please connect to the internet before attempting an upload."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if (uploadOptionsControl.selectedSegmentIndex == 0) {
        //Upload Photo
        
        if (self.selectedImage != nil) {
            
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"Upload Started"
             object:self];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                NSString* fileLink = [LFAConnector uploadImage:self.selectedImage withAPIKey:keyForUser(LFA_KEYCHAIN_USER, LFA_KEYCHAIN_PASS)];
                
                uploadLink = fileLink;
                
                NSLog(@"%@",fileLink);
                
                
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"Upload Finished"
                 object:self];
                
            });
        }
        
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Image Selected"
                                                            message:@"Please select an image first."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    
    else {
        //Upload Paste
        
        if (![pasteTextView.text isEqualToString:@""] || pasteTextView.text != nil) {
            
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"Upload Started"
             object:self];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                NSString* fileLink = [LFAConnector uploadPaste:pasteTextView.text withAPIKey:keyForUser(LFA_KEYCHAIN_USER, LFA_KEYCHAIN_PASS)];
                
                uploadLink = fileLink;
                
                NSLog(@"%@",fileLink);
                
                
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"Upload Finished"
                 object:self];
                
            });
        }
        
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Paste is empty"
                                                            message:@"You may not upload an empty paste."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    
    
}

-(IBAction)pickImage:(id)sender {
    
    if (![UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeCamera] && [UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary])
        
    {
        [self showImagePicker];
        return;
    }
    
    UIActionSheet *popupQuery = [[UIActionSheet alloc]
                                 initWithTitle:@"Select Image From"
                                 delegate:self cancelButtonTitle:@"Cancel"
                                 destructiveButtonTitle:nil
                                 otherButtonTitles:@"Photo Library", @"Camera", nil];
    
    popupQuery.tag = 20;
    
    [popupQuery showInView:self.view];
}

-(void)showImagePicker {
    UIImagePickerController *imagePicker =
    [[UIImagePickerController alloc] init];
    
    imagePicker.navigationBar.tintColor = [UIColor whiteColor];
    imagePicker.navigationBar.barStyle = UIBarStyleBlack;
    imagePicker.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
    
    imagePicker.delegate = self;
    
    imagePicker.sourceType =
    UIImagePickerControllerSourceTypePhotoLibrary;
    
    imagePicker.mediaTypes =
    @[(NSString *) kUTTypeImage];
    
    imagePicker.allowsEditing = NO;
    [self presentViewController:imagePicker
                       animated:YES completion:nil];
}

-(void)showCamera {
    UIImagePickerController *imagePicker =
    [[UIImagePickerController alloc] init];
    
    imagePicker.delegate = self;
    
    imagePicker.sourceType =
    UIImagePickerControllerSourceTypeCamera;
    
    imagePicker.mediaTypes =
    @[(NSString *) kUTTypeImage];
    
    imagePicker.allowsEditing = NO;
    [self presentViewController:imagePicker
                       animated:YES completion:nil];
}

-(void)imagePickerController: (UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // Code here to work with media
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.selectedImage = image;
    [imageButton setTitle:@"" forState:UIControlStateNormal];
    imageButton.backgroundColor = [UIColor clearColor];
    [imagePreview setImage:image];
    //
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel: (UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (actionSheet.tag == 20) {
        switch (buttonIndex) {
            case 0:
                [self showImagePicker];
                break;
            case 1:
                [self showCamera];
                break;
                
                break;
        }
    }
    if (actionSheet.tag == 21) {
        switch (buttonIndex) {
            case 0:
                
                [self copyLink];
                
                break;
            case 1:
                [self openInSafari];
                
                break;
                
                break;
        }
    }
    
    
}

@end
