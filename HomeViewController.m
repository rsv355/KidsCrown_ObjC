//
//  HomeViewController.m
//  KidsCrown
//
//  Created by webmyne systems on 15/04/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import "HomeViewController.h"
#import "DataBaseFile.h"
#import "UIImageView+AFNetworking.h"
#import "UIView+Toast.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "KidsCrownUrlSchema.h"

@interface HomeViewController ()
{
    NSString *strAD;
    DataBaseFile *dbHandler;
}
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    _btnViewTopLayoutConstraints.constant=42.0f;
    
    [self setButtonLayout];
    
    self.btnCrown1.layer.borderColor=[UIColor whiteColor].CGColor;
    self.btnCrown1.layer.borderWidth=2.0f;
    self.btnCrown2.layer.borderColor=[UIColor clearColor].CGColor;
    self.btnCrown3.layer.borderColor=[UIColor clearColor].CGColor;
    
    dbHandler = [[DataBaseFile alloc] init];
    [dbHandler CopyDatabaseInDevice];
   
    [self FetchDiscountDetail];
    
   // [self getDiscountInfo];
    
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CROWN1"];
    [self addChildViewController:vc];
    vc.view.frame = CGRectMake(0, 0, self.containerView.frame.size.width, self.containerView.frame.size.height);
    [self.containerView addSubview:vc.view];
}

-(void)viewWillAppear:(BOOL)animated {
    
    NSLog(@"WILL APPERE -----");
    
    [self FetchDiscountDetail];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getDiscountInfo {
    
    NSString *selectQuery = [NSString stringWithFormat:@"select DiscountImage,DiscountPercentage from Discount where ProductID=%@",@"0"];
    
    strAD = [[[dbHandler selectAllDataFromTablewithQuery:selectQuery ofColumn:2] objectAtIndex:0] objectAtIndex:0];
    
    if ([[[[dbHandler selectAllDataFromTablewithQuery:selectQuery ofColumn:2] objectAtIndex:0] objectAtIndex:1] integerValue] !=0) {
        
         [self.adImageView setImageWithURL:[NSURL URLWithString:strAD]];
    }
   
}

-(void) setButtonLayout
{
    self.btnCrown1.layer.cornerRadius=20.0f;
    self.btnCrown2.layer.cornerRadius=20.0f;
    self.btnCrown3.layer.cornerRadius=20.0f;
    self.btnCrown1.layer.borderColor=[UIColor whiteColor].CGColor;
    self.btnCrown1.layer.borderWidth=2.0f;
    
    
}

- (IBAction)btnCrown1:(id)sender {
    
    self.btnCrown1.layer.borderColor=[UIColor whiteColor].CGColor;
    self.btnCrown1.layer.borderWidth=2.0f;
    self.btnCrown2.layer.borderColor=[UIColor clearColor].CGColor;
    self.btnCrown3.layer.borderColor=[UIColor clearColor].CGColor;
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CROWN1"];
    [self addChildViewController:vc];
    vc.view.frame = CGRectMake(0, 0, self.containerView.frame.size.width, self.containerView.frame.size.height);
    [self.containerView addSubview:vc.view];
}

- (IBAction)btnCrown2:(id)sender {
    
    self.btnCrown2.layer.borderColor=[UIColor whiteColor].CGColor;
    self.btnCrown2.layer.borderWidth=2.0f;
    self.btnCrown1.layer.borderColor=[UIColor clearColor].CGColor;
    self.btnCrown3.layer.borderColor=[UIColor clearColor].CGColor;
    
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CROWN2"];
    [self addChildViewController:vc];
    vc.view.frame = CGRectMake(0, 0, self.containerView.frame.size.width, self.containerView.frame.size.height);
    [self.containerView addSubview:vc.view];
    
}

- (IBAction)btnCrown3:(id)sender {
    
    self.btnCrown3.layer.borderColor=[UIColor whiteColor].CGColor;
    self.btnCrown3.layer.borderWidth=2.0f;
    self.btnCrown2.layer.borderColor=[UIColor clearColor].CGColor;
    self.btnCrown1.layer.borderColor=[UIColor clearColor].CGColor;
    
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CROWN3"];
    [self addChildViewController:vc];
    vc.view.frame = CGRectMake(0, 0, self.containerView.frame.size.width, self.containerView.frame.size.height);
    [self.containerView addSubview:vc.view];
}


-(void)FetchDiscountDetail{
    
    
    NSLog(@"DISCOUNT FETCH ------");
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *fetchURL=[NSString stringWithFormat:@"%@%@",Kids_Crown_BASEURL,FETCH_DISCOUNT];
    NSLog(@"FETCHURL :%@",fetchURL);
    
    [manager GET:fetchURL  parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"dic1 : %@",dic1);
        
        [self fetchDiscountDataFromResponse:dic1];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"KidsCrown" message:@"Network error. Please try again later" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [errorAlert show];
    }];
}

-(void) fetchDiscountDataFromResponse:(NSDictionary *)dictionary{
    
    NSNumber *no1=[NSNumber numberWithInt:1];
    
    if ([[dictionary valueForKey:@"ResponseCode"]isEqualToNumber:no1]) {
        
        NSArray *arrDiscount =[dictionary valueForKey:@"Data"];
        
        NSString *deleteQuery =[NSString stringWithFormat:@"delete from Discount"];
        NSLog(@"DELETE_QUERY :: %@",deleteQuery);
        [dbHandler DeleteDataWithQuesy:deleteQuery];
        
        for (NSDictionary *dict in arrDiscount) {
            
            
            NSString *insertQuery = [NSString stringWithFormat:@"insert into Discount (DiscountImage,DiscountInitial,DiscountPercentage,ProductID) values ('%@','%@','%@','%@')",[dict objectForKey:@"DiscountImage"],[dict objectForKey:@"DiscountInitial"],[dict objectForKey:@"DiscountPercentage"],[dict objectForKey:@"ProductID"]];
            
            [dbHandler insertDataWithQuesy:insertQuery];
        
            
        }
        [self getDiscountInfo];
    }
    else{
        [self.view makeToast:[dictionary valueForKey:@"ResponseMessage"]];
    }
    
}

@end
