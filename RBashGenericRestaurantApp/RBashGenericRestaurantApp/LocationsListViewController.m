//
//  LocationsListViewController.m
//  RBashGenericRestaurantApp
//
//  Created by Manulogix on 30/03/15.
//  Copyright (c) 2015 Manulogix. All rights reserved.
//

#import "LocationsListViewController.h"
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#import "CustomTimeCell.h"
#import "District.h"
#import "GenericPinAnnotationView.h"
#import "MultiRowCalloutAnnotationView.h"
#import "MultiRowAnnotation.h"

@interface LocationsListViewController ()
@property (nonatomic,strong) MKAnnotationView *selectedAnnotationView;
@property (nonatomic,strong) MultiRowAnnotation *calloutAnnotation;
@end

@implementation LocationsListViewController

- (void)viewDidLoad {
    findLoctaionsRetriveCount = 0;

    annotationTagArray = [[NSMutableArray alloc]init];
    annotationsArray = [[NSMutableArray alloc]init];
    
    isLocationsList = YES;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
            self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"pgm_ipad-Background-Landscape.png"]];
        }else if(UIInterfaceOrientationIsPortrait(STATUSBAR_ORIENTATION)){
            self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"pgm_ipad-Background-Potrait.png"]];
        }
    }else{
        if ([UIScreen mainScreen].bounds.size.height >= 568) {  // iphone 4 inch
            self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"pgm_iphone-Background-Potrait.png"]];
        }else{
            self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"pgm_iphone-Background-Potrait.png"]];
        }
    }
    
    UIImageView *tempimageView;
    UIImageView *tempimageView1;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        tempimageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
        tempimageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
    }else  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        tempimageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
        tempimageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    }
    
    [tempimageView setImage:[UIImage imageNamed:@"search.png"]];
    tempimageView.contentMode = UIViewContentModeScaleAspectFit;
    searchTextField.leftView= tempimageView;
    searchTextField.leftViewMode = UITextFieldViewModeAlways;
    [searchTextField setReturnKeyType:UIReturnKeyNext];

    
    NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
    NSMutableArray *vals = [defaults objectForKey:@"SearchedLocationsArray"];
    
    if ([vals count] == 0) {
        locationsListArray = [[NSMutableArray alloc]init];
        recivedCoordinates = NO;
        
        locationManager = [[CLLocationManager alloc] init];
        [locationManager setDelegate:self];
        
        if (IS_OS_8_OR_LATER){
            [locationManager requestWhenInUseAuthorization];
            [locationManager requestAlwaysAuthorization];
        }
        
        [locationManager startUpdatingLocation];
        
    }else{
        locationsListArray = [vals mutableCopy];
        
        searchTextField.text = [defaults objectForKey:@"SearchedLocationString"];
        
        NSString *selectLocView = [defaults objectForKey:@"SelectedLocSuperView"];
        
        if ([selectLocView isEqualToString:@"locListTableView"]) {
            locationsListTabelView.hidden = NO;
            [locationsListTabelView reloadData];
            [self loadMap];
            isLocationsList = YES;
            mapView.hidden = YES;
            currentLocationView.hidden = YES;
        }else if ([selectLocView isEqualToString:@"mapView"]){
            mapView.hidden = NO;
            noLocationsLabel.hidden = YES;
            currentLocationView.hidden = NO;
            [self loadMap];
            [locationsListTabelView reloadData];
            isLocationsList = NO;
            locationsListTabelView.hidden = YES;
        }
        
        NSString *currentLoctionStr=[defaults objectForKey:@"Current_Location"];

        if ([currentLoctionStr isEqualToString:@"Current Location"]) {
            recivedCoordinates = NO;
            locationManager = [[CLLocationManager alloc] init];
            [locationManager setDelegate:self];
            if (IS_OS_8_OR_LATER){
                [locationManager requestWhenInUseAuthorization];
                [locationManager requestAlwaysAuthorization];
            }
            [locationManager startUpdatingLocation];
        }
    }
    
    searchTextField.returnKeyType = UIReturnKeySearch;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    if (recivedCoordinates == YES) {
        return;
    }
    
    CLLocationCoordinate2D currentCoordinates = newLocation.coordinate;
//    NSString   *longitudeString = [NSString stringWithFormat:@"%f", currentCoordinates.longitude];
//    NSString   *latitudeString = [NSString stringWithFormat:@"%f", currentCoordinates.latitude];
    
    
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:locationManager.location
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       
                       if (error){
                           customAlertTitle  = @"Alert";
                           
                           if (findLoctaionsRetriveCount ==0) {
                               customAlertMessage = @"Unfortunately, we are not able to retrieve locations near you, will try again. Please wait...";
                           }else{
                               customAlertMessage = @"Unfortunately, we are not able to retrieve locations near you. Please enter zipcode or address to retrieve locations.";
                           }
                           
                           buttons = 1;
                    
                           isLocationsRetry = YES;
                           [self LoadCustomAlertWithMessage];
                           return;
                       }
                       
                       if(placemarks && placemarks.count > 0){
                           //do something
                           CLPlacemark *topResult = [placemarks objectAtIndex:0];
                           
                           NSString *subThoroughfareStr =[topResult subThoroughfare];
                           NSString *thoroughfareStr =[topResult thoroughfare];
                           NSString *localityStr =[topResult locality];
                           NSString *administrativeAreaStr = [topResult administrativeArea];
                           
                           
                           NSString *subThoroughfareStrVal;
                           NSString *thoroughfareStrVal;
                           NSString *localityStrVal;
                           NSString *administrativeAreaStrVal;
                           
                           
                           if (subThoroughfareStr == nil || subThoroughfareStr.length ==0) {
                               subThoroughfareStrVal = @"";
                           }else{
                               subThoroughfareStrVal = subThoroughfareStr;
                           }

                           if (thoroughfareStr == nil || thoroughfareStr.length ==0) {
                               thoroughfareStrVal = @"";
                           }else{
                               thoroughfareStrVal = thoroughfareStr;
                           }
                           
                           if (localityStr == nil || localityStr.length ==0) {
                               localityStrVal = @"";
                           }else{
                               localityStrVal = localityStr;
                           }

                           
                           if (administrativeAreaStr == nil || administrativeAreaStr.length ==0) {
                               administrativeAreaStrVal = @"";
                           }else{
                               administrativeAreaStrVal = administrativeAreaStr;
                           }

                           
                           NSString *addressTxt = [NSString stringWithFormat:@"%@ %@,%@ %@",
                                                   subThoroughfareStrVal,thoroughfareStrVal,
                                                   localityStrVal, administrativeAreaStrVal];
                           searchTextField.text = addressTxt;
                           locationString = addressTxt;
                           [self postRequest:GET_RESTAURANT_LOCATIONS_REQ_TYPE];

                       }
                   }];
    recivedCoordinates = YES;
    [locationManager stopUpdatingLocation];
    
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    customAlertTitle  = @"Alert";
    
    if (findLoctaionsRetriveCount ==0) {
        customAlertMessage = @"Unfortunately, we are not able to retrieve locations near you, will try again. Please wait...";
    }else{
        customAlertMessage = @"Unfortunately, we are not able to retrieve locations near you. Please enter zipcode or address to retrieve locations.";
    }
    buttons = 1;
    
    isLocationsRetry = YES;
    [self LoadCustomAlertWithMessage];
}




