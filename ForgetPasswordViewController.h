//
//  ForgetPasswordViewController.h
//  KidsCrown
//
//  Created by webmyne systems on 14/04/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgetPasswordViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
- (IBAction)btnClose:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end
