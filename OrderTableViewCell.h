//
//  OrderTableViewCell.h
//  KidsCrown
//
//  Created by webmyne systems on 07/04/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderTableViewCell : UITableViewCell

//--------OrderSendConfirmation
@property (weak, nonatomic) IBOutlet UILabel *lblNameSend;
@property (weak, nonatomic) IBOutlet UILabel *lblQtySend;
@property (weak, nonatomic) IBOutlet UILabel *lblPriceSend;


//------------OrderHistory
@property (weak, nonatomic) IBOutlet UILabel *lblOrderNo;
@property (weak, nonatomic) IBOutlet UILabel *lblPayableAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblShippingCharge;
@property (weak, nonatomic) IBOutlet UILabel *lblData;
@property (weak, nonatomic) IBOutlet UILabel *lblPaymentStatus;


//------------OrderDescription
@property (weak, nonatomic) IBOutlet UILabel *lblOrderName;
@property (weak, nonatomic) IBOutlet UILabel *lblOrderQty;
@property (weak, nonatomic) IBOutlet UILabel *lblOrderPrice;

@property (strong, nonatomic) IBOutlet UIView *subviewOfCell;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *subviewOfCellheightConstraint;


@end



