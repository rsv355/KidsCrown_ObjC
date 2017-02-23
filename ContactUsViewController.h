//
//  ContactUsViewController.h
//  KidsCrown
//
//  Created by Jenish Mistry on 23/01/17.
//  Copyright © 2017 Webmyne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactUsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *lblContactUsTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblContactUsDescription;
@property (strong, nonatomic) IBOutlet UILabel *lblBankDetailTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblBankDetailDescription;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lblBottomConstraint;


@end
