//
//  ProfileViewController.m
//  KidsCrown
//
//  Created by webmyne systems on 07/04/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import "ProfileViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "KidsCrownUrlSchema.h"
#import "RPFloatingPlaceholderTextField.h"

@interface ProfileViewController ()<UITextFieldDelegate>
{
    UIToolbar * toolbar;
}
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _txtRegistrationNo.delegate = self;
    
     _txtRegistrationNo.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    
    _txtEmailId.enabled = false;
    _txtRegistrationNo.enabled = false;
    
    NSString *currentAppVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];

    
    _txtMobileNo.delegate = self;
    
    [self setTextPlaceholders];
    
    [self fetchUserProfileDetails];
    
    // [self fetchUserProfile];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextField Delegate

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

-(void)setTextPlaceholders{
   /*
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
    */
    
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


-(void)fetchUserProfileDetails{
    
    NSString *userId=[[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
//    NSString *userId=@"2";
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    // NSString *str=[NSString stringWithFormat:FETCHUSERDETAILS,email,socialName];
    
    
    [manager GET:[NSString stringWithFormat:@"%@%@%@",NEW_BASE_URL,FETCH_PROFILE_DETAIL,userId]  parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        [self fetchDataResponse:dic1];
        
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Kid's Crown" message:@"Network error. Please try again later" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [errorAlert show];
    }];
    
    
    
}


- (void)fetchDataResponse:(NSDictionary*)dictionary {
    //    int i = 1;
    //    NSNumber *no1 = [NSNumber numberWithInt:i];
    
    float j = 1;
    NSNumber *no2 = [NSNumber numberWithFloat:j];
    
    
    if([[[dictionary valueForKey:@"Response"] valueForKey:@"ResponseCode"]isEqualToNumber:no2])   //([dictionary valueForKey:@"Data"])
    {
        
        NSDictionary *dataDictionary=[dictionary valueForKey:@"Data"];
        NSDictionary *dc=dataDictionary;//[dataArr objectAtIndex:0];
        
        if([dc[@"FirstName"] isKindOfClass:[NSNull class]]){
            [self.txtFirstName setText:@""];
        }else{
            [self.txtFirstName setText:dc[@"FirstName"]];
        }
        
        
        if([dc[@"LastName"] isKindOfClass:[NSNull class]]){
            [self.txtLastName setText:@""];
        }else{
            [self.txtLastName setText:dc[@"LastName"]];
        }
        
        if([dc[@"UserName"] isKindOfClass:[NSNull class]]){
            [self.txtUserName setText:@""];
            _txtUserName.enabled = true;
        }else{
            [self.txtUserName setText:dc[@"UserName"]];
            _txtUserName.enabled = false;
        }
        
        if([dc[@"EmailID"] isKindOfClass:[NSNull class]]){
            [self.txtEmailId setText:@""];
        }else{
            [self.txtEmailId setText:dc[@"EmailID"]];
        }
        
        if([dc[@"ClinicName"] isKindOfClass:[NSNull class]]){
            [self.txtClinicNo setText:@""];
        }else{
            [self.txtClinicNo setText:dc[@"ClinicName"]];
        }
        
        if([dc[@"RegistrationNumber"] isKindOfClass:[NSNull class]]){
            [self.txtRegistrationNo setText:@""];
        }else{
            [self.txtRegistrationNo setText:dc[@"RegistrationNumber"]];
        }
        
        if([dc[@"Password"] isKindOfClass:[NSNull class]]){
            [self.txtPassword setText:@""];
        }else{
            [self.txtPassword setText:dc[@"Password"]];
        }
        
        if([dc[@"MobileNo"] isKindOfClass:[NSNull class]]){
            [self.txtMobileNo setText:@""];
        }else{
            [self.txtMobileNo setText:dc[@"MobileNo"]];
        }
        
    }
    
    else //if ([[dictionary valueForKey:@"ResponseCode"]isEqualToNumber:no2])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"KidsCrown" message:[[dictionary valueForKey:@"Response"] valueForKey:@"ResponseMsg"] delegate:(id)self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}


-(IBAction)btnUpdateProfile:(id)sender
{
    [self.view endEditing:YES];
    {
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
        else if ([self validateEmail:self.txtEmailId.text]==FALSE)
        {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"KidsCrown" message:@"Please Enter Valid E-mail Address." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            
        }
        else if ([self.txtMobileNo.text length]!=10)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"KidsCrown" message:@"Please enter valid phone no." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
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
            NSString *userID=[[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
            //using post
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            
            NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    clinicname,@"ClinicName",
                                    emailid,@"EmailID",
                                    firstname,@"FirstName",
                                    lastname,@"LastName",
                                    mobileno,@"MobileNo",
                                    password,@"Password",
                                    registerno,@"RegistrationNumber",
                                    username,@"UserName",
                                    userID,@"UserID",nil];
            
            manager.requestSerializer = [AFJSONRequestSerializer serializer]; // if request JSON format
            [manager POST:[NSString stringWithFormat:@"%@%@",NEW_BASE_URL,UPDATE_PROFILE_DETAIL] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                
                NSDictionary *dic1 = responseObject;
                [self response:dic1];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }];
            
            [self.view endEditing:YES];
        }
    }
    
    
}
- (void)response:(NSDictionary*)dictionary {
    int i = 1;
    NSNumber *number = [NSNumber numberWithInt:i];
    if([[[dictionary valueForKey:@"Response"] valueForKey:@"ResponseCode"]isEqualToNumber:number])
    {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"KidsCrown" message:[[dictionary valueForKey:@"Response"] valueForKey:@"ResponseMsg"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        alert.tag = 1;
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"KidsCrown" message:[NSString stringWithFormat:@"%@",[[dictionary valueForKey:@"Response"] valueForKey:@"ResponseMsg"]] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
}


#pragma mark - UITextfield Method

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


@end
