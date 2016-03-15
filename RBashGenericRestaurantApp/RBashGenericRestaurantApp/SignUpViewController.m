//
//  SignUpViewController.m
//  ThinkingCup
//
//  Created by Manulogix on 03/09/14.
//  Copyright (c) 2014 Manulogix. All rights reserved.
//

#import "SignUpViewController.h"
#import "FAUtilities.h"
#import "PlaceOrderViewController.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController
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

    
    UIImageView *tempimageView;
    UIImageView *tempimageView1;
    UIImageView *tempimageView2;
    UIImageView *tempimageView3;
    UIImageView *tempimageView4;
    UIImageView *tempimageView5;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        tempimageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
        tempimageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
        tempimageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
        tempimageView3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
        tempimageView4 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
         tempimageView5 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];

        
    }else  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        tempimageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
        tempimageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
        tempimageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
        tempimageView3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
        tempimageView4 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
        tempimageView5 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];

    }
    
    [tempimageView setImage:[UIImage imageNamed:@"pgm_userName.png"]];
    tempimageView.contentMode = UIViewContentModeScaleAspectFit;
    firstNameTextField.leftView= tempimageView;
    firstNameTextField.leftViewMode = UITextFieldViewModeAlways;
    [firstNameTextField setReturnKeyType:UIReturnKeyNext];
    
    [tempimageView1 setImage:[UIImage imageNamed:@"pgm_email.png"]];
    tempimageView1.contentMode = UIViewContentModeScaleAspectFit;
    emailTextField.leftView = tempimageView1;
    emailTextField.leftViewMode = UITextFieldViewModeAlways;
    [emailTextField setReturnKeyType:UIReturnKeyNext];


    [tempimageView4 setImage:[UIImage imageNamed:@"pgm_mobile.png"]];
    tempimageView4.contentMode = UIViewContentModeScaleAspectFit;
    mobileTextField.leftView = tempimageView4;
    mobileTextField.leftViewMode = UITextFieldViewModeAlways;
    [mobileTextField setReturnKeyType:UIReturnKeyNext];

    
    [tempimageView2 setImage:[UIImage imageNamed:@"pgm_password.png"]];
    tempimageView2.contentMode = UIViewContentModeScaleAspectFit;
    passwordTextField.leftView = tempimageView2;
    passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    [passwordTextField setReturnKeyType:UIReturnKeyNext];

    
    [tempimageView3 setImage:[UIImage imageNamed:@"pgm_confirmPassword.png"]];
    tempimageView3.contentMode = UIViewContentModeScaleAspectFit;
    confirmPasswordTextField.leftView = tempimageView3;
    confirmPasswordTextField.leftViewMode = UITextFieldViewModeAlways;
    [confirmPasswordTextField setReturnKeyType:UIReturnKeyNext];

    [tempimageView5 setImage:[UIImage imageNamed:@"pgm_zipCode.png"]];
    tempimageView5.contentMode = UIViewContentModeScaleAspectFit;
    zipCodeTextField.leftView = tempimageView5;
    zipCodeTextField.leftViewMode = UITextFieldViewModeAlways;
    [zipCodeTextField setReturnKeyType:UIReturnKeyDone];

    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



-(IBAction)submitBtnClicked:(id)sender{
    
    [self.view endEditing:YES];
    
    BOOL email = YES;
    BOOL zip =YES;
    
    if (firstNameTextField.text.length == 0) {
        customAlertMessage = @"Please enter first and last name";
        customAlertTitle = @"Alert";
        [self LoadCustomAlertWithMessage];
    }else if (emailTextField.text.length ==0){
        customAlertMessage = @"Please enter email";
        customAlertTitle = @"Alert";
        [self LoadCustomAlertWithMessage];
    }else if (mobileTextField.text.length ==0){
        customAlertMessage = @"Please enter mobile number";
        customAlertTitle = @"Alert";
        [self LoadCustomAlertWithMessage];
    }else if (passwordTextField.text.length ==0){
        customAlertMessage = @"Please enter password";
        customAlertTitle = @"Alert";
        [self LoadCustomAlertWithMessage];
    }else if (confirmPasswordTextField.text.length ==0){
        customAlertMessage = @"Please enter confirm password";
        customAlertTitle = @"Alert";
        [self LoadCustomAlertWithMessage];
    }else if (zip!=[self isZipValid:zipCodeTextField.text]){
        customAlertMessage = @"Please enter Valid zip Code";
        customAlertTitle = @"Alert";
        [self LoadCustomAlertWithMessage];
        zipCodeTextField.text=nil;
    }else if (email!= [self validateEmailWithString:emailTextField.text]){
        customAlertMessage = @"Please enter valid email id";
        customAlertTitle = @"Alert";
        [self LoadCustomAlertWithMessage];
    }else{
    
        if ([passwordTextField.text isEqualToString:confirmPasswordTextField.text]) {
            [self postRequest:SIGN_UP_REQ_TYPE];
        }else{
            customAlertMessage = @"The passwords you enterd do not match";
            customAlertTitle = @"Alert";
            [self LoadCustomAlertWithMessage];
        }
    }
}




