//
//  Crown2ViewController.m
//  KidsCrown
//
//  Created by webmyne systems on 07/04/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import "Crown2ViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "KidsCrownUrlSchema.h"
#import "UIView+Toast.h"

@interface Crown2ViewController ()
{
    NSNumber *price,*maxPrice,*minPrice,*totalPrice,*orderLimit,*productId,*quantity,*priceId;
    NSString *productName;
     NSString *discountPercentage;
}
@end

@implementation Crown2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.lblHeader setText:@"Kids Crown SS Primary Molar \nAssorted Kit"];
    [self FetchAllProductDetail];
    self.dbHandler = [[DataBaseFile alloc] init];
    [self.dbHandler CopyDatabaseInDevice];
    [self.txtQty addTarget:self action:@selector(textFieldInputDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self getDiscountInfo];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -  Keyboard methods

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

#pragma mark -  Consume Webservice methods

-(void)FetchAllProductDetail{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *fetchURL=[NSString stringWithFormat:@"%@%@%@",Kids_Crown_BASEURL,FETCH_CURRENT_PRICING_FORMOBILE,@"0"];
    //NSLog(@"FETCHURL :%@",fetchURL);
    // NSString *str=[NSString stringWithFormat:FETCHUSERDETAILS,email,socialName];
    
    [manager GET:fetchURL  parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        //NSLog(@"dic1 : %@",dic1);
        
        [self fetchDataResponse:dic1];
        
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"KidsCrown" message:@"Network error. Please try again later" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [errorAlert show];
    }];
}

-(void)fetchDataResponse:(NSDictionary *)dictionary{
    
    NSArray *arrData=[dictionary valueForKey:@"Data"];
    //NSLog(@"-------%ld",[arrData count]);
    for (int i=0; i<[arrData count]; i++) {
        ////NSLog(@"-------Object %d--->>%@",i,[arrData objectAtIndex:i]);
        
        NSDictionary *dataDict=[arrData objectAtIndex:i];
        //NSLog(@"---->> %@",[dataDict objectForKey:@"ProductID"]);
        
        NSString *str=[NSString stringWithFormat:@"%@",[dataDict objectForKey:@"ProductID"]];
        if ([str isEqualToString:@"15"]) {
            productId=[dataDict objectForKey:@"ProductID"];
            //NSLog(@"--->>%@",[dataDict objectForKey:@"ProductName"]);
            [self.lblHeader setText:[dataDict objectForKey:@"ProductName"]];
            productName=[dataDict objectForKey:@"ProductName"];
            [self.lblDescription setText:[dataDict objectForKey:@"Description"]];
            
            orderLimit=[dataDict objectForKey:@"OrderLimit"];
            NSArray *priceArr=[dataDict objectForKey:@"lstProductPriceForMobile"];
            NSDictionary *priceDict=[priceArr objectAtIndex:0];
            
            priceId=[priceDict objectForKey:@"PriceID"];
            price=[priceDict objectForKey:@"Price"];
            minPrice=[priceDict objectForKey:@"MinQty"];
            maxPrice=[priceDict objectForKey:@"MaxQty"];
            [self.lblProductPrice setText:[@"₹ " stringByAppendingString:[NSString stringWithFormat:@"%@",price]]];
            [self.lblTotalPrice setText:[@"= ₹ " stringByAppendingString:[NSString stringWithFormat:@"%@",price]]];
            
            
            NSArray *imagesArr=[dataDict objectForKey:@"lstProductImg"];
            NSDictionary *imagesDict=[imagesArr objectAtIndex:0];
            NSURL *url=[NSURL URLWithString:[imagesDict objectForKey:@"ImagePath"]];
            NSData *data=[NSData dataWithContentsOfURL:url];
            [self.ImgProduct setImage:[[UIImage alloc]initWithData:data]];
            
            NSArray *categoryArr=[imagesArr valueForKey:@"ImagePath"];
            
            NSSet *set = [NSSet setWithArray:categoryArr];
            NSMutableArray *dataArr=[[NSMutableArray alloc]init];
            for(NSString *myString in set){
                [dataArr addObject:myString];
            }
            //NSLog(@"---%@",dataArr);
            [[NSUserDefaults standardUserDefaults]setObject:dataArr forKey:@"imageArr"];
        }
    }
}

- (IBAction)btnImage:(id)sender {
 
    UIViewController *viewController=[self.storyboard instantiateViewControllerWithIdentifier:@"PAGE"];
    [self presentViewController:viewController animated:YES completion:nil];
}

