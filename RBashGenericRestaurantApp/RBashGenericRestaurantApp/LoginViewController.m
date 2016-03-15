//
//  LoginViewController.m
//  ThinkingCup
//
//  Created by Manulogix on 03/09/14.
//  Copyright (c) 2014 Manulogix. All rights reserved.
//

#import "LoginViewController.h"
#import "SignUpViewController.h"
#import "FAUtilities.h"
#import "PlaceOrderViewController.h"
#import <FacebookSDK/FacebookSDK.h>


@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize dishItemDetailsDict;

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
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
            bgImageView.image = [UIImage imageNamed:@"iPad_landscape.png"];
            self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"pgm_ipad-Background-Landscape.png"]];
        }else if(UIInterfaceOrientationIsPortrait(STATUSBAR_ORIENTATION)){
            bgImageView.image = [UIImage imageNamed:@"iPad_potrait.png"];
            self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"pgm_ipad-Background-Potrait.png"]];
        }
        bgImageView.alpha = 0.7;
    }else{
        self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"pgm_iphone-Background-Potrait.png"]];
    }


    signUpNowBtn.titleLabel.textColor=[FAUtilities getUIColorObjectFromHexString:MENU_CELL_TEXT_COLOR alpha:1.0];
    
    UIImageView *tempimageView;
    UIImageView *tempimageView1;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        tempimageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
        tempimageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
    }else  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        tempimageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
        tempimageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    }
    
    [tempimageView setImage:[UIImage imageNamed:@"pgm_email.png"]];
    tempimageView.contentMode = UIViewContentModeScaleAspectFit;
    userNameTextField.leftView= tempimageView;
    userNameTextField.leftViewMode = UITextFieldViewModeAlways;
    [userNameTextField setReturnKeyType:UIReturnKeyNext];
    
    
    [tempimageView1 setImage:[UIImage imageNamed:@"pgm_password.png"]];
    tempimageView1.contentMode = UIViewContentModeScaleAspectFit;
    passwordTextField.leftView = tempimageView1;
    passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    [passwordTextField setReturnKeyType:UIReturnKeyDone];

    
    
    
    
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


-(void)postRequest:(NSString *)reqType{
    NSString *finalReqUrl;
    
    if ([reqType isEqualToString:LOGIN_REQ_TYPE]) {
        finalReqUrl = [NSString stringWithFormat:@"%@%@",REQ_URL,LOGIN_REQ_URL];
    }
    
    NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
    NSString *resID = [defaults objectForKey:@"RestaurantID"];
    
    NSMutableDictionary *test = [[NSMutableDictionary alloc]init];
    [test setObject:userNameTextField.text forKey:@"Email"];
    [test setObject:passwordTextField.text forKey:@"Password"];
    [test setObject:resID forKey:@"RestaurantID"];
    
    NSString *formattedBodyStr = [self jsonFormat:reqType withDictionary:test];
    NSString *dataInString = [NSString stringWithFormat: @"\"Data\":%@",formattedBodyStr];
    NSString *postDataInString = [NSString stringWithFormat:@"{\"Type\":\"%@\",%@}",reqType,dataInString];
    NSData *postJsonData = [postDataInString dataUsingEncoding:NSUTF8StringEncoding];
    webServiceInterface = [[WebServiceInterface alloc]initWithVC:self];
    webServiceInterface.delegate =self;
    [webServiceInterface sendRequest:postDataInString PostJsonData:postJsonData Req_Type:reqType Req_url:finalReqUrl];

}


-(NSString*)jsonFormat:(NSString *)type withDictionary:(NSMutableDictionary *)formatDict{
    NSString *bodyStr =[NSString stringWithFormat: @"{\"rest_id\":\"%@\",\"email\":\"%@\",\"password\":\"%@\"}",[formatDict objectForKey:@"RestaurantID"],[formatDict objectForKey:@"Email"],[formatDict objectForKey:@"Password"]];
    return bodyStr;
}



-(IBAction)loginBtnClicked:(id)sender{
    [self.view endEditing:YES];
    
    BOOL email = YES;
    
    if (userNameTextField.text.length == 0) {
        customAlertMessage = @"Please enter email id";
        customAlertTitle = @"Alert";
        [self LoadCustomAlertWithMessage];
    }else if (passwordTextField.text.length ==0){
        customAlertMessage = @"Please enter password";
        customAlertTitle = @"Alert";
        [self LoadCustomAlertWithMessage];
    }else if(email!= [self validateEmailWithString:userNameTextField.text]){
        customAlertMessage = @"Please enter valid email id";
        customAlertTitle = @"Alert";
        [self LoadCustomAlertWithMessage];
    }else{
        [self postRequest:LOGIN_REQ_TYPE];
    }
}