-(void)postRequest:(NSString *)reqType{
    
    NSString *finalReqUrl;
    
    if ([reqType isEqualToString:SIGN_UP_REQ_TYPE]) {
        finalReqUrl = [NSString stringWithFormat:@"%@%@",REQ_URL,SIGN_UP_REQ_URL];
    }
 
    NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
    NSString *resID = [defaults objectForKey:@"RestaurantID"];

    NSMutableDictionary *test = [[NSMutableDictionary alloc]init];
    [test setObject:firstNameTextField.text forKey:@"Name"];
    [test setObject:emailTextField.text forKey:@"Email"];
    [test setObject:passwordTextField.text forKey:@"Password"];
    [test setObject:mobileTextField.text forKey:@"Phone"];
    [test setObject:zipCodeTextField.text forKey:@"zip"];
    [test setObject:resID forKey:@"RestaurantID"];
    
    
    NSString *formattedBodyStr = [self jsonFormat:reqType withDictionary:test];
    NSString *dataInString = [NSString stringWithFormat: @"\"Data\":%@",formattedBodyStr];
    NSString *postDataInString = [NSString stringWithFormat:@"{\"Type\":\"%@\",%@}",reqType,dataInString];
    
    NSData *postJsonData = [postDataInString dataUsingEncoding:NSUTF8StringEncoding];
    webServiceInterface = [[WebServiceInterface alloc]initWithVC:self];
    webServiceInterface.delegate =self;
    [webServiceInterface sendRequest:postDataInString PostJsonData:postJsonData Req_Type:reqType Req_url:finalReqUrl];
}


