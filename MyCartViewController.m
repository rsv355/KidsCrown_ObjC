//
//  MyCartViewController.m
//  KidsCrown
//
//  Created by webmyne systems on 08/04/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import "MyCartViewController.h"
#import "MyCartTableViewCell.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
#import "BillingAddressViewController.h"


@interface MyCartViewController ()
{
    MyCartTableViewCell *cell;
    NSMutableArray *arrData;
    NSMutableDictionary *paramsDict;
    NSMutableArray *kit, *crown;
    NSMutableArray *productIdArr;
    NSMutableArray *productArr,*productPriceArr;
    float grand_total;
    NSString *userId;
    NSMutableArray *orderArr;
}
@end

@implementation MyCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
   

    _lblSubTotal.text = @"";
    grand_total = 0.0;
    
    userId=[[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];

    
    
    paramsDict = [[NSMutableDictionary alloc]init];
    
    if ([_strSetHidden isEqualToString:@"yes"]) {
        _subviewNavigationBar.hidden = YES;
        _subviewNavigationBarHeightConstraint.constant = 0;
    } else {
        _subviewNavigationBar.hidden = NO;
        _subviewNavigationBarHeightConstraint.constant = 64;

    }
    
    [self.plusCartView setHidden:YES];
    
    arrData=[[NSMutableArray alloc]init];
    self.dbHandler = [[DataBaseFile alloc] init];
    [self.dbHandler CopyDatabaseInDevice];
    
     [self fetchProductsID];
     [self setPlusCartViewHidden];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setPlusCartViewHidden
{
    
    if ([productArr count] > 0)
    {
        [self.plusCartView setHidden:YES];
    }
    else
    {
        [self.plusCartView setHidden:NO];
        
    }
}


- (IBAction)btnBack:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - change PRICE

/*-------------  CART PRICE CODE BY MASUM  --------------*/

-(void)fetchProductsID {
    
    kit = [[NSMutableArray alloc]init];
    crown = [[NSMutableArray alloc]init];
    productArr = [[NSMutableArray alloc]init];
    productIdArr = [[NSMutableArray alloc]init];
    productPriceArr = [[NSMutableArray alloc]init];

    [self fetchProductIDFromDatabase];

    
}

-(void)fetchProductIDFromDatabase {
    
    NSString *selectKitID = [NSString stringWithFormat:@"select product_id, discount_price as issingle, SUM(qty) as total_qty from CartItem GROUP By product_id"];
    NSMutableArray * kitIDArr= [self.dbHandler selectTableDatawithQuery:selectKitID];
    
    NSString *selectCrownID = [NSString stringWithFormat:@"select product_id, discount_price as issingle, SUM(qty) as total_qty from CrownKit GROUP By product_id"];
    NSArray * crownIDArr= [self.dbHandler selectTableDatawithQuery:selectCrownID];
    
    productIdArr = [NSMutableArray arrayWithArray:[kitIDArr arrayByAddingObjectsFromArray:crownIDArr]];
    
    productPriceArr = [self fetchPriceSlabForArray:productIdArr];
    
    productArr = [self fetchAllProductFromCart];
    
    
    [self mergeProductDetails:productArr price:productIdArr];

}


-(NSMutableArray *)fetchPriceSlabForArray:(NSMutableArray *)array {
    
    NSMutableArray *prices = [[NSMutableArray alloc] init];
    
    NSString *selectPrice = [NSString stringWithFormat:@"select product_id,price,min,max from ProductPrice"];
    NSArray *priceArr = [self.dbHandler selectTableDatawithQuery:selectPrice];
    
    for (NSMutableDictionary *dict in array) {
        
        for (NSMutableDictionary *priceDict in priceArr) {
         
            if ([[dict objectForKey:@"product_id"] isEqualToString:[priceDict objectForKey:@"product_id"]]) {
                
                [prices addObject:priceDict];
            }
        }
    }
    
    return prices;
}

-(NSMutableArray *)fetchAllProductFromCart {
    
    NSString *selectKit = [NSString stringWithFormat:@"select _id,product_id,product_name,qty from CartItem where userId ='%@'",userId];
    NSArray *kitArr = [self.dbHandler selectTableDatawithQuery:selectKit];
    
    NSString *selectCrown = [NSString stringWithFormat:@"select _id,product_id,product_name,qty,crownKit_tag as specificId from CrownKit where user_Id ='%@'",userId];
    NSArray *crownArr = [self.dbHandler selectTableDatawithQuery:selectCrown];
    
    NSMutableArray *productArray = [NSMutableArray arrayWithArray:[kitArr arrayByAddingObjectsFromArray:crownArr]];
    
    return productArray;
}
/*-------------  CART PRICE CODE BY MASUM  --------------*/


-(void)mergeProductDetails:(NSMutableArray *)productArray price:(NSMutableArray *)priceArray {
    
    
    for (NSMutableDictionary *productDict in productArray) {
        
        NSString *productID = [productDict objectForKey:@"product_id"];
        
        for (NSMutableDictionary *priceDict in priceArray) {
            
            if ([productID isEqualToString:[priceDict objectForKey:@"product_id"]]) {
                
                NSString *issingle = [priceDict objectForKey:@"issingle"];
                NSString *total_qty = [priceDict objectForKey:@"total_qty"];
                
                [productDict setObject:issingle forKey:@"issingle"];
                [productDict setObject:total_qty forKey:@"total_qty"];
            }
        }
    }
    
    
    [self mergeTwoFinalArray];
}


-(void)mergeTwoFinalArray {
    
    for (NSMutableDictionary *productDict in productArr) {
        
        NSString *productID = [productDict objectForKey:@"product_id"];
        NSString *total_qty = [productDict objectForKey:@"total_qty"];
        
        for (NSMutableDictionary *priceDict in productPriceArr) {
            
            if ([productID isEqualToString:[priceDict objectForKey:@"product_id"]]) {
            
                NSString *min = [priceDict objectForKey:@"min"];
                NSString *max = [priceDict objectForKey:@"max"];
                
                if ([total_qty integerValue] >=[min integerValue] && [total_qty integerValue] <=[max integerValue]) {
                    
                    [productDict setObject:[priceDict objectForKey:@"price"] forKey:@"unit_price"];
                    
                }
                
                
            }
        }
    }
    
    [self countSubTotal];
    
    [self setPlusCartViewHidden];
    
    [self.tableView reloadData];
}


-(void)countSubTotal {
    
    grand_total = 0;
    
    for (NSDictionary *dict in productArr) {
        
        grand_total = grand_total + ([[dict objectForKey:@"qty"] floatValue] * [[dict objectForKey:@"unit_price"] floatValue]);
    }
    
    self.lblSubTotal.text = [NSString stringWithFormat:@"₹ %.2f",grand_total];
}
#pragma mark- UITableView Datasource and Delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
      return [productArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
/*
 {
 "_id" = 1;
 issingle = 1;
 "product_id" = 14;
 "product_name" = "KIDS Crown SS Primary Molar Intro Kit";
 qty = 2;
 "total_qty" = 2;
 "unit_price" = 6000;
 },
 */
    NSDictionary *productDict = [productArr objectAtIndex:indexPath.row];
    if ([[productDict objectForKey:@"issingle"] isEqualToString:@"1"]) {
       
        cell=(MyCartTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
        
        cell.btnDeleteKit.tag = indexPath.row - [kit count];
        [cell.btnDeleteKit addTarget:(id)self action:@selector(btnDeleteKitFromCart:) forControlEvents:UIControlEventTouchDown];
        
        cell.lblKitName.text = [productDict objectForKey:@"product_name"];
        cell.lblKitQuantity.text = [NSString stringWithFormat:@"X %@ QTY",[productDict objectForKey:@"qty"]];
        cell.lblKitUnitPrice.text = [NSString stringWithFormat:@"₹ %@",[productDict objectForKey:@"unit_price"]];
        
        float total_Price = [[productDict objectForKey:@"qty"] floatValue] * [[productDict objectForKey:@"unit_price"] floatValue];
        cell.lblKitTotalPrice.text =  [NSString stringWithFormat:@"= ₹ %.2f",total_Price];
//
        
    }
    else{
  
        cell=(MyCartTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell1"];
       
        cell.btnDeleteCrown.tag = indexPath.row - [kit count];
        [cell.btnDeleteCrown addTarget:(id)self action:@selector(btnDeleteCrownFromCart:) forControlEvents:UIControlEventTouchDown];
        cell.lblCrownName.text = [productDict objectForKey:@"product_name"];
        cell.lblCrownQuantity.text = [productDict objectForKey:@"qty"];
        cell.lblCrownUnitPrice.text = [productDict objectForKey:@"unit_price"];
        float total_Price = [[productDict objectForKey:@"qty"] floatValue] * [[productDict objectForKey:@"unit_price"] floatValue];
        cell.lblCrownTotalPrice.text =  [NSString stringWithFormat:@"₹ %.2f",total_Price];
        
        
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   CGFloat cellHeight;
    
    NSDictionary *productDict = [productArr objectAtIndex:indexPath.row];
    
    if ([[productDict objectForKey:@"issingle"] isEqualToString:@"1"]) {
        cellHeight=71;
    }
    else{
        cellHeight=118;
    }

    return cellHeight;
}

-(void)btnDeleteCrownFromCart:(id)sender {
    
    NSString *strMessage = [NSString stringWithFormat:@"Are you sure want to delete '%@' from Cart?",[[productArr objectAtIndex:[sender tag]] objectForKey:@"product_name"]];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Kids Crown" message:strMessage delegate:(id)self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    
    alertView.tag = [sender tag];
    
    [alertView show];
}

-(void)btnDeleteKitFromCart:(id)sender {
    
    NSString *strMessage = [NSString stringWithFormat:@"Are you sure want to delete '%@' from Cart?",[[productArr objectAtIndex:[sender tag]] objectForKey:@"product_name"]];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Kids Crown" message:strMessage delegate:(id)self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    
    alertView.tag = [sender tag];
    
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex != [alertView cancelButtonIndex]) {
        
        
        if ([[[productArr objectAtIndex:alertView.tag] objectForKey:@"issingle"] isEqualToString:@"1"]) {
        
            [self deleteKitFromCart:alertView.tag];
        }
        else {
            
             [self deleteCrownFromCart:alertView.tag];
        }
        
    }
}


-(void)deleteKitFromCart:(NSInteger)index {
    
    NSInteger ID = [[[productArr objectAtIndex:index] objectForKey:@"_id"] integerValue];
    
    NSString *strProductID = [[productArr objectAtIndex:index] objectForKey:@"product_id"];

    NSString *deleteQuery =[NSString stringWithFormat:@"delete from CartItem where _id=%ld",ID];
    [self.dbHandler DeleteDataWithQuesy:deleteQuery];
    
    [productArr removeObjectAtIndex:index];
    
    [self mergeTwoFinalArray];
    
    NSMutableArray *temporary = [[NSMutableArray alloc] init];
    
    for (NSMutableDictionary *dict in productIdArr) {
        
        if (![[dict objectForKey:@"product_id"] isEqualToString:strProductID]) {
            
            [temporary addObject:dict];
        }
    }
    
    productIdArr = [NSMutableArray arrayWithArray:temporary];
//    [self checkQuantity];
    
    [self changeBadgeCount];
}

-(void)deleteCrownFromCart:(NSInteger)index {
    
    NSInteger ID = [[[productArr objectAtIndex:index] objectForKey:@"_id"] integerValue];
    
    NSString *deleteQuery =[NSString stringWithFormat:@"delete from CrownKit where _id=%ld",ID];
    [self.dbHandler DeleteDataWithQuesy:deleteQuery];
    
    NSInteger qtyToMinus = [[[productArr objectAtIndex:index] objectForKey:@"qty"] integerValue];
    NSString *strProductID = [[productArr objectAtIndex:index] objectForKey:@"product_id"];
    
    for (NSMutableDictionary *dict in productArr) {
        
        if ([[dict objectForKey:@"product_id"] isEqualToString:strProductID]) {
            
            NSInteger total_qty = [[dict objectForKey:@"total_qty"] integerValue] - qtyToMinus;
            
            [dict setObject:[NSString stringWithFormat:@"%ld",total_qty] forKey:@"total_qty"];
        }
    }
    
    for (NSMutableDictionary *dict in productIdArr) {
        
        if ([[dict objectForKey:@"product_id"] isEqualToString:strProductID]) {
            
            NSInteger total_qty = [[dict objectForKey:@"total_qty"] integerValue] - qtyToMinus;
            
            [dict setObject:[NSString stringWithFormat:@"%ld",total_qty] forKey:@"total_qty"];
        }
    }
    [productArr removeObjectAtIndex:index];
    
    [self checkQuantity];
    
    [self mergeTwoFinalArray];
    
    [self changeBadgeCount];
}

-(void)checkQuantity {
    
    for (NSMutableDictionary *dict in productIdArr) {
        
        if ([[dict objectForKey:@"total_qty"] isEqualToString:@"0"]) {
            
            [productIdArr removeObject:dict];
        }
    }
}

-(void)changeBadgeCount {
    
    NSMutableArray *countArray = [productIdArr valueForKey:@"product_id"];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithArray:countArray] forKey:@"CART_COUNT"];
}
/*
 {
 "_id" = 4;
 issingle = 0;
 "product_id" = 16;
 "product_name" = "E-UL-3";
 qty = 25;
 "total_qty" = 50;
 "unit_price" = 150;
 }
 */
- (IBAction)btnCheckOut:(id)sender {
    
    
    [self getRequestParams];
    
}


- (void)ParseDataResponse:(NSMutableDictionary*)dictionary {
    

    BillingAddressViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BILLING_ADDRESS"];
    viewController.orderDict = dictionary;
    viewController.orderArr = orderArr;
    [self presentViewController:viewController animated:YES completion:nil];
    
}

#pragma mark - PLACE-ORDER POJO


-(void)getRequestParams {
    
    orderArr = [[NSMutableArray alloc] init];
    

    
    for (NSDictionary *dict in productIdArr)
    {
        
            if ([[dict objectForKey:@"issingle"] isEqualToString:@"1"])
            {
            
                for (NSDictionary *pDict in productArr)
                {
                
                    NSMutableDictionary *productDict = [[NSMutableDictionary alloc] init];
                    
                    if ([[pDict objectForKey:@"product_id"] isEqualToString:[dict objectForKey:@"product_id"]])
                    {
                    
                        [productDict setObject:[pDict objectForKey:@"product_id"] forKey:@"ProductID"];
                        [productDict setObject:[pDict objectForKey:@"qty"] forKey:@"Quantity"];
                     
                         [orderArr addObject:productDict];
                    }
                    
                   
                   
                }
            
            }
        
            else
            {
            
//                NSMutableArray *crownArr = [[NSMutableArray alloc]init];
                NSMutableArray *array = [[NSMutableArray alloc]init];
                
                NSMutableDictionary *crownDict = [[NSMutableDictionary alloc]init];
               
                
                for (NSDictionary *pDict in productArr)
                {
                     NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
                    
                    if ([[pDict objectForKey:@"product_id"] isEqualToString:[dict objectForKey:@"product_id"]])
                    {
                        
                        [dictionary setObject:[pDict objectForKey:@"qty"] forKey:@"Quantity"];
                        [dictionary setObject:[pDict objectForKey:@"product_name"] forKey:@"RiffleName"];
                        [dictionary setObject:[pDict objectForKey:@"specificId"] forKey:@"ProductSpecID"];
                       
                        [array addObject:dictionary];
                    }
                     [crownDict setObject:array forKey:@"placeOrderRiffileDC"];
                }
                
                [crownDict setObject:[dict objectForKey:@"product_id"] forKey:@"ProductID"];
                [crownDict setObject:[dict objectForKey:@"total_qty"] forKey:@"Quantity"];
                
                [orderArr addObject:crownDict];

                
            }  // End Of ELSE
        
      
    }
    
    [paramsDict setObject:@"I" forKey:@"MobileOS"];
    [paramsDict setObject:userId forKey:@"UserID"];
    [paramsDict setObject:@"" forKey:@"billingAddressDC"];
    [paramsDict setObject:@"" forKey:@"placeOrderCalculationDC"];
    [paramsDict setObject:orderArr forKey:@"placeOrderProductDC"];
    [paramsDict setObject:@"" forKey:@"shippingAddressDC"];

    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:paramsDict
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    if (! jsonData) {
        //NSLog(@"Got an error: %@", error);
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }

    
    [self callPlaceOrderService];
}

-(void)callPlaceOrderService {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@",NEW_BASE_URL,NEW_PLACE_ORDER];
    [manager POST:strURL parameters:paramsDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSMutableDictionary *dictionary = responseObject;
        
        if ([[[dictionary objectForKey:@"Response"] valueForKey:@"ResponseCode"] integerValue] == 1)
        {
            [productArr removeAllObjects];
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

@end
