//
//  OrderSendConfirmationViewController.h
//  KidsCrown
//
//  Created by webmyne systems on 19/04/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBaseFile.h"

@interface OrderSendConfirmationViewController : UIViewController
{
    NSInteger kitCellPrice;
    NSInteger crownKitCellPrice;
    float amount;
    NSInteger totalPrice;
}
@property (weak, nonatomic) IBOutlet UILabel *lblBillingAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblShippingAddress;
@property(strong,nonatomic)DataBaseFile *dbHandler;
@property(strong,nonatomic)NSMutableArray *arrShippingAddress;
@property(strong,nonatomic)NSMutableArray *arrBillingAddress;
@property(strong,nonatomic)NSMutableArray *KitArr;
@property(strong,nonatomic)NSMutableArray *CrownArr;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConst;

@property (weak, nonatomic) IBOutlet UILabel *lblSubTotal;
@property (weak, nonatomic) IBOutlet UILabel *lblGrandTotal;
- (IBAction)btnHome:(id)sender;
- (IBAction)btnPlaceOrder:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnPlaceOrder;

@property (weak, nonatomic) IBOutlet UILabel *lblIntroKitDiscount;
@property (weak, nonatomic) IBOutlet UILabel *lblAssortedKitDiscount;
@property (weak, nonatomic) IBOutlet UILabel *lblCrownDiscount;
@property (weak, nonatomic) IBOutlet UILabel *lblInVoiceDiscount;

@property (weak, nonatomic) IBOutlet UILabel *lblDiscount1;
@property (weak, nonatomic) IBOutlet UILabel *lblDiscount2;
@property (weak, nonatomic) IBOutlet UILabel *lblDiscount3;
@property (weak, nonatomic) IBOutlet UILabel *lblDiscount4;



@property (strong,nonatomic) NSMutableDictionary *orderDict;
@property (strong,nonatomic) NSMutableArray *orderArr;

@property (strong, nonatomic) IBOutlet UILabel *labelSubTotal;
@property (strong, nonatomic) IBOutlet UILabel *labelYouSaved;
@property (strong, nonatomic) IBOutlet UILabel *labelShippingCost;
@property (strong, nonatomic) IBOutlet UILabel *labelPayableAmount;



@end