-(void)postRequest:(NSString *)reqType{
    NSString *finalReqUrl;
    NSMutableDictionary *test = [[NSMutableDictionary alloc]init];

    if ([reqType isEqualToString:GET_RESTAURANT_LOCATIONS_REQ_TYPE]) {
        finalReqUrl = [NSString stringWithFormat:@"%@%@",REQ_URL,GET_RESTAURANT_LOCATIONS_REQ];
        [test setObject:RESTAURANT_NAME forKey:@"RestaurantName"];
        [test setObject:locationString forKey:@"Address"];
    }else if ([reqType isEqualToString:GET_REST_TIMING_TYPE]){
        finalReqUrl = [NSString stringWithFormat:@"%@%@",REQ_URL,GET_REST_TIMING_URL];
        [test setObject:selectedRestId forKey:@"RestaurantID"];
    }
    
    NSString *formattedBodyStr = [self jsonFormat:reqType withDictionary:test];
    NSString *dataInString = [NSString stringWithFormat: @"\"Data\":%@",formattedBodyStr];
    NSString *postDataInString = [NSString stringWithFormat:@"{\"Type\":\"%@\",%@}",reqType,dataInString];
    NSData *postJsonData = [postDataInString dataUsingEncoding:NSUTF8StringEncoding];
    webServiceInterface = [[WebServiceInterface alloc]initWithVC:self];
    webServiceInterface.delegate =self;
    [webServiceInterface sendRequest:postDataInString PostJsonData:postJsonData Req_Type:reqType Req_url:finalReqUrl];
}


-(NSString*)jsonFormat:(NSString *)type withDictionary:(NSMutableDictionary *)formatDict{
    NSString *bodyStr;
    if ([type isEqualToString:GET_RESTAURANT_LOCATIONS_REQ_TYPE]){
        bodyStr =[NSString stringWithFormat: @"{\"rest_name\":\"%@\",\"address\":\"%@\"}",[formatDict objectForKey:@"RestaurantName"],[formatDict objectForKey:@"Address"]];
    }else if ([type isEqualToString:GET_REST_TIMING_TYPE]){
        bodyStr =[NSString stringWithFormat: @"{\"rest_id\":\"%@\"}",[formatDict objectForKey:@"RestaurantID"]];
    }
    return bodyStr;
}


-(void)getResponse:(NSDictionary *)resp type:(NSString *)respType{

    if ([respType isEqualToString:GET_RESTAURANT_LOCATIONS_REQ_TYPE]){
        NSDictionary *statusDict = [resp objectForKey:@"Status"];
        NSString *status = [NSString stringWithFormat:@"%@",[statusDict objectForKey:@"status"]];
        NSString *statusDesc = [statusDict objectForKey:@"desc"];
        
        if ([status isEqualToString:@"1"]) {
            NSArray *locationsData = [resp objectForKey:@"Data"];
            locationsListArray = [locationsData mutableCopy];
            
            NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
            [defaults setObject:locationsListArray forKey:@"SearchedLocationsArray"];
            [defaults synchronize];
            
            noLocationsLabel.hidden = YES;
            [locationsListTabelView reloadData];
            [self loadMap];
        }else{
            
            if ([statusDesc containsString:@"No restaurant found"]) {
                customAlertTitle  = @"No Restaurants Found";
                customAlertMessage = @"No restaurants found near your searched location.";
                noLocationsLabel.hidden = NO;
            }else{
                customAlertTitle  = @"Alert";
                customAlertMessage = statusDesc;
            }
            
            buttons = 1;
            
            locationsListArray = [[NSMutableArray alloc]init];
            [locationsListTabelView reloadData];
            [self loadMap];
            isLocationsRetry = NO;

            [self LoadCustomAlertWithMessage];
        }
    }else if ([respType isEqualToString:GET_REST_TIMING_TYPE]){
        pickUpTimingsArray  =[[NSArray alloc]init];
        deliveryTimingsArray=[[NSArray alloc]init];
        
        timingDic=[[NSMutableDictionary alloc]init];
        
        timingDic = [resp objectForKey:@"Data"];
        
        pickUpTimingsArray=    [timingDic objectForKey:@"pickup_time"];//pickup_time
        deliveryTimingsArray=    [timingDic objectForKey:@"delivery_time"];//delivery Time
        
    }
}


-(CLLocationCoordinate2D) getLocationFromAddressString:(NSString*) addressStr {
    
    double latitude = 0, longitude = 0;
    NSString *esc_addr =  [addressStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
            [scanner scanDouble:&latitude];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                [scanner scanDouble:&longitude];
            }
        }
    }
    CLLocationCoordinate2D center;
    center.latitude = latitude;
    center.longitude = longitude;
    return center;
    
}


#pragma mark
#pragma mark TableView Datasource
/* number of sections in form list record table */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    if (tableView == timingsTableview) {
        if (deliveryTimingsArray.count>0) {// delivery timings are their
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                 if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
                    column1width   =85+47;
                    column2width   =150+42;
                    column3width   =150+8;//label width+reaming gap
                } else if (UIInterfaceOrientationIsPortrait(STATUSBAR_ORIENTATION)) {
                    column1width   =85+47;
                    column2width   =150+42;
                    column3width   =150+8;//label width+reaming gap
                }
            } else {
                column1width   =57+8;
                column2width   =95+12;
                column3width   =105;
            }
            
            
            tableColumnWidths = [[NSMutableArray alloc]init];
            [tableColumnWidths addObject:[NSString stringWithFormat:@"%f",column1width]];
            [tableColumnWidths addObject:[NSString stringWithFormat:@"%f",column2width]];
            [tableColumnWidths addObject:[NSString stringWithFormat:@"%f",column3width]];
            
            tableColumns=[[NSArray alloc]initWithObjects:@"Day",@"Pickup Hours",@"Delivery Hours" ,nil];
        } else {// no delivery timngs
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                
                if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
                    column1width   =150+17;//label+gap
                    column2width   =300+25;//label+remainggap
                }else if (UIInterfaceOrientationIsPortrait(STATUSBAR_ORIENTATION)){
                    column1width   =150+17;
                    column2width   =300+25;
                }
            }else{
                column1width   =90+10;
                column2width   =200;
            }
            
            tableColumnWidths = [[NSMutableArray alloc]init];
            [tableColumnWidths addObject:[NSString stringWithFormat:@"%f",column1width]];
            [tableColumnWidths addObject:[NSString stringWithFormat:@"%f",column2width]];
            
            tableColumns=[[NSArray alloc]initWithObjects:@"Day",@"Pickup Hours" ,nil];
        }
    
    }
    
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==timingsTableview) {
        return 7;
    }
    return [locationsListArray count];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    if (tableView == timingsTableview) {
        if (deliveryTimingsArray.count>0) {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                return 80;
            }else{
                return 54;
            }
        }else{
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                return 60;
            }else{
                return 34;
            }
        }
        return 0;
    }
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){

    }else{
        
    }
    return 110;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    if (tableView == timingsTableview) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            return 40;
        }else {
            return 20;
        }
        return 0;
    }
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        return 60;
    }else{
        return 45;
    }

}




- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (tableView == timingsTableview) {
        CGFloat originX = 0.0f;
        CGFloat originY = 0.0f;
        CGFloat width = 0.0f;
        CGFloat height = 0.0f;
        UIView *headerView = [[UIView alloc] init];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
                headerView.frame = CGRectMake(0, 0,timingsTableview.frame.size.width, 40);
                
            }else if(UIInterfaceOrientationIsPortrait(STATUSBAR_ORIENTATION)){
                headerView.frame = CGRectMake(0, 0, timingsTableview.frame.size.width, 40);
            }
            headerLabelFont = [UIFont fontWithName:@"Thonburi-Bold" size:22];
            height = 44.0f;
        }else{
            headerView.frame = CGRectMake(0, 0,timingsTableview.frame.size.width, 20);
            headerLabelFont = [UIFont fontWithName:@"Thonburi-Bold" size:14];
            height = 20.0f;
        }
        
        for (int i=0; i<[tableColumnWidths count]; i++) {
            NSString *widthVal = [tableColumnWidths objectAtIndex:i];
            width = [widthVal floatValue];
            
            headerLabelView = [[UILabel alloc]initWithFrame:CGRectMake(originX, originY, width, height)];
            headerLabelView.text = [tableColumns objectAtIndex:i];
            headerLabelView.backgroundColor=[UIColor whiteColor];
            headerLabelView.textColor = [FAUtilities getUIColorObjectFromHexString:APP_HEADER_COLOR alpha:1];
            headerLabelView.font=headerLabelFont;
            headerLabelView.numberOfLines=0;
            headerLabelView.textAlignment = NSTextAlignmentCenter;
            [headerView addSubview:headerLabelView];
            originX += width+2;
            headerLabelView.tag = 100+i;
        }
        return headerView;
    }
    
    
    float cellWidth;
    cellWidth = locationsListTabelView.frame.size.width;

    CGFloat height = 0.0f;
    UIView *headerView = [[UIView alloc] init];
    
    CGRect locationLabelFrame;
    CGRect nearByLabelFrame;
    
    UIFont *headerLblFont;
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
            headerView.frame = CGRectMake(0, 0, locationsListTabelView.frame.size.width, 55);
            nearByLabelFrame = CGRectMake(800, 6, 200, 46);
        }else if(UIInterfaceOrientationIsPortrait(STATUSBAR_ORIENTATION)){
            headerView.frame = CGRectMake(0, 0, locationsListTabelView.frame.size.width, 55);
   
            nearByLabelFrame = CGRectMake(568, 6, 200, 46);
        }
        
        locationLabelFrame = CGRectMake(16, 6, 300, 46);
        
        height = 55.0f;
        headerLblFont = [UIFont fontWithName:@"Thonburi-Bold" size:26];
        
    }else{
        headerView.frame = CGRectMake(0, 0, locationsListTabelView.frame.size.width, 45);
        
        locationLabelFrame = CGRectMake(8, 2, 220, 40);
        nearByLabelFrame = CGRectMake(238, 2, 80, 40);

        height = 45.0f;
        headerLblFont = [UIFont fontWithName:@"Thonburi-Bold" size:20];
    }


    UILabel *locationsLabel = [[UILabel alloc]initWithFrame:locationLabelFrame];
    locationsLabel.text = @"Locations";
    locationsLabel.backgroundColor= [UIColor clearColor];
    locationsLabel.textColor = [UIColor blackColor];
    locationsLabel.font=headerLblFont;
    locationsLabel.numberOfLines=0;
    locationsLabel.textAlignment = NSTextAlignmentLeft;
    [headerView addSubview:locationsLabel];

    
    UILabel *nearByLabel = [[UILabel alloc]initWithFrame:nearByLabelFrame];
    nearByLabel.text = @"Nearby";
    nearByLabel.backgroundColor= [UIColor clearColor];
    nearByLabel.textColor = [UIColor blackColor];
    nearByLabel.font=headerLabelFont;
    nearByLabel.numberOfLines=0;
    nearByLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:nearByLabel];
    
    headerView.layer.backgroundColor = [[FAUtilities getUIColorObjectFromHexString:@"D8D8D8" alpha:1]CGColor];
    [FAUtilities borderForBottomLineLayer:headerView withHexColor:@"D3D3D3" borderWidth:4];
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (tableView == timingsTableview) {

        static NSString *CellIdentifier;
        CustomTimeCell *cell;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            CellIdentifier = @"CustomTimeCell-ipad";//CustomTimeCell-ipad
            cell = (CustomTimeCell *)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
        }else {
            CellIdentifier = @"CustomTimeCell";//CustomTimeCell-iphone
            cell = (CustomTimeCell *)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        
        
        if (cell== nil) {
             if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                [tableView registerNib:[UINib nibWithNibName:@"CustomTimeCell-ipad" bundle:nil] forCellReuseIdentifier:CellIdentifier];
                cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
            }else{
                [tableView registerNib:[UINib nibWithNibName:@"CustomTimeCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
                cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
            }
        }
        
        
        NSDictionary *temppickUpDict;
        NSDictionary *tempDeliveryDict ;
            
        if (pickUpTimingsArray.count>0) {
            temppickUpDict = [pickUpTimingsArray objectAtIndex:indexPath.row];
        }else{
        }

        
         if (deliveryTimingsArray.count>0) {//Delivery timngs are available
             
             tempDeliveryDict = [deliveryTimingsArray objectAtIndex:indexPath.row];
             
             cell.pickOrDeliveryTimeLabel.hidden=YES;
             cell.daysOneTimeLabel.hidden=YES;
             
             cell.dayLabel.hidden=NO;
             cell.pickupFromTimeLabel.hidden=NO;
             cell.deliveryFromTimeLabel.hidden=NO;
             
             cell.dayLabel.text=[temppickUpDict objectForKey:@"day"];
             cell.dayLabel.textAlignment=NSTextAlignmentCenter;
             cell.pickupFromTimeLabel.textAlignment=NSTextAlignmentCenter;
             cell.deliveryFromTimeLabel.textAlignment=NSTextAlignmentCenter;
             
             cell.pickupFromTimeLabel.text=[NSString stringWithFormat:@"%@\nto\n%@",[temppickUpDict objectForKey:@"from_time"],[temppickUpDict objectForKey:@"to_time"]];
             cell.deliveryFromTimeLabel.text=[NSString stringWithFormat:@"%@\nto\n%@",[tempDeliveryDict objectForKey:@"from_time"],[tempDeliveryDict objectForKey:@"to_time"]];
             
         }else{//Delivery timngs not available
             cell.pickOrDeliveryTimeLabel.hidden=NO;
             cell.daysOneTimeLabel.hidden=NO;
             
             cell.dayLabel.hidden=YES;
             cell.pickupFromTimeLabel.hidden=YES;
             cell.deliveryFromTimeLabel.hidden=YES;
             
             cell.daysOneTimeLabel.text=[temppickUpDict objectForKey:@"day"];
             cell.pickOrDeliveryTimeLabel.text=  cell.pickupFromTimeLabel.text=[NSString stringWithFormat:@"%@ to %@",[temppickUpDict objectForKey:@"from_time"],[temppickUpDict objectForKey:@"to_time"]];
         }
         
        return cell;
    }

    
    static NSString *CellIdentifier = @"LocationsListTableViewCell";
    LocationsListTableViewCell *cell = [tableView
                                           dequeueReusableCellWithIdentifier:CellIdentifier
                                           forIndexPath:indexPath];

    
    NSDictionary *tempDict = [locationsListArray objectAtIndex:indexPath.row];
    
    NSString *addressStr = [tempDict objectForKey:@"address"];
    NSString *cityStr = [tempDict objectForKey:@"city"];
    NSString *stateStr = [tempDict objectForKey:@"state"];
    NSString *zipStr = [tempDict objectForKey:@"zip"];
    
    
    NSString *addressString = [NSString stringWithFormat:@"%@\n%@, %@ %@",addressStr,cityStr,stateStr,zipStr];
    
    cell.addressLabel.text = addressString;
    cell.addressLabel.numberOfLines = 0;
    
    
    NSDictionary *timingsDict = [tempDict objectForKey:@"pickup_timings"];
    
    NSString *fromTimeStr = [timingsDict objectForKey:@"from_time"];
    NSString *toTimeStr = [timingsDict objectForKey:@"to_time"];
    
    
    cell.timingsLabel.text = [NSString stringWithFormat:@"Open Today: %@ to %@",fromTimeStr,toTimeStr];
    cell.distanceLabel.text = [NSString stringWithFormat:@"%@ mi",[tempDict objectForKey:@"distance"]];
    
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath {
    
    NSDictionary *tempDict = [locationsListArray objectAtIndex:indexPath.row];
    selectedLocation = tempDict;
    selectLocationSuperView = @"locListTableView";
    [self loadLocationSubView:tempDict];
}



#pragma mark
#pragma mark TextField Delegates

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    locationString = textField.text;
    [self postRequest:GET_RESTAURANT_LOCATIONS_REQ_TYPE];
    return YES;
}


