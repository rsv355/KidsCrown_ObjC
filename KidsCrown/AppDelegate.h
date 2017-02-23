//
//  AppDelegate.h
//  KidsCrown
//
//  Created by webmyne systems on 31/03/16.
//  Copyright © 2016 Webmyne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+(AppDelegate*)appDelegate;
- (BOOL)isReachable;
@end

