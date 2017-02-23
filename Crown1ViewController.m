//
//  Crown1ViewController.m
//  KidsCrown
//
//  Created by webmyne systems on 07/04/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import "Crown1ViewController.h"
#import "MyCartViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "KidsCrownUrlSchema.h"
#import "UIView+Toast.h"
#import "Reachability.h"
#import "ANStepperView.h"
#import "UIImageView+AFNetworking.h"
#import "UIButton+tintImage.h"

@interface Crown1ViewController ()
{
    NSNumber *price,*maxPrice,*minPrice,*totalPrice,*orderLimit,*productId,*quantity,*priceId;
    NSString *productName;
    NSString *discountPercentage;
    int qtyValue;
}
@property (strong, nonatomic) IBOutlet ANStepperView *stepperView;

@end

@implementation Crown1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.dbHandler = [[DataBaseFile alloc] init];
    [self.dbHandler CopyDatabaseInDevice];
    
    [self.txtQty addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    
    qtyValue = 0;
    
    _subviewOfHeaderLabel.backgroundColor = _colorcode;
    
    NSLog(@"ProductDetailArray:- >> %@",_productDetailArray);
    
    [self displayData];
    
   
    _stepperView.minimumValue = [minPrice intValue];
    _stepperView.maximumValue = [orderLimit intValue];
    
    
    _btnAddtoCart.layer.cornerRadius = _btnAddtoCart.frame.size.width / 2;
    _btnAddtoCart.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    _btnAddtoCart.layer.shadowOffset = CGSizeMake(0, 2.0f);
    _btnAddtoCart.layer.shadowOpacity = 5.0f;
    _btnAddtoCart.layer.shadowRadius = 3.5f;
    _btnAddtoCart.layer.masksToBounds = NO;
    
    _lblBadgeCount.layer.cornerRadius = _lblBadgeCount.frame.size.width/2;
    _lblBadgeCount.layer.masksToBounds = YES;
    
    [self setBadgeLabel];
    


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)displayData
{
        productId=[_productDetailArray valueForKey:@"ProductID"];
        [self.lblHeader setText:[_productDetailArray valueForKey:@"ProductName"]];
        productName=[_productDetailArray valueForKey:@"ProductName"];
        [self.lblDescription setText:[_productDetailArray valueForKey:@"Description"]];
        
        orderLimit=[_productDetailArray valueForKey:@"OrderLimit"];
    
        NSArray *priceArr=[_productDetailArray valueForKey:@"priceSlabDCs"];
    
        NSDictionary *priceDict=[priceArr objectAtIndex:0];
        
//        priceId=[priceDict objectForKey:@"PriceID"];
        price=[priceDict objectForKey:@"Price"];
        minPrice=[priceDict objectForKey:@"MinQty"];
        maxPrice=[priceDict objectForKey:@"MaxQty"];
        [self.lblProductPrice setText:[@"₹ " stringByAppendingString:[NSString stringWithFormat:@"%@",price]]];
        [self.lblTotalPrice setText:[@"= ₹ " stringByAppendingString:[NSString stringWithFormat:@"%@",price]]];
 
    
        [self.ImgProduct setImageWithURL:[NSURL URLWithString:[_productDetailArray valueForKey:@"RootImage"]]  placeholderImage:[UIImage imageNamed:@"Kidscrownlogo.png"]];
    
        
    NSMutableArray *dataArr = [[NSMutableArray alloc]init];
    [dataArr addObject:[_productDetailArray valueForKey:@"RootImage"]];
    
        [[NSUserDefaults standardUserDefaults]setObject:dataArr forKey:@"imageArr"];

    
    
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

    [self setBadgeLabel];
    
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


- (IBAction)btnBack:(id)sender {
    
    [self.WSForProductOnBackButtonDelegate CheckService];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)btnImage:(id)sender {
    UIViewController *viewController=[self.storyboard instantiateViewControllerWithIdentifier:@"PAGE"];
    [self presentViewController:viewController animated:YES completion:nil];
}
- (IBAction)btnCartNavBar:(id)sender {
    
    MyCartViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MY_CART"];
    
    viewController.strSetHidden = @"no";
    
    [self presentViewController:viewController animated:YES completion:nil];
     
}

- (IBAction)btnAddToCart:(id)sender {
    
    if (qtyValue != 0)
    {
        
        NSString *userId=[[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
        
        quantity=[NSNumber numberWithInteger:qtyValue];
        
        NSString *deleteQuery =[NSString stringWithFormat:@"delete from CartItem where product_id='%@' AND userId='%@'",productId,userId];
        [self.dbHandler DeleteDataWithQuesy:deleteQuery];
        
        float discount_price = ([totalPrice floatValue] * [discountPercentage floatValue])/100;
        NSString *isSingle = [_productDetailArray valueForKey:@"IsSingle"];
        
        float grand_price = [totalPrice floatValue] - discount_price;
        
        NSString *insertQuery = [NSString stringWithFormat:@"insert into CartItem (product_id,userId,price_id,product_name,qty,unit_price,total_price,discount_price,grand_price) values (%@,'%@',%@,'%@',%@,'%@','%@','%@','%@')",productId,userId,priceId,productName,quantity,price,totalPrice, isSingle, [NSNumber numberWithFloat:grand_price]];
        [self.dbHandler insertDataWithQuesy:insertQuery];
        [self.view makeToast:@"Kit is added to your cart. Check your cart."];
    
        
        [self updateBadgeCount];
    }
    else
    {
        [self.view makeToast:@"Please enter quantity"];
    }

}
-(void)setBadgeLabel
{
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"CART_COUNT"] != nil) {
       
        NSArray *cartCountArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"CART_COUNT"];
        
       
        if ([cartCountArr count] == 0) {
            
              [self.lblBadgeCount setHidden:YES];
        }
        else {
           
            [self.lblBadgeCount setHidden:NO];
            
            [self.lblBadgeCount setText:[NSString stringWithFormat:@"%ld",[cartCountArr count]]];
            
            NSLog(@"UPDATE CART COUNT ----->>%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"CART_COUNT"]);

        }
        
        
    }
    else {
        
        [self.lblBadgeCount setHidden:YES];
    }
   
}


-(void)updateBadgeCount {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"CART_COUNT"] != nil) {
        
        
        NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"CART_COUNT"];
        
        NSMutableArray *cartCountArr = [NSMutableArray arrayWithArray:array];
        
        for (NSString *strID in array) {
            
            if(![strID isEqualToString:[NSString stringWithFormat:@"%@",productId]]) {
                
                [cartCountArr addObject:[NSString stringWithFormat:@"%@",productId]];
                
            }
        }
        NSOrderedSet *mySet = [[NSOrderedSet alloc] initWithArray:cartCountArr];
        NSMutableArray *myArray = [[NSMutableArray alloc] initWithArray:[mySet array]];
       
        NSArray *array1 = [NSArray arrayWithArray:myArray];
        
        [[NSUserDefaults standardUserDefaults] setObject:array1 forKey:@"CART_COUNT"];
    }
    else {
        
        NSMutableArray *cartCountArr = [[NSMutableArray alloc] init];
        
        [cartCountArr addObject:[NSString stringWithFormat:@"%@",productId]];
        [[NSUserDefaults standardUserDefaults] setObject:cartCountArr forKey:@"CART_COUNT"];
    }
    
    [self setBadgeLabel];
    
    NSLog(@"CART COUNT ----->>%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"CART_COUNT"]);
}

