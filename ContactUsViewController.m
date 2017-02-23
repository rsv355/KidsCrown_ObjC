//
//  ContactUsViewController.m
//  KidsCrown
//
//  Created by Jenish Mistry on 23/01/17.
//  Copyright © 2017 Webmyne. All rights reserved.
//

#import "ContactUsViewController.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "UIView+Toast.h"
#import "KidsCrownUrlSchema.h"

@interface ContactUsViewController ()
{
    NSMutableArray *dataArray;
}

@end

@implementation ContactUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    _lblBottomConstraint.constant = 10.0f;
    
    _lblContactUsDescription.text = @"";
    _lblBankDetailDescription.text = @"";
    
    [self FetchContactUsDataFromWebService];
    dataArray = [[NSMutableArray alloc]init];
    
    _lblBankDetailDescription.lineBreakMode = UILineBreakModeWordWrap;
    _lblBankDetailDescription.numberOfLines = 0;
    
    _lblContactUsTitle.hidden = true;
    _lblBankDetailTitle.hidden = true;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)FetchContactUsDataFromWebService
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    [manager GET:[NSString stringWithFormat:@"%@%@",NEW_BASE_URL,CONTACT_US]  parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        
        if ([[[dict objectForKey:@"Response"]valueForKey:@"ResponseCode"]integerValue] == 1)
        {
            [self ParseDataResponse:dict];
        }
        else
        {
            NSString *strMsg = [[dict objectForKey:@"Response"]valueForKey:@"ResponseMsg"];
            [self.view makeToast:strMsg];
        }
        
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Kid's Crown" message:@"Network error. Please try again later" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [errorAlert show];
    }];

}

-(void)ParseDataResponse:(NSDictionary *)dictionary
{
    
    dataArray = [dictionary valueForKey:@"Data"];
   
    
 // Contact Us Detail
    _lblContactUsTitle.hidden = false;
    _lblContactUsTitle.text = [NSString stringWithFormat:@"%@ :",[[dataArray objectAtIndex:0]valueForKey:@"PageName"]];
    
    NSString *htmlString = [[dataArray objectAtIndex:0]valueForKey:@"Description"];
    
    NSAttributedString *attributedString = [[NSAttributedString alloc]
                                            initWithData: [htmlString dataUsingEncoding:NSUnicodeStringEncoding]
                                            options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                            documentAttributes: nil
                                            error: nil
                                            ];
    
    
    self.lblContactUsDescription.attributedText = attributedString;
    self.lblContactUsDescription.textAlignment = NSTextAlignmentLeft;
    self.lblContactUsDescription.font = [UIFont systemFontOfSize:15];
    

  // Bank Detail
    _lblBankDetailTitle.hidden = false;
    _lblBankDetailTitle.text = [NSString stringWithFormat:@"%@ :",[[dataArray objectAtIndex:1]valueForKey:@"PageName"]];
    
    NSString *htmlString1 = [[dataArray objectAtIndex:1] valueForKey:@"Description"];
    
    NSAttributedString *attributedString1 = [[NSAttributedString alloc]
                                            initWithData: [htmlString1 dataUsingEncoding:NSUnicodeStringEncoding]
                                            options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                            documentAttributes: nil
                                            error: nil
                                            ];
    
    self.lblBankDetailDescription.attributedText = attributedString1;
    self.lblBankDetailDescription.textAlignment = NSTextAlignmentLeft;
    self.lblBankDetailDescription.font = [UIFont systemFontOfSize:15];


    
    
    
    
}

@end
