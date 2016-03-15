//
//  CustomTimeCell.h
//  RBashGenericRestaurantApp
//
//  Created by Ramesh on 4/6/15.
//  Copyright (c) 2015 Manulogix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTimeCell : UITableViewCell

{
    IBOutlet    UILabel *pickupFromTimeLabel;
    IBOutlet    UILabel *daysOneTimeLabel;
    
    IBOutlet    UILabel *deliveryFromTimeLabel;
    IBOutlet    UILabel *pickOrDeliveryTimeLabel;
    
    IBOutlet    UILabel *dayLabel;
    
}

@property(nonatomic,retain)IBOutlet UILabel *pickupFromTimeLabel;
//@property(nonatomic,retain)UILabel *pickupToTimeLabel;

@property(nonatomic,retain)IBOutlet UILabel *deliveryFromTimeLabel;
//@property(nonatomic,retain)UILabel *deliveryToTimeLabel;

@property(nonatomic,retain)IBOutlet UILabel *dayLabel;
@property(nonatomic,retain)IBOutlet UILabel *daysOneTimeLabel;
@property(nonatomic,retain)IBOutlet UILabel *pickOrDeliveryTimeLabel;


@end
