//
//  AppDelegate.h
//  ThinkingCup
//
//  Created by Manulogix on 01/09/14.
//  Copyright (c) 2014 Manulogix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

#import "DataBaseManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    DataBaseManager *dbManager;
    id lastViewController;
    id presentViewController;
    UIView *disableCustomAlertView;
    NSString *customAlertMessage;
    NSString *customAlertTitle;
    int buttons;
    
}

@property (strong, nonatomic) UIWindow *window;

@end
