//
//  Crown1ViewController.h
//  KidsCrown
//
//  Created by webmyne systems on 07/04/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBaseFile.h"


@protocol WSForProductOnBackButtonDelegate <NSObject>

@required
-(void)CheckService;
@end

@interface Crown1ViewController : UIViewController
@property (weak, nonatomic)id<WSForProductOnBackButtonDelegate> WSForProductOnBackButtonDelegate;
@property (weak, nonatomic) IBOutlet UILabel *lblHeader;

- (IBAction)btnImage:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *ImgProduct;
@property (weak, nonatomic) IBOutlet UILabel *lblProductPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblProductQty;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalPrice;
@property (weak, nonatomic) IBOutlet UITextField *txtQty;


@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property(strong,nonatomic)DataBaseFile *dbHandler;
@property(strong,nonatomic)NSMutableArray *arrIntrokit;


@property (strong, nonatomic) IBOutlet UIView *subviewOfHeaderLabel;

@property (strong,nonatomic) UIColor *colorcode;
@property (strong,nonatomic) NSMutableArray *productDetailArray;
@property (strong,nonatomic) NSString *strProductId;

@property (strong, nonatomic) IBOutlet UIButton *btnAddToCartNavBar;

@property (strong, nonatomic) IBOutlet UIButton *btnAddtoCart;

@property (strong, nonatomic) IBOutlet UILabel *lblBadgeCount;



@end
