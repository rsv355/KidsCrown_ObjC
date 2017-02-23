//
//  Crown3ViewController.h
//  KidsCrown
//
//  Created by webmyne systems on 07/04/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBaseFile.h"

@protocol WSForProductOnBackButtonDelegate2 <NSObject>
    @required
    
-(void)CheckService2;
    @end


@interface Crown3ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *btnAddToCartNavBar;
    
@property (weak, nonatomic)id<WSForProductOnBackButtonDelegate2> WSForProductOnBackButtonDelegate2;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

//- (IBAction)btnUL:(id)sender;
//- (IBAction)btnUR:(id)sender;
//- (IBAction)btnLL:(id)sender;
//- (IBAction)btnLR:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *calculatorView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calculatorViewHeightConst;
//@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *txtQty;

- (IBAction)btnNumbers:(id)sender;
- (IBAction)btnClearNumber:(id)sender;
- (IBAction)btnCancel:(id)sender;
- (IBAction)btnSave:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblCrownName;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)btnAddCart:(id)sender;

@property(strong,nonatomic)DataBaseFile *dbHandler;


@property (strong,nonatomic) NSMutableArray *productDetailArray;
@property (strong,nonatomic) NSString *strProductId;

@property (strong, nonatomic) IBOutlet UILabel *lblBadgeCount;



@end
