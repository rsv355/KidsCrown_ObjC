//
//  PageContentViewController.m
//  KidsCrown
//
//  Created by webmyne systems on 18/04/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import "PageContentViewController.h"

@interface PageContentViewController ()

@end

@implementation PageContentViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
   
    NSURL *url=[NSURL URLWithString:self.imageFile];
    NSData *data=[NSData dataWithContentsOfURL:url];
    [self.backgroundImageView setImage:[[UIImage alloc]initWithData:data]];
    //self.backgroundImageView.image = [UIImage imageNamed:self.imageFile];
    
//    [self.backgroundImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"Kidscrownlogo.png"]];
    
    self.titleLabel.text = self.titleText;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