-(void)getDiscountInfo {
    
    NSString *selectQuery = [NSString stringWithFormat:@"select DiscountPercentage from Discount where ProductID=%@",@"15"];
    
    discountPercentage = [[[self.dbHandler selectAllDataFromTablewithQuery:selectQuery ofColumn:1] objectAtIndex:0] objectAtIndex:0];
    
    NSLog(@"---> --- %@",discountPercentage);
}

- (IBAction)btnAddCart:(id)sender {
    
    if ([self.txtQty.text length]!=0) {

    NSString *userId=[[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
    int qtyInt=[self.txtQty.text intValue];
    quantity=[NSNumber numberWithInteger:qtyInt];
    
    NSString *deleteQuery =[NSString stringWithFormat:@"delete from CartItem where product_id='%@'AND userId='%@'",@"15",userId];
    [self.dbHandler DeleteDataWithQuesy:deleteQuery];
    
    float discount_price = ([totalPrice floatValue] * [discountPercentage floatValue])/100;
        
    float grand_price = [totalPrice floatValue] - discount_price;

    NSString *insertQuery = [NSString stringWithFormat:@"insert into CartItem (product_id,userId,price_id,product_name,qty,unit_price,total_price,discount_price,grand_price) values (%@,'%@',%@,'%@',%@,'%@','%@','%@','%@')",productId,userId,priceId,productName,quantity,price,totalPrice, [NSNumber numberWithFloat:discount_price], [NSNumber numberWithFloat:grand_price]];
    //NSLog( @"ADDTOPCART :: %@",insertQuery);
    [self.dbHandler insertDataWithQuesy:insertQuery];
    
        [self.view makeToast:@"Kit is added to your cart. Check your cart."];
    }
    else{
        [self.view makeToast:@"Please enter quantity"];
    }

}

- (IBAction)btnMinus:(id)sender {
    [self.txtQty resignFirstResponder];
    NSNumber *qty=[NSNumber numberWithInteger:[self.txtQty.text integerValue]];
    if (qty<=minPrice) {
        [self.view makeToast:@"Minimum Quantity should be 1."];
    }
    else{
        int i=[qty intValue];
        i-=1;
        [self.txtQty setText:[NSString stringWithFormat:@"%i",i]];
        [self.lblProductQty setText:[[@" X " stringByAppendingString:[self.txtQty text]] stringByAppendingString:@"QTY"]];
        // totalPrice=price.integerValue * qty.integerValue;
        double n1=[price doubleValue];
        
        double total=n1*i;
        totalPrice=[NSNumber numberWithLong:total];
        //NSLog(@"----%@",totalPrice);
        [self.lblTotalPrice setText:[@"= ₹ " stringByAppendingString:[NSString stringWithFormat:@"%@",totalPrice]]];
    }
}

- (IBAction)btnPlus:(id)sender {
    [self.txtQty resignFirstResponder];
    NSNumber *qty=[NSNumber numberWithInteger:[self.txtQty.text integerValue]];
    
    if (qty>=orderLimit) {
        [self.view makeToast:@"In single order, You can't order more than 10 kits."];
    }
    else{
        int i=[qty intValue];
        i+=1;
        [self.txtQty setText:[NSString stringWithFormat:@"%i",i]];
        [self.lblProductQty setText:[[@" X " stringByAppendingString:[self.txtQty text]] stringByAppendingString:@"QTY"]];
        // totalPrice=price.integerValue * qty.integerValue;
        double n1=[price doubleValue];
        
        double total=n1*i;
        totalPrice=[NSNumber numberWithLong:total];
        //NSLog(@"----%@",totalPrice);
        [self.lblTotalPrice setText:[@"= ₹ " stringByAppendingString:[NSString stringWithFormat:@"%@",totalPrice]]];
    }
    
}
-(void)textFieldInputDidChange:(UITextField *)textfield{
    
    NSNumber *qty=[NSNumber numberWithInteger:[self.txtQty.text integerValue]];
    
    
    if (qty<minPrice) {
        [self.txtQty resignFirstResponder];
        [self.txtQty setText:@""];
        [self.view makeToast:@"Minimum Quantity should be 1."];
    }
    else if (qty>orderLimit) {
        [self.txtQty resignFirstResponder];
        [self.txtQty setText:@""];
        [self.view makeToast:@"In single order, You can't order more than 10 kits."];
    }
    else{
        int i=[qty intValue];
        [self.txtQty setText:[NSString stringWithFormat:@"%i",i]];
        [self.lblProductQty setText:[[@" X " stringByAppendingString:[self.txtQty text]] stringByAppendingString:@"QTY"]];
        
        double n1=[price doubleValue];
        double total=n1*i;
        totalPrice=[NSNumber numberWithLong:total];
        [self.lblTotalPrice setText:[@"= ₹ " stringByAppendingString:[NSString stringWithFormat:@"%@",totalPrice]]];
    }
}


@end
