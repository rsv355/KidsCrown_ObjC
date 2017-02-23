//
//  AboutUsViewController.h
//  KidsCrown
//
//  Created by Jenish Mistry on 23/01/17.
//  Copyright © 2017 Webmyne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
#import "KidsCrownUrlSchema.h"


@interface AboutUsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *headerImageView;
@property (strong, nonatomic) IBOutlet UITextView *txtViewDescription;


@end
