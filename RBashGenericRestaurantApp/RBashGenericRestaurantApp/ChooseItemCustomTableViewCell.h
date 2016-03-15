//
//  ChooseItemCustomTableViewCell.h
//  ThinkingCup
//
//  Created by Manulogix on 01/09/14.
//  Copyright (c) 2014 Manulogix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseItemCustomTableViewCell : UITableViewCell{
    IBOutlet UILabel *itemNameLabel;
    IBOutlet UIView  *itemCostSubView;
    IBOutlet UILabel *itemCostLabel;
    IBOutlet UIButton *cameraButton;//cameraImageVW

}


@property(nonatomic,retain)UILabel      *itemNameLabel;
@property(nonatomic,retain)UIView       *itemCostSubView;
@property(nonatomic,retain)UILabel      *itemCostLabel;
@property(nonatomic,retain) IBOutlet UIButton    *cameraButton;
@end
