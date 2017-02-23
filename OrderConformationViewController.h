//
//  OrderConformationViewController.h
//  KidsCrown
//
//  Created by webmyne systems on 08/04/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderConformationViewController : UIViewController
- (IBAction)btnBack:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *lblInvoiceNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblBankDetail;

@property (strong,nonatomic) NSMutableDictionary *orderConfirmDict;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lblBankDetailBottomConstraint;


@end
