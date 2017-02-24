//
//  LoginViewController.m
//  KidsCrown
//
//  Created by webmyne systems on 04/04/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import "LoginViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
//#import "NSString+HTML.h"
//#import "GTMNSString+HTML.h"
//#import "NSMutableDictionary+DictionaryWithValidation.h"


static NSString * const kClientId = @"965550713375-08qf2a21r68gh0jqgjbv6o48lvqlm86h.apps.googleusercontent.com";


@interface LoginViewController ()<GPPSignInDelegate,UIAlertViewDelegate,UITextFieldDelegate>
{
    NSString *email,*socialName,*password;
    NSMutableDictionary *userDataDict;
    int loginViaValue;
    
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        // Do any additional setup after loading the view.
    
    _txtUserName.delegate = self;
    _txtPassword.delegate = self;
    
    loginViaValue = 0;
    static NSString * const kClientId = @"965550713375-08qf2a21r68gh0jqgjbv6o48lvqlm86h.apps.googleusercontent.com";
   
    
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.shouldFetchGooglePlusUser = YES;
       signIn.clientID = kClientId;
    
   
    signIn.scopes = @[ kGTLAuthScopePlusLogin ];
    signIn.delegate = self;
   
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField == self.txtUserName)
    {
        NSString *resultText = [_txtUserName.text stringByReplacingCharactersInRange:range
                                                                          withString:string];
        return resultText.length <= 50;
        
    }
    
    else if(textField == self.txtPassword)
    {
        NSString *resultText = [_txtPassword.text stringByReplacingCharactersInRange:range
                                                                          withString:string];
        return resultText.length <= 50;
        
    }
    
    else
    {
        return YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
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

- (IBAction)btnSignIn:(id)sender {

    [self.view endEditing:YES];
    
    if ([self.txtUserName.text length]==0||[self.txtPassword.text length]==0) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"KidsCrown" message:@"Please enter Details." delegate:(id)self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = 101;
        [alert show];
    }
    else if ([self.txtPassword.text length] < 6)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"KidsCrown" message:@"Please Enter at least 6 Digit Password." delegate:(id)self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = 101;
        [alert show];
    }
    else
    {
        loginViaValue = 1;
        [self WebServiceCalling:@"1" forSocial:@"NO" forDictionary:nil];
    
    }
    
}


