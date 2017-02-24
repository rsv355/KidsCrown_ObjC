//
//  WelcomeViewController.m
//  KidsCrown
//
//  Created by webmyne systems on 07/04/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import "WelcomeViewController.h"
#import "DashboardViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "KidsCrownUrlSchema.h"
#import "UIView+Toast.h"
#import "NSString+HTML.h"
#import "GTMNSString+HTML.h"
#import "NSMutableDictionary+DictionaryWithValidation.h"

@interface WelcomeViewController ()

@property (strong, nonatomic) NSMutableArray *maxQty;
@property (strong, nonatomic) NSMutableArray *minQty;
@property (strong, nonatomic) NSMutableArray *priceID;
@property (strong, nonatomic) NSMutableArray *productID;
@property (strong, nonatomic) NSMutableArray *productName;
@property (strong, nonatomic) NSMutableArray *productNumberArray;
@property (strong, nonatomic) NSMutableArray *productDiscription;
@property (strong, nonatomic) NSMutableArray *proImgID;

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.arrProductData = [[NSMutableArray alloc] init];
    
    self.dbHandler = [[DataBaseFile alloc] init];
    [self.dbHandler CopyDatabaseInDevice];
    
//    [self FetchAllProductDetail];
  //  [self FetchDiscountDetail];
    
    
 // New Webservice Calling
    
//    [self FetchProductDataFromWebService];
//    [self FetchDiscountDetail];

    [self webserivceForVersionCheck];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appplicationIsActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationEnteredForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    
}

- (void)appplicationIsActive:(NSNotification *)notification {
    
}

- (void)applicationEnteredForeground:(NSNotification *)notification {
    [self webserivceForVersionCheck];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -  Web Service for Fetch check Letest Version

-(void)webserivceForVersionCheck
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    NSString *currentAppVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    
    NSString * deviceType=@"IOS";
    
    
    [manager GET:[NSString stringWithFormat:@"%@%@%@/%@",NEW_BASE_URL,CHECK_APP_VERSION,currentAppVersion,deviceType]  parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        [self fetchDataResponse:dic1];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Kid's Crown" message:@"Network error. Please try again later" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [errorAlert show];
    }];
    
}

- (void)fetchDataResponse:(NSDictionary*)dictionary {
    
    int i = 2;
    NSNumber *number = [NSNumber numberWithInt:i];
    
    
    
    if([[[dictionary valueForKey:@"Response"] valueForKey:@"ResponseCode"]isEqualToNumber:number])
    {
        int j = 1;
        NSNumber *number1 = [NSNumber numberWithInt:j];
        if ([[[dictionary valueForKey:@"Data"] valueForKey:@"IsMendatory"]isEqualToNumber:number1])
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"KidsCrown" message:@"Update is Available" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alert show];
        }
        
    }
    
    
//    
//    if([[dictionary valueForKey:@"Response"] valueForKey:@"ResponseCode"] == 0)
//    {
//                   UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"KidsCrown" message:@"Update is Available" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
//        [alert show];
//    }
//
    
    
    
    
    // | [[dictionary valueForKey:@"Response"] valueForKey:@"ResponseCode"] == 0
    
    
    /*  else
     {
     UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"KidsCrown" message:[NSString stringWithFormat:@"%@",[[dictionary valueForKey:@"Response"] valueForKey:@"ResponseMsg"]] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
     [alert show];
     }*/
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == [alertView firstOtherButtonIndex]) {
        
        NSString *iTunesLink =@"https://itunes.apple.com/in/app/kids-crown/id1137556962?mt=8";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
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
    NSMutableArray *AllProductDataArray = [[NSMutableArray alloc]init];
    
    AllProductDataArray = [dictionary objectForKey:@"Data"];
    
}






