//
//  OrderConformationViewController.m
//  KidsCrown
//
//  Created by webmyne systems on 08/04/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import "OrderConformationViewController.h"
#import "DataBaseFile.h"

@interface OrderConformationViewController ()
@property(strong,nonatomic)DataBaseFile *dbHandler;

@end

@implementation OrderConformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.dbHandler = [[DataBaseFile alloc] init];
    [self.dbHandler CopyDatabaseInDevice];

    _lblBankDetailBottomConstraint.constant = 5.0f;
    
    _lblInvoiceNumber.text = [NSString stringWithFormat:@"%@",[_orderConfirmDict valueForKey:@"InvoiceNumber"]];
    
    NSString *htmlString = [_orderConfirmDict valueForKey:@"BankDetails"];
    
    NSAttributedString *attributedString = [[NSAttributedString alloc]
                                            initWithData: [htmlString dataUsingEncoding:NSUnicodeStringEncoding]
                                            options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                            documentAttributes: nil
                                            error: nil
                                            ];
    
    
    _lblBankDetail.attributedText = attributedString;
    
    [_lblBankDetail setFont:[UIFont systemFontOfSize:13]];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnBack:(id)sender
{
    
    NSString *strDeleteCrown = [NSString stringWithFormat:@"delete from Crownkit"];
    
    [self.dbHandler DeleteDataWithQuesy:strDeleteCrown];
    
    NSString *strDeleteKit = [NSString stringWithFormat:@"delete from CartItem"];
    
    [self.dbHandler DeleteDataWithQuesy:strDeleteKit];
    
    
    UIViewController *viewController=[self.storyboard instantiateViewControllerWithIdentifier:@"MENU_DRAWER"];
    [self presentViewController:viewController animated:YES completion:nil];
    
}



@end
