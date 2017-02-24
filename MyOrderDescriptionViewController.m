//
//  MyOrderDescriptionViewController.m
//  KidsCrown
//
//  Created by webmyne systems on 08/04/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import "MyOrderDescriptionViewController.h"
#import "OrderTableViewCell.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "KidsCrownUrlSchema.h"
#import "UIView+Toast.h"

@interface MyOrderDescriptionViewController ()
{
   
    NSArray *arr;
    NSMutableArray *orderArr;
    NSMutableDictionary *productOrderList;
    NSMutableArray *nameArray;
    float assortedDiscount, introDiscount, crownDiscount, inVoiceDiscount;
    
}
@end

@implementation MyOrderDescriptionViewController

- (void)viewDidLoad   {
    
    [super viewDidLoad];
    
    
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    
    orderArr = [[NSMutableArray alloc]init];
    productOrderList = [[NSMutableDictionary alloc]init];
    nameArray = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
    arr=[[NSArray alloc]initWithObjects:@"",@"",@"",@"",@"", nil];
    
    
    
    nameArray = [_orderDetailDict objectForKey:@"lstOrderProduct"];
    
    
    [self DisplayData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)DisplayData
{
    _lblOrderNo.text = [NSString stringWithFormat:@"%@",[_orderDetailDict objectForKey:@"InvoiceNumber"]];

    _lblTotalPayment.text = [NSString stringWithFormat:@"₹ %@",[_orderDetailDict objectForKey:@"SubTotal"]];
    
    _lblYouSaved.text = [NSString stringWithFormat:@"₹ %@",[_orderDetailDict objectForKey:@"YouSaved"]];
    
    _lblShippingCharge.hidden = YES;
    _lblShippingChargeTitle.hidden  = YES;
    
//    _lblShippingCharge.text = [NSString stringWithFormat:@"₹ %@",[_orderDetailDict objectForKey:@"ShippingCost"]];
    
    
    _lblDate.text = [NSString stringWithFormat:@"%@",[_orderDetailDict objectForKey:@"OrderDate"]];
    _lblPaymentStatus.text = [NSString stringWithFormat:@"%@",[_orderDetailDict objectForKey:@"Status"]];
    
    
 // Shipping Address
    
    NSString *strAddress1 = [NSString stringWithFormat:@"%@",[[_orderDetailDict objectForKey:@"ShippingAddressDC"] valueForKey:@"Address1"]];
    
    NSString *strAddress2 = [NSString stringWithFormat:@"%@",[[_orderDetailDict objectForKey:@"ShippingAddressDC"] valueForKey:@"Address2"]];
    
    NSString *strCity = [NSString stringWithFormat:@"%@ - %@",[[_orderDetailDict objectForKey:@"ShippingAddressDC"] valueForKey:@"City"],[[_orderDetailDict objectForKey:@"ShippingAddressDC"] valueForKey:@"PinCode"]];
    
    NSString *strAddress = [NSString stringWithFormat:@"%@, %@, %@",strAddress1,strAddress2,strCity];
    _lblShippingAddress.text = strAddress;
    
    
// payable amount
    
    _lblPayableAmount.text = [NSString stringWithFormat:@"₹ %@",[_orderDetailDict objectForKey:@"TotalAmount"]];
    
    
    
}

#pragma mark- UITableView Datasource and Delegate methods


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [nameArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSString *str = [nameArray [indexPath.row] valueForKey:@"ProductSpecification"];
    
    
    if (![str isEqualToString:@""])
    {
        cell.lblOrderName.text = [NSString stringWithFormat:@"%@: %@",[nameArray [indexPath.row] valueForKey:@"ProductName"],str];
    }
    else {
        
        cell.lblOrderName.text = [nameArray [indexPath.row] valueForKey:@"ProductName"];
    }
    cell.lblOrderName.numberOfLines = 0;
    
    [self getHeight:cell.lblOrderName];
    
    cell.lblOrderQty.text = [NSString stringWithFormat:@"%@",[nameArray [indexPath.row] valueForKey:@"Quantity"]];
    cell.lblOrderPrice.text = [NSString stringWithFormat:@"₹ %@",[nameArray [indexPath.row] valueForKey:@"ProductPrice"]];
    
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
        _tableViewHeight.constant = ((nameArray.count)*70) + height;
        height = 0.0;
    }
    
    
}



- (IBAction)btnBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