-(void)getResponse:(NSDictionary *)resp type:(NSString *)respType{

    if ([respType isEqualToString:SIGN_UP_REQ_TYPE]) {
        NSDictionary *statusDict = [resp objectForKey:@"Status"];
        
        NSString *status = [NSString stringWithFormat:@"%@",[statusDict objectForKey:@"status"]];
        NSString *statusDesc = [statusDict objectForKey:@"desc"];
        
        if ([status isEqualToString:@"1"]) {
            NSDictionary *dataDict = [resp objectForKey:@"Data"];
            NSString *custId = [dataDict objectForKey:@"id"];
            dbManager = [DataBaseManager dataBaseManager];
            [dbManager execute:[NSString stringWithFormat:@"DELETE FROM LoginDetails "]];
            [dbManager execute:[NSString stringWithFormat: @"INSERT INTO 'LoginDetails' (UserName, Password,CustomerID,Phone,Email,Address)VALUES ('%@','%@','%@','%@','%@','%@')",firstNameTextField.text,passwordTextField.text,custId,mobileTextField.text,emailTextField.text,@""]];
            NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
            NSString *signUpParentView = [defaults objectForKey:@"LoginParentView"];
            
            
            if ([signUpParentView isEqualToString:@"OrderCart"]) {
                
                NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
                [defaults setObject:@"LoginViewFromOrder" forKey:@"PlaceOrderParentView"];
                [defaults synchronize];
                
                PlaceOrderViewController *placeOrder = [self.storyboard instantiateViewControllerWithIdentifier:@"PlaceOrderViewController"];
                placeOrder.dishItemDetailsDict = dishItemDetailsDict;
                [self presentViewController:placeOrder animated:YES completion:nil];
                
            }else if ([signUpParentView isEqualToString:@"CategoryList"]){
                NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
                [defaults setObject:@"LoginViewCategoryList" forKey:@"PlaceOrderParentView"];
                [defaults synchronize];
                
                PlaceOrderViewController *placeOrder = [self.storyboard instantiateViewControllerWithIdentifier:@"PlaceOrderViewController"];
                placeOrder.dishItemDetailsDict = dishItemDetailsDict;
                [self presentViewController:placeOrder animated:YES completion:nil];
                
            }else if ([signUpParentView isEqualToString:@"ItemMenu"]){
                [self performSegueWithIdentifier:@"SignUpToItemMenu" sender:self];
            }else if ([signUpParentView isEqualToString:@"Menu"]){
                [self performSegueWithIdentifier:@"SignUpToHome" sender:self];
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


-(NSString*)jsonFormat:(NSString *)type withDictionary:(NSMutableDictionary *)formatDict{
    
    NSString *bodyStr =[NSString stringWithFormat: @"{\"full_name\":\"%@\",\"email\":\"%@\",\"phone\":\"%@\",\"password\":\"%@\",\"zip\":\"%@\"}",[formatDict objectForKey:@"Name"],[formatDict objectForKey:@"Email"],[formatDict objectForKey:@"Phone"],[formatDict objectForKey:@"Password"],[formatDict objectForKey:@"zip"]];
    
    return bodyStr;
}




-(IBAction)backBtnClicekd:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (void) scrollViewAdaptToStartEditingTextField:(UITextField*)textField
{
    
    CGPoint point;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        point = CGPointMake(0, textField.frame.origin.y - 0.1 * textField.frame.size.height);
    }else{
        point = CGPointMake(0, textField.frame.origin.y - 0.3 * textField.frame.size.height);
    }
    
    [signUpScrollView setContentOffset:point animated:YES];
}

- (void) scrollVievEditingFinished:(UITextField*)textField
{
    CGPoint point = CGPointMake(0, 0);
    [signUpScrollView setContentOffset:point animated:YES];
}


- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
            [self scrollViewAdaptToStartEditingTextField:textField];
        }else if(UIInterfaceOrientationIsPortrait(STATUSBAR_ORIENTATION)){
            
        }
    }else{
        if ([UIScreen mainScreen].bounds.size.height == 568) {  // iphone 4 inch
            if (textField == mobileTextField || textField == passwordTextField || textField == confirmPasswordTextField || textField == zipCodeTextField ) {
                [self scrollViewAdaptToStartEditingTextField:textField];
            }
        }else{
            if (textField == mobileTextField || textField == passwordTextField || textField == emailTextField || textField == confirmPasswordTextField || textField == zipCodeTextField ){
                [self scrollViewAdaptToStartEditingTextField:textField];
            }
        }
    }

    

    return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self scrollVievEditingFinished:textField];
    
    
    if (textField == firstNameTextField) {
        [textField resignFirstResponder];
        [emailTextField becomeFirstResponder];
        
    }
     else if (textField == emailTextField)
     {
         [textField resignFirstResponder];
         [mobileTextField becomeFirstResponder];
     }
     else if (textField == mobileTextField)
     {
         [textField resignFirstResponder];
         [passwordTextField becomeFirstResponder];
     }
     else if (textField == passwordTextField)
     {
         [textField resignFirstResponder];
         [confirmPasswordTextField becomeFirstResponder];
     }
     else if (textField == confirmPasswordTextField)
     {
         [textField resignFirstResponder];
         [zipCodeTextField becomeFirstResponder];
     }
    else if (textField == zipCodeTextField)
    {
        [textField resignFirstResponder];
        [self submitBtnClicked:nil];
        
    }
    
    
    
    
    
    
    
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        if (textField == confirmPasswordTextField) {
            [textField resignFirstResponder];
            [self scrollVievEditingFinished:textField];
        }
    }
    
    if (textField == mobileTextField)
    {
        
        NSString *filtered = [[textField.text componentsSeparatedByString:@"-"] componentsJoinedByString:@""];
        
        if (filtered.length>9) {
            
            NSMutableString *str=[[NSMutableString alloc]initWithString:filtered];
            [str insertString:@"(" atIndex:0];
            [str insertString:@")" atIndex:4];
            [str insertString:@" " atIndex:5];
            [str insertString:@"-" atIndex:9];


            
            textField.text=str;
        }
    }
    else if (textField == passwordTextField)
    {
        if ( [textField.text length]<8 ){
            customAlertMessage = @"Password should have 8 characters or more.";
            customAlertTitle = @"Alert";
            [self LoadCustomAlertWithMessage];
            textField.text=nil;
        }else{
        BOOL PWD=YES;
        if (PWD!=[self isPasswordValid:passwordTextField.text]) {
            customAlertMessage = @"Password must contain atleast one capital letter, number and special character.";
            customAlertTitle = @"Alert";
            [self LoadCustomAlertWithMessage];
            textField.text=nil;
        }
            PWD=NO;
        }
    }
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    if (textField == zipCodeTextField) {
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        
        if (filtered) {
            if ([string isEqualToString:@""]) {
                return YES;
            }else{
                
                NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:@"[-()-]"
                                                                                            options:0
                                                                                              error:NULL];
                
                
                NSString *cleanedString = [expression stringByReplacingMatchesInString:textField.text
                                                                               options:0
                                                                                 range:NSMakeRange(0, [self getLength:textField.text])
                                                                          withTemplate:@""];
                
                
                if (cleanedString.length > 9) {//accessing max characters in textfield
                    return NO;
                }else{
                    if ([string isEqualToString:filtered] == YES) {
                        return [string isEqualToString:filtered];
                      
                    }else{
                        return NO;
                    }
                    
                }
            }
        }
        
        
    }

    
    
    if (textField == mobileTextField) {
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        
        if (filtered) {
            if ([string isEqualToString:@""]) {
                return YES;
            }else{
                NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:@"[-()-]"
                                                                                            options:0
                                                                                              error:NULL];
                NSString *cleanedString = [expression stringByReplacingMatchesInString:textField.text
                                                                               options:0
                                                                                 range:NSMakeRange(0, [self getLength:textField.text])
                                                                          withTemplate:@""];
                if (cleanedString.length > 9) {
                    return NO;
                }else{
                    if ([string isEqualToString:filtered] == YES) {
                        if ((range.location == 3) || (range.location == 7))
                        {
                            NSString *str    = [NSString stringWithFormat:@"%@-",textField.text];
                            textField.text   = str;
                        }
                        return YES;
                    }else{
                        return NO;
                    }
                }
            }
        }
    }
    
    return YES;
}

