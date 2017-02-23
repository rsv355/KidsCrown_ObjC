//
//  MyOrdersViewController.m
//  KidsCrown
//
//  Created by webmyne systems on 07/04/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import "MyOrdersViewController.h"
#import "OrderTableViewCell.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
#import "KidsCrownUrlSchema.h"
#import "MyOrderDescriptionViewController.h"

@interface MyOrdersViewController ()
{
    
    NSMutableArray *orderArr;
}
@end

@implementation MyOrdersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self fetchOrderHistory];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- UITableView Datasource and Delegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
       return [orderArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.lblShippingCharge.hidden = true;
    
    NSDictionary *dataDict=[orderArr objectAtIndex:indexPath.row];

    cell.lblOrderNo.text = [NSString stringWithFormat:@"%@",[dataDict objectForKey:@"InvoiceNumber"]];
    
    [cell.lblPayableAmount setText:[@"Payable Amount : ₹" stringByAppendingString:[NSString stringWithFormat:@"%@",[dataDict objectForKey:@"TotalAmount"]]]];
//    [cell.lblShippingCharge setText:[@"Shipping Charge : ₹" stringByAppendingString:[NSString stringWithFormat:@"%@",[dataDict objectForKey:@"ShippingCost"]]]];
    [cell.lblData setText:[dataDict objectForKey:@"OrderDate"]];
    [cell.lblPaymentStatus setText:[dataDict objectForKey:@"Status"]];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSMutableDictionary *dataDict=[orderArr objectAtIndex:indexPath.row];
    [[NSUserDefaults standardUserDefaults]setObject:[dataDict objectForKey:@"OrderID"] forKey:@"orderId"];
    
    MyOrderDescriptionViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CHECKOUT_ORDER"];
    
    viewController.orderDetailDict = dataDict;
    [self presentViewController:viewController animated:YES completion:nil];
}

-(void)fetchOrderHistory
{
    NSString *userId=[[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    [manager GET:[NSString stringWithFormat:@"%@%@%@",NEW_BASE_URL,NEW_FETCH_ORDER_HISTORY,userId]  parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        orderArr=[[NSMutableArray alloc]init];
        
        if ([[[dict objectForKey:@"Response"]valueForKey:@"ResponseCode"] integerValue] == 1){
            
            orderArr=[dict objectForKey:@"Data"];
            [self.tableView reloadData];

        }
        else{
            
            [self.view makeToast:[[dict objectForKey:@"Response"]valueForKey:@"ResponseMsg"]];
        }
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Kid's Crown" message:@"Network error. Please try again later" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [errorAlert show];
    }];
}


@end
