//
//  SignUpViewController.h
//  ThinkingCup
//
//  Created by Manulogix on 03/09/14.
//  Copyright (c) 2014 Manulogix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBaseManager.h"
#import "WebServiceInterface.h"
#import <MessageUI/MessageUI.h>

@interface SignUpViewController : UIViewController<WebServiceInterfaceDelegate,MFMailComposeViewControllerDelegate>{
    IBOutlet UIScrollView *signUpScrollView;
    IBOutlet UITextField *firstNameTextField;
    IBOutlet UITextField *emailTextField;
    IBOutlet UITextField *mobileTextField;
    IBOutlet UITextField *passwordTextField;
    IBOutlet UITextField *confirmPasswordTextField;
     IBOutlet UITextField *zipCodeTextField;
    DataBaseManager *dbManager;
    WebServiceInterface *webServiceInterface;
    IBOutlet UIImageView *bgImageView;

    // for alerts
    
    UIView *customView;
    NSString *alertMsg;

    
    UIView *disableCustomAlertView;
    NSString *customAlertMessage;
    NSString *customAlertTitle;

    
}

@property(nonatomic,retain)NSDictionary *dishItemDetailsDict;
-(IBAction)submitBtnClicked:(id)sender;
-(IBAction)backBtnClicekd:(id)sender;

@end
