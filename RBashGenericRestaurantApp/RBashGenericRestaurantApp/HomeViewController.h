//
//  HomeViewController.h
//  ThinkingCup
//
//  Created by Manulogix on 01/09/14.
//  Copyright (c) 2014 Manulogix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "WebServiceInterface.h"
#import "DataBaseManager.h"

@interface HomeViewController : UIViewController<MKAnnotation,WebServiceInterfaceDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>{
    IBOutlet UILabel *restaurantName;
    IBOutlet UILabel *restaurantAddrLabel;
    IBOutlet UIButton *chooseItemBtn;
    IBOutlet UIView *pickUrOrderSubView;
    NSMutableDictionary *restDetails;
    WebServiceInterface *webServiceInterface;
    IBOutlet UIImageView *sliderImageView;
    IBOutlet UIImageView *resLogo;
    IBOutlet UILabel *phoneNumLabel;
    IBOutlet UIView *poweredByLinkView;

    UIView *customView;
    NSString *alertMsg;

 // for delivery options
    
    
    IBOutlet UILabel *pickUpASAPLabe;
    IBOutlet UILabel *pickUpZeroRad;

    IBOutlet UIButton *pickUpBtn;
    IBOutlet UIButton *deliveryBtn;
    IBOutlet UIView *orderView;
    
    NSString *orderTypeStr;
    
    // for delivery address subview
    
    UIView *disabledview;
    UIView *disabledSeeHrsView;

    UIScrollView *deliveryAddressSubView;
    UIScrollView *timngHrsScrollSubView;

    
    UITextField *deliveryAddressTextField;
    UITextField *deliveryNotesTextField;
    UITextField *deliveryCityTextField;
    UITextField *deliveryStateTextField;
    UITextField *deliveryPinTextField;
    
    UIButton *deliveryAddrSubViewCancelBtn;
    UIButton *deliveryAddrSubViewDoneBtn;
    
    
    NSMutableDictionary *deliveryDataDict;
    NSDictionary *restaurantDetailsDict;

   IBOutlet UILabel *timingsLabel;
    
    NSMutableString *restaurantAddress;
    UIView *disableCustomAlertView;
    UIView *disableCustomAlertViewNoTimings;

    NSString *customAlertMessage;
    NSString *customAlertTitle;
    
    IBOutlet UILabel *orderDetailsLbl;
    
    
    NSArray *restaurantMenuArray;
    CGRect mapSubViewFrame;
    UIView *diabledview;
    UIView *mapSubView;
    UITableView *menuListTableView;
    UITableViewCell *updateCell;
    NSMutableDictionary *dataDic;
    NSMutableArray *pathArr;
    NSDictionary *timingsDic;

    DataBaseManager *dbManager;

    
    NSString *localUpdatedOnstr;

    IBOutlet UIView *restaurantAddressView;
    IBOutlet UIView *restaurantAddressAndImageView;

    float poweredByViewLayerBorderWidth;
    
    NSArray *pickUpTimingsArray;
    NSArray *deliveryTimingsArray;
  //  UITableViewController *timingsTableViewCtrl;
    UITableView *timingsTableview;
    NSMutableArray *tableColumnWidths;
    UILabel* headerLabelView;
    
    NSArray*  tableColumns;
    UIFont *headerLabelFont;
    
    CGFloat column1width;
    CGFloat column2width;
    CGFloat column3width;
    NSMutableDictionary *timingDic;
    UIView *popupOverallView;
    UIView *popFromView;
    UIImageView *popupDropImage;
    UIView *popupView;
    UIViewController *popoverContent;
    UINavigationController *popOverNavigationController;
    UIPopoverController *popoverController;
    UIButton *seeHoursBtn;
    
    IBOutlet UIView *addressView;
    IBOutlet UIView *anotherLoctionView;
    IBOutlet UIButton *anotherLocationBtn;
    IBOutlet UILabel *todayHoursLabel;
    NSString *countStr;
    UITextField* addressTextField;


}

-(IBAction)chooseItemBtn:(id)sender;
-(IBAction)pickUpBtnClicked:(id)sender;
-(IBAction)deliveryBtnClicked:(id)sender;
-(IBAction)poweredByViewBtnClicked:(id)sender;
@property(nonatomic,strong) UIView *disableCustomAlertView;


@end
