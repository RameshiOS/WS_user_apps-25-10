//
//  MyProfileViewController.h
//  ThinkingCup
//
//  Created by Manulogix on 23/09/14.
//  Copyright (c) 2014 Manulogix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBaseManager.h"
#import "WebServiceInterface.h"
#import <MessageUI/MessageUI.h>

@interface MyProfileViewController : UIViewController<WebServiceInterfaceDelegate,MFMailComposeViewControllerDelegate,UITextFieldDelegate,UITextViewDelegate>{
    
    IBOutlet UITextField *firstNameTextField;
    IBOutlet UITextField *lastNameTextField;
    IBOutlet UITextField *emailTextField;
    IBOutlet UITextField *mobileTextField;
    IBOutlet UITextView *addressTextField;
    IBOutlet UITextField *cityTextField;
    IBOutlet UITextField *stateTextField;
    IBOutlet UITextField *zipTextField;
    IBOutlet UIView *headerView;
    
    IBOutlet UIScrollView *myProfileScrollView;
   
    DataBaseManager *dbManager;
    
    NSDictionary *profileDict;
    WebServiceInterface *webServiceInterface;
    
    
    // change password view
    
    UIView *diabledview;
    UITextField *oldPasswordTextField;
    UITextField *newPasswordTextField;
    UITextField *confirmPasswordTextField;
    
    NSString *password ;

    // for alerts
    
    UIView *customView;
    NSString *alertMsg;

    
    UIView *disableCustomAlertView;
    NSString *customAlertMessage;
    NSString *customAlertTitle;

}

-(IBAction)backBtnClicked:(id)sender;
-(IBAction)saveBtnClicked:(id)sender;
-(IBAction)keyBoardResignBtnClicked:(id)sender;

-(IBAction)changePswdBtnClicked:(id)sender;

@end
