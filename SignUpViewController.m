//
//  SignUpViewController.m
//  KidsCrown
//
//  Created by webmyne systems on 04/04/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import "SignUpViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#import "AppDelegate.h"
#import "KidsCrownUrlSchema.h"
#import "UIView+Toast.h"
#import "Reachability.h"

static NSString * const kClientId = @"965550713375-08qf2a21r68gh0jqgjbv6o48lvqlm86h.apps.googleusercontent.com";


@interface SignUpViewController ()<UITextFieldDelegate,GPPSignInDelegate>
{
     FBSDKLoginManager *login1 ;
    UITextField *login;
    NSDictionary *jsonResponse;
    UIToolbar * toolbar;

}
@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
       
    _txtMobileNo.delegate = self;
    _txtRegistrationNo.delegate = self;
   _txtRegistrationNo.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    //--------SIGN UP WITH SOCIAL MEDIA
    
    static NSString * const kClientId = @"965550713375-08qf2a21r68gh0jqgjbv6o48lvqlm86h.apps.googleusercontent.com";
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.shouldFetchGooglePlusUser = YES;
    signIn.shouldFetchGoogleUserEmail = YES;
    signIn.clientID = kClientId;
    signIn.scopes = @[ kGTLAuthScopePlusLogin ];
    signIn.delegate = self;
    
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextField Delegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField==_txtMobileNo)
    {
        
        toolbar  = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
        toolbar.barStyle = UIBarStyleBlackTranslucent;
        toolbar.items = [NSArray arrayWithObjects:
                         [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithSelection:)],
                         nil];
        [toolbar sizeToFit];
        _txtMobileNo.inputAccessoryView = toolbar;
    }
    
    return YES;
}
- (void)doneWithSelection:(id)sender
{
    [self.view endEditing:YES];
    [toolbar removeFromSuperview];
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
 replacementString:(NSString *)string
{
    if(textField == self.txtMobileNo)
    {
        NSString *resultText = [_txtMobileNo.text stringByReplacingCharactersInRange:range
                                                                          withString:string];
        return resultText.length <= 10;
        
    }
    
   else if(textField == self.txtFirstName)
    {
        NSString *resultText = [_txtFirstName.text stringByReplacingCharactersInRange:range
                                                                          withString:string];
        return resultText.length <= 70;
        
    }
    
    else if(textField == self.txtLastName)
    {
        NSString *resultText = [_txtLastName.text stringByReplacingCharactersInRange:range
                                                            withString:string];
        return resultText.length <= 70;
        
    }
    
    else if(textField == self.txtUserName)
    {
        NSString *resultText = [_txtUserName.text stringByReplacingCharactersInRange:range
                                                                          withString:string];
        return resultText.length <= 20;
        
    }
   
    else if(textField == self.txtEmailId)
    {
        NSString *resultText = [_txtEmailId.text stringByReplacingCharactersInRange:range
                                                                          withString:string];
        return resultText.length <= 50;
        
    }
    else if(textField == self.txtPassword)
    {
        NSString *resultText = [_txtPassword.text stringByReplacingCharactersInRange:range
                                                                          withString:string];
        return resultText.length <= 50;
        
    }
    
    else if(textField == self.txtConfirmPassword)
    {
        NSString *resultText = [_txtConfirmPassword.text stringByReplacingCharactersInRange:range
                                                                          withString:string];
        return resultText.length <= 50;
        
    }
    else if(textField == self.txtClinicNo)
    {
        NSString *resultText = [_txtClinicNo.text stringByReplacingCharactersInRange:range
                                                                          withString:string];
        return resultText.length <= 50;
        
    }
    
    else if(textField == self.txtRegistrationNo)
    {
        NSString *resultText = [_txtRegistrationNo.text stringByReplacingCharactersInRange:range
                                                                          withString:string];
        return resultText.length <= 12;
        
    }
    else
    {
        return YES;
    }
}

// keyboard hide on touch outside
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardDidHideNotification object:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    
}
- (void)keyboardWasShown:(NSNotification *)aNotification
{
    
    NSDictionary *userInfo = [aNotification userInfo];
    CGRect keyboardInfoFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGRect windowFrame = [self.view.window convertRect:self.view.frame fromView:self.view];
    CGRect keyboardFrame = CGRectIntersection (windowFrame, keyboardInfoFrame);
    CGRect coveredFrame = [self.view.window convertRect:keyboardFrame toView:self.view];
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake (0.0, 0.0, coveredFrame.size.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    [self.scrollView setContentSize:CGSizeMake (self.scrollView.frame.size.width, self.scrollView.contentSize.height)];
    
}

- (void)keyboardWillBeHidden:(NSNotification *)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

-(void)setTextPlaceholders{
    
    UIColor *color = [UIColor grayColor];
    
    self.txtFirstName.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"First Name" attributes:@{NSForegroundColorAttributeName : color}];
     self.txtLastName.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"Last Name" attributes:@{NSForegroundColorAttributeName : color}];
     self.txtUserName.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"User Name" attributes:@{NSForegroundColorAttributeName : color}];
     self.txtMobileNo.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"Mobile No" attributes:@{NSForegroundColorAttributeName : color}];
     self.txtEmailId.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"Email Id" attributes:@{NSForegroundColorAttributeName : color}];
    self.txtPassword.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"Password" attributes:@{NSForegroundColorAttributeName : color}];
    self.txtConfirmPassword.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"Confirm Password" attributes:@{NSForegroundColorAttributeName : color}];
    self.txtClinicNo.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"Clinic Number" attributes:@{NSForegroundColorAttributeName : color}];
    self.txtRegistrationNo.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"Registration Number" attributes:@{NSForegroundColorAttributeName : color}];


}

