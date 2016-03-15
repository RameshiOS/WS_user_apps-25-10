//
//  WebServiceInterface.h
//  DDMForms
//
//  Created by Manulogix on 19/07/13.
//  Copyright (c) 2013 Manulogix. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "LoginDetails.h"
#import "MBProgressHUD.h"
#import <QuartzCore/QuartzCore.h>
#import "FAUtilities.h"
#import <MessageUI/MessageUI.h>
#import "SKPSMTPMessage.h"
#import <CFNetwork/CFNetwork.h>


@protocol WebServiceInterfaceDelegate<NSObject>
@required
-(void)getResponse:(NSDictionary *)resp type:(NSString*)respType;
@end

@interface WebServiceInterface : UIViewController<MBProgressHUDDelegate,UIAlertViewDelegate,MFMailComposeViewControllerDelegate,SKPSMTPMessageDelegate>{
    NSString *postReqString,*postReqType, *postReqUrl;
    NSData *postReqData;
    NSData *receivedData;
    id<NSObject,WebServiceInterfaceDelegate> delegate;
    NSMutableString *currentElementValue;
    NSMutableString *element;
    NSMutableArray *employeeArray;
    NSString *responseString;
    NSString *reqName;
    NSString *reqVersion;
//    DataBaseManager *dbManager;
    double statusCode;
    UIAlertView *alert;
    
    UIView *customView;
    NSString *alertMsg;
    
    UIAlertView *placeOrderAlertView;
    
    
    NSString *customAlertMessage;
    NSString *customAlertTitle;
    int buttons;
    UIView *disableCustomAlertView;


}
@property (retain, nonatomic) NSURLConnection *connection;
@property (retain, nonatomic) NSData *receivedData;
@property(nonatomic,retain)id<NSObject,WebServiceInterfaceDelegate> delegate;

-(void) sendRequest:(NSString *)postString PostJsonData:(NSData *)postData Req_Type:(NSString *)reqType Req_url:(NSString *)reqUrl;

-(void) sendResponse:(NSDictionary *)respDict;
-(id)   initWithVC  : (UIViewController *)parentVC;

@end
