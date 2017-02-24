//
//  Crown3ViewController.m
//  KidsCrown
//
//  Created by webmyne systems on 07/04/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import "Crown3ViewController.h"
#import "CrownCollectionViewCell.h"
#import "UIView+Toast.h"
#import "CrownTableViewCell.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "KidsCrownUrlSchema.h"
#import "MyCartViewController.h"
#import "UIButton+tintImage.h"
#import "CollectionReusableView.h"

@interface Crown3ViewController ()
{
    NSString *strSel,*strCalc;
    NSArray *arrCrownTitles;
    NSArray *arrCrownNames;
    NSMutableArray *nameArr,*qtyArr,*priceIdArr,*_idArr,*productDetailsDCsArr,*productSpecIDArr;
    CrownTableViewCell *tcell;
    NSString *crownTag,*total_price;
    NSNumber *price,*maxPrice,*minPrice,*totalPrice,*orderLimit,*productId,*quantity,*priceId;
    NSString *productName;
    NSInteger totalQty,price_id,unit_price;
    NSArray *priceArr;
    NSInteger updatedTotal;
    
    NSString *discountPercentage;
    
    int ULColumnCount,URColumnCount,LLColumnCount,LRColumnCount;
    NSMutableArray *ULNameArr,*URNameArr,*LLNameArr,*LRNameArr;
    NSArray *HeaderArr;
    
    int qtyCountToTableView;
    
}

@end

@implementation Crown3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
       strSel=@"ul";
    [self.collectionView reloadData];
    
    strCalc=@"0";
    
    qtyCountToTableView = 0;
    
    ULColumnCount = 0;
    URColumnCount = 0;
    LLColumnCount = 0;
    LRColumnCount = 0;
    
    ULNameArr = [[NSMutableArray alloc]init];
    URNameArr = [[NSMutableArray alloc]init];
    LLNameArr = [[NSMutableArray alloc]init];
    LRNameArr = [[NSMutableArray alloc]init];
    
    HeaderArr=[NSArray arrayWithObjects:@"Upper Left",@"Upper Right",@"Lower Left",@"Lower Right", nil];


    
    [self.txtQty addTarget:self action:@selector(textFieldInputDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.lblCrownName setText:@""];
    [self.txtQty setText:@""];
    nameArr=[[NSMutableArray alloc]init];
    qtyArr=[[NSMutableArray alloc]init];
    priceIdArr=[[NSMutableArray alloc]init];
    productDetailsDCsArr = [[NSMutableArray alloc]init];
    productSpecIDArr = [[NSMutableArray alloc]init];
    
    
    [self loadDataFromArray];
    
    self.dbHandler = [[DataBaseFile alloc] init];
    [self.dbHandler CopyDatabaseInDevice];
    
    _lblBadgeCount.layer.cornerRadius = _lblBadgeCount.frame.size.width/2;
    _lblBadgeCount.layer.masksToBounds = YES;
    
    [self setBadgeLabel];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [self setBadgeLabel];
}

#pragma mark - Load Data From Array

-(void)loadDataFromArray
{
    productId=[_productDetailArray valueForKey:@"ProductID"];
    orderLimit=[_productDetailArray valueForKey:@"OrderLimit"];
    priceArr=[_productDetailArray valueForKey:@"priceSlabDCs"];
    productDetailsDCsArr = [_productDetailArray valueForKey:@"productDetailsDCs"];
    
    [self CollectionViewRowAndColumn];
    
}

