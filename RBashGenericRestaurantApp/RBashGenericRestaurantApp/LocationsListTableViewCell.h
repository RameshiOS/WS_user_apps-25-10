//
//  LocationsListTableViewCell.h
//  RBashGenericRestaurantApp
//
//  Created by Manulogix on 30/03/15.
//  Copyright (c) 2015 Manulogix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationsListTableViewCell : UITableViewCell{
    IBOutlet UILabel *addressLabel;
    IBOutlet UILabel *timingsLabel;
    IBOutlet UILabel *distanceLabel;
}

@property(nonatomic,retain)UILabel      *addressLabel;
@property(nonatomic,retain)UILabel      *timingsLabel;
@property(nonatomic,retain)UILabel      *distanceLabel;


@end