-(IBAction)selectViewBtnClicked:(id)sender{

    if (isLocationsList == YES) {
        isLocationsList = NO;
        [selectViewBtn setBackgroundImage:[UIImage imageNamed:@"stb_listView_Btn.png"] forState:UIControlStateNormal];
        locationsListTabelView.hidden = YES;
        mapView.hidden = NO;
        noLocationsLabel.hidden = YES;

        currentLocationView.hidden = NO;
        mapView.delegate=self;
    }else{
        
        isLocationsList = YES;
        [selectViewBtn setBackgroundImage:[UIImage imageNamed:@"stb_MapView_btn.png"] forState:UIControlStateNormal];
        locationsListTabelView.hidden = NO;
        mapView.hidden = YES;
        currentLocationView.hidden = YES;
        tag=0;
    }
}



-(void)loadMap{
    
    for (id annotation in mapView.annotations) {
        if (![annotation isKindOfClass:[MKUserLocation class]]){
            [mapView removeAnnotation:annotation];
        }
    }
    
    
    for (int i=0; i<[locationsListArray count]; i++) {
        
        NSDictionary *tempDict = [locationsListArray objectAtIndex:i];
        NSString *addressStr = [tempDict objectForKey:@"address"];
        NSString *cityStr = [tempDict objectForKey:@"city"];
        NSString *stateStr = [tempDict objectForKey:@"state"];
        NSString *zipStr = [tempDict objectForKey:@"zip"];
        
        NSString *phoneNum = [tempDict objectForKey:@"phone"];
        
        NSString *locationAddress = [NSString stringWithFormat:@"%@ %@, %@ %@",addressStr,cityStr,stateStr,zipStr];
        
        NSDictionary *timngsDic=[tempDict objectForKey:@"pickup_timings"];
        
        NSString*   fromTimeStr=[timngsDic objectForKey:@"from_time"];
        NSString*    toTimeStr=[timngsDic objectForKey:@"to_time"];
        
        if ([fromTimeStr isEqualToString:@""] || [fromTimeStr isEqual:nil]) {
        
        }
        NSString *todayHours=[NSString stringWithFormat:@"Today's Hours %@ - %@",fromTimeStr,toTimeStr];
        
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder geocodeAddressString:locationAddress
                     completionHandler:^(NSArray* placemarks, NSError* error){
                         if (placemarks && placemarks.count > 0) {
                             
                             CLPlacemark *topresult = [placemarks objectAtIndex:0];
                             MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
                             annotation.coordinate = topresult.location.coordinate;
                             
                             
                             [mapView addAnnotation:[District demoAnnotationFactory_WithAddress:locationAddress PhoneNum:phoneNum todayHrs:todayHours cordinateLat:0.00 longtude:0.00 orCordinate:annotation.coordinate withId:[NSString stringWithFormat:@"%d",i+1]]];
                             NSString *tagStr=[[NSString alloc]init];
                             tagStr=[NSString stringWithFormat:@"%i",i];
                             
                             NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
                             [def setValue:tagStr forKey:@"annoValue"];
                             
                             [annotationTagArray addObject:[NSString stringWithFormat:@"%d",i]];
                             tag=i;
                             [mapView showAnnotations:mapView.annotations animated:YES];
                        }
                     }
         ];
      
    }
}


- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation{
    
    if (![annotation conformsToProtocol:@protocol(MultiRowAnnotationProtocol)])
        return nil;
    
    NSObject <MultiRowAnnotationProtocol> *newAnnotation = (NSObject <MultiRowAnnotationProtocol> *)annotation;
    if (newAnnotation == _calloutAnnotation){

        MultiRowCalloutAnnotationView *annotationView = (MultiRowCalloutAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:MultiRowCalloutReuseIdentifier];
        
        
        if (!annotationView){
            annotationView = [MultiRowCalloutAnnotationView calloutWithAnnotation:newAnnotation onCalloutAccessoryTapped:^(MultiRowCalloutCell *cell, UIControl *control, NSDictionary *userData) {
                // This is where I usually push in a new detail view onto the navigation controller stack, using the object's ID
               //[self openDetail:nil];
                NSLog(@"%@",userData);
                NSString *dataId=[userData objectForKey:@"id"];
                
                int tagValue=0;
                for (int i =0; i<[locationsListArray count]; i++) {
                    
                    NSDictionary *tempDic=[locationsListArray objectAtIndex:i];
                    tagValue+=1;
                    if ([dataId isEqualToString:[NSString stringWithFormat:@"%d",tagValue]]) {
                        selectedLocation = tempDic;
                        selectLocationSuperView = @"mapView";
                        
                        [self loadLocationSubView:selectedLocation];
                        break;
                        
                    }
                }
            }];
        }else{
            annotationView.annotation = newAnnotation;
        }

        annotationView.parentAnnotationView = _selectedAnnotationView;
        annotationView.mapView = mapView;
        return annotationView;
    }
    
    
    GenericPinAnnotationView*annotationView=[[GenericPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:GenericPinReuseIdentifier];
    
    if (!annotationView){
        annotationView = [GenericPinAnnotationView pinViewWithAnnotation:newAnnotation];
    }
    
    annotationView.annotation = newAnnotation;
    annotationView.image=[UIImage imageNamed:@"pgm_annotation_pin.png"];
   
    int distanceVal = 0;

  
    if([annotationsArray count] > 0){
        for (int i=0 ; i<[annotationsArray count]; i++) {
            id<MKAnnotation> anno= [annotationsArray objectAtIndex:i];
                if (anno == annotation) {
                    isAddAnnotation = NO;
                    break;
                }else{
                    isAddAnnotation = YES;
                    distanceVal = i+1;
                }
        }
    }else{
        isAddAnnotation = YES;
        distanceVal = 1;
  
    }
    
    if (isAddAnnotation == YES) {
        [annotationsArray addObject:annotation];
    }
    int tagVal = 0;
  
    for(int i=0; i<[annotationsArray count]; i++){
        District *anno = [annotationsArray objectAtIndex:i];
  
        if ([anno.title isEqualToString:newAnnotation.title]) {
            tagVal = [[annotationTagArray objectAtIndex:i] intValue];
            break;
        }
  
    }
  
    if (tagVal >= 0) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(14,6,30,30)];
        label.text = [NSString stringWithFormat:@"%d",tagVal+1];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont fontWithName:@"Thonburi" size:14];
      
        [annotationView addSubview:label];
    }
  
   return annotationView;
    
}


- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)aView
{
    id<MKAnnotation> annotation = aView.annotation;
    if (!annotation || ![aView isSelected])
        return;
    if ( NO == [annotation isKindOfClass:[MultiRowCalloutCell class]] &&
        [annotation conformsToProtocol:@protocol(MultiRowAnnotationProtocol)] )
    {
        NSObject <MultiRowAnnotationProtocol> *pinAnnotation = (NSObject <MultiRowAnnotationProtocol> *)annotation;
        if (!_calloutAnnotation)
        {
            _calloutAnnotation = [[MultiRowAnnotation alloc] init];
            [_calloutAnnotation copyAttributesFromAnnotation:pinAnnotation];
            [mapView addAnnotation:_calloutAnnotation];
        }
        _selectedAnnotationView = aView;
        return;
    }
    [mapView setCenterCoordinate:annotation.coordinate animated:YES];
    _selectedAnnotationView = aView;
}




- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)aView
{
    if ( NO == [aView.annotation conformsToProtocol:@protocol(MultiRowAnnotationProtocol)] )
        return;
    if ([aView.annotation isKindOfClass:[MultiRowAnnotation class]])
        return;
    GenericPinAnnotationView *pinView = (GenericPinAnnotationView *)aView;
    if (_calloutAnnotation && !pinView.preventSelectionChange)
    {
        [mapView removeAnnotation:_calloutAnnotation];
        _calloutAnnotation = nil;
    }
}



