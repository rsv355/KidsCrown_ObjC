//
//  OrderSendConfirmationViewController.m
//  KidsCrown
//
//  Created by webmyne systems on 19/04/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import "OrderSendConfirmationViewController.h"
#import "OrderTableViewCell.h"
#import "AFNetworking.h"
#import "UIView+Toast.h"
#import "MBProgressHUD.h"
#import "KidsCrownUrlSchema.h"
#import "JSONHelper.h"
#import "OrderConformationViewController.h"

@interface OrderSendConfirmationViewController ()
{
     MBProgressHUD *hud;
    NSMutableArray *arrData;
    int GrandTotal;
    NSString *systemDate;
    NSString *userId,*shippingAddress;
    NSMutableArray *crownsArr,*OrdersArray;
    NSMutableDictionary *crownDict;
    NSInteger product_id,price_id,crownQty,crowTotal,shipping_cost;
    NSDictionary *jsonResponse;
    NSMutableDictionary *Params;
    NSMutableDictionary *orderCrownDict;
    NSInteger inVoiceDiscount;
    NSArray *discountArr;
    NSInteger crowndiscount, introdiscount, assortedDiscount;
    NSInteger crownPer, introPer, assortedPer;
    
    
    NSMutableArray *TotalDataArray;
    NSMutableArray *kit, *crown;
    NSMutableArray *productIdArr;
    NSMutableArray *productArr;
    NSMutableDictionary *paramsDict;
    float grand_total;

}
@end

@implementation OrderSendConfirmationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    self.dbHandler = [[DataBaseFile alloc] init];
    [self.dbHandler CopyDatabaseInDevice];
    
    [self.btnPlaceOrder setUserInteractionEnabled:YES];
    
    paramsDict = [[NSMutableDictionary alloc]init];
    productArr = [[NSMutableArray alloc]init];


    TotalDataArray = [[NSMutableArray alloc]init];
    
    NSMutableArray *totalRecord = [[[_orderDict objectForKey:@"Data"]objectForKey:@"placeOrderCalculationDC"] valueForKey:@"productCalculationDCs"];
    
    for (NSDictionary *dict in totalRecord) {
        
            if ([[dict objectForKey:@"IsSingle"] boolValue] == 1) {
                
                NSMutableDictionary *kitDict = [[NSMutableDictionary alloc]init];
                [kitDict setObject:[dict valueForKey:@"ProductName"] forKey:@"ProductName"];
                [kitDict setObject:[dict valueForKey:@"Quantity"] forKey:@"Quantity"];
                [kitDict setObject:[dict valueForKey:@"TotalPrice"] forKey:@"TotalPrice"];
                [kitDict setObject:[dict valueForKey:@"IsSingle"] forKey:@"IsSingle"];

                [TotalDataArray addObject:kitDict];
                
            }
            else
            {
                
                NSMutableArray *crArr = [dict objectForKey:@"placeOrderRiffileDC"];
                
                NSString *strComma= [dict objectForKey:@"ProductName"];
                strComma = [strComma stringByAppendingString:@": "];
                
                 NSMutableDictionary *crDict = [[NSMutableDictionary alloc]init];
                
                for (NSDictionary *d in crArr)
                {
                    strComma = [strComma stringByAppendingString:[NSString stringWithFormat:@"%@,",[d valueForKey:@"RiffleName"]]];
                }
                
                [crDict setObject:strComma forKey:@"ProductName"];
                [crDict setObject:[dict valueForKey:@"Quantity"] forKey:@"Quantity"];
                [crDict setObject:[dict valueForKey:@"TotalPrice"] forKey:@"TotalPrice"];
                [crDict setObject:[dict valueForKey:@"IsSingle"] forKey:@"IsSingle"];

                [TotalDataArray addObject:crDict];
                
            }
    }
    
    NSLog(@"TotalArray - > %@",TotalDataArray);
    
     [self DisplayDataFromPOJO];
}



