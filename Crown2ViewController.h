//
//  Crown2ViewController.h
//  KidsCrown
//
//  Created by webmyne systems on 07/04/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBaseFile.h"

@interface Crown2ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblHeader;


- (IBAction)btnImage:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *ImgProduct;
- (IBAction)btnAddCart:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblProductPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblProductQty;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalPrice;
@property (weak, nonatomic) IBOutlet UITextField *txtQty;
- (IBAction)btnMinus:(id)sender;
- (IBAction)btnPlus:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property(strong,nonatomic)DataBaseFile *dbHandler;

@end
