//
//  BillingAddressViewController.m
//  KidsCrown
//
//  Created by webmyne systems on 27/04/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import "BillingAddressViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "JSONHelper.h"
#import "UIView+Toast.h"
#import "KidsCrownUrlSchema.h"
#import "MyCartTableViewCell.h"
#import "ShippingAddressViewController.h"

@interface BillingAddressViewController ()<UITextFieldDelegate>
{
    NSDictionary *jsonResponse;
    NSString *isShipping;
    NSMutableArray *stateArr,*stateIdArr;
    NSMutableArray *values;
    NSDictionary *billingAddress;
    NSInteger stateId;
    
    
    NSMutableArray *stateListArray;
    UIToolbar * toolbar;
    NSString *stateIdForGettingState;



}
@end

@implementation BillingAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    _txtAddress1.delegate = self;
    _txtAddress2.delegate = self;
    _txtCity.delegate = self;
    _txtPincode.delegate = self;
    _txtMobileNo.delegate = self;
    
    values=[[NSMutableArray alloc]init];
    
    stateListArray = [[NSMutableArray alloc]init];
   
    NSLog(@"POJO RESPONSE>>%@",_orderDict);
    
    self.checkboxHeightConst.constant=0.0f;
    [self.btnConfirmOrder setTitle:@"Next" forState:UIControlStateNormal];
    [_tableView setHidden:YES];
    // Do any additional setup after loading the view.
    
    
    self.dbHandler = [[DataBaseFile alloc] init];
    [self.dbHandler CopyDatabaseInDevice];
    
    
    stateIdForGettingState = [NSString stringWithFormat:@"%@",[[[_orderDict objectForKey:@"Data"]objectForKey:@"billingAddressDC"] valueForKey:@"StateID"]];
    
    [self FetchStateList];

    [self DisplayUserAddressFromPOJO];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)DisplayUserAddressFromPOJO
{
    if ([[[_orderDict objectForKey:@"Data"] objectForKey:@"billingAddressDC"]valueForKey:@"Address1"]==[NSNull null])
    {
        self.txtAddress1.text=@"";
    }
    else
    {
        self.txtAddress1.text = [[[_orderDict objectForKey:@"Data"] objectForKey:@"billingAddressDC"]valueForKey:@"Address1"];
    }
    
    if ([[[_orderDict objectForKey:@"Data"] objectForKey:@"billingAddressDC"]valueForKey:@"Address2"]==[NSNull null])
    {
        self.txtAddress2.text=@"";
    }
    else
    {
        self.txtAddress2.text = [[[_orderDict objectForKey:@"Data"] objectForKey:@"billingAddressDC"]valueForKey:@"Address2"];
    }
    
    if ([[[_orderDict objectForKey:@"Data"] objectForKey:@"billingAddressDC"]valueForKey:@"City"]==[NSNull null])
    {
        self.txtCity.text=@"";
    }
    else
    {
        self.txtCity.text = [[[_orderDict objectForKey:@"Data"] objectForKey:@"billingAddressDC"]valueForKey:@"City"];
    }
    
    
    if ([[[_orderDict objectForKey:@"Data"] objectForKey:@"billingAddressDC"]valueForKey:@"PinCode"]==[NSNull null])
    {
        self.txtPincode.text=@"";
    }
    else
    {
        self.txtPincode.text = [[[_orderDict objectForKey:@"Data"] objectForKey:@"billingAddressDC"]valueForKey:@"PinCode"];
    }
    
    if ([[[_orderDict objectForKey:@"Data"] objectForKey:@"billingAddressDC"]valueForKey:@"MobileNo"]==[NSNull null])
    {
        self.txtMobileNo.text=@"";
    }
    else
    {
        self.txtMobileNo.text = [[[_orderDict objectForKey:@"Data"] objectForKey:@"billingAddressDC"]valueForKey:@"MobileNo"];
    }

    
}


-(void)fetchStateNameFromStateId :(NSString *)strId
{
    
    for (int i = 0; i < stateListArray.count; i++)
    {
        NSString *str = [NSString stringWithFormat:@"%@",[[stateListArray objectAtIndex:i] valueForKey:@"StateID"]];
        
        if ([strId isEqualToString:str])
        {
            
            self.txtState.text = [[stateListArray objectAtIndex:i]valueForKey:@"StateName"];
        }
    }
    
    
    
}


#pragma mark - Button Action

- (IBAction)btnBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)segmentControl:(id)sender{
}

