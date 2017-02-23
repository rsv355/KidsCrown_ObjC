//
//  AboutUsViewController.m
//  KidsCrown
//
//  Created by Jenish Mistry on 23/01/17.
//  Copyright © 2017 Webmyne. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.txtViewDescription.text = @"";
    [self FetchAboutUsDataFromWebService];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)FetchAboutUsDataFromWebService
{
   
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
 
    
    [manager GET:[NSString stringWithFormat:@"%@%@",NEW_BASE_URL,ABOUT_US]  parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
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
    NSString *strURL = [[dictionary objectForKey:@"Data"]valueForKey:@"HeaderImage"];
    
    [self.headerImageView setImageWithURL:[NSURL URLWithString:strURL]];
    
    NSString *htmlString = [[dictionary objectForKey:@"Data"]valueForKey:@"Description"];
    
    NSAttributedString *attributedString = [[NSAttributedString alloc]
                                            initWithData: [htmlString dataUsingEncoding:NSUnicodeStringEncoding]
                                            options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                            documentAttributes: nil
                                            error: nil
                                            ];
    
    self.txtViewDescription.attributedText = attributedString;
    
    [self.txtViewDescription setFont:[UIFont systemFontOfSize:15]];

    
}




@end
