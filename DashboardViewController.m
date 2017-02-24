//
//  DashboardViewController.m
//  KidsCrown
//
//  Created by Jenish Mistry on 17/01/17.
//  Copyright © 2017 Webmyne. All rights reserved.
//
#import "DashboardViewController.h"


@interface DashboardViewController () <UITableViewDataSource,UITableViewDelegate>
{
    NSArray *BGColorArray;
    NSMutableArray *allProductsDataArray;
    NSMutableArray *HeaderArray, *DescriptionArray, *imageArray;
    NSString *strAD;

}

@property(strong,nonatomic)DataBaseFile *dbHandler;

@end

@implementation DashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    NSString *path=[[NSBundle mainBundle]pathForResource:@"animated" ofType:@"gif"];
//    NSURL *url=[[NSURL alloc] initFileURLWithPath:path];
//    _adImageView.image= [UIImage animatedImageWithAnimatedGIFURL:url];
    
    
    self.dbHandler = [[DataBaseFile alloc] init];
    [self.dbHandler CopyDatabaseInDevice];
    
    allProductsDataArray = [[NSMutableArray alloc]init];
    
    BGColorArray = [[NSArray alloc]initWithObjects:[UIColor colorWithRed:107.0/255.0 green:107.0/255.0 blue:172.0/255.0 alpha:1.0],[UIColor colorWithRed:238.0/255.0 green:150.0/255.0 blue:33.0/255.0 alpha:1.0],[UIColor colorWithRed:90.0/255.0 green:150.0/255.0 blue:202.0/255.0 alpha:1.0],[UIColor colorWithRed:146.0/255.0 green:200.0/255.0 blue:70.0/255.0 alpha:1.0], nil];
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable)
    {
        [self.view makeToast:@"Please check your Internet Connectivity...!!"];

    }
    else
    {
        [self FetchProductDataFromWebService];
    }
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
-(void)CheckService
{
    [self FetchProductDataFromWebService];
}
    
-(void)CheckService2
{
    [self FetchProductDataFromWebService];   
}
    
-(void)viewWillAppear:(BOOL)animated
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus != NotReachable)
    {
        
    }
    else
    {
        [self.view makeToast:@"Please check your Internet Connectivity...!!"];
    }
}


#pragma mark - New Web Service for Fetch Product Data

-(void)FetchProductDataFromWebService
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *fetchURL=[NSString stringWithFormat:@"%@%@",NEW_BASE_URL,FETCH_ALL_PRODUCT_DETAIL];
    
    [manager GET:fetchURL  parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[[dict objectForKey:@"Response"]valueForKey:@"ResponseCode"]integerValue] == 1)
        {
            [self ParseDataFromResponse:dict];
            
        }
        else
        {
            NSString *strMsg = [[dict objectForKey:@"Response"]valueForKey:@"ResponseMsg"];
            [self.view makeToast:strMsg];
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"KidsCrown" message:@"Network error. Please try again later" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [errorAlert show];
    }];
    
}

-(void)ParseDataFromResponse:(NSDictionary *)dictionary
{
    allProductsDataArray = [dictionary objectForKey:@"Data"];
    
    NSMutableArray *cartCountArr = [[NSMutableArray alloc] init];

   
    NSString *strIMAGE = [[dictionary objectForKey:@"RootImage"]valueForKey:@"Image"];
    
    _adImageView.image = [UIImage animatedImageWithAnimatedGIFURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",strIMAGE]]];
    
    [self AddPriceDataIntoDatabase:allProductsDataArray];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [_tableview reloadData];

    
}

#pragma mark - UITableview Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return allProductsDataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DashboardTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
  
    
    if (indexPath.row >= [BGColorArray count]) {
        cell.subviewOfTableCell.backgroundColor = [UIColor colorWithRed:90.0/255.0 green:150.0/255.0 blue:202.0/255.0 alpha:1.0];
        
    } else {
          cell.subviewOfTableCell.backgroundColor = BGColorArray[indexPath.row];
    }
    
    
    cell.lblHeader.text = [[allProductsDataArray objectAtIndex:indexPath.row]valueForKey:@"ProductName"];
    cell.lblDescription.text = [[allProductsDataArray objectAtIndex:indexPath.row]valueForKey:@"Description"];
    NSString *strImage = [[allProductsDataArray objectAtIndex:indexPath.row] valueForKey:@"RootImage"];
    [cell.imageview setImageWithURL:[NSURL URLWithString:strImage]];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSString *strIsSingle = [allProductsDataArray[indexPath.row]valueForKey:@"IsSingle"];
    
    if ([strIsSingle boolValue] == 1)
    {
        Crown1ViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CROWN1"];
        viewController.WSForProductOnBackButtonDelegate = (id)self;
        viewController.productDetailArray = allProductsDataArray[indexPath.row];
        viewController.strProductId = [allProductsDataArray[indexPath.row] valueForKey:@"ProductID"];

        if (indexPath.row >= [BGColorArray count]) {
            viewController.colorcode = [UIColor colorWithRed:90.0/255.0 green:150.0/255.0 blue:202.0/255.0 alpha:1.0];
            
        } else {
           viewController.colorcode = BGColorArray[indexPath.row];
        }

        
        [self presentViewController:viewController animated:YES completion:nil];

        

    }
    else
    {
        Crown3ViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CROWN3"];
        viewController.productDetailArray = allProductsDataArray[indexPath.row];
        viewController.strProductId = [allProductsDataArray[indexPath.row] valueForKey:@"ProductID"];
        viewController.WSForProductOnBackButtonDelegate2 = (id)self;
        [self presentViewController:viewController animated:YES completion:nil];
        
    }
    
}

#pragma mark - Add Product Price into Database

-(void)AddPriceDataIntoDatabase:(NSMutableArray *)array
{
    
    NSString *deleteQuery =[NSString stringWithFormat:@"delete from ProductPrice"];
    [self.dbHandler DeleteDataWithQuesy:deleteQuery];

    for (NSDictionary *dict in array)
    {
        NSString *strProductId = [dict valueForKey:@"ProductID"];
        NSString *strOrderLimit = [dict valueForKey:@"OrderLimit"];
        NSString *strIsSingle = [dict valueForKey:@"IsSingle"];
        
        if ([dict objectForKey:@"priceSlabDCs"])
        {
            NSArray *ProductPriceArray = [[NSArray alloc] init];
            ProductPriceArray = [dict objectForKey:@"priceSlabDCs"];
            
            for (NSDictionary *priceDict in ProductPriceArray)
            {
                NSString *insertQuery = [NSString stringWithFormat:@"insert into ProductPrice (product_id,price_id,price,min,max,orderlimit,issingle) values (%@,%@,%@,%@,%@,'%@','%@')",strProductId,[priceDict objectForKey:@"PriceID"],[priceDict objectForKey:@"Price"],[priceDict objectForKey:@"MinQty"],[priceDict objectForKey:@"MaxQty"],strOrderLimit,strIsSingle];
                
                [self.dbHandler insertDataWithQuesy:insertQuery];
            }
        }
        
    }
    
    
}


@end
