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

@interface MenuDrawerViewController (){
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
//    NSLog(@"StoryBoard ID for container is %@",storyboardID);
    [parentViewController setSubContent:storyboardID];
    [self closeDrawer];
}
-(void)shareMyFeedback:(NSString *)strFeedback
{
    NSString *textToShare = @"We all are great!!";
    NSURL *myWebsite = [NSURL URLWithString:@"https://www.google.co.in/search?q=hulk+images&espv=2&biw=646&bih=399&tbm=isch&imgil=v4x83FyqO5-lZM%253A%253BYLEpIzVFYf4cKM%253Bhttp%25253A%25252F%25252Fweknowyourdreamz.com%25252Fhulk.html&source=iu&pf=m&fir=v4x83FyqO5-lZM%253A%252CYLEpIzVFYf4cKM%252C_&usg=__ESBmc5HRSIiD3EZ_H9JXHN2Yftw%3D&ved=0ahUKEwjvzPHTjv_LAhUOWY4KHWfeAgMQyjcIOA&ei=t60HV6-VO46yuQTnvIsY"];
    
    NSArray *objectsToShare = @[textToShare, myWebsite];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                   UIActivityTypePrint,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList,
                                   UIActivityTypePostToFlickr,
                                   UIActivityTypePostToVimeo,UIActivityTypeMail,UIActivityTypeMessage,UIActivityTypePostToTwitter];
    
    activityVC.excludedActivityTypes = excludeActivities;
    
    [self presentViewController:activityVC animated:YES completion:nil];
    
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
