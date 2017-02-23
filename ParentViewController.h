//
//  ParentViewController.h
//  KidsCrown
//
//  Created by webmyne systems on 05/04/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainContentNavigationController.h"
#import "MyCartViewController.h"



@interface ParentViewController : UIViewController

@property (nonatomic,strong) MainContentNavigationController *mainContentNavigationController;


@property (weak, nonatomic) IBOutlet UIButton *btnCrown1;
- (IBAction)btnCrown1:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnCrown2;
- (IBAction)btnCrown2:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnCrown3;
- (IBAction)btnCrown3:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *buttonView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonviewHeight;

-(void)setSubContent:(NSString*)storyboardID;

@property (weak, nonatomic) IBOutlet UILabel *lblHeaderTitle;

@end
