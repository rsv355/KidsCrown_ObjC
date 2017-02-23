//
//  HomeViewController.h
//  KidsCrown
//
//  Created by webmyne systems on 15/04/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController


@property (weak, nonatomic) IBOutlet UIButton *btnCrown1;
- (IBAction)btnCrown1:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnCrown2;
- (IBAction)btnCrown2:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnCrown3;
- (IBAction)btnCrown3:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnViewTopLayoutConstraints;
@property (weak, nonatomic) IBOutlet UIImageView *adImageView;
@end