#pragma mark -  Consume Webservice methods
-(void)FetchAllProductDetail{
 
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *fetchURL=[NSString stringWithFormat:@"%@%@%@",Kids_Crown_BASEURL,FETCH_CURRENT_PRICING_FORMOBILE,@"0"];
    
    [manager GET:fetchURL  parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        [self fetchDataFromResponse:dic1];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"KidsCrown" message:@"Network error. Please try again later" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [errorAlert show];
    }];
}
-(void) fetchDataFromResponse:(NSDictionary *)dictionary{
    NSNumber *no1=[NSNumber numberWithInt:1];
    if ([[dictionary valueForKey:@"ResponseCode"]isEqualToNumber:no1]) {
        _arrProductData =[dictionary valueForKey:@"Data"];
        
        [[NSUserDefaults standardUserDefaults]
         setObject:[NSKeyedArchiver archivedDataWithRootObject:_arrProductData]
         forKey:@"ProductData"];
        
        [self ModelListSuccessfully];
    }
    else{
        [self.view makeToast:@"Please check Internet connection!"];
        [MBProgressHUD hideHUDForView:self.view animated:YES];

    }

}
-(void)addDataToDataBase:(NSDictionary *)dictionary{
    
    NSString *insertQuery = [NSString stringWithFormat:@"insert into Product (color,description,max,min,price,product_id,name,product_number,ProductImage) values (%d,'%@',%d,%d,%d,%d,'%@',%d,'%@')",1,@"Hi hello",12,12,121,15,@"Masum",12,@"fzdsds"];
    
    [self.dbHandler insertDataWithQuesy:insertQuery];
    [self.view makeToast:@"Added to Product..."];
    
}


-(void)FetchDiscountDetail{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *fetchURL=[NSString stringWithFormat:@"%@%@",Kids_Crown_BASEURL,FETCH_DISCOUNT];
   
    [manager GET:fetchURL  parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        [self fetchDiscountDataFromResponse:dic1];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"KidsCrown" message:@"Network error. Please try again later" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [errorAlert show];
    }];
}

-(void) fetchDiscountDataFromResponse:(NSDictionary *)dictionary{
   
    NSNumber *no1=[NSNumber numberWithInt:1];
    
    if ([[dictionary valueForKey:@"ResponseCode"]isEqualToNumber:no1]) {
       
        NSArray *arrDiscount =[dictionary valueForKey:@"Data"];
        
        NSString *deleteQuery =[NSString stringWithFormat:@"delete from Discount"];
        [self.dbHandler DeleteDataWithQuesy:deleteQuery];

        for (NSDictionary *dict in arrDiscount) {
            
            
            NSString *insertQuery = [NSString stringWithFormat:@"insert into Discount (DiscountImage,DiscountInitial,DiscountPercentage,ProductID) values ('%@','%@','%@','%@')",[dict objectForKey:@"DiscountImage"],[dict objectForKey:@"DiscountInitial"],[dict objectForKey:@"DiscountPercentage"],[dict objectForKey:@"ProductID"]];
            
            [self.dbHandler insertDataWithQuesy:insertQuery];
            [self.view makeToast:@"Added to Discount..."];

        }
    }
    else{
        [self.view makeToast:[dictionary valueForKey:@"ResponseMessage"]];
    }
    
}
#pragma mark - store webservice data in database

