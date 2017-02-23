//
//  MyCartViewController.h
//  KidsCrown
//
//  Created by webmyne systems on 08/04/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBaseFile.h"
#import "KidsCrownUrlSchema.h"

@interface MyCartViewController : UIViewController
{
    
    NSInteger kitCellPrice;
    NSInteger crownKitCellPrice;
    NSInteger amount;
    NSInteger totalPrice;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btnRemove;
- (IBAction)btnRemove:(id)sender;
@property(strong,nonatomic)DataBaseFile *dbHandler;
@property(strong,nonatomic)NSMutableArray *arrIntrokit;

@property(strong,nonatomic)NSMutableArray *KitArr;
@property(strong,nonatomic)NSMutableArray *CrownArr;
@property(assign,nonatomic)long  price;

@property(assign,nonatomic)long  unit;
@property(assign,nonatomic)long  calPrice;
@property(strong,nonatomic)NSMutableArray *CrownKitArr;

@property (weak, nonatomic) IBOutlet UILabel *lblSubTotal;

@property (weak, nonatomic) IBOutlet UIView *plusCartView;

@property (strong,nonatomic) NSString *strSetHidden;
@property (strong, nonatomic) IBOutlet UIView *subviewNavigationBar;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *subviewNavigationBarHeightConstraint;

@property (strong, nonatomic) NSMutableArray *productListArray;


@end
