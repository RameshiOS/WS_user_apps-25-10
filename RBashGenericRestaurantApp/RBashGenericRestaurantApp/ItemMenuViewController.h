//
//  ItemMenuViewController.h
//  ThinkingCup
//
//  Created by Manulogix on 05/09/14.
//  Copyright (c) 2014 Manulogix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBaseManager.h"

@interface ItemMenuViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    IBOutlet UITableView *itemMenuTableView;
    NSMutableArray *itemMenuListAry;
    DataBaseManager *dbManager;

    UIView *disableCustomAlertView;
    NSString *customAlertMessage;
    NSString *customAlertTitle;
    int buttons;

}

@end