-(BOOL) validateEmail:(NSString*) emailString{
    NSString *regExPattern = @"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$";
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:emailString options:0 range:NSMakeRange(0, [emailString length])];
   
    if (regExMatches == 0){
        return NO;
    }
    else
        return YES;
}

- (IBAction)btnSign:(id)sender {
    
    [self.view endEditing:YES];
    if([_txtEmailId.text isEqualToString:@""] || [_txtLastName.text isEqualToString:@""] || [_txtFirstName.text isEqualToString:@""]|| [_txtUserName.text isEqualToString:@""]|| [_txtClinicNo.text isEqualToString:@""]|| [_txtRegistrationNo.text isEqualToString:@""]|| [_txtPassword.text isEqualToString:@""]|| [_txtConfirmPassword.text isEqualToString:@""]|| [_txtMobileNo.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"KidsCrown" message:@"Please enter all fields." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (![[self.txtPassword text] isEqualToString:[self.txtConfirmPassword text]])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"KidsCrown" message:@"Entered Passwords does not match." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if ([self.txtMobileNo.text length]!=10)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"KidsCrown" message:@"Please enter valid phone no." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if(![self validateEmail:self.txtEmailId.text]){
        UIAlertView *emailvalid = [[UIAlertView alloc]initWithTitle:@"KidsCrown" message:@"Please Enter Valid E-mail Address." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [emailvalid show];
        
        self.txtEmailId.textColor = [UIColor redColor];
    }
    else if([_txtPassword.text length] < 6 || [_txtConfirmPassword.text length] < 6){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"KidsCrown" message:@"Please Enter at least 6 Digit Password." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        
    }


        else
    {
        
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NSString *firstname = self.txtFirstName.text;
        NSString *lastname = self.txtLastName.text;
        NSString *username = self.txtUserName.text;
        NSString *mobileno = self.txtMobileNo.text;
        NSString *emailid = self.txtEmailId.text;
        NSString *password = self.txtPassword.text;
        NSString *clinicname = self.txtClinicNo.text;
        NSString *registerno = self.txtRegistrationNo.text;
        NSString *strDeviceID = [[NSUserDefaults standardUserDefaults]valueForKey:@"UDID"];
        
        //using post
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];

        NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                                clinicname,@"ClinicName",
                                strDeviceID,@"DeviceID",
                                emailid,@"EmailID",
                                @"",@"FacebookID",
                                firstname,@"FirstName",
                                @"0",@"GCMToken",
                                @"",@"GoogleID",
                                lastname,@"LastName",
                                @"1",@"LoginVia",
                                mobileno,@"MobileNo",
                                @"I",@"MobileOS",
                                password,@"Password",
                                registerno,@"RegistrationNumber",
                                username,@"UserName",nil];
        
        NSString *strURL = [NSString stringWithFormat:@"%@%@",NEW_BASE_URL,NEW_LOGIN_SIGNUP_URL];
        [manager POST:strURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *dictionary = responseObject;
            
            if ([[[dictionary objectForKey:@"Response"] valueForKey:@"ResponseCode"] integerValue] == 1)
            {
                [self fetchDataResponse:dictionary];
                
            }
            else
            {
                NSString *strMsg = [[dictionary objectForKey:@"Response"]valueForKey:@"ResponseMsg"];
                [self.view makeToast:strMsg];
            }
       
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
           
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self.view makeToast:@"Network Error...!!"];
        }];
        
     
        [self.view endEditing:YES];
    }
}
- (void)fetchDataResponse:(NSDictionary*)dictionary {
    
    NSString *strUserId = [[dictionary objectForKey:@"Data"]valueForKey:@"UserID"];
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:strUserId forKey:@"userID"];
    [def synchronize];
    
    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WELCOME"];
    
    [self presentViewController:viewController animated:YES completion:nil];
    
}

