//
//  SettingsViewController.h
//  ThinkingCup
//
//  Created by Manulogix on 05/09/14.
//  Copyright (c) 2014 Manulogix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController{
    IBOutlet UITableView *settingsTableView;
    NSMutableArray *settingsAry;
    NSMutableArray *settingsImgsAry;
    IBOutlet UIImageView *bgImageView;
    IBOutlet UILabel *acc_settingsLbl;
}
-(IBAction)backBtnClicked:(id)sender;


@end
