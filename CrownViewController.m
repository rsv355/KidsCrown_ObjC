//
//  CrownViewController.m
//  KidsCrown
//
//  Created by webmyne systems on 04/04/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import "CrownViewController.h"
#import "CrownCollectionViewCell.h"

@interface CrownViewController ()

@end

@implementation CrownViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Datasource and Delegate method

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 12;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CrownCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    double side1,side2;
    CGSize collectionviewSize=self.colllectionView.frame.size;
    side1=collectionviewSize.width/7-5;
    side2=collectionviewSize.height/2;
    
    return CGSizeMake(side1, 80);
}


@end