-(void)textChange:(UITextField *)textfield{
    
    NSNumber *qty=[NSNumber numberWithInteger:[self.txtQty.text integerValue]];
    
    if (qty<minPrice) {
        [self.txtQty resignFirstResponder];
        [self.txtQty setText:@""];
        [self.view makeToast:@"Minimum Quantity should be 1."];
    }
    else if (qty>orderLimit) {
        [self.txtQty resignFirstResponder];
        [self.txtQty setText:@""];
        
        NSString *str = [NSString stringWithFormat:@"In single order, You can't order more than %@ kits.",orderLimit];
        [self.view makeToast:str];

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


#pragma mark - Stepper Delegate Method

- (IBAction)stepperValueChange:(id)sender {
    
     NSLog(@"--->> Stepper Value:-> %@", [sender currentTitle]);
    
    qtyValue = [[sender currentTitle]intValue];
    
    [self.lblProductQty setText:[[@" X " stringByAppendingString:[sender currentTitle]] stringByAppendingString:@" QTY"]];
    
    double n1=[price doubleValue];
    double total=n1 * [[sender currentTitle]intValue];
    
    totalPrice=[NSNumber numberWithLong:total];
    
    [self.lblTotalPrice setText:[@"= ₹ " stringByAppendingString:[NSString stringWithFormat:@"%@",totalPrice]]];
    
}


@end
