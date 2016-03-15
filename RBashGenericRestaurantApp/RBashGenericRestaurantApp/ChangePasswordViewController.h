//
//  ChangePasswordViewController.h
//  ThinkingCup
//
//  Created by Manulogix on 24/09/14.
//  Copyright (c) 2014 Manulogix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServiceInterface.h"
#import "DataBaseManager.h"
#import <MessageUI/MessageUI.h>

@interface ChangePasswordViewController : UIViewController<WebServiceInterfaceDelegate,MFMailComposeViewControllerDelegate,UITextFieldDelegate>{
    IBOutlet UITextField *oldPasswordTextField;
    IBOutlet UITextField *newPasswordTextField;
    IBOutlet UITextField *confirmPasswordTextField;
    WebServiceInterface *webServiceInterface;
    IBOutlet UIScrollView *changePswdScrollView;
    float keyboardHeight;
    DataBaseManager *dbManager;
    
    // for alerts
    
    UIView *customView;
    NSString *alertMsg;
    
    UIView *disableCustomAlertView;
    NSString *customAlertMessage;
    NSString *customAlertTitle;
    IBOutlet UIView *headerView;



}
@property(nonatomic,retain)NSString     *validOldPassword;
@property(nonatomic,retain)NSDictionary *valuesDict;
-(IBAction)passwordSaveBtnClicked:(id)sender;
-(IBAction)passwordCancelBtnClicked:(id)sender;
-(IBAction)keyboardResignBtnClicked:(id)sender;
-(IBAction)backBtnClicked:(id)sender;
@end
