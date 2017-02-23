//
//  LoginViewController.h
//  KidsCrown
//
//  Created by webmyne systems on 04/04/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KidsCrownUrlSchema.h"
#import "DataBaseFile.h"

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

- (IBAction)btnSignIn:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)btnSignInFacebook:(id)sender;
- (IBAction)btnGooglePlus:(id)sender;

@property(strong,nonatomic) NSString *uid;
@property(strong,nonatomic) NSString *fnm;
@property(strong,nonatomic) NSString *lnm;
@property(strong,nonatomic) NSString *dentistNumber;
- (IBAction)btnForgetPassword:(id)sender;

//@property(strong,nonatomic)DataBaseFile *dbHandler;
//@property(strong,nonatomic)NSMutableArray *arrDB;
//
//@property(strong,nonatomic)NSMutableArray *productImgUrl;
//
//@property(strong,nonatomic)NSMutableArray *productPrice;
//
//@property (strong, nonatomic) NSMutableArray *productTableData;
//
//@property (strong, nonatomic) NSMutableArray *productPriceForMobile;
//@property(strong,nonatomic)NSMutableArray *arrProductData;
//@property (nonatomic,assign) int productCountFromDb;
@end