-(void)openDetail:(id)sender{
    
    UIButton *btn = (UIButton *)sender;
    NSString *addressStr = btn.titleLabel.text;
    
    int tagVal;

    for(int i=0; i<[annotationsArray count]; i++){
        id <MKAnnotation> anno = [annotationsArray objectAtIndex:i];

        if ([anno.title isEqualToString:addressStr]) {
            tagVal = [[annotationTagArray objectAtIndex:i] intValue];
            break;
        }
        
    }
 
    NSDictionary *selectedLocDict = [[NSDictionary alloc]init];
    selectedLocDict = [locationsListArray objectAtIndex:tagVal];
    
    selectedLocation = selectedLocDict;
    selectLocationSuperView = @"mapView";
    [self loadLocationSubView:selectedLocDict];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    NSLog(@"view.annotation.title %@",view.annotation.title);
    NSLog(@"%lu",(unsigned long)[mapView.annotations indexOfObject:view.annotation]);
}




-(void)loadLocationSubView:(NSDictionary *)locationDetails{

    selectedRestId = [locationDetails objectForKey:@"id"];
    [self postRequest:GET_REST_TIMING_TYPE];
   
    CGRect restaurantAddressFrame;
    CGRect restaurantTimingsFrame;
    CGRect restaurantPhoneNumFrame;
    CGRect restaurantMapViewFrame;
    CGRect selectLocationBtnFrame;
    
    CGRect locationSubViewFrame;
    
    CGRect headingViewPlaceholderFrame;
    CGRect headingViewFrame;
    CGRect headingLabelFrame;
    
    UIFont *headingLabelFont;
    UIFont *btnFonts;
    
    CGRect disableViewFrame;
    
    CGFloat locationSubViewiPadHeight=560;
    CGFloat locationSubViewiPhoneHeight=40;
    
    UIFont *addressLabelFont;
    UIFont *timingsLabelFont;
    UIFont *phoneNumLabelFont;

    
    CGRect closeBtnFrame;
    CGRect seeHoursBtnFrame;
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
            locationSubViewFrame = CGRectMake(212, 159, 600, locationSubViewiPadHeight);
            disableViewFrame = CGRectMake(0, 0, 1024, 768);
        }else if(UIInterfaceOrientationIsPortrait(STATUSBAR_ORIENTATION)){
            locationSubViewFrame = CGRectMake(84, 237, 600, locationSubViewiPadHeight);
            disableViewFrame = CGRectMake(0, 0, 768, 1024);
        }
        
        headingViewPlaceholderFrame = CGRectMake(0, 0, locationSubViewFrame.size.width, 10);
        headingViewFrame = CGRectMake(0, 8, locationSubViewFrame.size.width, 45);
        headingLabelFrame = CGRectMake(12, 0, headingViewFrame.size.width-24, 45);
        headingLabelFont = [UIFont fontWithName:@"Thonburi" size:32];

        
        btnFonts = [UIFont fontWithName:@"Verdana" size:30];
        
        addressLabelFont    = [UIFont fontWithName:@"Thonburi-Bold" size:22];
        timingsLabelFont    = [UIFont fontWithName:@"Thonburi" size:22];
        phoneNumLabelFont   = [UIFont fontWithName:@"Thonburi" size:22];

        restaurantAddressFrame = CGRectMake(20, headingViewFrame.origin.y + headingViewFrame.size.height +8, locationSubViewFrame.size.width-40, 80);
        
        restaurantTimingsFrame = CGRectMake(20, restaurantAddressFrame.origin.y+restaurantAddressFrame.size.height+4, locationSubViewFrame.size.width-40, 40);
        
        restaurantPhoneNumFrame = CGRectMake(20, restaurantTimingsFrame.origin.y+restaurantTimingsFrame.size.height+4, locationSubViewFrame.size.width-220, 40);
        
        restaurantMapViewFrame = CGRectMake(20, restaurantPhoneNumFrame.origin.y+restaurantPhoneNumFrame.size.height+4, locationSubViewFrame.size.width-40, 200);
        
        selectLocationBtnFrame = CGRectMake(20, restaurantMapViewFrame.origin.y+restaurantMapViewFrame.size.height+20, locationSubViewFrame.size.width-40, 60);
        
        closeBtnFrame = CGRectMake(headingViewFrame.size.width-50, 2, 40, 40);
       
        seeHoursBtnFrame = CGRectMake(restaurantPhoneNumFrame.origin.x+restaurantPhoneNumFrame.size.width+4, restaurantPhoneNumFrame.origin.y, 160, 40);

    }else{
        if ([UIScreen mainScreen].bounds.size.height == 568) {  // iphone 4 inch
            locationSubViewFrame = CGRectMake(18, 98, 320-36, 250+4+50+locationSubViewiPhoneHeight+40);
        }else{
            locationSubViewFrame = CGRectMake(18, 78, 320-36, 250+4+50+locationSubViewiPhoneHeight+40);
        }
        
        
        headingViewPlaceholderFrame = CGRectMake(0, 0, locationSubViewFrame.size.width, 10);
        headingViewFrame = CGRectMake(0, 8, locationSubViewFrame.size.width, 35);
        headingLabelFrame = CGRectMake(8, 0, headingViewFrame.size.width-16, 35);
        headingLabelFont = [UIFont fontWithName:@"Thonburi" size:24];

        addressLabelFont    = [UIFont fontWithName:@"Thonburi-Bold" size:14];
        timingsLabelFont    = [UIFont fontWithName:@"Thonburi" size:14];
        phoneNumLabelFont   = [UIFont fontWithName:@"Thonburi" size:14];
        
        btnFonts = [UIFont fontWithName:@"Verdana" size:22];

        disableViewFrame = self.view.frame;
        
        restaurantAddressFrame = CGRectMake(4, headingViewFrame.origin.y + headingViewFrame.size.height +2, locationSubViewFrame.size.width-8, 60);
        
        restaurantTimingsFrame = CGRectMake(4, restaurantAddressFrame.origin.y+restaurantAddressFrame.size.height+2, locationSubViewFrame.size.width-8, 30);
        
        restaurantPhoneNumFrame = CGRectMake(4, restaurantTimingsFrame.origin.y+restaurantTimingsFrame.size.height+2, locationSubViewFrame.size.width-128, 30);
        
        restaurantMapViewFrame = CGRectMake(4, restaurantPhoneNumFrame.origin.y+restaurantPhoneNumFrame.size.height+2, locationSubViewFrame.size.width-8, 160);
        
        selectLocationBtnFrame = CGRectMake(20, restaurantMapViewFrame.origin.y+restaurantMapViewFrame.size.height+2, locationSubViewFrame.size.width-40, 40);

    
        closeBtnFrame = CGRectMake(headingViewFrame.size.width-45, 2, 30, 30);

        
        seeHoursBtnFrame = CGRectMake(restaurantPhoneNumFrame.origin.x+restaurantPhoneNumFrame.size.width+4, restaurantPhoneNumFrame.origin.y, 100, 30);
    }
    
    diabledview = [[UIView alloc]initWithFrame:disableViewFrame];
    diabledview.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pgm_gallery.png"]];
    
    diabledview.tag = 600;
   
    
    UIButton *disabledBtn = [[UIButton alloc]initWithFrame:diabledview.frame];
    [disabledBtn addTarget:self
                    action:@selector(locationSubViewCloseBtn:)
          forControlEvents:UIControlEventTouchUpInside];
    
    [diabledview addSubview:disabledBtn];

    
    
    UIView *locationSubView1 = [[UIView alloc]initWithFrame:locationSubViewFrame];
    locationSubView1.backgroundColor = [UIColor whiteColor];
    locationSubView1.layer.cornerRadius = 8;
    
    locationSubView = [[UIScrollView alloc]initWithFrame:CGRectMake(2, 2, locationSubView1.frame.size.width-4, locationSubView1.frame.size.height-4)];
    
    locationSubView.backgroundColor = [FAUtilities getUIColorObjectFromHexString:@"EFF0F2" alpha:1];
    locationSubView.layer.borderColor = [[UIColor grayColor]CGColor];
    locationSubView.layer.borderWidth = 2;
    locationSubView.layer.cornerRadius = 8;
    
    
    UIView *headingViewPlaceholder = [[UIView alloc]initWithFrame:headingViewPlaceholderFrame];
    headingViewPlaceholder.backgroundColor = [FAUtilities getUIColorObjectFromHexString:APP_HEADER_COLOR alpha:1];
    headingViewPlaceholder.layer.cornerRadius = 8;
    
    UIView *headingView = [[UIView alloc]initWithFrame:headingViewFrame];
    headingView.backgroundColor = [FAUtilities getUIColorObjectFromHexString:APP_HEADER_COLOR alpha:1];//#1B3745//A2439D
    
    UILabel *headingLabel = [[UILabel alloc]initWithFrame:headingLabelFrame];
    headingLabel.textColor = [UIColor whiteColor];
    
    headingLabel.text = @"Location Details";
    
    headingLabel.textAlignment = NSTextAlignmentCenter;
    headingLabel.font = headingLabelFont;
    
    
    
    NSString *addressStr = [locationDetails objectForKey:@"address"];
    NSString *cityStr = [locationDetails objectForKey:@"city"];
    NSString *stateStr = [locationDetails objectForKey:@"state"];
    NSString *zipStr = [locationDetails objectForKey:@"zip"];
    
    
    NSString *addressString = [NSString stringWithFormat:@"%@\n%@, %@ %@",addressStr,cityStr,stateStr,zipStr];

    UILabel *addressLabel = [[UILabel alloc]initWithFrame:restaurantAddressFrame];
    addressLabel.text = addressString;
    addressLabel.numberOfLines = 0;
    addressLabel.font = addressLabelFont;
    
    
    NSDictionary *timingsDict = [locationDetails objectForKey:@"pickup_timings"];
    
    NSString *fromTimeStr = [timingsDict objectForKey:@"from_time"];
    NSString *toTimeStr = [timingsDict objectForKey:@"to_time"];

    
    UILabel *timingLabel = [[UILabel alloc]initWithFrame:restaurantTimingsFrame];
    timingLabel.text = [NSString stringWithFormat:@"Today's Hours :%@ to %@", fromTimeStr,toTimeStr];
    timingLabel.font = timingsLabelFont;

    
    UILabel *phoneNumLabel = [[UILabel alloc]initWithFrame:restaurantPhoneNumFrame];
    phoneNumLabel.font = phoneNumLabelFont;
    phoneNumLabel.text = [locationDetails objectForKey:@"phone"];
    phoneNumLabel.textColor = [FAUtilities getUIColorObjectFromHexString:APP_HEADER_COLOR alpha:1];
    
    
    UIButton *closeBtn = [[UIButton alloc]initWithFrame:closeBtnFrame];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"pgm_closeButton.png"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(locationSubViewCloseBtn:) forControlEvents:UIControlEventTouchUpInside];
    [headingView addSubview:closeBtn];

    
    
    MKMapView *restMapView = [[MKMapView alloc]initWithFrame:restaurantMapViewFrame];
    
    restMapView.zoomEnabled = NO;
    restMapView.scrollEnabled = NO;
    restMapView.userInteractionEnabled = NO;
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:addressString
                 completionHandler:^(NSArray* placemarks, NSError* error){
                     if (placemarks && placemarks.count > 0) {
                         CLPlacemark *topResult = [placemarks objectAtIndex:0];
                         MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:topResult];
                         
                         MKCoordinateRegion region = restMapView.region;
                         region.center = [(CLCircularRegion *)placemark.region center];
                         region.span.longitudeDelta /= 3800.0f;
                         region.span.latitudeDelta /= 3800.0f;
                        
                         
                         
                         [restMapView setRegion:region animated:YES];
                         [restMapView addAnnotation:placemark];
                     }
                 }
     ];

    
    
    
    UIButton *selectLocBtn = [[UIButton alloc]initWithFrame:selectLocationBtnFrame];
    selectLocBtn.titleLabel.font = btnFonts;
    [selectLocBtn setTitle:@"Select Location" forState:UIControlStateNormal];
    [selectLocBtn addTarget:self action:@selector(selectLocBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [FAUtilities setBackgroundImagesForButton:selectLocBtn];


    seeHoursBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    seeHoursBtn.frame = seeHoursBtnFrame;
    [seeHoursBtn setTitle:@"See Hours" forState:UIControlStateNormal];
    [seeHoursBtn addTarget:self action:@selector(seeHoursBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    seeHoursBtn.titleLabel.font = timingsLabelFont;
    [seeHoursBtn setTitleColor:[FAUtilities getUIColorObjectFromHexString:APP_HEADER_COLOR alpha:1] forState:UIControlStateNormal];
    [locationSubView addSubview:seeHoursBtn];

    
    [headingView addSubview:headingLabel];
    [locationSubView addSubview:headingView];
    
    [locationSubView addSubview:headingViewPlaceholder];
    
    
    [locationSubView addSubview:addressLabel];
    [locationSubView addSubview:timingLabel];
    [locationSubView addSubview:phoneNumLabel];
    [locationSubView addSubview:restMapView];
    [locationSubView addSubview:selectLocBtn];
 
    

    [locationSubView1 addSubview:locationSubView];
    [diabledview addSubview:locationSubView1];
    [self.view addSubview:diabledview];
    
}



- (void)locationSubViewCloseBtn:(id)sender{
    [diabledview removeFromSuperview];
}





-(void)selectLocBtnClicked:(id)sender{
  
    NSString *restID = [selectedLocation objectForKey:@"id"];;
    
    NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
    [defaults setObject:restID forKey:@"RestaurantID"];
    [defaults setObject:selectedLocation forKey:@"UserSelectedLocationDetails"];
    [defaults setObject:selectLocationSuperView forKey:@"SelectedLocSuperView"];
    [defaults setObject:searchTextField.text forKey:@"SearchedLocationString"];
    [defaults synchronize];
    
    [self performSegueWithIdentifier:@"selectLocationToDashBoard" sender:self];
}


- (void)disablePopUp:(id)sender{
    [popupOverallView removeFromSuperview];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        
        if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
            self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"pgm_ipad-Background-Landscape.png"]];
        }else if(UIInterfaceOrientationIsPortrait(STATUSBAR_ORIENTATION)){
            self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"pgm_ipad-Background-Potrait.png"]];
        }
        
        
        [locationsListTabelView reloadData];
    
        for (UIView *subView in self.view.subviews) {
            [diabledview removeFromSuperview];
            
            if (subView.tag == 600 ) {
                [self loadLocationSubView:selectedLocation];
            }
        }
    }
    
}



