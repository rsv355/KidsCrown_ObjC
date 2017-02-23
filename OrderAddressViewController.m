//
//  OrderAddressViewController.m
//  KidsCrown
//
//  Created by webmyne systems on 08/04/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import "OrderAddressViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "JSONHelper.h"
#import "UIView+Toast.h"
#import "KidsCrownUrlSchema.h"
#import "MyCartTableViewCell.h"

@interface OrderAddressViewController ()
{
    NSDictionary *jsonResponse;
    NSString *isShipping;
    NSMutableArray *addressArr,*stateArr;
    NSMutableArray *values;
    NSDictionary *shippingAddress,*billingAddress;
}
@end

@implementation OrderAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    values=[[NSMutableArray alloc]init];
     self.checkboxHeightConst.constant=0.0f;
    [self.btnConfirmOrder setTitle:@"Next" forState:UIControlStateNormal];
     _tableViewHeightConst.constant =0;
//    [self.txtAddress1 setText:@"Ambikapark"];
//    [self.txtAddress2 setText:@"Gardens"];
//    [self.txtCity setText:@"Vadodara"];
//    [self.txtState setText:@"Guajrat"];
//    [self.txtCountry setText:@"India"];
//    [self.txtPincode setText:@"390020"];
//    [self.txtMobileNo setText:@"1234567890"];
    [self FetchAddress];
    self.dbHandler = [[DataBaseFile alloc] init];
    [self.dbHandler CopyDatabaseInDevice];
    [self fetchAllState];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)segmentControl:(id)sender{
    /*if (self.segmentControl.selectedSegmentIndex==0) {
        self.checkboxHeightConst.constant=0.0f;
        [self.btnConfirmOrder setTitle:@"Next" forState:UIControlStateNormal];
        [self.btnConfirmOrder setTag:0];
    }
    else if (self.segmentControl.selectedSegmentIndex==1){
        addressArr =[[NSMutableArray alloc]init];
        [addressArr addObject:[self.txtAddress1 text]];
        [addressArr addObject:[self.txtAddress2 text]];
        [addressArr addObject:[self.txtCity text]];
        [addressArr addObject:[self.txtState text]];
        [addressArr addObject:[self.txtCountry text]];
        [addressArr addObject:[self.txtPincode text]];
        [addressArr addObject:[self.txtMobileNo text]];
        [self resetFields];
        self.checkboxHeightConst.constant=28.0f;
         [self.btnConfirmOrder setTitle:@"Confirm Order" forState:UIControlStateNormal];
        [self.btnConfirmOrder setTag:1];
    }*/
}

-(void)resetFields{
    [self.txtAddress1 setText:@""];
    [self.txtAddress2 setText:@""];
    [self.txtCity setText:@""];
    [self.txtState setText:@""];
    [self.txtCountry setText:@""];
    [self.txtPincode setText:@""];
    [self.txtMobileNo setText:@""];
}

