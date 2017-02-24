//
//  ParentViewController.m
//  KidsCrown
//
//  Created by webmyne systems on 05/04/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import "ParentViewController.h"

@interface ParentViewController ()


@end

@implementation ParentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setButtonLayout];
   
    self.btnCrown1.layer.borderColor=[UIColor whiteColor].CGColor;
    self.btnCrown1.layer.borderWidth=2.0f;
    self.btnCrown2.layer.borderColor=[UIColor clearColor].CGColor;
    self.btnCrown3.layer.borderColor=[UIColor clearColor].CGColor;
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DashboardView"];
    [self addChildViewController:vc];
    vc.view.frame = CGRectMake(0, 0, self.containerView.frame.size.width, self.containerView.frame.size.height);
    [self.containerView addSubview:vc.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    

-(void)setSubContent:(NSString*)storyboardID{
    if ([storyboardID isEqualToString:@"CROWN1"]) {
        
        [self.buttonView setHidden:NO];
        
    }
    else{
        [self.buttonView setHidden:YES];
    }
    
    
    
    [self.mainContentNavigationController setNavigationRoot:storyboardID];
 
    if ([storyboardID isEqualToString:@"MY_CART"])
    {
        MyCartViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MY_CART"];
        vc.strSetHidden = @"yes";
        [self addChildViewController:vc];
        vc.view.frame = CGRectMake(0, 0, self.containerView.frame.size.width, self.containerView.frame.size.height);
        [self.containerView addSubview:vc.view];
        
//        MyCartViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MY_CART"];
//        vc.strSetHidden = @"no";
//        [self presentViewController:vc animated:YES completion:nil];
        
        
    }
    else
    {
        UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:storyboardID];
        [self addChildViewController:vc];
        vc.view.frame = CGRectMake(0, 0, self.containerView.frame.size.width, self.containerView.frame.size.height);
        [self.containerView addSubview:vc.view];

    }
    
    
    if ([storyboardID isEqualToString:@"DashboardView"]) {
        [self.lblHeaderTitle setText:@"Home"];
    }
    else if ([storyboardID isEqualToString:@"PROFILE"]) {
        [self.lblHeaderTitle setText:@"Profile"];
    }
    else if ([storyboardID isEqualToString:@"MY_ORDERS"]) {
        [self.lblHeaderTitle setText:@"My Orders"];
    }
    else if ([storyboardID isEqualToString:@"MY_CART"]) {
            
        [self.lblHeaderTitle setText:@"My Cart"];
    }
    else if ([storyboardID isEqualToString:@"AboutUs"]) {
        
        [self.lblHeaderTitle setText:@"About US"];
    }
    else if ([storyboardID isEqualToString:@"ContactUs"]) {
        
        [self.lblHeaderTitle setText:@"Contact Us"];
    }
 
    
    
}

-(void) setButtonLayout
{
    self.btnCrown1.layer.cornerRadius=20.0f;
    self.btnCrown2.layer.cornerRadius=20.0f;
    self.btnCrown3.layer.cornerRadius=20.0f;
    self.btnCrown1.layer.borderColor=[UIColor whiteColor].CGColor;
    self.btnCrown1.layer.borderWidth=2.0f;
}

- (IBAction)btnCrown1:(id)sender {
    
    self.btnCrown1.layer.borderColor=[UIColor whiteColor].CGColor;
    self.btnCrown1.layer.borderWidth=2.0f;
    self.btnCrown2.layer.borderColor=[UIColor clearColor].CGColor;
    self.btnCrown3.layer.borderColor=[UIColor clearColor].CGColor;
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HOME1"];
    [self addChildViewController:vc];
    vc.view.frame = CGRectMake(0, 0, self.containerView.frame.size.width, self.containerView.frame.size.height);
    [self.containerView addSubview:vc.view];
}

- (IBAction)btnCrown2:(id)sender {
    
    self.btnCrown2.layer.borderColor=[UIColor whiteColor].CGColor;
    self.btnCrown2.layer.borderWidth=2.0f;
    self.btnCrown1.layer.borderColor=[UIColor clearColor].CGColor;
    self.btnCrown3.layer.borderColor=[UIColor clearColor].CGColor;

    UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CROWN2"];
    [self addChildViewController:vc];
    vc.view.frame = CGRectMake(0, 0, self.containerView.frame.size.width, self.containerView.frame.size.height);
    [self.containerView addSubview:vc.view];
    
}

- (IBAction)btnCrown3:(id)sender {
    
    self.btnCrown3.layer.borderColor=[UIColor whiteColor].CGColor;
    self.btnCrown3.layer.borderWidth=2.0f;
    self.btnCrown2.layer.borderColor=[UIColor clearColor].CGColor;
    self.btnCrown1.layer.borderColor=[UIColor clearColor].CGColor;

    UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CROWN3"];
    [self addChildViewController:vc];
    vc.view.frame = CGRectMake(0, 0, self.containerView.frame.size.width, self.containerView.frame.size.height);
    [self.containerView addSubview:vc.view];
}

@end
