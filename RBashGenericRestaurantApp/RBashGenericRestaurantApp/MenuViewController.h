//
//  MenuViewController.h
//  ThinkingCup
//
//  Created by Manulogix on 03/09/14.
//  Copyright (c) 2014 Manulogix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBaseManager.h"

@interface MenuViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    IBOutlet UITableView *menuTableView;
    NSMutableArray *menuListAry;
    DataBaseManager *dbManager;
}

@end
