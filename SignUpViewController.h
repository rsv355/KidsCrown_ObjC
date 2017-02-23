//
//  SignUpViewController.h
//  KidsCrown
//
//  Created by webmyne systems on 04/04/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
@property (weak, nonatomic) IBOutlet UITextField *txtMobileNo;
@property (weak, nonatomic) IBOutlet UITextField *txtEmailId;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirmPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtClinicNo;
@property (weak, nonatomic) IBOutlet UITextField *txtRegistrationNo;
- (IBAction)btnSign:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)btnSignUpWithFacebook:(id)sender;
- (IBAction)btnSignUpWithGmail:(id)sender;

@property(strong,nonatomic) NSString *uid;
@property(strong,nonatomic) NSString *fnm;
@property(strong,nonatomic) NSString *lnm;
@property (retain, nonatomic) NSString *dentistNumber;

@end