-(void)fillUpFields{
    if ([addressArr count]>0) {
        [self.txtAddress1 setText:[addressArr objectAtIndex:0]];
        [self.txtAddress2 setText:[addressArr objectAtIndex:1]];
        [self.txtCity setText:[addressArr objectAtIndex:2]];
        [self.txtState setText:[addressArr objectAtIndex:3]];
        [self.txtCountry setText:[addressArr objectAtIndex:4]];
        [self.txtPincode setText:[addressArr objectAtIndex:5]];
        [self.txtMobileNo setText:[addressArr objectAtIndex:6]];
    }
    else{
        [self.view makeToast:@"Enter Shipping address"];
    }
}
- (IBAction)btnCheck:(id)sender {
    
    if (self.btnCheck.tag ==0) {
        
        self.btnCheck.tag=1;
        [self.btnCheck setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
        [self fillUpFields];
        
    }
    else if (self.btnCheck.tag ==1) {
        
        self.btnCheck.tag=0;
        [self.btnCheck setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
        [self resetFields];
    }
}
- (IBAction)btnConfirmOrder:(id)sender {
    
    if (self.btnConfirmOrder.tag==0) {
        if([_txtAddress1.text isEqualToString:@""] || [_txtAddress2.text isEqualToString:@""] || [_txtCity.text isEqualToString:@""]|| [_txtState.text isEqualToString:@"State"]|| [_txtCountry.text isEqualToString:@""]|| [_txtPincode.text isEqualToString:@""]|| [_txtMobileNo.text isEqualToString:@""])
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
        [self insertAddressToDatabase];
        [self.segmentControl setSelectedSegmentIndex:1];
        [self.btnConfirmOrder setTitle:@"Confirm Order" forState:UIControlStateNormal];
        self.btnConfirmOrder.tag=1;
        self.checkboxHeightConst.constant=28.0f;
        addressArr =[[NSMutableArray alloc]init];
          //  if ([addressArr count]>0) {
                [addressArr addObject:[self.txtAddress1 text]];
                [addressArr addObject:[self.txtAddress2 text]];
                [addressArr addObject:[self.txtCity text]];
                [addressArr addObject:[self.txtState text]];
                [addressArr addObject:[self.txtCountry text]];
                [addressArr addObject:[self.txtPincode text]];
                [addressArr addObject:[self.txtMobileNo text]];
           // }
       
        
        //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NSString *address1 = self.txtAddress1.text;
        NSString *address2 = self.txtAddress2.text;
        NSString *city = self.txtCity.text;
        //NSString *state = self.txtState.text;
        NSString *country = self.txtCountry.text;
        NSString *pincode = self.txtPincode.text;
        NSString *mobileno=self.txtMobileNo.text;
        
        int userId=[[[NSUserDefaults standardUserDefaults]objectForKey:@"userID"] intValue];
        
        NSDictionary *params1 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                address1,@"Address1",
                                address2,@"Address2",
                                [NSNumber numberWithInt:0],@"AddressID",
                                city,@"City",
                                country,@"Country",
                                mobileno,@"MobileNo",
                                pincode,@"PinCode",
                                [NSNumber numberWithInt:1278],@"StateID",
                                [NSNumber numberWithInt:userId],@"UserID",[NSNumber numberWithBool:NO],@"IsDefault",[NSNumber numberWithBool:NO],@"IsShipping",
                                nil];
       
        [values addObject:params1];
        

         [self resetFields];
            if ([shippingAddress count]>0) {
                [self.txtAddress1 setText:shippingAddress[@"Address1"]];
                [self.txtAddress2 setText:shippingAddress[@"Address2"]];
                [self.txtCity setText:shippingAddress[@"City"]];
                [self.txtCountry setText:shippingAddress[@"Country"]];
                [self.txtPincode setText:shippingAddress[@"PinCode"]];
                [self.txtMobileNo setText:shippingAddress[@"MobileNo"]];
                [self fetchStateName:shippingAddress[@"StateID"]];
            }
            
               }
    }
    else{
        
        
        

        if([_txtAddress1.text isEqualToString:@""] || [_txtAddress2.text isEqualToString:@""] || [_txtCity.text isEqualToString:@""]|| [_txtState.text isEqualToString:@"State"]|| [_txtCountry.text isEqualToString:@""]|| [_txtPincode.text isEqualToString:@""]|| [_txtMobileNo.text isEqualToString:@""])
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
            
            isShipping=@"true";
            [self insertAddressToDatabase];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
           NSString *address1 = self.txtAddress1.text;
            NSString *address2 = self.txtAddress2.text;
            NSString *city = self.txtCity.text;
            //NSString *state = self.txtState.text;
            NSString *country = self.txtCountry.text;
            NSString *pincode = self.txtPincode.text;
            NSString *mobileno=self.txtMobileNo.text;
            
           int userId=[[[NSUserDefaults standardUserDefaults]objectForKey:@"userID"] intValue];
            
            //using post
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            
            NSDictionary *params2 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    address1,@"Address1",
                                    address2,@"Address2",
                                    [NSNumber numberWithInt:0],@"AddressID",
                                    city,@"City",
                                    country,@"Country",
                                    mobileno,@"MobileNo",
                                   pincode,@"PinCode",
                                    [NSNumber numberWithInt:1278],@"StateID",
                                [NSNumber numberWithInt:userId],@"UserID",[NSNumber numberWithBool:NO],@"IsDefault",[NSNumber numberWithBool:YES],@"IsShipping",
                                   nil];
          //  NSMutableArray *values=[[NSMutableArray alloc]init];
            [values addObject:params2];
            NSDictionary *paramDict=[[NSDictionary alloc]initWithObjectsAndKeys:values,@"Addresses", nil];
            //NSLog(@"PARAM--->>%@",paramDict);
            
            NSString *jsonString = [[NSString alloc] init];
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:paramDict options:NSJSONWritingPrettyPrinted error:&error];
            if (! jsonData) {
                //NSLog(@"Got an error: %@", error);
            } else {
                jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            }
           //http://ws-srv-net.in.webmyne.com/Applications/KidsCrown/KidsCrownWS_V01/Services/Master.svc/json/help/operations/AddNewShippingAddress
            
            //NSLog(@"String is %@",jsonString);
           NSString* WebServiceURL = [NSString stringWithFormat:@"%@%@",Kids_Crown_BASEURL,PostShippingAddress];
            
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(queue, ^{
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                // Load the JSON string from our web serivce (in a background thread)
              jsonResponse= [JSONHelper loadJSONDataFromPostURL:WebServiceURL postData:jsonString];
                //NSLog(@"--------%@",jsonResponse);
                dispatch_async(dispatch_get_main_queue(), ^{
                    //[SVProgressHUD dismiss];
                   
                    if (!jsonResponse || error)
                    {
                        //NSLog(@"Errrror");
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                    }
                    else
                    {
                        //NSLog(@"Reply from webservice is : %@",jsonResponse);
                        [self fetchDataResponse:jsonResponse];
                    }
                });
            });
            
        }

        }
    

}
- (void)fetchDataResponse:(NSDictionary*)dictionary {
    int i = 1;
    NSNumber *no1 = [NSNumber numberWithInt:i];
    
    
    if([dictionary valueForKey:@"Data"]){
    
        if([[dictionary valueForKey:@"ResponseCode"]isEqualToNumber:no1])
        {
            UIViewController *viewController=[self.storyboard instantiateViewControllerWithIdentifier:@"ORDER_SEND_CONFIRMATION"];
            [self presentViewController:viewController animated:YES completion:nil];
        }
        else{
            [self.view makeToast:[dictionary valueForKey:@"ResponseMessage"]];
        }
    
    }
}