-(void)CollectionViewRowAndColumn
{
    
    for (int i = 0; i<productDetailsDCsArr.count; i++)
    {
        NSArray *arr = [productDetailsDCsArr objectAtIndex:i];
        
        if([[arr valueForKey:@"Position"] isEqualToString:@"UL"])
        {
            ULColumnCount  = ULColumnCount + 1 ;
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            [dict setObject:[arr valueForKey:@"ModelName"] forKey:@"ModelName"];
            [dict setObject:[arr valueForKey:@"ModelNumber"] forKey:@"ModelNumber"];
            [ULNameArr addObject:dict];
            
        }
        
        else if([[arr valueForKey:@"Position"] isEqualToString:@"UR"])
        {
            URColumnCount  = URColumnCount + 1 ;
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            [dict setObject:[arr valueForKey:@"ModelName"] forKey:@"ModelName"];
            [dict setObject:[arr valueForKey:@"ModelNumber"] forKey:@"ModelNumber"];
            [URNameArr addObject:dict];
        }
        
        else if([[arr valueForKey:@"Position"] isEqualToString:@"LL"])
        {
            LLColumnCount  = LLColumnCount + 1 ;
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            [dict setObject:[arr valueForKey:@"ModelName"] forKey:@"ModelName"];
            [dict setObject:[arr valueForKey:@"ModelNumber"] forKey:@"ModelNumber"];
            [LLNameArr addObject:dict];
        }
        
        else if([[arr valueForKey:@"Position"] isEqualToString:@"LR"])
        {
            LRColumnCount  = LRColumnCount + 1 ;
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            [dict setObject:[arr valueForKey:@"ModelName"] forKey:@"ModelName"];
            [dict setObject:[arr valueForKey:@"ModelNumber"] forKey:@"ModelNumber"];
            [LRNameArr addObject:dict];
            
        }
        

    }
    
    
    
}

#pragma mark - UICollectionView Datasoruce & Delegate

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader)
    {
        CollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        
        headerView.lblHeader.layer.cornerRadius = headerView.lblHeader.frame.size.height/2;
        [ headerView.lblHeader setClipsToBounds:YES];
        
        headerView.lblHeader.text =[HeaderArr objectAtIndex:indexPath.section];// title;
        
        
        if (indexPath.section == 0) {
            headerView.lineview.hidden = YES;
        } else {
            headerView.lineview.hidden = NO;
        }
        reusableview = headerView;
    }
    
    
    
    
    return reusableview;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return ULColumnCount;
}
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 4;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CrownCollectionViewCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.subviewOfCellModelName.layer.cornerRadius = 5.0;
    [cell.subviewOfCellModelName setClipsToBounds:YES];
    cell.subviewOfCellModelName.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.subviewOfCellModelName.layer.borderWidth = 1.0;
    
    if (indexPath.section == 0) {
        
        cell.lblCellModelName.text = [[ULNameArr objectAtIndex:indexPath.row]valueForKey:@"ModelName"];
         cell.lblCellModelNumber.text = [[ULNameArr objectAtIndex:indexPath.row]valueForKey:@"ModelNumber"];
        cell.imgCell.image = [UIImage imageNamed:@"ul.png"];
        
    }
    
    else if (indexPath.section == 1) {
        
        cell.lblCellModelName.text = [[URNameArr objectAtIndex:indexPath.row]valueForKey:@"ModelName"];
        cell.lblCellModelNumber.text = [[URNameArr objectAtIndex:indexPath.row]valueForKey:@"ModelNumber"];
        cell.imgCell.image = [UIImage imageNamed:@"ur.png"];
        
    }
    
    else if (indexPath.section == 2) {
        
        cell.lblCellModelName.text = [[LLNameArr objectAtIndex:indexPath.row]valueForKey:@"ModelName"];
        cell.lblCellModelNumber.text = [[LLNameArr objectAtIndex:indexPath.row]valueForKey:@"ModelNumber"];
        cell.imgCell.image = [UIImage imageNamed:@"ll.png"];
        
    }
    else if (indexPath.section == 3) {
        
        cell.lblCellModelName.text = [[LRNameArr objectAtIndex:indexPath.row]valueForKey:@"ModelName"];
        cell.lblCellModelNumber.text = [[LRNameArr objectAtIndex:indexPath.row]valueForKey:@"ModelNumber"];
        cell.imgCell.image = [UIImage imageNamed:@"lr.png"];
        
    }
  
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.lblCrownName setText:@""];
    [self.txtQty setText:@""];
    
    if (indexPath.section == 0) {
         [self.lblCrownName setText:[[ULNameArr objectAtIndex:indexPath.row]valueForKey:@"ModelNumber"]];
    }
    else if (indexPath.section == 1) {
       [self.lblCrownName setText:[[URNameArr objectAtIndex:indexPath.row]valueForKey:@"ModelNumber"]];
    }
    else if (indexPath.section == 2) {
        [self.lblCrownName setText:[[LLNameArr objectAtIndex:indexPath.row]valueForKey:@"ModelNumber"]];
    }
    else if (indexPath.section == 3) {
        [self.lblCrownName setText:[[LRNameArr objectAtIndex:indexPath.row]valueForKey:@"ModelNumber"]];
    }
    
    
  }

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{ 
    double side1,side2;
    CGSize collectionviewSize=self.collectionView.frame.size;
    side1=collectionviewSize.width/6-5;
    side2=collectionviewSize.height/2-25;
    
    return CGSizeMake(side1, side1+45);
}


