//
//  CustomTimeCell.m
//  RBashGenericRestaurantApp
//
//  Created by Ramesh on 4/6/15.
//  Copyright (c) 2015 Manulogix. All rights reserved.
//

#import "CustomTimeCell.h"

@implementation CustomTimeCell
@synthesize dayLabel;
@synthesize pickupFromTimeLabel;
@synthesize deliveryFromTimeLabel;
@synthesize pickOrDeliveryTimeLabel;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