-(void)StoreWebserviceRecordInDataBasewithArr:(NSMutableArray *)arrProduct
{
    NSString *deleteQuery =[NSString stringWithFormat:@"delete from Product"];
    [self.dbHandler DeleteDataWithQuesy:deleteQuery];
    
    deleteQuery =[NSString stringWithFormat:@"delete from ProductImage"];
    [self.dbHandler DeleteDataWithQuesy:deleteQuery];
    
    deleteQuery =[NSString stringWithFormat:@"delete from ProductPrice"];
    [self.dbHandler DeleteDataWithQuesy:deleteQuery];
    
    for (int i=0; i<arrProduct.count; i++)
    {
        
        ////////////////////////////////////////////////// Store product Detail With ////////////////////////////////////////
        
        NSString *htmlstr = [self.productDiscription objectAtIndex:i];
        NSString *str=[htmlstr stringByConvertingHTMLToPlainText];
        
        NSString *removeSpace=[str stringByRemovingNewLinesAndWhitespace];
        
        NSString *insertProductQuery = [NSString stringWithFormat:@"insert into Product (description,max,min,product_id,name,product_number,ProductImage,price) values ('%@',%@,%@,%@,'%@','%@','%@',%@)",removeSpace,[self.maxQty objectAtIndex:i],[self.minQty objectAtIndex:i],[self.productID objectAtIndex:i],[self.productName objectAtIndex:i],[self.productNumberArray objectAtIndex:i],[self.productImgUrl objectAtIndex:i],[self.productPrice objectAtIndex:i]];
        
        [self.dbHandler insertDataWithQuesy:insertProductQuery];
        
        //////////////////////////////////////////////////// Image Store in Database ////////////////////////////////////////
      
        NSURL *url = [NSURL URLWithString:[self.productImgUrl objectAtIndex:i]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        //        UIImage *img = [[UIImage alloc]initWithData:data];
        
        NSString *s1 = [self.proImgID objectAtIndex:i];
        NSString *imagePath =[self.dbHandler.ImageFolderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",s1]];
                
        
        if (![data writeToFile:imagePath atomically:NO])
        {
        }
        else
        {
        }
        NSString *insertQuery = [NSString stringWithFormat:@"insert into ProductImage (path,product_id,product_image_id) values ('%@',%@,%@)",imagePath,[self.productID objectAtIndex:i],[self.proImgID objectAtIndex:i]];
        
        [self.dbHandler insertDataWithQuesy:insertQuery];
        
    }
    
    
    for (NSDictionary *dict  in arrProduct)
    {
        
        if ([dict objectForKey:@"lstProductPriceForMobile"])
        {
            NSArray *arrlstProductPrice = [[NSArray alloc] init];
            arrlstProductPrice = [dict objectForKey:@"lstProductPriceForMobile"];
            
            for (NSDictionary *d in arrlstProductPrice)
            {
                NSString *insertQuery = [NSString stringWithFormat:@"insert into ProductPrice (product_id,price_id,price,min,max) values (%@,%@,%@,%@,%@)",[d objectForKey:@"ProductID"],[d objectForKey:@"PriceID"],[d objectForKey:@"Price"],[d objectForKey:@"MinQty"],[d objectForKey:@"MaxQty"]];
                [self.dbHandler insertDataWithQuesy:insertQuery];
            }
        }
    }
    
}

-(void)ModelListSuccessfully
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    // [self.refreshControl endRefreshing];
    // self.jsonResponse = [self.req returnResponse];
    self.productImgUrl = [[NSMutableArray alloc] init];
    
    self.productPrice = [[NSMutableArray alloc] init];
    self.maxQty = [[NSMutableArray alloc] init];
    self.minQty = [[NSMutableArray alloc] init];
    self.priceID = [[NSMutableArray alloc] init];
    self.productID = [[NSMutableArray alloc] init];
    self.productName = [[NSMutableArray alloc] init];
    self.productDiscription = [[NSMutableArray alloc] init];
    self.productNumberArray = [[NSMutableArray alloc] init];
    self.proImgID = [[NSMutableArray alloc] init];
    
    
    for (NSDictionary *dict in self.arrProductData)
    {
        if ([dict objectForKey:@"lstProductImg"])
        {
            if ([dict objectForKey:@"lstProductImg"] != [NSNull null])
            {
                NSMutableArray *arrlstProductImg = [dict objectForKey:@"lstProductImg"];
                
                if (arrlstProductImg.count>0)
                {
                    for (NSDictionary *imgLstDict in arrlstProductImg)
                    {
                        if ([imgLstDict objectForKey:@"ImagePath"] != [NSNull null])
                        {
                            [self.productImgUrl addObject:[imgLstDict objectForKey:@"ImagePath"]];
                        }
                        else
                        {
                            [self.productImgUrl addObject:@""];
                        }
                        
                        if ([imgLstDict objectForKey:@"ProductImageID"])
                        {
                            if ([imgLstDict objectForKey:@"ProductImageID"] != [NSNull null])
                            {
                                [self.proImgID addObject:[imgLstDict objectForKey:@"ProductImageID"]];
                            }
                            else
                            {
                                [self.proImgID addObject:@""];
                            }
                        }
                        else
                        {
                            [self.proImgID addObject:@""];
                        }
                    }
                }
            }
            else
            {
                [self.productImgUrl addObject:@""];
            }
            
        }
        
        
        if ([dict objectForKey:@"lstProductPriceForMobile"])
        {
            if ([dict objectForKey:@"lstProductPriceForMobile"] != [NSNull null])
            {
                NSMutableArray *arrlstProductPrice = [dict objectForKey:@"lstProductPriceForMobile"];
                if (arrlstProductPrice.count>0)
                {
                    for (NSDictionary *productPriceDict in arrlstProductPrice)
                    {
                        if ([productPriceDict objectForKey:@"Price"])
                        {
                            if ([productPriceDict objectForKey:@"Price"] != [NSNull null])
                            {
                                [self.productPrice addObject:[NSString stringWithFormat:@"%@",[productPriceDict objectForKey:@"Price"]]];
                            }
                            else
                            {
                                [self.productPrice addObject:@""];
                            }
                        }
                        else
                        {
                            [self.productPrice addObject:@""];
                        }
                        if ([productPriceDict objectForKey:@"MaxQty"])
                        {
                            if ([productPriceDict objectForKey:@"MaxQty"] != [NSNull null])
                            {
                                [self.maxQty addObject:[productPriceDict objectForKey:@"MaxQty"]];
                            }
                            else
                            {
                                [self.maxQty addObject:@""];
                            }
                        }
                        else
                        {
                            [self.maxQty addObject:@""];
                        }
                        if ([productPriceDict objectForKey:@"MinQty"])
                        {
                            if ([productPriceDict objectForKey:@"MinQty"] != [NSNull null])
                            {
                                [self.minQty addObject:[productPriceDict objectForKey:@"MinQty"]];
                            }
                            else
                            {
                                [self.minQty addObject:@""];
                            }
                        }
                        else
                        {
                            [self.minQty addObject:@""];
                        }
                        if ([productPriceDict objectForKey:@"PriceID"])
                        {
                            if ([productPriceDict objectForKey:@"PriceID"] != [NSNull null])
                            {
                                [self.priceID addObject:[productPriceDict objectForKey:@"PriceID"]];
                            }
                            else
                            {
                                [self.priceID addObject:@""];
                            }
                        }
                        else
                        {
                            [self.priceID addObject:@""];
                        }
                    }
                }
            }
            else
            {
                [self.productPrice addObject:@""];
            }
        }
        
        if ([dict objectForKey:@"ProductID"])
        {
            if ([dict objectForKey:@"ProductID"] != [NSNull null])
            {
                [self.productID addObject:[dict objectForKey:@"ProductID"]];
            }
            else
            {
                [self.productID addObject:@""];
            }
        }
        else
        {
            [self.productID addObject:@""];
        }
        if ([dict objectForKey:@"ProductName"])
        {
            if ([dict objectForKey:@"ProductName"] != [NSNull null])
            {
                [self.productName addObject:[dict objectForKey:@"ProductName"]];
            }
            else
            {
                [self.productName addObject:@""];
            }
        }
        else
        {
            [self.productName addObject:@""];
        }
        
        if ([dict objectForKey:@"Description"])
        {
            if ([dict objectForKey:@"Description"] != [NSNull null])
            {
                [self.productDiscription addObject:[dict objectForKey:@"Description"]];
            }
            else
            {
                [self.productDiscription addObject:@""];
            }
        }
        else
        {
            [self.productDiscription addObject:@""];
        }
        
        if ([dict objectForKey:@"ProductNumber"])
        {
            if ([dict objectForKey:@"ProductNumber"] != [NSNull null])
            {
                [self.productNumberArray addObject:[dict objectForKey:@"ProductNumber"]];
            }
            else
            {
                [self.productNumberArray addObject:@""];
            }
        }
        else
        {
            [self.productNumberArray addObject:@""];
        }
    }
    
    
    if (self.productCountFromDb != [self.arrProductData count])
    {
        [self StoreWebserviceRecordInDataBasewithArr:self.arrProductData];
    }
    else
    {
        NSString *selectQuery = @"select * from Product";
        self.productTableData = [[NSMutableArray alloc] init];
        self.productTableData = [self.dbHandler selectAllDataFromTablewithQuery:selectQuery ofColumn:10];
    }
}



- (IBAction)btnCrlose:(id)sender
{
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable)
    {
        [self.view makeToast:@"Please check Internet connection!"];
    
    }
    else
    {
        UIViewController *viewController=[self.storyboard instantiateViewControllerWithIdentifier:@"MENU_DRAWER"];
        [self presentViewController:viewController animated:YES completion:nil];
      
      
    }
 
}
@end