#pragma mark - UIButton IBAction
- (IBAction)btnAddToCartNavBAr:(id)sender {
    
    MyCartViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MY_CART"];
    
    viewController.strSetHidden = @"no";
    
    viewController.productListArray = _productDetailArray;
    
    [self presentViewController:viewController animated:YES completion:nil];
}
- (IBAction)btnBack:(id)sender {
    
    [self.WSForProductOnBackButtonDelegate2 CheckService2];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)textFieldInputDidChange:(UITextField *)textfield{
    
}

- (IBAction)btnNumbers:(id)sender {

    if ([self.txtQty.text length]<3&&![self.lblCrownName.text isEqualToString:@""])
    {
    if (![[self.txtQty text]isEqualToString:@"0"]) {
        if ([self.txtQty.text length]==2) {
            NSString *str=[[self.txtQty text]stringByAppendingString:[NSString stringWithFormat:@"%ld",[sender tag]]];
            if ([str isEqualToString:@"100"]) {
                [self.txtQty setText:@"100"];
            }
            else{
                [self.view makeToast:@"You can't add more than 100"];
            }
        }else{
            [self.txtQty setText:[[self.txtQty text]stringByAppendingString:[NSString stringWithFormat:@"%ld",[sender tag]]]];}
            }
            else{
                [self.txtQty setText:[NSString stringWithFormat:@"%ld",[sender tag]]];
            }
        }
   
    else if ([self.lblCrownName.text length]==0){
        [self.view makeToast:@"Select Crown First"];
    }
    else{
        [self.view makeToast:@"You can't add more than 100"];
    }
}

- (IBAction)btnClearNumber:(id)sender {
    [self.txtQty setText:@"0"];
}

- (IBAction)btnCancel:(id)sender {
    [self.txtQty setText:@""];
    [self.lblCrownName setText:@""];
}

- (IBAction)btnSave:(id)sender {
    if ([self.lblCrownName.text length]==0) {
        [self.view makeToast:@"Select Crown to add."];
    }
    else if ([self.txtQty.text isEqualToString:@"0"]||[self.txtQty.text isEqualToString:@""]) {
        [self.view makeToast:@"Enter Quantity"];
    }
    else{
            [nameArr addObject:[self.lblCrownName text]];
            [qtyArr addObject:[self.txtQty text]];
        
        qtyCountToTableView = qtyCountToTableView + [_txtQty.text intValue];
        
            NSString *strName = self.lblCrownName.text;
        
        for (int i = 0; i < productDetailsDCsArr.count;  i++)
        {
            NSString *strProductModelNumber = [[productDetailsDCsArr objectAtIndex:i]valueForKey:@"ModelNumber"];
            
            if ([strName isEqualToString:strProductModelNumber])
            {
                NSString *strProductSpecId = [[productDetailsDCsArr objectAtIndex:i]valueForKey:@"ProductSpecID"];
                [productSpecIDArr addObject:strProductSpecId];
            }
            
        }
        
        [self.tableView reloadData];
        [self.txtQty setText:@""];
        [self.lblCrownName setText:@""];
       }

    
}

#pragma mark- UITableView Datasource and Delegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return [nameArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tcell=(CrownTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    [tcell.lblName setText:[nameArr objectAtIndex:indexPath.row]];
    [tcell.lblQuantity setText:[qtyArr objectAtIndex:indexPath.row]];
    return tcell;
}

