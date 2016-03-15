//
//  SettingsCustomTableViewCell.h
//  ThinkingCup
//
//  Created by Manulogix on 05/09/14.
//  Copyright (c) 2014 Manulogix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsCustomTableViewCell : UITableViewCell{
    
}

@property(nonatomic,retain)IBOutlet UIImageView *cellIcon;
@property(nonatomic,retain)IBOutlet UILabel *settingName;
@property(nonatomic,retain)IBOutlet UISwitch *cellSwitch;


@end
