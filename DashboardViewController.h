//
//  DashboardViewController.h
//  KidsCrown
//
//  Created by Jenish Mistry on 17/01/17.
//  Copyright © 2017 Webmyne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DashboardTableCell.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "KidsCrownUrlSchema.h"
#import "DataBaseFile.h"
#import "UIView+Toast.h"
#import "UIImageView+AFNetworking.h"
#import "Crown1ViewController.h"
#import "Crown3ViewController.h"
#import "Reachability.h"
#import "UIImage+animatedGIF.h"

@interface DashboardViewController : UIViewController <WSForProductOnBackButtonDelegate,WSForProductOnBackButtonDelegate2>

@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) IBOutlet UIImageView *adImageView;
    

@end
