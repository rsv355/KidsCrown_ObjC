//
//  DashboardTableCell.h
//  KidsCrown
//
//  Created by Jenish Mistry on 17/01/17.
//  Copyright © 2017 Webmyne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashboardTableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblHeader;
@property (strong, nonatomic) IBOutlet UILabel *lblDescription;
@property (strong, nonatomic) IBOutlet UIImageView *imageview;
@property (strong, nonatomic) IBOutlet UIView *subviewOfTableCell;


@end