/* Method to format the textfield value length after entering for SSN/DOB*/
-(int)getLength:(NSString*)formatNumber{
    formatNumber = [formatNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    formatNumber = [formatNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    formatNumber = [formatNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    formatNumber = [formatNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    formatNumber = [formatNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    formatNumber = [formatNumber stringByReplacingOccurrencesOfString:@":" withString:@""];
    formatNumber = [formatNumber stringByReplacingOccurrencesOfString:@"/" withString:@""];
    int length = (int)[formatNumber length];
    return length;
}

#pragma mark ===Validations=====

- (BOOL)validateEmailWithString:(NSString*)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

-(BOOL) isPasswordValid:(NSString *)pwd {
    
    
    
    NSCharacterSet *SymbolsChars = [NSCharacterSet characterSetWithCharactersInString:@"{[(|/?.!@#$%^&*_-+=§:'<>)]}"];
    
    NSRange rang;
    rang = [pwd rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet]];
    if ( !rang.length )
    {
        return NO;  // no letter
    }
    //    NSCharacterSet* symbols = [NSCharacterSet symbolCharacterSet];
    //    if([symbols characterIsMember:<#(unichar)#>]) {
    //        //Check Your condition here
    //    }
    
    
    
    rang=[pwd rangeOfCharacterFromSet:SymbolsChars];
    
    if ( !rang.length)
    {
        return NO;  // no specialCharacter
    }
    
    rang = [pwd rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]];
    if ( !rang.length )
    {
        return NO;  // no number;
    }
    rang = [pwd rangeOfCharacterFromSet:[NSCharacterSet uppercaseLetterCharacterSet]];
    if ( !rang.length )
        return NO;  // no uppercase letter;
    rang = [pwd rangeOfCharacterFromSet:[NSCharacterSet lowercaseLetterCharacterSet]];
    if ( !rang.length )
        return NO;  // no lowerCase Chars;
    
    return YES;
}
-(BOOL) isZipValid:(NSString *)ZipStr {
    
    NSString *zipRegex = @"^(\\d{5}(-\\d{4})?|[a-z]\\d[a-z][- ]*\\d[a-z]\\d)$";//for U.S n Canada Only
    
    NSPredicate *zipTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", zipRegex];
    return [zipTest evaluateWithObject:ZipStr];
    
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
            bgImageView.alpha = 0.7;
        }else if(UIInterfaceOrientationIsPortrait(STATUSBAR_ORIENTATION)){
            bgImageView.image = [UIImage imageNamed:@"iPad_landscape.png"];
            bgImageView.alpha = 0.7;
            
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
    
    if (disableCustomAlertView.tag ==900) {
        [disableCustomAlertView removeFromSuperview];

    }
    else{
    [disableCustomAlertView removeFromSuperview];
    }
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
