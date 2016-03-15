//
//  SelectLocationViewController.h
//  RBashGenericRestaurantApp
//
//  Created by Manulogix on 30/03/15.
//  Copyright (c) 2015 Manulogix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface SelectLocationViewController : UIViewController<CLLocationManagerDelegate>{
    
    IBOutlet UILabel *restaurantNameLabel;

  CLLocationManager *locationManager;
    

}

@property (strong, nonatomic) CLLocation        *currentLocation;

-(IBAction)findLocationBtnClicked:(id)sender;


@end
