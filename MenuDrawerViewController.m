//
//  MenuDrawerViewController.m
//  ShreeSwastik
//
//  Created by Rajendrasinh Parmar on 25/09/15.
//  Copyright © 2015 ChorusProapp. All rights reserved.
//

#import "MenuDrawerViewController.h"
#import "ParentViewController.h"
#import "DataBaseFile.h"
#import <MessageUI/MessageUI.h>
#import "UIView+Toast.h"

@interface MenuDrawerViewController ()<MFMailComposeViewControllerDelegate>{
    ParentViewController *parentViewController;
}

@end

@implementation MenuDrawerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(slideDrawer:) name:@"notifyMenuButtonClick" object:nil];
    [self setMainContainer];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"embedMenu"]) {
        MenuTableViewController *menuTableViewController = segue.destinationViewController;
        menuTableViewController.menuDrawerViewController = self;
        self.menuTableViewController = menuTableViewController;
    }
}


-(void)setContent:(NSString *)storyboardID{
    [parentViewController setSubContent:storyboardID];
    [self closeDrawer];
}
-(void)shareMyFeedback:(NSString *)strFeedback
{
   /* NSString *textToShare = @"We all are great!!";
    NSURL *myWebsite = [NSURL URLWithString:@"https://www.google.co.in/search?q=hulk+images&espv=2&biw=646&bih=399&tbm=isch&imgil=v4x83FyqO5-lZM%253A%253BYLEpIzVFYf4cKM%253Bhttp%25253A%25252F%25252Fweknowyourdreamz.com%25252Fhulk.html&source=iu&pf=m&fir=v4x83FyqO5-lZM%253A%252CYLEpIzVFYf4cKM%252C_&usg=__ESBmc5HRSIiD3EZ_H9JXHN2Yftw%3D&ved=0ahUKEwjvzPHTjv_LAhUOWY4KHWfeAgMQyjcIOA&ei=t60HV6-VO46yuQTnvIsY"];
    
    NSArray *objectsToShare = @[textToShare, myWebsite];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    NSArray *excludeActivities = @[UIActivityTypeMail];
    
    activityVC.excludedActivityTypes = excludeActivities;
    
    [self presentViewController:activityVC animated:YES completion:nil];
    */
    
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        [controller setSubject:@"KidsCrown Feedback"];
        [controller setToRecipients:[NSArray arrayWithObjects:@"kids@crown.com",nil]];
       
        [self presentViewController:controller animated:YES completion:NULL];
    }
    else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"KidsCrown" message:@"You can not send mail.." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] ;
        [alert show];
    }
    
}
-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            [self.view makeToast:@"Email Cancelled."];
            break;
        case MFMailComposeResultSaved:
            [self.view makeToast:@"Email Saved."];

            break;
        case MFMailComposeResultSent:
            [self.view makeToast:@"Email Sent."];

            
            break;
        case MFMailComposeResultFailed:
            [self.view makeToast:@"Email Failed."];

            break;
        default:
            [self.view makeToast:@"Email Not Sent."];

            break;
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)setMainContainer{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    parentViewController = [storyBoard instantiateViewControllerWithIdentifier:@"MAINCONTAINER"];
    _mainContent = parentViewController;
    [self addChildViewController:_mainContent];
    [_mainContent didMoveToParentViewController:self];
    [self.view addSubview:_mainContent.view];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - Drawer slider methods

-(void)slideDrawer:(id)sender{
    if (self.mainContent.view.frame.origin.x > 0) {
        [self closeDrawer];
    }else{
        [self openDrawer];
    }
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];

}


-(void)openDrawer{
    CGRect frame = self.mainContent.view.frame;
    frame.origin.x = 240.0;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.mainContent.view.frame = frame;
    }];
}


-(void)closeDrawer{
    CGRect frame = self.mainContent.view.frame;
    frame.origin.x = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.mainContent.view.frame = frame;
    }];
}

@end
