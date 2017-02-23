//
//  OrderTableViewCell.m
//  KidsCrown
//
//  Created by webmyne systems on 07/04/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import "OrderTableViewCell.h"

@implementation OrderTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    [self.subviewOfCell.layer setShadowColor:[[UIColor grayColor] CGColor]];
    [self.subviewOfCell.layer setShadowOffset:CGSizeMake(0.0, 1.0)];
    [self.subviewOfCell.layer setShadowRadius:1.0];
    [self.subviewOfCell.layer setShadowOpacity:3.0];
    // Initialization code
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
