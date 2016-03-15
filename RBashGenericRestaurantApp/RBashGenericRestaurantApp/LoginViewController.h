//
//  LoginViewController.h
//  ThinkingCup
//
//  Created by Manulogix on 03/09/14.
//  Copyright (c) 2014 Manulogix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBaseManager.h"
#import "WebServiceInterface.h"
#import <MessageUI/MessageUI.h>

@interface LoginViewController : UIViewController<WebServiceInterfaceDelegate,MFMailComposeViewControllerDelegate>{
    IBOutlet UITextField *userNameTextField;
    IBOutlet UITextField *passwordTextField;
    IBOutlet UIScrollView *loginScrollView;
    DataBaseManager *dbManager;
    WebServiceInterface *webServiceInterface;
    IBOutlet UIImageView *bgImageView;

    IBOutlet UIButton *closeBtn;
    IBOutlet UIButton *signUpNowBtn;
    IBOutlet UIButton *backBtn;
    
// for alerts
    
    UIView *customView;
    NSString *alertMsg;
    UIView *disableCustomAlertView;
    NSString *customAlertMessage;
    NSString *customAlertTitle;
    
}

@property(nonatomic,retain) NSDictionary *dishItemDetailsDict;
-(IBAction)loginBtnClicked:(id)sender;
-(IBAction)signUpBtnClicked:(id)sender;
-(IBAction)closeBtnClicked:(id)sender;

@end