- (IBAction)btnSignUpWithFacebook:(id)sender {
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Information"
                                          message:@"Registration Number"
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = NSLocalizedString(@"for:eg A123456", @"");
     }];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"NEXT", @"")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   login = alertController.textFields.firstObject;
                                   
                                   self.dentistNumber=login.text;
                                   
                                   if ([self checkValidation:login])
                                   {
                                       
                                    }
                                   
                               }];
    [alertController addAction:okAction];
    
    
    

}
- (BOOL)checkValidation:(UITextField *)textField
{
    if ((self.txtRegistrationNo.text.length >12))
    {
        return FALSE;
    }
    else
    {
       
        NSString *rejex = @"[A-Z0-9\\\\/#/_-]*";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", rejex];
        
        if ([emailTest evaluateWithObject:textField.text])
        {
            
            return TRUE;
        }
        else
        {
            return false;
        }
    }
    return TRUE;
}
-(void)FBloginCall
{
    login1 = [[FBSDKLoginManager alloc] init];
    [login1
     logInWithReadPermissions: @[@"public_profile", @"email", @"user_friends"]
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
            
             UIAlertView *errMsg=[[UIAlertView alloc]initWithTitle:@"Error!" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [errMsg show];
             
         } else if (result.isCancelled) {
             
             UIAlertView *canMsg=[[UIAlertView alloc]initWithTitle:@"Information" message:@"User has cancelled authorization" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
             [canMsg show];
         } else {
             
             if ([FBSDKAccessToken currentAccessToken]) {
                 FBSDKGraphRequest *basicRequest=[[FBSDKGraphRequest alloc]initWithGraphPath:@"me" parameters:@{@"fields": @"id,name,friends,email,first_name,last_name,about,birthday"} HTTPMethod:@"GET"];
                 [basicRequest startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                     
                     
                     NSDictionary *dict = (NSDictionary*)result;
                     
                     if ([dict objectForKey:@"email"])
                     {
                         self.uid=[dict objectForKey:@"email"];
                     }
                     
                     
                     if ([dict objectForKey:@"first_name"])
                     {
                         self.fnm=[dict objectForKey:@"first_name"];
                     }
                     
                     if ([dict objectForKey:@"last_name"])
                     {
                         self.lnm=[dict objectForKey:@"last_name"];
                     }
                     
                     
                     [self CallWebServiceFacebook];
                     
                 }];
                 
             }
             
         }
     }];
    return;
    
}
-(void)CallWebServiceFacebook
{
    
    NSString *requestedURL=[NSString stringWithFormat:@"%@%@/%@/%@/%@/f/%@/%@",Kids_Crown_BASEURL,SignUpWithSocialMedia,self.uid,self.fnm,self.lnm, self.dentistNumber,@"i"];

    NSURL *url = [NSURL URLWithString:requestedURL];
    NSURLResponse *response;
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:url];
    NSData *GETReply = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:nil];
    NSString *theReply = [[NSString alloc] initWithBytes:[GETReply bytes] length:[GETReply length] encoding: NSASCIIStringEncoding];
    
    NSDictionary *dict=[[NSDictionary alloc]init];
    NSData *data = [theReply dataUsingEncoding:NSUTF8StringEncoding];
    
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    dict = [NSDictionary dictionaryWithDictionary:json];
    [self fetchDataResponse:dict];

}

