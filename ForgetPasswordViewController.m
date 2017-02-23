//
//  ForgetPasswordViewController.m
//  KidsCrown
//
//  Created by webmyne systems on 14/04/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "KidsCrownUrlSchema.h"
#import "UIView+Toast.h"

@interface ForgetPasswordViewController ()
{
    MBProgressHUD *hud;
}
@end

@implementation ForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Return Keyboard

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

//FOR Close KEYBOARD
#pragma mark - UITextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (_txtEmail.text.length >= 50 && range.length == 0)
    {
        return NO; // return NO to not change text
    }
    else
    {
        return YES;
    }
    
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return true;
}

- (IBAction)btnClose:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)btnSend:(id)sender
{
    
    if ([_txtEmail.text length] == 0) {
        [self.view makeToast:@"Please enter User Name / Email id"];
    }
    else
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        
        [manager GET:[NSString stringWithFormat:@"%@%@%@",NEW_BASE_URL,NEW_FORGET_PASSWORD,_txtEmail.text]  parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            if([[[dictionary objectForKey:@"Response"]valueForKey:@"ResponseCode"] intValue] == 1)
            {
                NSString *strMsg = [[dictionary objectForKey:@"Response"]valueForKey:@"ResponseMsg"];
                
                [self.view makeToast:strMsg];
                
            }
            else
            {
                NSString *strMsg = [[dictionary objectForKey:@"Response"]valueForKey:@"ResponseMsg"];
                
                [self.view makeToast:strMsg];
            }
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Kid's Crown" message:@"Network error. Please try again later" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [errorAlert show];
        }];

        _txtEmail.text = nil;
        
    }
    
}













@end
