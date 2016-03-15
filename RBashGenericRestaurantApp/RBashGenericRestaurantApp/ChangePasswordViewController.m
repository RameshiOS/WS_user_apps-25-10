//
//  ChangePasswordViewController.m
//  ThinkingCup
//
//  Created by Manulogix on 24/09/14.
//  Copyright (c) 2014 Manulogix. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController ()

@end

@implementation ChangePasswordViewController
@synthesize validOldPassword;
@synthesize valuesDict;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
        headerView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"pgm_HeaderLandscape.png"]];
        
    }else if(UIInterfaceOrientationIsPortrait(STATUSBAR_ORIENTATION)){
        
        headerView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"pgm_Header.png"]];
    }
    
    [oldPasswordTextField setReturnKeyType:UIReturnKeyNext];
    oldPasswordTextField.delegate=self;
    
    [newPasswordTextField setReturnKeyType:UIReturnKeyNext];
    newPasswordTextField.delegate=self;

    [confirmPasswordTextField setReturnKeyType:UIReturnKeyDone];
    confirmPasswordTextField.delegate=self;

}
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if (textField==oldPasswordTextField)
    {
        [textField resignFirstResponder];
        [newPasswordTextField becomeFirstResponder];
    }
    else if (textField==newPasswordTextField)
    {
        [textField resignFirstResponder];
        [confirmPasswordTextField becomeFirstResponder];
    }
    else if (textField==confirmPasswordTextField)
    {
        [textField resignFirstResponder];
        [self passwordSaveBtnClicked:nil];
    }

    return YES;
}

-(IBAction)passwordSaveBtnClicked:(id)sender{
        [self.view endEditing:YES];
    
    if (oldPasswordTextField.text.length == 0 || newPasswordTextField.text.length == 0 || confirmPasswordTextField.text.length == 0) {
//        [FAUtilities showAlert:@"Please enter all the details"];
        
        
        customAlertMessage = @"Please enter all the details";
        customAlertTitle = @"Alert";
        [self LoadCustomAlertWithMessage];

        
    }else if (![oldPasswordTextField.text isEqualToString:validOldPassword]){
//        [FAUtilities showAlert:@"Please enter valid old password"];
        
        customAlertMessage = @"Please enter valid old password";
        customAlertTitle = @"Alert";
        [self LoadCustomAlertWithMessage];

        
    }else if (![newPasswordTextField.text isEqualToString:confirmPasswordTextField.text]){
//        [FAUtilities showAlert:@"Please enter valid confirm password"];
        
        customAlertMessage = @"Please enter valid confirm password";
        customAlertTitle = @"Alert";
        [self LoadCustomAlertWithMessage];

        
    }else{
        [self postRequest:UPDATE_MY_PROFILE_REQ_TYPE withMethod:@"Password"];
    }
}

-(IBAction)passwordCancelBtnClicked:(id)sender{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)keyboardResignBtnClicked:(id)sender{
    
}

-(IBAction)backBtnClicked:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)postRequest:(NSString *)reqType withMethod:(NSString *)method{
    NSString *finalReqUrl;
    
    if ([reqType isEqualToString:UPDATE_MY_PROFILE_REQ_TYPE]) {
        finalReqUrl = [NSString stringWithFormat:@"%@%@",REQ_URL,UPDATE_MY_PROFILE_REQ_URL];
    }
    
    
    NSMutableDictionary *test = [[NSMutableDictionary alloc]init];
    [test setObject:[valuesDict objectForKey:@"UserName"] forKey:@"Name"];
    [test setObject:[valuesDict objectForKey:@"Email"] forKey:@"Email"];
    [test setObject:[valuesDict objectForKey:@"Phone"] forKey:@"Phone"];
    [test setObject:[valuesDict objectForKey:@"Address"] forKey:@"Address"];
    [test setObject:newPasswordTextField.text forKey:@"Password"];
    [test setObject:[valuesDict objectForKey:@"CustomerID"] forKey:@"CustomerID"];
    
    
    NSString *formattedBodyStr = [self jsonFormat:reqType withDictionary:test];
    NSString *dataInString = [NSString stringWithFormat: @"\"Data\":%@",formattedBodyStr];
    
    NSString *postDataInString = [NSString stringWithFormat:@"{\"Type\":\"%@\",%@}",reqType,dataInString];
    
    
    
    
    NSData *postJsonData = [postDataInString dataUsingEncoding:NSUTF8StringEncoding];
    webServiceInterface = [[WebServiceInterface alloc]initWithVC:self];
    webServiceInterface.delegate =self;
    [webServiceInterface sendRequest:postDataInString PostJsonData:postJsonData Req_Type:reqType Req_url:finalReqUrl];
    
}

