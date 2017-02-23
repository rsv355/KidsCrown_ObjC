//
//  MyOrderDescriptionViewController.h
//  KidsCrown
//
//  Created by webmyne systems on 08/04/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBaseFile.h"

@interface MyOrderDescriptionViewController : UIViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;

- (IBAction)btnBack:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *lblShippingAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalPayment;
@property (weak, nonatomic) IBOutlet UILabel *lblYouSaved;
@property (weak, nonatomic) IBOutlet UILabel *lblPayableAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblShippingCharge;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblPaymentStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblOrderNo;
@property (weak, nonatomic) IBOutlet UILabel *lblIncludeshipping;

@property (strong,nonatomic) NSMutableArray *OrderDetailArray;
@property (strong,nonatomic) NSMutableDictionary *orderDetailDict;


@property (strong, nonatomic) IBOutlet UILabel *lblShippingChargeTitle;



@end