- (IBAction)btnSignUpWithGmail:(id)sender {
    
    //sign in with google sdk
    if ([[AppDelegate appDelegate]isReachable])
    {
       
        
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Information"
                                              message:@"Registration Number"
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
         {
             textField.placeholder = NSLocalizedString(@"for:eg A123456", @"");
         }];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"NEXT", @"")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       login = alertController.textFields.firstObject;
                                      
                                       self.dentistNumber=login.text;
                                       if ([self checkValidation:login])
                                       {
                                           
                                           
                                           if ([[AppDelegate appDelegate]isReachable])
                                           {
                                              [self GooglePlusCall];
                                           }
                                           
                                           else
                                               [self.view makeToast:@"Check your internet connection"];
                                           
                                       }
                                       
                                   }];
        [alertController addAction:okAction];
        
        
        
    }
    else
    {
        [self.view makeToast:@"Check your internet connection"];
    }
  

}

-(void)CallWebServiceGooglePlus
{
    
    NSString *requestedURL=[NSString stringWithFormat:@"%@%@/%@/%@/%@/g/%@/%@",Kids_Crown_BASEURL,SignUpWithSocialMedia,_uid,_fnm,_lnm,self.dentistNumber,@"i"];
   
    NSURL *url = [NSURL URLWithString:requestedURL];
    NSURLResponse *response;
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:url];
    NSData *GETReply = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:nil];
    NSString *theReply = [[NSString alloc] initWithBytes:[GETReply bytes] length:[GETReply length] encoding: NSASCIIStringEncoding];
   
    
    NSDictionary *dict=[[NSDictionary alloc]init];
    NSData *data = [theReply dataUsingEncoding:NSUTF8StringEncoding];
    
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    dict = [NSDictionary dictionaryWithDictionary:json];
    [self fetchDataResponse:dict];

}

-(void)GooglePlusCall
{
    GPPSignIn *googleSignIn = [GPPSignIn sharedInstance];
    googleSignIn.shouldFetchGooglePlusUser = YES;
    googleSignIn.shouldFetchGoogleUserEmail = YES;
    googleSignIn.clientID = @"965550713375-08qf2a21r68gh0jqgjbv6o48lvqlm86h.apps.googleusercontent.com";
    googleSignIn.scopes = @[ kGTLAuthScopePlusLogin ];
    googleSignIn.delegate = self;
    
    [googleSignIn authenticate];
}

#pragma mark - Google+ Methods
-(void)refreshInterfaceBasedOnSignIn {
    if ([[GPPSignIn sharedInstance] authentication]) {
        // The user is signed in.
        //self.signInButton.hidden = YES;
        // Perform other actions here, such as showing a sign-out button
    } else {
        //self.signInButton.hidden = NO;
        // Perform other actions here
    }
}


- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error {
   
    if (error) {
      
        UIAlertView *alrt=[[UIAlertView alloc]initWithTitle:@"Error!" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alrt show];
        
        
        // Do some error handling here.
    } else {
        
        
        GTLServicePlus* plusService = [[GTLServicePlus alloc] init];
        plusService.retryEnabled = YES;
        
        [plusService setAuthorizer:[GPPSignIn sharedInstance].authentication];
        
        
        
        
        GTLQueryPlus *query =
        [GTLQueryPlus queryForPeopleListWithUserId:@"me"
                                        collection:kGTLPlusCollectionVisible];
        [plusService executeQuery:query
                completionHandler:^(GTLServiceTicket *ticket,
                                    GTLPlusPeopleFeed *peopleFeed,
                                    NSError *error) {
                    if (error) {
                        GTMLoggerError(@"Error: %@", error);
                    } else {
                        // Get an array of people from GTLPlusPeopleFeed
                        //   NSArray* peopleList = peopleFeed.items;
                        
                    }
                }];
        
        GTLQueryPlus *query1 = [GTLQueryPlus queryForPeopleGetWithUserId:@"me"];
        
        [plusService executeQuery:query1
                completionHandler:^(GTLServiceTicket *ticket,
                                    GTLPlusPerson *person,
                                    NSError *error) {
                    if (error) {
                        GTMLoggerError(@"Error: %@", error);
                    } else {
                        
                        self.uid=[GPPSignIn sharedInstance].authentication.userEmail ;
                        self.fnm=person.name.givenName;
                        self.lnm=person.name.familyName;
                        
                        
                        [self CallWebServiceGooglePlus];
                        
                    }
                    
                }];
    }
}

@end