-(NSString*)jsonFormat:(NSString *)type withDictionary:(NSMutableDictionary *)formatDict{
    
    NSString *bodyStr =[NSString stringWithFormat: @"{\"user_id\":\"%@\",\"first_name\":\"%@\",\"phone\":\"%@\",\"email\":\"%@\",\"address\":\"%@\",\"password\":\"%@\"}",[formatDict objectForKey:@"CustomerID"],[formatDict objectForKey:@"Name"],[formatDict objectForKey:@"Phone"],[formatDict objectForKey:@"Email"],[formatDict objectForKey:@"Address"],[formatDict objectForKey:@"Password"]];
    
    return bodyStr;
}


-(void)getResponse:(NSDictionary *)resp type:(NSString *)respType{
    
    if ([respType isEqualToString:UPDATE_MY_PROFILE_REQ_TYPE]) {
        
        NSDictionary *statusDict = [resp objectForKey:@"Status"];
        
        NSString *status = [NSString stringWithFormat:@"%@",[statusDict objectForKey:@"status"]];
        NSString *statusDesc = [statusDict objectForKey:@"desc"];
        
        if ([status isEqualToString:@"1"]) {
            dbManager = [DataBaseManager dataBaseManager];
            [dbManager execute:[NSString stringWithFormat:@"Update LoginDetails set UserName='%@', Address='%@',Phone='%@',Email='%@' , Password = '%@' where CustomerID = '%@'",[valuesDict objectForKey:@"UserName"],[valuesDict objectForKey:@"Address"],[valuesDict objectForKey:@"Phone"],[valuesDict objectForKey:@"Email"],newPasswordTextField.text,[valuesDict objectForKey:@"CustomerID"]]];
            
//            [FAUtilities showAlert:@"Profile has been updated"];
            
            
            customAlertMessage = @"Profile has been updated";
            customAlertTitle = @"Alert";
            [self LoadCustomAlertWithMessage];

        }else{
            
            NSString *communicationStr = [resp objectForKey:@"CommunicationAlert"];
            alertMsg = communicationStr;
            if (communicationStr.length == 0) {
//                [FAUtilities showAlert:statusDesc];
                
                customAlertMessage = statusDesc;
                customAlertTitle = @"Alert";
                [self LoadCustomAlertWithMessage];

                
            }else{
                [self loadCustomAlertSubView:alertMsg];
            }

            
//            [FAUtilities showAlert:statusDesc];
        }
    }
    
}

-(void)loadCustomAlertSubView:(NSString *)message{
    
    customView = [FAUtilities loadCustomServiceAlertView:self.view Message:message];
    
    for (UIView *subview in customView.subviews){
        if (subview.tag == 5004) {
            UIButton *cancelBtn = (UIButton *)subview;
            [cancelBtn addTarget:self
                          action:@selector(cancelBtn:)
                forControlEvents:UIControlEventTouchUpInside];
            
            
        }else if (subview.tag == 5005){
            UIButton *emailBtn = (UIButton *)subview;
            [emailBtn addTarget:self
                         action:@selector(emailBtn:)
               forControlEvents:UIControlEventTouchUpInside];
            
        }
        
        
    }
}

-(void)cancelBtn:(id)sender{
    [customView removeFromSuperview];
    
}


-(void)emailBtn:(id)sender{
    NSLog(@"email Btn clicked");
    
    NSString *emailTitle = @"Error from fuel america";
    NSString *messageBody = alertMsg;
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
}


- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    
    for (UIView *subView in self.view.subviews) {
        if (subView.tag ==501) {
            [subView removeFromSuperview];
            [self loadCustomAlertSubView:alertMsg];
        }else if (subView.tag == 700){
            [disableCustomAlertView removeFromSuperview];
            [self LoadCustomAlertWithMessage];
        }
    }
}




-(void)LoadCustomAlertWithMessage{
    
    [self cancelCustomAlertSubViewBtnClicked:nil];
    
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
    UIView *customAlertView = [FAUtilities customAlert:customAlertTitle withStr:customAlertMessage withColor:@"992d2d" withFrame:frame withNumberOfButtons:1 withOnlyCancelBtnMessage:@"Ok" WithCancelBtnMessage:@"" WithDoneBtnMessage:@""];
    
    
    UIButton *onlyCancelBtn;
    
    
    for (UIView *subview in [[[customAlertView subviews] objectAtIndex:0] subviews]){
        if([subview isKindOfClass:[UIButton class]]){
            if (subview.tag == 1001) {
                onlyCancelBtn = (UIButton *)subview;
                [onlyCancelBtn addTarget:self action:@selector(cancelCustomAlertSubViewBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                
            }
        }
    }
    
    [disableCustomAlertView addSubview:customAlertView];
    [self.view addSubview:disableCustomAlertView];
}

-(void)cancelCustomAlertSubViewBtnClicked:(id)sender{
    [disableCustomAlertView removeFromSuperview];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
