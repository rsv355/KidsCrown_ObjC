//
//  MenuTableViewController.m
//  ShreeSwastik
//
//  Created by Rajendrasinh Parmar on 25/09/15.
//  Copyright © 2015 ChorusProapp. All rights reserved.
//

#import "MenuTableViewController.h"
#import "MenuRow.h"
#import "DataBaseFile.h"


@implementation MenuTableViewController 
{
    NSUserDefaults *defaults;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    defaults=[NSUserDefaults standardUserDefaults];
    menuItems = [[NSMutableArray alloc] init];
    menuIcons = [[NSMutableArray alloc] init];
    menuItemIdentifire = [[NSMutableArray alloc] init];
    
    NSArray *defaultItems;
   
    defaultItems = [[NSArray alloc] initWithObjects:@"Home",@"Profile",@"My Orders",@"My Cart",@"About Us",@"Contact Us",@"Feedbacks",@"Logout", nil];
  

    NSArray *defaultIcons = [[NSArray alloc] initWithObjects:@"homeNew.png", @"profileNew.png", @"myorder.png",@"ic_action_cart.png",@"about.png",@"contactus.png", @"feedbackNew.png",@"logoutNew.png", nil];
   
    NSArray *defaultsMenuitemIdentifire = [[NSArray alloc] initWithObjects:@"DashboardView",@"PROFILE",@"MY_ORDERS",@"MY_CART",@"AboutUs",@"ContactUs", nil];
    
       [menuItems addObjectsFromArray:defaultItems];
    [menuIcons addObjectsFromArray:defaultIcons];
    [menuItemIdentifire addObjectsFromArray:defaultsMenuitemIdentifire];
   
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
    self.dbHandler = [[DataBaseFile alloc] init];
    [self.dbHandler CopyDatabaseInDevice];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [menuItems count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuRow *cell = [tableView dequeueReusableCellWithIdentifier:@"menuRow" forIndexPath:indexPath];
    [cell.menuLabel setText:[menuItems objectAtIndex:indexPath.row]];
    [cell.menuIcon setImage:[UIImage imageNamed:[menuIcons objectAtIndex:indexPath.row]]];
   

    return cell;
}

-(void)tableView: (UITableView*)tableView didSelectRowAtIndexPath:( NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    
    if (indexPath.row==7)
        {
            NSString *DeleteQuery = [NSString stringWithFormat:@"delete from Product"];
            [self.dbHandler DeleteDataWithQuesy:DeleteQuery];
            
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"Are you Sure?" delegate:(id)self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
            [alertView setTag:1];
            [alertView show];
            


    }
    else if(indexPath.row==6)
    {
              [self.menuDrawerViewController shareMyFeedback:@"FEEDBACK"];
    }
    else
    {
        //[defaults setObject:[menuItems objectAtIndex:indexPath.row] forKey:@"setTitle"];
        //[defaults setObject:@"1" forKey:@"drawerStatus"];
        [self.menuDrawerViewController setContent:[menuItemIdentifire objectAtIndex:indexPath.row]];
        
    }
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1)
    {
        if(buttonIndex == 1)
        {
                     UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
                        UIViewController *signup=[storyboard instantiateViewControllerWithIdentifier:@"LOGIN"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userID"];
            
            NSString *strDeleteCrown = [NSString stringWithFormat:@"delete from Crownkit"];
            
            [self.dbHandler DeleteDataWithQuesy:strDeleteCrown];
            
            NSString *strDeleteKit = [NSString stringWithFormat:@"delete from CartItem"];
            
            [self.dbHandler DeleteDataWithQuesy:strDeleteKit];
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CART_COUNT"];
            
            [self presentViewController:signup animated:YES completion:nil];
        }
    }
}
@end