-(void)insertAddressToDatabase
{
    NSString *user_id=[[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
    NSString *address1 = self.txtAddress1.text;
    NSString *address2 = self.txtAddress2.text;
    NSString *city = self.txtCity.text;
    NSString *state = self.txtState.text;
    NSString *country = self.txtCountry.text;
    NSString *pincode = self.txtPincode.text;
    NSString *mobileno=self.txtMobileNo.text;

    NSString *deleteQuery =[NSString stringWithFormat:@"delete from Address where user_id='%@' AND is_shipping='%@'",user_id,isShipping];
   // //NSLog(@"DELETE_QUERY :: %@",deleteQuery);
    [self.dbHandler DeleteDataWithQuesy:deleteQuery];
    
    NSString *insertQuery = [NSString stringWithFormat:@"insert into Address (user_id,is_shipping,color,pincode,state_name,country_name,city_name,address_1,address_2,mobile_no) values ('%@','%@',%@,'%@','%@','%@','%@','%@','%@','%@')",user_id,isShipping,[NSNumber numberWithInt:0],pincode,state,country,city,address1,address2,mobileno];
   // //NSLog( @"ADDTOPCART :: %@",insertQuery);
    [self.dbHandler insertDataWithQuesy:insertQuery];
    [self.view makeToast:@"Saved..."];

}
-(void)FetchAddress{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *userId=[[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *fetchURL=[NSString stringWithFormat:@"%@%@%@",Kids_Crown_BASEURL,FETCT_SHIPPING_ADDRESS,userId];
    //NSLog(@"FETCHURL :%@",fetchURL);
    
    
    [manager GET:fetchURL  parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        //NSLog(@"dic1 : %@",dic1);
        
      [self fetchAddressDataResponse:dic1];
        
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"KidsCrown" message:@"Network error. Please try again later" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [errorAlert show];
    }];
}

-(void)fetchAddressDataResponse:(NSDictionary *)dictionary
{
    int i = 1;
    NSNumber *no1 = [NSNumber numberWithInt:i];
    if([[dictionary valueForKey:@"ResponseCode"]isEqualToNumber:no1])
    {
        
        NSArray *data=[dictionary objectForKey:@"Data"];
        for (int i=0; i<[data count]; i++) {
            NSDictionary *dc=[data objectAtIndex:i];
            if ([[dc objectForKey:@"IsShipping"] isEqualToNumber:[NSNumber numberWithInt:0]]) {
                //NSLog(@"biiling address");
                billingAddress=[data objectAtIndex:i];
                [self.txtAddress1 setText:billingAddress[@"Address1"]];
                [self.txtAddress2 setText:billingAddress[@"Address2"]];
                [self.txtCity setText:billingAddress[@"City"]];
               // [self.txtState setText:billingAddress[@""]];
                [self.txtCountry setText:billingAddress[@"Country"]];
                [self.txtPincode setText:billingAddress[@"PinCode"]];
                [self.txtMobileNo setText:billingAddress[@"MobileNo"]];
                [self fetchStateName:billingAddress[@"StateID"]];
                
            }
            else if ([[dc objectForKey:@"IsShipping"] isEqualToNumber:[NSNumber numberWithInt:1]]) {
                //NSLog(@"shipping address");
                shippingAddress=[data objectAtIndex:i];
            }
        }
    }
    else{
        [self.view makeToast:[dictionary valueForKey:@"ResponseMessage"]];
    }
}
-(void) fetchStateName:(NSString *)name{
   
    NSString *selectQuery = [NSString stringWithFormat:@"select state_name from State where state_id=%@",name];
    
    NSMutableArray *arr = [self.dbHandler selectAllDataFromTablewithQuery:selectQuery ofColumn:1];
    //NSLog(@"PRICES-->> %@",arr);
    arr=[arr objectAtIndex:0];
    NSString *strS=[arr objectAtIndex:0];
    [self.txtState setText:strS];
}


-(void)fetchAllState{
    NSString *selectQuery = [NSString stringWithFormat:@"select state_name from State"];
    stateArr =[[NSMutableArray alloc]init];
    NSMutableArray *arr = [self.dbHandler selectAllDataFromTablewithQuery:selectQuery ofColumn:1];
   
    for (int i=0; i<[arr count]; i++) {
        [stateArr addObject:[[arr objectAtIndex:i] objectAtIndex:0]];
    }
     //NSLog(@"===>> %@",stateArr);
    // [self.tableView reloadData];
}
#pragma mark- UITableView Datasource and Delegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [stateArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyCartTableViewCell *cell=(MyCartTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    [cell.stateName setText:[stateArr objectAtIndex:indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.txtState setText:[stateArr objectAtIndex:indexPath.row]];
   _tableViewHeightConst.constant =0;
//    [UIView animateWithDuration:0.8
//                     animations:^{
//                         
//                         _tableViewHeightConst.constant -=128;
//                         [self.view layoutIfNeeded];
//                         
//                     }];

    _btnState.tag=0;
}

-(IBAction)btnState:(id)sender{
    if (_btnState.tag==0) {
        _btnState.tag=1;
        [UIView animateWithDuration:0.8
                         animations:^{
                             
                             _tableViewHeightConst.constant +=128;
                             [self.view layoutIfNeeded];
                             
                         }];
    }
    else if (_btnState.tag==1) {
        _btnState.tag=0;

        [UIView animateWithDuration:0.8
                         animations:^{
                             
                             _tableViewHeightConst.constant -=128;
                             [self.view layoutIfNeeded];
                             
                         }];
    }


}
@end
