//
//  WelcomeViewController.h
//  KidsCrown
//
//  Created by webmyne systems on 07/04/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBaseFile.h"

@interface WelcomeViewController : UIViewController
- (IBAction)btnCrlose:(id)sender;

@property(strong,nonatomic)DataBaseFile *dbHandler;
@property(strong,nonatomic)NSMutableArray *arrDB;

@property(strong,nonatomic)NSMutableArray *productImgUrl;

@property(strong,nonatomic)NSMutableArray *productPrice;

@property (strong, nonatomic) NSMutableArray *productTableData;

@property (strong, nonatomic) NSMutableArray *productPriceForMobile;
@property(strong,nonatomic)NSMutableArray *arrProductData;
@property (nonatomic,assign) int productCountFromDb;
@end
