//
//  CrownCollectionViewCell.h
//  KidsCrown
//
//  Created by webmyne systems on 04/04/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CrownCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblCellModelName;
@property (strong, nonatomic) IBOutlet UILabel *lblCellModelNumber;
@property (strong, nonatomic) IBOutlet UIView *subviewOfCellModelName;

@property (weak, nonatomic) IBOutlet UIImageView *imgCell;
@end