-(void)LoadCustomAlertWithMessage{
    
    CGRect disableCustomAlertViewFrame;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
            disableCustomAlertViewFrame = CGRectMake(0, 0, 1024, 768);
        }else if(UIInterfaceOrientationIsPortrait(STATUSBAR_ORIENTATION)){
            disableCustomAlertViewFrame = CGRectMake(0, 0, 768, 1024);
        }
    }else{
        disableCustomAlertViewFrame = self.view.frame;
    }
    
    disableCustomAlertView = [[UIView alloc]initWithFrame:disableCustomAlertViewFrame];
    disableCustomAlertView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pgm_gallery.png"]];
    disableCustomAlertView.tag = 700;
    
    UIFont *msgLabelFont;
    CGSize messageSize;
    
    float frameSizeHeight;
    float frameSizeY;
    float frameSizeX;
    float frameWidth;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        msgLabelFont = [UIFont fontWithName:@"Thonburi" size:22];
        messageSize = [FAUtilities getHeightFromString:customAlertMessage AndWidth:500-40 AndFont:msgLabelFont];
        
        frameSizeHeight = messageSize.height + 55 + 100 +20;
        frameSizeY = ((disableCustomAlertView.frame.size.height - frameSizeHeight)/2)-20;
        
        
        if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
            frameSizeX = 262;
        }else if(UIInterfaceOrientationIsPortrait(STATUSBAR_ORIENTATION)){
            frameSizeX = 134;
        }
        
        frameWidth = 500;
        
    }else{
        msgLabelFont = [UIFont fontWithName:@"Thonburi" size:12];
        messageSize = [FAUtilities getHeightFromString:customAlertMessage AndWidth:284-40 AndFont:msgLabelFont];
        
        frameSizeHeight = messageSize.height + 45 + 70 +20;
        frameSizeY = ((disableCustomAlertView.frame.size.height - frameSizeHeight)/2)-30;
        
        
        frameSizeX = 18;
        frameWidth = 284;
        
    }
    
    
    CGRect frame = CGRectMake(frameSizeX, frameSizeY, frameWidth, frameSizeHeight);
    UIView *customAlertView = [FAUtilities customAlert:customAlertTitle withStr:customAlertMessage withColor:@"992d2d" withFrame:frame withNumberOfButtons:buttons withOnlyCancelBtnMessage:@"Ok" WithCancelBtnMessage:@"No" WithDoneBtnMessage:@"Yes"];
    
    
    UIButton *cancelBtn;
    UIButton *doneBtn;
    UIButton *onlyCancelBtn;
    
    
    for (UIView *subview in [[[customAlertView subviews] objectAtIndex:0] subviews]){
        if([subview isKindOfClass:[UIButton class]]){
            if (subview.tag == 1001) {
                onlyCancelBtn = (UIButton *)subview;
                [onlyCancelBtn addTarget:self action:@selector(cancelCustomAlertSubViewBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                
            }else if (subview.tag == 1002) {
                cancelBtn = (UIButton *)subview;
                [cancelBtn addTarget:self action:@selector(cancelCustomAlertSubViewBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            }else if (subview.tag == 1003){
                doneBtn = (UIButton *)subview;
                [doneBtn addTarget:self action:@selector(doneCustomAlertSubViewBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                
            }
        }
    }
    
    
    [disableCustomAlertView addSubview:customAlertView];
    [self.view addSubview:disableCustomAlertView];
    
}



-(void)dissMissPopUpAfterDelay{
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
        
        CGFloat heightTimingSubView_ipad_port;
        CGFloat heightTimingSubView_ipad_land;
        
        heightTimingSubView_ipad_port=100;
        heightTimingSubView_ipad_land=100;
        
        
        
        popoverContent = [[UIViewController alloc] init];
        
        UIView* popoverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,500, heightTimingSubView_ipad_land)];
        popoverView.backgroundColor = [UIColor whiteColor];
        popoverContent.view = popoverView;
        
        
        popoverContent.preferredContentSize = CGSizeMake(popoverView.frame.size.width,popoverView.frame.size.height);
        popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
        
        CGRect popoverRect = [self.view convertRect:[searchTextField frame] fromView:[searchTextField superview]];
        
        popoverRect.size.width = MIN(popoverRect.size.width, heightTimingSubView_ipad_port) ;
        popoverRect.origin.x  = popoverRect.origin.x+18;
        
        
        UILabel *popupMsgLabel=[[UILabel alloc]initWithFrame:popoverContent.view.frame];
        popupMsgLabel.text=@"Please enter a zip code or city/state to retrieve locations near you.";
        popupMsgLabel.font=[UIFont fontWithName:@"Thonburi" size:20.0f];
        popupMsgLabel.numberOfLines=3;
        popupMsgLabel.textAlignment=NSTextAlignmentCenter;
          popupMsgLabel.textColor = [UIColor redColor];
        [popoverContent.view addSubview:popupMsgLabel];
        
        [self popOverWithBtnFrame:popoverRect];
        [self performSelector:@selector(removePopUp) withObject:nil afterDelay:3];
        
    }else if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone){
        //popupOverallView touch any ware to remove so overall view
        popupOverallView = [[UIView alloc]initWithFrame:self.view.bounds];
        popupOverallView.backgroundColor = [UIColor clearColor];
        popupOverallView.tag = 500;
        
        UIButton *disabledBtn = [[UIButton alloc]initWithFrame:popupOverallView.frame];
        [disabledBtn addTarget:self
                        action:@selector(disablePopUp:)
              forControlEvents:UIControlEventTouchUpInside];
        
        
        [popupOverallView addSubview:disabledBtn];
        popupOverallView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pgm_gallery.png"]];
        
        
        CGRect popoverRect = [self.view convertRect:[searchTextField frame] fromView:[searchTextField superview]];
        
        CGFloat height_iPhone_5 = 0.0;
        CGFloat height_iPhone_4 = 0.0;
        CGFloat y_Axis_timingHrsSubView_iphone_4 = 0.0;
        CGFloat y_Axis_timingHrsSubView_iphone_5 = 0.0;
        
        CGRect timingHoursSubViewFrame;
        
        height_iPhone_5 = 60 ;
        height_iPhone_4 = 50;
        y_Axis_timingHrsSubView_iphone_5 = popoverRect.origin.y+popoverRect.size.height-10;
        y_Axis_timingHrsSubView_iphone_4 = popoverRect.origin.y+popoverRect.size.height-10;
        
        
        if ([UIScreen mainScreen].bounds.size.height == 568) {  // iphone 5 inch
            timingHoursSubViewFrame = CGRectMake(18, y_Axis_timingHrsSubView_iphone_5, 286, height_iPhone_5);
            
        }else{
            timingHoursSubViewFrame = CGRectMake(18, y_Axis_timingHrsSubView_iphone_4, 286, height_iPhone_4);
        }
        //dropdownview is popfromview is on popupOverall view
        popFromView=[[UIView alloc]initWithFrame:timingHoursSubViewFrame];
        popFromView.backgroundColor=[UIColor clearColor];
        //        popFromView.layer.borderWidth=2;
        //        popFromView.layer.borderColor=[[FAUtilities getUIColorObjectFromHexString:MENU_CELL_TEXT_COLOR alpha:1.0]CGColor];
        
        popupDropImage=[[UIImageView alloc]initWithFrame:CGRectMake(25, 10, 20, 20)];
        [popupDropImage setImage:[UIImage imageNamed:@"popupArrow.png"]];
        
        [popFromView addSubview:popupDropImage];
        popFromView.layer.cornerRadius=10;
        popFromView.layer.borderColor=[[UIColor darkGrayColor] CGColor];
        
        UIView *cornerView=[[UIView alloc]initWithFrame:CGRectMake(0,0, popFromView.frame.size.width, popFromView.frame.size.height)];
        cornerView.backgroundColor=[UIColor clearColor];
        
        popupView=[[UIView alloc]initWithFrame:CGRectMake(0,20, cornerView.frame.size.width, cornerView.frame.size.height)];
        
        
        
        popupView.backgroundColor=[UIColor whiteColor];    //set to popupimage here fontWithName:@"Thonburi-Bold" size:22
        popupView.layer.cornerRadius=10;
        UILabel *popupMsgLabel=[[UILabel alloc]initWithFrame:cornerView.frame];
        popupMsgLabel.text=@"Please enter a zip code or city/state to retrieve locations near you.";
        popupMsgLabel.font=[UIFont fontWithName:@"Thonburi" size:12.0f];
        popupMsgLabel.numberOfLines=3;
        popupMsgLabel.textAlignment=NSTextAlignmentCenter;
          popupMsgLabel.textColor = [UIColor redColor];
        [popupView addSubview:popupMsgLabel];
        
        
        [cornerView addSubview:popupView];
        [popFromView addSubview:cornerView];
        [popupOverallView addSubview:popFromView];
        
        [self.view addSubview:popupOverallView];
        [self performSelector:@selector(removePopUp) withObject:nil afterDelay:3];
        
    }
    
}


-(void)removePopUp{
    [popupOverallView removeFromSuperview];
    [popoverController dismissPopoverAnimated:YES];
    [popoverContent removeFromParentViewController];
    [popoverContent.view removeFromSuperview];
}

-(void)cancelCustomAlertSubViewBtnClicked:(id)sender{
    
    if (isLocationsRetry == YES) {
        
        if (findLoctaionsRetriveCount ==0) {
            findLoctaionsRetriveCount = findLoctaionsRetriveCount +1;
            recivedCoordinates = NO;
            [locationManager startUpdatingLocation];
        }else{
            [self dissMissPopUpAfterDelay];
        }
    }
    
    [disableCustomAlertView removeFromSuperview];
    
}



-(IBAction)currentLocationBtnClicked:(id)sender{
    recivedCoordinates = NO;
    [locationManager startUpdatingLocation];
}


-(void)seeHoursBtnClicked:(id)sender{
    
    if (pickUpTimingsArray.count >0 || deliveryTimingsArray.count>0) {
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
            CGFloat heightTimingSubView_ipad_port;
            CGFloat heightTimingSubView_ipad_land;
            
            CGFloat y_Axis_timingHrsSubView_ipad_port;
            CGFloat y_Axis_timingHrsSubView_ipad_land;
            
            if (deliveryTimingsArray.count>0) {
                heightTimingSubView_ipad_port=500;
                heightTimingSubView_ipad_land=500;
                
                y_Axis_timingHrsSubView_ipad_port=220;
                y_Axis_timingHrsSubView_ipad_land=129;
                
                
            }else{
                heightTimingSubView_ipad_port=500;
                heightTimingSubView_ipad_land=500;
                
                y_Axis_timingHrsSubView_ipad_port=250;
                y_Axis_timingHrsSubView_ipad_land=159;
                
            }
            
            
            if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
                timingsTableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 500, heightTimingSubView_ipad_land)];
            }else{
                timingsTableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 500, heightTimingSubView_ipad_port)];
            }
            
            
            timingsTableview.delegate = self;
            timingsTableview.dataSource = self;
            timingsTableview.tag = 800;
        
            
            [self showPopOverForSeeHours:timingsTableview withButton:sender withTitle:@""];
        
        }else if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone){
            //popupOverallView touch any ware to remove so overall view
            popupOverallView = [[UIView alloc]initWithFrame:self.view.bounds];
            popupOverallView.backgroundColor = [UIColor clearColor];
            popupOverallView.tag = 500;
            
            UIButton *disabledBtn = [[UIButton alloc]initWithFrame:popupOverallView.frame];
            [disabledBtn addTarget:self
                            action:@selector(disablePopUp:)
                  forControlEvents:UIControlEventTouchUpInside];
            
            CGRect popoverRect = [self.view convertRect:[seeHoursBtn frame] fromView:[seeHoursBtn superview]];
            
            [popupOverallView addSubview:disabledBtn];
            
            CGFloat height_iPhone_5 = 0.0;
            CGFloat height_iPhone_4 = 0.0;
            CGFloat y_Axis_timingHrsSubView_iphone_4 = 0.0;
            CGFloat y_Axis_timingHrsSubView_iphone_5 = 0.0;
            
            CGRect timingHoursSubViewFrame;
            
            if (deliveryTimingsArray.count>0) {
                height_iPhone_5 = 280 ;
                height_iPhone_4 = 200;
                y_Axis_timingHrsSubView_iphone_5 = popoverRect.origin.y+popoverRect.size.height-18;
                y_Axis_timingHrsSubView_iphone_4 = popoverRect.origin.y+popoverRect.size.height-18;
                
            }else{
                height_iPhone_5 = 260 ;
                height_iPhone_4 = 200;
                y_Axis_timingHrsSubView_iphone_5 = popoverRect.origin.y+popoverRect.size.height-18;
                y_Axis_timingHrsSubView_iphone_4 = popoverRect.origin.y+popoverRect.size.height-18;
                
            }
            if ([UIScreen mainScreen].bounds.size.height == 568) {  // iphone 5 inch
                timingHoursSubViewFrame = CGRectMake(18, y_Axis_timingHrsSubView_iphone_5, 286, height_iPhone_5);
            }else{
                timingHoursSubViewFrame = CGRectMake(18, y_Axis_timingHrsSubView_iphone_4, 286, height_iPhone_4);
            }
            //dropdownview is popfromview is on popupOverall view
            
            popFromView=[[UIView alloc]initWithFrame:timingHoursSubViewFrame];
            popFromView.backgroundColor=[UIColor clearColor];
            
            
            
            popupDropImage=[[UIImageView alloc]initWithFrame:CGRectMake(popFromView.frame.size.width-50, 10, 20, 20)];
            
            [popupDropImage setImage:[UIImage imageNamed:@"popupArrow.png"]];
            [popFromView addSubview:popupDropImage];
            popFromView.layer.cornerRadius=10;
            popFromView.layer.borderColor=[[UIColor darkGrayColor] CGColor];
            
            UIView *cornerView=[[UIView alloc]initWithFrame:CGRectMake(0,0, popFromView.frame.size.width, popFromView.frame.size.height-30)];
            // cornerView.layer.cornerRadius=10;
            cornerView.backgroundColor=[UIColor clearColor];
            
            popupView=[[UIView alloc]initWithFrame:CGRectMake(0,20, cornerView.frame.size.width, cornerView.frame.size.height)];
            
            
            popupView.backgroundColor=[UIColor whiteColor];    //set to popupimage here
            
            popupView.layer.cornerRadius=10;
            
            timingsTableview=[[UITableView alloc]initWithFrame:CGRectMake(0,0, popupView.frame.size.width-6, popupView.frame.size.height)];
            
            timingsTableview.layer.cornerRadius=10;
            timingsTableview.delegate = self;
            timingsTableview.dataSource = self;
            timingsTableview.tag = 100;
            
            
            [popupView addSubview:timingsTableview];
            
            [cornerView addSubview:popupView];
            [popFromView addSubview:cornerView];
            [popupOverallView addSubview:popFromView];
            
            [self.view addSubview:popupOverallView];
        }
    }else {
        customAlertMessage = [NSString stringWithFormat:@"No Timngs Found"];
        customAlertTitle = @"Alert";
        isLocationsRetry = NO;
        [self LoadCustomAlertWithMessage];
    }
}


-(void)showPopOverForSeeHours:(UIView *)aView withButton:(UIButton *)button withTitle:(NSString *)aTitle{
    popoverContent = [[UIViewController alloc] init];
    
    UIView* popoverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,aView.frame.size.width, aView.frame.size.height)];
    popoverView.backgroundColor = [UIColor whiteColor];
    [popoverView addSubview:aView];
    popoverContent.view = popoverView;
    popoverContent.title = aTitle;
   
    [timingsTableview reloadData];
    popoverContent.preferredContentSize = CGSizeMake(aView.frame.size.width,aView.frame.size.height);
    popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
    
    CGRect popoverRect = [self.view convertRect:[button frame] fromView:[button superview]];
    
    popoverRect.size.width = MIN(popoverRect.size.width, 100) ;
    popoverRect.origin.x  = popoverRect.origin.x+18;
    
    [self popOverWithBtnFrame:popoverRect];
}



-(void)popOverWithBtnFrame:(CGRect )popoverRect{
    [popoverController presentPopoverFromRect:popoverRect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        [popoverController dismissPopoverAnimated:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
//    if (self.isViewLoaded && mapView && mapView.annotations)
//    {
//        [mapView removeAnnotations:mapView.annotations];
//    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
