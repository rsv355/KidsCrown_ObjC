//
//  MyCartTableViewCell.h
//  KidsCrown
//
//  Created by webmyne systems on 08/04/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCartTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblKitName;
@property (weak, nonatomic) IBOutlet UILabel *lblKitUnitPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblKitQuantity;
@property (weak, nonatomic) IBOutlet UILabel *lblKitTotalPrice;


@property (weak, nonatomic) IBOutlet UILabel *lblCrownName;
@property (weak, nonatomic) IBOutlet UILabel *lblCrownUnitPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblCrownQuantity;
@property (weak, nonatomic) IBOutlet UILabel *lblCrownTotalPrice;

@property (weak, nonatomic) IBOutlet UIButton *btnDeleteKit;
@property (weak, nonatomic) IBOutlet UIButton *btnDeleteCrown;


//---STATE LIST
@property (weak, nonatomic) IBOutlet UILabel *stateName;
@property (weak, nonatomic) IBOutlet UILabel *stateSName;

@property (weak, nonatomic) IBOutlet UIButton *removeButton;
@end
