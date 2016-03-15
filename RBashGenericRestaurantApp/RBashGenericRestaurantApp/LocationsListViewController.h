//
//  LocationsListViewController.h
//  RBashGenericRestaurantApp
//
//  Created by Manulogix on 30/03/15.
//  Copyright (c) 2015 Manulogix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "LocationsListTableViewCell.h"
#import "FAUtilities.h"
#import "WebServiceInterface.h"
#import <CoreLocation/CoreLocation.h>
#import "GenericPinAnnotationView.h"
#import "MultiRowCalloutAnnotationView.h"

@interface LocationsListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,MKMapViewDelegate,WebServiceInterfaceDelegate,CLLocationManagerDelegate>{
    
    
    IBOutlet UITextField *searchTextField;
    IBOutlet UIButton *selectViewBtn;
    IBOutlet UITableView *locationsListTabelView;
    IBOutlet MKMapView *mapView;

    
    BOOL isLocationsList;
    
    NSMutableArray *locationsListArray;
    
    UIView *diabledview;
    UIScrollView *locationSubView;
    
    NSDictionary *selectedLocation;
    WebServiceInterface *webServiceInterface;
    
    NSString *locationString;

    UIView *disableCustomAlertView;
    NSString *customAlertMessage;
    NSString *customAlertTitle;
    int buttons;
    
    CLLocationManager *locationManager;

    
    IBOutlet UIView *currentLocationView;
    IBOutlet UIButton *currentLocationBtn;
    
    BOOL recivedCoordinates;
    
    
    NSMutableArray *annotationTagArray;
    NSMutableArray *annotationsArray;
    NSMutableArray *annotationsAr;


    BOOL isAddAnnotation;
    
    
    NSString *selectLocationSuperView;
    

    // For see hours view
    NSString *selectedRestId;
    
    NSArray *pickUpTimingsArray;
    NSArray *deliveryTimingsArray;
    
    NSMutableDictionary *timingDic;
    
    UITableView *timingsTableview;
    UIView *popupOverallView;
    UIView *popFromView;
    UIImageView *popupDropImage;
    UIView *popupView;
    UIViewController *popoverContent;
    UIPopoverController *popoverController;

    
    CGFloat column1width;
    CGFloat column2width;
    CGFloat column3width;
    NSMutableArray *tableColumnWidths;
    NSArray*  tableColumns;
    UIFont *headerLabelFont;
    UILabel* headerLabelView;
    UIButton *seeHoursBtn;
    
    IBOutlet UILabel *noLocationsLabel;

    BOOL isLocationsRetry;
    int findLoctaionsRetriveCount;
    UILabel *annotationLabel;
    int tag;
}

@property (strong, nonatomic) CLLocation        *currentLocation;

-(IBAction)selectViewBtnClicked:(id)sender;
-(IBAction)currentLocationBtnClicked:(id)sender;


@end