-(void)WebServiceCalling:(NSString *)strValue forSocial:(NSString *)strSocial forDictionary:(NSDictionary *)dict
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *strDeviceID = [[NSUserDefaults standardUserDefaults]valueForKey:@"UDID"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSDictionary *parameter;
    
    if ([strValue isEqualToString:@"1"])
    {
        email=[self.txtUserName text];
        password=[self.txtPassword text];
        
        parameter = [[NSDictionary alloc] initWithObjectsAndKeys:
                     @"",@"ClinicName",
                     strDeviceID,@"DeviceID",
                     @"",@"EmailID",
                     @"",@"FacebookID",
                     @"",@"FirstName",
                     @"0",@"GCMToken",
                     @"",@"GoogleID",
                     @"",@"LastName",
                     strValue,@"LoginVia",
                     @"",@"MobileNo",
                     @"I",@"MobileOS",
                     password,@"Password",
                     @"",@"RegistrationNumber",
                     email,@"UserName",nil];
        
    }
    
    else
    {
        NSString *strUserName = [dict objectForKey:@"name"];
        NSString *strFirstName = [dict objectForKey:@"first_name"];
        NSString *strLastName = [dict objectForKey:@"last_name"];
        NSString *strSocialId = [dict objectForKey:@"id"];
        NSString *strEmail = [dict objectForKey:@"email"];
        
        if ([strSocialId length] == 0) {
            [self.view makeToast:@"Cant connect...!!"];
            return;
        }
        
        if ([strEmail length] == 0) {
            strEmail = @"";
        } else {
            strEmail = [dict objectForKey:@"email"];
        }
        
        
        if ([strValue isEqualToString:@"2"]) {
            parameter = [[NSDictionary alloc]initWithObjectsAndKeys:
                        @"",@"ClinicName",
                        strDeviceID,@"DeviceID",
                        @"",@"EmailID",
                        strSocialId,@"FacebookID",
                        strFirstName,@"FirstName",
                        @"0",@"GCMToken",
                        @"",@"GoogleID",
                        strLastName,@"LastName",
                        strValue,@"LoginVia",
                        @"",@"MobileNo",
                        @"I",@"MobileOS",
                        @"",@"Password",
                        @"",@"RegistrationNumber",
                        strEmail,@"UserName",nil];
        }
        
        else if ([strValue isEqualToString:@"3"]) {
            
            parameter = [[NSDictionary alloc]initWithObjectsAndKeys:
                         @"",@"ClinicName",
                         strDeviceID,@"DeviceID",
                         @"",@"EmailID",
                         @"",@"FacebookID",
                         strFirstName,@"FirstName",
                         @"0",@"GCMToken",
                         strSocialId,@"GoogleID",
                         strLastName,@"LastName",
                         strValue,@"LoginVia",
                         @"",@"MobileNo",
                         @"I",@"MobileOS",
                         @"",@"Password",
                         @"",@"RegistrationNumber",
                         strEmail,@"UserName"
                         , nil];
            
        }
        
    }
    
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@",NEW_BASE_URL,NEW_LOGIN_SIGNUP_URL];
    
    
    [manager POST:strURL parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
        dictionary = responseObject;
        
        
        if ([[[dictionary objectForKey:@"Response"] valueForKey:@"ResponseCode"] integerValue] == 1)
        {
            [self fetchDataResponse:dictionary IsSocial:strSocial];
            
        }
        else
        {
            NSString *strMsg = [[dictionary objectForKey:@"Response"]valueForKey:@"ResponseMsg"];
            
            [self.txtPassword setText:nil];
            [self.txtUserName setText:nil];
            
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


- (void)fetchDataResponse:(NSMutableDictionary*)dictionary IsSocial:(NSString *)str
{
    
//    NSString *strUserId = [[dictionary objectForKey:@"Data"]valueForKey:@"UserID"];
//    NSString *strEmailId = [[dictionary objectForKey:@"Data"]valueForKey:@"EmailID"];

//    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
//    [def setObject:strUserId forKey:@"userID"];
//    [def setObject:strEmailId forKey:@"emailID"];
    
//    [def synchronize];
    
    NSString *strIsSocial = [[dictionary objectForKey:@"Data"]valueForKey:@"IsNewUser"];
    NSString *regNumber = [[dictionary objectForKey:@"Data"] valueForKey:@"RegistrationNumber"];
    
    if ([str isEqualToString:@"YES"] && [strIsSocial boolValue] == 1)
    {

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Kids Crown"
                                                        message:@"Enter Registration Number"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK",nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alert textFieldAtIndex:0].autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
        [alert textFieldAtIndex:0].delegate = self;
        userDataDict = dictionary;
        [alert show];
        
    }
    else if ([regNumber length] == 0){
        
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Kids Crown"
                                                        message:@"Enter Registration Number"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK",nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alert textFieldAtIndex:0].autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
        [alert textFieldAtIndex:0].delegate = self;
        userDataDict = dictionary;
        [alert show];

        
    }
    else
    {
        UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WELCOME"];
        
        NSString *strUserId = [[dictionary objectForKey:@"Data"]valueForKey:@"UserID"];
         NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        [def setObject:strUserId forKey:@"userID"];
        [def synchronize];


        [self presentViewController:viewController animated:YES completion:nil];

    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag!= 101) {
    
    NSString *strRegistrationNumber = [alertView textFieldAtIndex:0].text;
    
    
    NSString *strUserName = [[userDataDict objectForKey:@"Data"] objectForKey:@"UserName"];
    NSString *strFirstName = [[userDataDict objectForKey:@"Data"] objectForKey:@"FirstName"];
    NSString *strLastName = [[userDataDict objectForKey:@"Data"] objectForKey:@"LastName"];
    NSString *strSocialId = [[userDataDict  objectForKey:@"Data"] objectForKey:@"id"];
    NSString *strMobNo = [[userDataDict objectForKey:@"Data"] objectForKey:@"MobileNo"];
    
    email = [[userDataDict objectForKey:@"Data"] objectForKey:@"EmailID"];
    password = [[userDataDict objectForKey:@"Data"] objectForKey:@"Password"];
    
    if ([email length] == 0) {
        email = @"";
    }
    
    if ([password length] == 0) {
        password = @"";
    }
    
    if ([strMobNo length] == 0) {
        strMobNo = @"";
    }
    
    if ([strRegistrationNumber length] == 0) {
        [self.view makeToast:@"Please Enter Registration Number...!!"];
        return;
    }
    else if ([strRegistrationNumber length] > 12){
        
        [self.view makeToast:@"Registration number length should be 12...!!"];
        return;
    }
    else {
        
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NSString *strUserName = [[userDataDict objectForKey:@"Data"] objectForKey:@"UserName"];
        NSString *strFirstName = [[userDataDict objectForKey:@"Data"] objectForKey:@"FirstName"];
        NSString *strLastName = [[userDataDict objectForKey:@"Data"] objectForKey:@"LastName"];
        NSString *strMobNo = [[userDataDict objectForKey:@"Data"] objectForKey:@"MobileNo"];
        NSString *strUserId = [[userDataDict objectForKey:@"Data"] objectForKey:@"UserID"];
        
        
        //using post
        NSDictionary *params ;
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
     
        params =[[NSDictionary alloc]initWithObjectsAndKeys:
                @"",@"ClinicName",
                email,@"EmailID",
                strFirstName,@"FirstName",
                strLastName,@"LastName",
                strMobNo,@"MobileNo",
                @"",@"Password",
                strRegistrationNumber,@"RegistrationNumber",
                strUserId,@"UserID",
                 strUserName,@"UserName",nil];
        
        NSString *strURL = [NSString stringWithFormat:@"%@%@",NEW_BASE_URL,UPDATE_PROFILE_DETAIL];
        
        
        [manager POST:strURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *dictionary = responseObject;
            
            if ([[[dictionary objectForKey:@"Response"] valueForKey:@"ResponseCode"] integerValue] == 1)
            {
                NSString *strMsg = [[dictionary objectForKey:@"Response"]valueForKey:@"ResponseMsg"];
                [self.view makeToast:strMsg];
         
                    NSString *strUserId = [[dictionary objectForKey:@"Data"]valueForKey:@"UserID"];
                    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
                    [def setObject:strUserId forKey:@"userID"];
                    [def synchronize];

                UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WELCOME"];
                
                [self presentViewController:viewController animated:YES completion:nil];
                
                
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
    
    
}


/*
- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    if (alertView.alertViewStyle == UIAlertViewStylePlainTextInput)
    {
        if([[[alertView textFieldAtIndex:0] text] length] == 0 )
        {
            return NO;
        }
        else if([[[alertView textFieldAtIndex:0] text] length] > 12  )
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    else{
        return YES;
    }
}
*/
- (IBAction)btnSignInFacebook:(id)sender {
    
    socialName=@"f";
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions: @[@"public_profile", @"email", @"user_friends"]
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
            
             UIAlertView *errMsg=[[UIAlertView alloc]initWithTitle:@"Error!" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [errMsg show];
             
         } else if (result.isCancelled) {
           
             UIAlertView *canMsg=[[UIAlertView alloc]initWithTitle:@"Information" message:@"User has cancelled authorization" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
             [canMsg show];
         } else {
             

             if ([FBSDKAccessToken currentAccessToken])
             {

                 FBSDKGraphRequest *basicRequest=[[FBSDKGraphRequest alloc]initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, link, first_name, last_name, picture.type(large), email, birthday, bio ,location ,friends ,hometown , friendlists"}];
                 [basicRequest startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                     
                     NSMutableDictionary *fbDict = [[NSMutableDictionary alloc]init];
                     [fbDict removeAllObjects];
                     fbDict = (NSMutableDictionary*)result;
                     
                     
                     if ([fbDict objectForKey:@"email"])
                     {
                         email=[fbDict objectForKey:@"email"];
                        
//                          [[NSUserDefaults standardUserDefaults]setObject:email forKey:@"emailID"];
                     }
                  
                     
//                     [self CallWebServiceFacebook];
                     loginViaValue = 2;
                     
                     [self WebServiceCalling:@"2" forSocial:@"YES" forDictionary:fbDict] ;
                     
                 }];
                 
             }
             
         }
     }];
    return;
    

}
-(void) CallWebServiceFacebook{

    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    [manager GET:[NSString stringWithFormat:LoginWithSocialMedia,Kids_Crown_BASEURL,email,password]  parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        
//        [self fetchDataResponse:dic1];
       
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Kid's Crown" message:@"Network error. Please try again later" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [errorAlert show];
    }];
    


}


- (IBAction)btnGooglePlus:(id)sender {
    
    socialName=@"g";
    
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



//- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
//                   error: (NSError *) error {
//}
//

- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error {
       if (error) {
     
        UIAlertView *alrt=[[UIAlertView alloc]initWithTitle:@"Error!" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alrt show];
        
        
       
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
                        
                        email=[GPPSignIn sharedInstance].authentication.userEmail;
//                         [[NSUserDefaults standardUserDefaults]setObject:email forKey:@"emailID"];
                        NSString *strSocialId = person.identifier;
                        NSString *strUserName = [person.name.givenName stringByAppendingFormat:@" %@",person.name.familyName];
                        NSString *strFirstName = person.name.givenName;
                        NSString *strLastName = person.name.familyName;
                        
                        NSDictionary *Dict = [[NSDictionary alloc]initWithObjectsAndKeys:
                                                   email,@"email",
                                                   strSocialId,@"id",
                                                   strUserName,@"name",
                                                   strFirstName,@"first_name",
                                                   strLastName,@"last_name"
                                                   ,nil];
                        
                
//                      [self CallWebServiceFacebook];
                        loginViaValue = 3;
                        [self WebServiceCalling:@"3" forSocial:@"YES" forDictionary:Dict];

                        
                    }
                }];
    }
}


- (IBAction)btnForgetPassword:(id)sender {
    UIViewController *viewcontroller=[self.storyboard instantiateViewControllerWithIdentifier:@"FORGET_PASSWORD"];
    [self presentViewController:viewcontroller animated:YES completion:nil];
}




@end