-(void)getResponse:(NSDictionary *)resp type:(NSString *)respType{
    
    if ([respType isEqualToString:LOGIN_REQ_TYPE]) {
        NSDictionary *statusDict = [resp objectForKey:@"Status"];
        NSString *status = [NSString stringWithFormat:@"%@",[statusDict objectForKey:@"status"]];
        NSString *statusDesc = [statusDict objectForKey:@"desc"];
        if ([status isEqualToString:@"1"]) {
            NSLog(@"response data %@", [resp objectForKey:@"Data"]);
            NSDictionary *dataDict = [resp objectForKey:@"Data"];
            dbManager = [DataBaseManager dataBaseManager];
            [dbManager execute:[NSString stringWithFormat:@"DELETE FROM LoginDetails "]];
            [dbManager execute:[NSString stringWithFormat: @"INSERT INTO 'LoginDetails' (UserName, Password,CustomerID,Phone,Email,Address)VALUES ('%@','%@','%@','%@','%@','%@')",[dataDict objectForKey:@"name"],passwordTextField.text,[dataDict objectForKey:@"id"],[dataDict objectForKey:@"phone"],[dataDict objectForKey:@"email"],[dataDict objectForKey:@"address"]]];
            NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
            NSString *loginParentView = [defaults objectForKey:@"LoginParentView"];
           
            if ([loginParentView isEqualToString:@"OrderCart"]) {
                NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
                [defaults setObject:@"LoginViewFromOrder" forKey:@"PlaceOrderParentView"];
                [defaults synchronize];
                PlaceOrderViewController *placeOrder = [self.storyboard instantiateViewControllerWithIdentifier:@"PlaceOrderViewController"];
                placeOrder.dishItemDetailsDict = dishItemDetailsDict;
                [self presentViewController:placeOrder animated:YES completion:nil];
            }else if([loginParentView isEqualToString:@"OrderCartFromSharingVC"]){
              
                NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
                [defaults setObject:@"LoginViewFromSharingVC" forKey:@"PlaceOrderParentView"];
                [defaults synchronize];
                PlaceOrderViewController *placeOrder = [self.storyboard instantiateViewControllerWithIdentifier:@"PlaceOrderViewController"];
                placeOrder.dishItemDetailsDict = dishItemDetailsDict;
                [self presentViewController:placeOrder animated:YES completion:nil];
                
                
            }else if ([loginParentView isEqualToString:@"CategoryList"]){
                NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
                [defaults setObject:@"LoginViewCategoryList" forKey:@"PlaceOrderParentView"];
                [defaults synchronize];
                PlaceOrderViewController *placeOrder = [self.storyboard instantiateViewControllerWithIdentifier:@"PlaceOrderViewController"];
                placeOrder.dishItemDetailsDict = dishItemDetailsDict;
                [self presentViewController:placeOrder animated:YES completion:nil];
            }else if ([loginParentView isEqualToString:@"ItemMenu"]){
                [self dismissViewControllerAnimated:YES completion:nil];
            }else if ([loginParentView isEqualToString:@"Menu"]){
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }else{
            
            NSString *communicationStr = [resp objectForKey:@"CommunicationAlert"];
            alertMsg = communicationStr;
            if (communicationStr.length == 0) {
                customAlertMessage = statusDesc;
                customAlertTitle = @"Alert";
                [self LoadCustomAlertWithMessage];
            }else{
                [self loadCustomAlertSubView:alertMsg];
            }
        }
    }
    
}



// for custom alert


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




-(IBAction)signUpBtnClicked:(id)sender{
    SignUpViewController *signUp = [self.storyboard instantiateViewControllerWithIdentifier:@"SignUpViewController"];
    signUp.dishItemDetailsDict = dishItemDetailsDict;
    [self presentViewController:signUp animated:YES completion:nil];

}
-(IBAction)closeBtnClicked:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];

}


- (void) scrollViewAdaptToStartEditingTextField:(UITextField*)textField
{
    int val;
    if ([UIScreen mainScreen].bounds.size.height == 568) {  // iphone 4 inch
        val =3;
    }else{
        val =2.5;
    }
    CGPoint point = CGPointMake(0, textField.frame.origin.y - val * textField.frame.size.height);
    [loginScrollView setContentOffset:point animated:YES];
}

- (void) scrollVievEditingFinished:(UITextField*)textField
{
    CGPoint point = CGPointMake(0, 0);
    [loginScrollView setContentOffset:point animated:YES];
}


- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
            [self scrollViewAdaptToStartEditingTextField:textField];
        }else if(UIInterfaceOrientationIsPortrait(STATUSBAR_ORIENTATION)){
        
        }
    }else{
        [self scrollViewAdaptToStartEditingTextField:textField];
    }
    return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
   [textField resignFirstResponder];
    [self scrollVievEditingFinished:textField];
    
    
    
    if (textField == userNameTextField) {
        [textField resignFirstResponder];
        [passwordTextField becomeFirstResponder];
        
    }
    else if (textField == passwordTextField)
    {
        [textField resignFirstResponder];
        [self loginBtnClicked:nil];
        
    }
        
    
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        if (textField == passwordTextField) {
            [textField resignFirstResponder];
            [self scrollVievEditingFinished:textField];
        }
    }
}



- (BOOL)validateEmailWithString:(NSString*)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}



- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
            self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"pgm_ipad-Background-Landscape.png"]];
        }else if(UIInterfaceOrientationIsPortrait(STATUSBAR_ORIENTATION)){
            self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"pgm_ipad-Background-Potrait.png"]];
        }
    }
    
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


-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
            bgImageView.image = [UIImage imageNamed:@"iPad_potrait.png"];
        }else if(UIInterfaceOrientationIsPortrait(STATUSBAR_ORIENTATION)){
            bgImageView.image = [UIImage imageNamed:@"iPad_landscape.png"];
        }
        bgImageView.alpha = 0.7;
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
