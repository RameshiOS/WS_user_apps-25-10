//
//  PlaceOrderViewController.h
//  ThinkingCup
//
//  Created by Manulogix on 09/09/14.
//  Copyright (c) 2014 Manulogix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBaseManager.h"
#import "WebServiceInterface.h"
#import <MessageUI/MessageUI.h>

@interface PlaceOrderViewController : UIViewController<UITextFieldDelegate,WebServiceInterfaceDelegate,MFMailComposeViewControllerDelegate>{
    IBOutlet UILabel *subtotalValLabel;
    IBOutlet UILabel *subTotalTaxLabel;
    IBOutlet UILabel *totalOrderCostLabel;
    
    IBOutlet UIScrollView *placeOrderScrolView;
    DataBaseManager *dbManager;
    NSMutableArray *itemsAry;
    IBOutlet UIView *placeOrderCostSubView;
    IBOutlet UIView *addTipBtnView;
    
    float totalCost;
    float totalTaxesVal;
    UITextField *itemQtyTextField;
    
    // payment subview
    
    UIView *diabledview;
    UITextField *cardHolderNameTextField;
    UITextField *cardNumberTextField;
    UITextField *cardExpDateTextField;
    UITextField *cardCvvTextField;
    
    UIButton *cardCancelBtn;
    UIButton *cardSubmitBtn;
    UIButton *paymentSuccessCancelBtn;

    IBOutlet UILabel *cartCountLabel;
    IBOutlet UILabel *addTipValue;
    IBOutlet UILabel *addTipHeading;
    IBOutlet UILabel *addTipPlaceHolder;

    UITextField *currentEditingTextField;
    UIButton *creditIcon1Btn;
    UIButton *creditIcon2Btn;
    UIButton *creditIcon3Btn;
    UIButton *creditIcon4Btn;
    UIScrollView *paymentSubView;

    WebServiceInterface *webServiceInterface;
    NSMutableDictionary *paymentDict;
    NSMutableDictionary *restDetailsDict;
    
    
    // for my orders
    
    IBOutlet UIButton *placeOrderHeadingBtn;
    IBOutlet UIButton *placeOrderValueBtn;
    IBOutlet UIButton *tipBtn;
    IBOutlet UIView *cartSubView;
    
    // for alerts
    
    UIView *customView;
    NSString *alertMsg;
    int cardNum;

    
    // for custom success alert
    NSString *subViewAlertStr;
//    NSString *paymentResponseAlertMsg;
    NSString *paymentResponseAlertMsgLine1;
    NSString *paymentResponseAlertMsgAddress;
    NSString *paymentOrderId;
    NSString *paymentOrderTotalValue;


    NSString *orderTypeStr;

    
    // for setting all details
    
    NSMutableArray *itemHeights;
    NSMutableArray *itemDescHeights;
    NSMutableArray *itemInstHeights;
    
    UIFont *itemDescFont;
    UIFont *itemInstFont;
    UIFont *itemInstHeadingFont;
    
    UIFont *modifierHeadingFont;
    UIFont *modifierOptionsFont;
    
    
    UIView *disableCustomAlertView;
    NSString *customAlertMessage;
    NSString *customAlertTitle;
    IBOutlet UIView *headerView;
    IBOutlet UIView *placeOrderSubView;
    
    
    CGRect itemNameFrame;
    CGRect itemCostFrame;
    IBOutlet UILabel *subtotalValLabelDelivery;
    IBOutlet UILabel *subTotalTaxLabelDelivery;
    IBOutlet UIView *addTipBtnViewDelivery;
    IBOutlet UILabel *addTipValueDelivery;
    IBOutlet UILabel *addTipHeadingDelivery;
    IBOutlet UILabel *addTipPlaceHolderDelivery;

    IBOutlet UIButton *tipBtnDelivery;
    IBOutlet UILabel *deliveryFeeLabel;
    
    IBOutlet UIView *pickUpView;
    IBOutlet UIView *deliveryView;
    CGFloat tempFloatVal;
    NSString *itemPrice  ;
    
    

}


@property(nonatomic,retain) NSDictionary *dishItemDetailsDict;
// for my orders

@property(nonatomic,retain)    NSArray *orderItemsAry;

@property(nonatomic,retain) NSString *subTotalVal;
@property(nonatomic,retain) NSString *taxVal;
@property(nonatomic,retain) NSString *tipVal;
@property(nonatomic,retain) NSString *totalVal;



-(IBAction)backBtnClicked:(id)sender;
-(IBAction)placeOrderBtnClicked:(id)sender;
-(IBAction)addTipBtnClicked:(id)sender;


@end
