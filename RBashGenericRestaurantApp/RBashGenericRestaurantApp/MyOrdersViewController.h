//
//  MyOrdersViewController.h
//  ThinkingCup
//
//  Created by Manulogix on 23/09/14.
//  Copyright (c) 2014 Manulogix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBaseManager.h"
#import "WebServiceInterface.h"
#import <MessageUI/MessageUI.h>


@interface MyOrdersViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,WebServiceInterfaceDelegate,UIPopoverControllerDelegate,MFMailComposeViewControllerDelegate>{
    IBOutlet UITableView *myOrdersTableView;
    NSArray *resultsArray;
    
    UILabel *labelView;
    UILabel *headerLabelView;
    IBOutlet UIView *navHeaderView;

    
    NSMutableArray *tableColumns;
    NSMutableArray *tableColumnKeys;
    NSMutableArray *tableColumnWidths;
    
    
    
    
    DataBaseManager *dbManager;
    WebServiceInterface *webServiceInterface;
    
    
    UIFont *headerLabelFont;
    UIFont *cellLaebelFont;
    
    IBOutlet UIScrollView *myordersScrollView;
    int tableViewWidth;
    int tableViewHeight;
    
    
    
    int currentOrderID;
    
    NSString *currentSubTotalVal;
    NSString *currentTaxVal;
    NSString *currentTipVal;
    NSString *currentTotalVal;
    
    IBOutlet UISegmentedControl *segCntl;
    
    
    UITableView *searchOptionListTableView;
    NSMutableArray *searchOptions;
    UIViewController* popoverContent;
    UINavigationController *popOverNavigationController;
    UIPopoverController *popoverController;
    NSMutableDictionary *popOverDict; // for search

    NSString *segmentedValue;
    
    // for alerts
    
    UIView *customView;
    NSString *alertMsg;

    
    UIView *disableCustomAlertView;
    NSString *customAlertMessage;
    NSString *customAlertTitle;

}

-(IBAction)backBtnClicked:(id)sender;
-(IBAction)searchBtnVClicked:(id)sender;
-(IBAction)segmentControlValChanged:(id)sender;

@end