-(void)DisplayDataFromPOJO
{
    
  // Billing Address
    
    NSString *strAddress1 = [NSString stringWithFormat:@"%@",[[[_orderDict objectForKey:@"Data"] objectForKey:@"billingAddressDC"] valueForKey:@"Address1"]];
    
    NSString *strAddress2 = [NSString stringWithFormat:@"%@",[[[_orderDict objectForKey:@"Data"] objectForKey:@"billingAddressDC"] valueForKey:@"Address2"]];
    
    NSString *strCity1 = [NSString stringWithFormat:@"%@ - %@",[[[_orderDict objectForKey:@"Data"] objectForKey:@"billingAddressDC"] valueForKey:@"City"],[[[_orderDict objectForKey:@"Data"] objectForKey:@"billingAddressDC"] valueForKey:@"PinCode"]];
    
    NSString *strAddressBilling = [NSString stringWithFormat:@"%@, %@, %@",strAddress1,strAddress2,strCity1];
    
    _lblBillingAddress.text = strAddressBilling;
    
    
    // Shipping Address
    
    NSString *strAddress3 = [NSString stringWithFormat:@"%@",[[[_orderDict objectForKey:@"Data"] objectForKey:@"shippingAddressDC"] valueForKey:@"Address1"]];
    
    NSString *strAddress4 = [NSString stringWithFormat:@"%@",[[[_orderDict objectForKey:@"Data"] objectForKey:@"shippingAddressDC"] valueForKey:@"Address2"]];
    
    NSString *strCity2 = [NSString stringWithFormat:@"%@ - %@",[[[_orderDict objectForKey:@"Data"] objectForKey:@"shippingAddressDC"] valueForKey:@"City"],[[[_orderDict objectForKey:@"Data"] objectForKey:@"shippingAddressDC"] valueForKey:@"PinCode"]];
    
    NSString *strAddressShipping = [NSString stringWithFormat:@"%@, %@, %@",strAddress3,strAddress4,strCity2];
    
    _lblShippingAddress.text = strAddressShipping;

    
 //
    
    _labelSubTotal.text = [NSString stringWithFormat:@"₹ %@",[[[_orderDict objectForKey:@"Data"] objectForKey:@"placeOrderCalculationDC"] valueForKey:@"TotalAmount"]];
    
    
    int ProductDiscount = [[[[_orderDict objectForKey:@"Data"] objectForKey:@"placeOrderCalculationDC"]valueForKey:@"ProductDiscount"] intValue];
    
    int InvoiceDiscount = [[[[_orderDict objectForKey:@"Data"] objectForKey:@"placeOrderCalculationDC"]valueForKey:@"InvoiceDiscount"] intValue];
    
    int totalDiscount = ProductDiscount + InvoiceDiscount ;
    
    
    _labelYouSaved.text = [NSString stringWithFormat:@"₹ %d",totalDiscount];
    
//    _labelShippingCost.text = [NSString stringWithFormat:@" %@",[[[_orderDict objectForKey:@"Data"] objectForKey:@"placeOrderCalculationDC"] valueForKey:@"TotalAmount"]];
    
    _labelPayableAmount.text = [NSString stringWithFormat:@"₹ %@",[[[_orderDict objectForKey:@"Data"] objectForKey:@"placeOrderCalculationDC"] valueForKey:@"PayableAmount"]];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- UITableView Datasource and Delegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return TotalDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSString *string = [[TotalDataArray objectAtIndex:indexPath.row]valueForKey:@"ProductName"];
    
    if ([string length] > 0) {
        string = [string substringToIndex:[string length] - 1];
    }
    
    cell.lblNameSend.numberOfLines = 0;
    
    cell.lblNameSend.text = string;
    
    [self getHeight:cell.lblNameSend];

    
     cell.lblQtySend.text = [NSString stringWithFormat:@"%@",[[TotalDataArray objectAtIndex:indexPath.row]valueForKey:@"Quantity"]];
    cell.lblPriceSend.text = [NSString stringWithFormat:@"₹ %@",[[TotalDataArray objectAtIndex:indexPath.row]valueForKey:@"TotalPrice"]];
    
    
    return cell;
}

-(void)getHeight :(UILabel *)label{
    
    
    CGSize labelSize = [label.text sizeWithFont:label.font
                              constrainedToSize:label.frame.size
                                  lineBreakMode:NSLineBreakByWordWrapping];
    
    CGFloat labelHeight = labelSize.height;
    CGFloat height;
    
    if (labelHeight > 0) {
        
        height = labelHeight;
        _tableViewHeightConst.constant = ((TotalDataArray.count)*70) + height;
        height = 0.0;
    }
    
    
}


#pragma mark  - Button Action
- (IBAction)btnPlaceOrder:(id)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    
        NSMutableDictionary *parameterDictionary = [_orderDict objectForKey:@"Data"];
        [parameterDictionary setObject:@"I" forKey:@"MobileOS"];
        [parameterDictionary removeObjectForKey:@"placeOrderSuccessDetailsDC"];
        [parameterDictionary setObject:_orderArr forKey:@"placeOrderProductDC"];

        NSLog(@"FINAL POJO @:-> %@",parameterDictionary);
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@",NEW_BASE_URL,NEW_PLACE_ORDER];
    [manager POST:strURL parameters:parameterDictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSMutableDictionary *dictionary = responseObject;
        NSLog(@"FINAL POJO RESPONSE:-> %@",dictionary);
        
        if ([[[dictionary objectForKey:@"Response"] valueForKey:@"ResponseCode"] integerValue] == 1)
        {
            [self ParseDataResponse:dictionary];
            
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

    
    
}

- (void)ParseDataResponse:(NSMutableDictionary*)dictionary {
    
    OrderConformationViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ORDER_CONFIRMATION"];
    
    viewController.orderConfirmDict = [[dictionary objectForKey:@"Data"] valueForKey:@"placeOrderSuccessDetailsDC"];
    
    [self presentViewController:viewController animated:YES completion:nil];
    
}



-(IBAction)btnHome:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -MBProgressHUD methods
-(void)showHud
{
    dispatch_async(dispatch_get_main_queue()
                   , ^{
                       hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                       hud.delegate = (id)self;
                       [self.view addSubview:hud];
                       [hud show:YES];
                       
                   });
}

-(void)hideHud
{
    dispatch_async(dispatch_get_main_queue()
                   , ^{
                       [hud hide:YES];
                       
                   });
}

@end