- (IBAction)btnConfirmOrder:(id)sender {
    
    [values removeAllObjects];
    
        if([_txtAddress1.text isEqualToString:@""] || [_txtAddress2.text isEqualToString:@""] || [_txtCity.text isEqualToString:@""]|| [_txtState.text isEqualToString:@"State"] || [_txtPincode.text isEqualToString:@""]|| [_txtMobileNo.text isEqualToString:@""])
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"KidsCrown" message:@"Please enter all fields." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
        else if ([self.txtMobileNo.text length]!=10)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"KidsCrown" message:@"Please enter valid phone no." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
        else if ([self.txtPincode.text length]!=6)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"KidsCrown" message:@"Please enter valid pincode." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            
        }
        else
        {
            isShipping=@"false";
            
            NSString *address1 = self.txtAddress1.text;
            NSString *address2 = self.txtAddress2.text;
            NSString *city = self.txtCity.text;
            NSString *pincode = self.txtPincode.text;
            NSString *mobileno=self.txtMobileNo.text;
            
             NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            [dict setObject:address1 forKey:@"Address1"];
            [dict setObject:address2 forKey:@"Address2"];
            [dict setObject:@"0" forKey:@"BillingAddressID"];
            [dict setObject:city forKey:@"City"];
            [dict setObject:@"1" forKey:@"IsUpdated"];
            [dict setObject:mobileno forKey:@"MobileNo"];
            [dict setObject:pincode forKey:@"PinCode"];
            [dict setObject:stateIdForGettingState forKey:@"StateID"];

            
            NSMutableDictionary * temp1=[[NSMutableDictionary alloc]init];
            temp1=[[_orderDict objectForKey:@"Data"] mutableCopy];
            
            [temp1 setObject:dict forKey:@"billingAddressDC"];
            
            NSMutableDictionary * temp2=[[NSMutableDictionary alloc]init];
            temp2=[_orderDict  mutableCopy];
            
            [temp2 setObject:temp1 forKey:@"Data"];
            
            NSLog(@"OrderDict >>>>%@",temp2);
     
            
          ShippingAddressViewController  *viewControllwer=[self.storyboard instantiateViewControllerWithIdentifier:@"SHIPPING_ADDRESS"];
            viewControllwer.orderDict = temp2;
             viewControllwer.orderArr = _orderArr;
            [self presentViewController:viewControllwer animated:YES completion:nil];
        
        }
    
}



#pragma mark - Fetch State List From WebService

-(void)FetchStateList
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *fetchURL=[NSString stringWithFormat:@"%@%@",NEW_BASE_URL,NEW_FETCH_STATELIST];
    
    [manager GET:fetchURL  parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];

        if ([[[dictionary objectForKey:@"Response"]valueForKey:@"ResponseCode"] integerValue] == 1)
        {
            stateListArray = [dictionary objectForKey:@"Data"];
            [self fetchStateNameFromStateId:stateIdForGettingState];

            [_tableView reloadData];
           
        }
        else
        {
            NSString *strMsg = [[dictionary objectForKey:@"Response"]valueForKey:@"ResponseMsg"];
            
            [self.view makeToast:strMsg];
        }
        
        
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"KidsCrown" message:@"Network error. Please try again later" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [errorAlert show];
    }];
}



#pragma mark- UITableView Datasource and Delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [stateListArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyCartTableViewCell *cell=(MyCartTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    [cell.stateName setText:[[stateListArray objectAtIndex:indexPath.row] valueForKey:@"StateName"]];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    _btnState.selected = false;
    [_tableView setHidden:YES];
    
    [self.txtState setText:[[stateListArray objectAtIndex:indexPath.row] valueForKey:@"StateName"]];
    
    
    stateIdForGettingState = [[stateListArray objectAtIndex:indexPath.row] valueForKey:@"StateID"] ;
    
    
    _btnState.tag=0;
}

-(IBAction)btnState:(id)sender{

    [self.view endEditing:YES];

    if (_btnState.selected == false) {
        _btnState.selected = true;
         [_tableView setHidden:NO];
    } else {
        _btnState.selected = false;
        [_tableView setHidden:YES];
    }
    
    
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
   else if (textField == _txtAddress1) {
        NSString *resultText = [textField.text stringByReplacingCharactersInRange:range
                                                                       withString:string];
        return resultText.length <= 140;
        
    }
    
   else if (textField == _txtAddress2) {
        NSString *resultText = [textField.text stringByReplacingCharactersInRange:range
                                                                       withString:string];
        return resultText.length <= 140;
        
    }
    
    else if (textField == _txtPincode) {
        NSString *resultText = [textField.text stringByReplacingCharactersInRange:range
                                                                       withString:string];
        return resultText.length <= 6;
        
    }
    
    else if (textField == _txtCity) {
        NSString *resultText = [textField.text stringByReplacingCharactersInRange:range
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

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    if (textField ==_txtMobileNo)
    {
        
        toolbar  = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
        toolbar.barStyle = UIBarStyleBlackTranslucent;
        toolbar.items = [NSArray arrayWithObjects:
                         [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithSelection:)],
                         nil];
        [toolbar sizeToFit];
        _txtMobileNo.inputAccessoryView = toolbar;
    }
    
    if (textField == _txtPincode)
    {
        
        toolbar  = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
        toolbar.barStyle = UIBarStyleBlackTranslucent;
        toolbar.items = [NSArray arrayWithObjects:
                         [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithSelection:)],
                         nil];
        [toolbar sizeToFit];
        _txtPincode.inputAccessoryView = toolbar;
    }


    return YES;
}

- (void)doneWithSelection:(id)sender
{
    [self.view endEditing:YES];
    [toolbar removeFromSuperview];
}
#pragma mark - Keyboard show and hide
// keyboard hide on touch outside
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    _btnState.selected = false;
    [_tableView setHidden:YES];
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



@end
