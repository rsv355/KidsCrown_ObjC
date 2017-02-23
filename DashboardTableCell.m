//
//  DashboardTableCell.m
//  KidsCrown
//
//  Created by Jenish Mistry on 17/01/17.
//  Copyright © 2017 Webmyne. All rights reserved.
//

#import "DashboardTableCell.h"

@implementation DashboardTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.subviewOfTableCell.layer setShadowColor:[[UIColor grayColor] CGColor]];
    [self.subviewOfTableCell.layer setShadowOffset:CGSizeMake(0.0, 1.0)];
    [self.subviewOfTableCell.layer setShadowRadius:1.0];
    [self.subviewOfTableCell.layer setShadowOpacity:3.0];
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