/*- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellHeight;
    if (indexPath.row<[self.KitArr count]) {
        cellHeight=71;
    }
    else{
        cellHeight=118;
    }
    
    return cellHeight;
}*/

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        
        int val = [[qtyArr objectAtIndex:indexPath.row] intValue];
        
        qtyCountToTableView = qtyCountToTableView - val;
        
        [nameArr removeObjectAtIndex:indexPath.row];
        [qtyArr removeObjectAtIndex:indexPath.row];
        [productSpecIDArr removeObjectAtIndex:indexPath.row];
        
        [self.tableView reloadData];
    }
}


- (IBAction)btnAddCart:(id)sender
{
   
    
    self.dbHandler = [[DataBaseFile alloc] init];
    [self.dbHandler CopyDatabaseInDevice];

   NSString *selectQty = [NSString stringWithFormat:@"select SUM(qty) from CrownKit where product_id = '%@'",productId];
    
    NSString *strQty = [[[self.dbHandler selectTableDatawithQuery:selectQty] objectAtIndex:0] objectForKey:@"SUM(qty)"];
    
  
    
    int value = qtyCountToTableView + [strQty intValue];
    
    if (value > [orderLimit integerValue]) {
        NSString *str = [NSString stringWithFormat:@"Your order limit is %d",[orderLimit intValue]];
        
        [self.view makeToast:str];
        return;
    }
        
  
    if ([nameArr count]!=0) {
        
     [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _idArr=[[NSMutableArray alloc]init];

    [self getPriceDataFromDatabase];
    
    NSString *userId=[[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
    
    for (int i=0; i<[qtyArr count]; i++) {
        totalQty=totalQty +[[qtyArr objectAtIndex:i] integerValue];
       
    }
    for (int i=0; i<[priceArr count]; i++)
    {
        NSDictionary *dc=[priceArr objectAtIndex:i];
       
        if (totalQty >[dc[@"MinQty"] integerValue]&&totalQty <[dc[@"MaxQty"] integerValue])
        {
            price_id=[dc[@"PriceID"] integerValue];
            unit_price=[dc[@"Price"] integerValue];
          
        }
    }
        
        float discount_price = ([totalPrice floatValue] * [discountPercentage floatValue])/100;
        
        float grand_price = [totalPrice floatValue] - discount_price;
    
        
    for (int i=0; i<[nameArr count]; i++)
    {
        if ([nameArr count]>0) {
            
            NSString *name=[nameArr objectAtIndex:i];
            NSInteger qty1=[[qtyArr objectAtIndex:i] integerValue];
            int strProductSpecId = [[productSpecIDArr objectAtIndex:i] intValue];
            
             NSString *isSingle = [_productDetailArray valueForKey:@"IsSingle"];
            
           // NSInteger ProductSpecId = [[productSpecIDArr objectAtIndex:i] integerValue];
            
            NSString *deleteQuery =[NSString stringWithFormat:@"delete from CrownKit where product_name='%@' AND user_Id='%@'",[nameArr objectAtIndex:i],userId];
            
            [self.dbHandler DeleteDataWithQuesy:deleteQuery];
            
            NSString *insertQuery = [NSString stringWithFormat:@"insert into CrownKit (user_id,product_id,price_id,product_name,qty,unit_price,total_price,crownKit_tag,discount_price,grand_price) values ('%@',%@,%ld,'%@',%ld,'%@','%@',%d,'%@','%@')",userId,productId,price_id,name,qty1,[NSNumber numberWithInteger:unit_price],total_price,strProductSpecId,isSingle, [NSNumber numberWithFloat:grand_price]];
            
            [self.dbHandler insertDataWithQuesy:insertQuery];
            

        }
    }
       for (int i=0; i<[nameArr count]; i++) {
        
           NSInteger qty1=[[qtyArr objectAtIndex:i] integerValue];
      
        
           NSInteger total=unit_price*qty1;
           total_price=[NSString stringWithFormat:@"%ld",total];
           if ([nameArr count]>0) {
        
            NSString *selectQuery = [NSString stringWithFormat:@"select count(*) from CrownKit where  user_Id='%@'",userId];
            
            NSString *totalcount = [self.dbHandler MathOperationInTable:selectQuery];
            
            if ([totalcount isEqualToString:@"0"]) {
               
                [self.view makeToast:@"Added to Cart..."];
                
            }
            else
            {
                NSString *selectQuery = [NSString stringWithFormat:@"select _id,qty from CrownKit where user_Id='%@'",userId];
                
                NSMutableArray *arrCrown = [self.dbHandler selectAllDataFromTablewithQuery:selectQuery ofColumn:2];
                totalQty=0;
                for (int i=0; i<[arrCrown count]; i++) {
                    totalQty=totalQty +[[[arrCrown objectAtIndex:i]objectAtIndex:1] integerValue] ;
                    
                }
               
                for (int i=0; i<[priceArr count]; i++)
                {
                    NSDictionary *dc=[priceArr objectAtIndex:i];
                    
                    if (totalQty >=[dc[@"MinQty"] integerValue]&&totalQty <=[dc[@"MaxQty"] integerValue])
                    {
                        price_id=[dc[@"PriceID"] integerValue];
                        unit_price=[dc[@"Price"] integerValue];
                      
                    }
                }
                
                for (int i=0; i<[arrCrown count]; i++) {
                   
                updatedTotal=[[[arrCrown objectAtIndex:i]objectAtIndex:1] integerValue]*unit_price;
                   
                    [priceIdArr addObject:[NSString stringWithFormat:@"%ld",updatedTotal]];
                    [_idArr addObject:[[arrCrown objectAtIndex:i] objectAtIndex:0]];
                }
                
                for (int i=0; i<[arrCrown count]; i++) {
                    
                    updatedTotal=[[[arrCrown objectAtIndex:i]objectAtIndex:1] integerValue]*unit_price;
                    
                    float discount_price1 = (updatedTotal  * [discountPercentage floatValue])/100;
                    
                    float grand_price1 = updatedTotal  - discount_price1;

                    NSString *updateQuery = [NSString stringWithFormat:@"update CrownKit set unit_price=%@,price_id=%ld,total_price=%ld,discount_price='%@',grand_price='%@'  where user_Id='%@' AND _id=%ld",[NSNumber numberWithInteger:unit_price],price_id,updatedTotal,[NSNumber numberWithFloat:discount_price1], [NSNumber numberWithFloat:grand_price1],userId,[[_idArr objectAtIndex:i] integerValue]];
                   
                    [self.dbHandler UpdateDataWithQuesy:updateQuery];
                    
                    
                    [nameArr removeAllObjects];
                    [qtyArr removeAllObjects];
                    [productSpecIDArr removeAllObjects];
                    qtyCountToTableView = 0;

                    [self.txtQty setText:@""];
                    [self.lblCrownName setText:@""];
                    [self.tableView reloadData];
                }
              
            }
           
        }
           [self.view makeToast:@"Crowns are added to your cart. Check your cart."];
           
           [self updateBadgeCount];
           
           [MBProgressHUD hideHUDForView:self.view animated:YES];

           
    }
    
    }
    else{
        
        [self.view makeToast:@"Select crown first...!!"];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
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
            
            
        }

        
    }
    else {
        
        [self.lblBadgeCount setHidden:YES];
    }
    
}


-(void)updateBadgeCount {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"CART_COUNT"] != nil) {
        
        
        NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"CART_COUNT"];
        
        if ([array count]>0) {
            
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
    }
    else {
        
        NSMutableArray *cartCountArr = [[NSMutableArray alloc] init];
        
        [cartCountArr addObject:[NSString stringWithFormat:@"%@",productId]];
        [[NSUserDefaults standardUserDefaults] setObject:cartCountArr forKey:@"CART_COUNT"];
    }
    
    [self setBadgeLabel];
    
}

-(void)getPriceDataFromDatabase
{
     NSString *userId=[[NSUserDefaults standardUserDefaults]objectForKey:@"userID"];
    NSString *selectQuery = [NSString stringWithFormat:@"select *from ProductPrice where product_id=%@ AND user_Id='%@'",[NSNumber numberWithInt:16],userId];
    
    NSMutableArray *arrPrices = [self.dbHandler selectAllDataFromTablewithQuery:selectQuery ofColumn:6];
   
    
}



@end
