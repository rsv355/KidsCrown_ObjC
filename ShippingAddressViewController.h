//
//  ShippingAddressViewController.h
//  KidsCrown
//
//  Created by webmyne systems on 27/04/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBaseFile.h"

@interface ShippingAddressViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong,nonatomic) NSMutableDictionary *params;
@property (strong,nonatomic) NSMutableArray *values;

- (IBAction)btnBack:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *checkboxView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *checkboxHeightConst;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
- (IBAction)segmentControl:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnCheck;
- (IBAction)btnCheck:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnConfirmOrder;
- (IBAction)btnConfirmOrder:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtAddress1;
@property (weak, nonatomic) IBOutlet UITextField *txtAddress2;
@property (weak, nonatomic) IBOutlet UITextField *txtCity;
@property (weak, nonatomic) IBOutlet UITextField *txtState;
@property (weak, nonatomic) IBOutlet UITextField *txtCountry;
@property (weak, nonatomic) IBOutlet UITextField *txtPincode;
@property (weak, nonatomic) IBOutlet UITextField *txtMobileNo;
@property(strong,nonatomic)NSMutableArray *arrBillingAddress;
@property(strong,nonatomic)DataBaseFile *dbHandler;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConst;
@property (weak, nonatomic) IBOutlet UIButton *btnState;
- (IBAction)btnState:(id)sender;

@property (strong,nonatomic) NSMutableDictionary *orderDict;
@property (strong,nonatomic) NSMutableArray *orderArr;

@end
