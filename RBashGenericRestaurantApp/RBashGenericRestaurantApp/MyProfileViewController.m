//
//  MyProfileViewController.m
//  ThinkingCup
//
//  Created by Manulogix on 23/09/14.
//  Copyright (c) 2014 Manulogix. All rights reserved.
//

#import "MyProfileViewController.h"
#import "ChangePasswordViewController.h"

@interface MyProfileViewController ()

@end

@implementation MyProfileViewController

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
    
 
    
    
    if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
          headerView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"pgm_HeaderLandscape.png"]];
      
    }else if(UIInterfaceOrientationIsPortrait(STATUSBAR_ORIENTATION)){
        
           headerView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"pgm_Header.png"]];
    }
    
    NSMutableArray *loginArray = [[NSMutableArray alloc]init];
    dbManager = [DataBaseManager dataBaseManager];
    [dbManager execute:[NSString stringWithFormat:@"SELECT * FROM LoginDetails "] resultsArray:loginArray];

    profileDict = [loginArray objectAtIndex:0];
    
    firstNameTextField.text = [profileDict objectForKey:@"UserName"];
    mobileTextField.text = [profileDict objectForKey:@"Phone"];
    emailTextField.text = [profileDict objectForKey:@"Email"];
    addressTextField.text = [profileDict objectForKey:@"Address"];
    addressTextField.layer.borderColor = [[UIColor grayColor]CGColor];
    
    
    [firstNameTextField setReturnKeyType:UIReturnKeyNext];
    [mobileTextField setReturnKeyType:UIReturnKeyNext];
    [emailTextField setReturnKeyType:UIReturnKeyNext];
    [addressTextField setReturnKeyType:UIReturnKeyDone];

   
    [firstNameTextField setDelegate:self];
    [mobileTextField setDelegate:self];
    [emailTextField setDelegate:self];
    [addressTextField setDelegate:self];

 
    
    addressTextField.layer.borderWidth = 2;
    [self performSelector:@selector(methodName) withObject:nil afterDelay:0.5];

    // Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated{
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
    
    }else{
        [self performSelector:@selector(methodName) withObject:nil afterDelay:0.5];
    }
}



-(void)methodName{
    myProfileScrollView.contentSize = CGSizeMake(320, myProfileScrollView.frame.size.height+60);
}


-(IBAction)keyBoardResignBtnClicked:(id)sender{
    myProfileScrollView.contentSize = CGSizeMake(320, myProfileScrollView.frame.size.height+60);
    [self scrollVievEditingFinished:nil];

    [self.view endEditing:YES];
}


-(IBAction)backBtnClicked:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)saveBtnClicked:(id)sender{
    
    [self.view endEditing:YES];
    [self scrollVievEditingFinished:nil];

    BOOL email = YES;
    
    if (firstNameTextField.text.length ==0) {
//        [FAUtilities showAlert:@"Please enter name"];
        
        customAlertMessage = @"Please enter name";
        customAlertTitle = @"Alert";
        [self LoadCustomAlertWithMessage];
        
    }
   else if (mobileTextField.text.length ==0){
//        [FAUtilities showAlert:@"Please enter mobile number"];
        
        customAlertMessage = @"Please enter mobile number";
        customAlertTitle = @"Alert";
        [self LoadCustomAlertWithMessage];

        
    }

    else if(emailTextField.text.length ==0){
//        [FAUtilities showAlert:@"Please enter email"];
        
        customAlertMessage = @"Please enter email";
        customAlertTitle = @"Alert";
        [self LoadCustomAlertWithMessage];

        
    }else if (email!= [self validateEmailWithString:emailTextField.text]){
//        [FAUtilities showAlert:@"Please enter valid email id"];
        
        customAlertMessage = @"Please enter valid email id";
        customAlertTitle = @"Alert";
        [self LoadCustomAlertWithMessage];

        
    }else{
        [self postRequest:UPDATE_MY_PROFILE_REQ_TYPE withMethod:@"Profile"];
    }
    
}

-(void)postRequest:(NSString *)reqType withMethod:(NSString *)method{
    NSString *finalReqUrl;
    
    if ([reqType isEqualToString:UPDATE_MY_PROFILE_REQ_TYPE]) {
        finalReqUrl = [NSString stringWithFormat:@"%@%@",REQ_URL,UPDATE_MY_PROFILE_REQ_URL];
    }
    
    
    
    if ([method isEqualToString:@"Profile"]) {
        password = [profileDict objectForKey:@"Password"];
    }else if([method isEqualToString:@"Password"]){
        password = newPasswordTextField.text;
    }
    
    NSMutableDictionary *test = [[NSMutableDictionary alloc]init];
    [test setObject:firstNameTextField.text forKey:@"Name"];
    [test setObject:emailTextField.text forKey:@"Email"];
    [test setObject:mobileTextField.text forKey:@"Phone"];
   
    
    NSString *address= [addressTextField.text stringByReplacingOccurrencesOfString:@"\n" withString:@" "];

    address = [address stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    address = [address stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
    address = [address stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];

    
    [test setObject:address forKey:@"Address"];
    [test setObject:password forKey:@"Password"];
    [test setObject:[profileDict objectForKey:@"CustomerID"] forKey:@"CustomerID"];

    
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
            
            NSString *address= [addressTextField.text stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
            
            address = [address stringByReplacingOccurrencesOfString:@"'" withString:@"''"];

            
            [dbManager execute:[NSString stringWithFormat:@"Update LoginDetails set UserName='%@', Address='%@',Phone='%@',Email='%@' , Password = '%@' where CustomerID = '%@'",firstNameTextField.text,address,mobileTextField.text,emailTextField.text,password,[profileDict objectForKey:@"CustomerID"]]];

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


-(IBAction)changePswdBtnClicked:(id)sender{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        
       
        
        
        
        [self changePasswordSubView:nil];
    }else  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
    
        
        ChangePasswordViewController *changePassword = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangePasswordViewController"];
        changePassword.valuesDict = profileDict;
        changePassword.validOldPassword = [profileDict objectForKey:@"Password"];
        [self presentViewController:changePassword animated:YES completion:nil];

        
    }
}


-(void)changePasswordSubView:(NSDictionary *)dict{

    diabledview = [[UIView alloc]initWithFrame:self.view.bounds];
    diabledview.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pgm_gallery.png"]];
    diabledview.tag = 401;
    [self.view addSubview:diabledview];
    
    UIFont *valuesFont = [UIFont fontWithName:@"Thonburi" size:22];
    UIFont *btnsFont = [UIFont fontWithName:@"Thonburi" size:24];
    
    
    UIView *addContactSubview= [[UIView alloc]init];
    
    if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
        [addContactSubview setFrame:CGRectMake(249, 180, 568, 486-180)];
    }else{
        [addContactSubview setFrame:CGRectMake(100, 269, 568, 486-180)];
    }

    UIView *addContactHeadingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 568, 50)];
    addContactHeadingView.backgroundColor = [FAUtilities getUIColorObjectFromHexString:APP_HEADER_COLOR alpha:1];
    
    UILabel *headingLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 5, 468, 40)];
    headingLabel.text = @"Change Password";
    headingLabel.textAlignment = NSTextAlignmentCenter;
    headingLabel.textColor = [UIColor whiteColor];
    
    [headingLabel setFont:[UIFont fontWithName:@"Verdana" size:26]];
    [addContactHeadingView addSubview:headingLabel];
    
    
    UILabel *oldPasswordLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, headingLabel.frame.origin.y+ headingLabel.frame.size.height+30, 220, 40)];
    oldPasswordLabel.text = @"Old Password:";
    [oldPasswordLabel setFont:valuesFont];
    oldPasswordLabel.textAlignment = NSTextAlignmentRight;
    
    oldPasswordTextField = [[UITextField alloc]initWithFrame:CGRectMake(oldPasswordLabel.frame.origin.x+oldPasswordLabel.frame.size.width+10, headingLabel.frame.origin.y+ headingLabel.frame.size.height+30, 280, 40)];
    oldPasswordTextField.borderStyle = UITextBorderStyleRoundedRect;
    [oldPasswordTextField setFont:valuesFont];
    [oldPasswordTextField setReturnKeyType:UIReturnKeyNext];
    oldPasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    oldPasswordTextField.secureTextEntry = YES;
    oldPasswordTextField.userInteractionEnabled=YES;
    [oldPasswordTextField setDelegate:self];

    
    UILabel *newPasswordLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, oldPasswordLabel.frame.origin.y+ oldPasswordLabel.frame.size.height+10, 220, 40)];
    newPasswordLabel.text = @"New Password:";
    [newPasswordLabel setFont:valuesFont];
    newPasswordLabel.textAlignment = NSTextAlignmentRight;
    
    newPasswordTextField = [[UITextField alloc]initWithFrame:CGRectMake(newPasswordLabel.frame.origin.x+newPasswordLabel.frame.size.width+10, oldPasswordLabel.frame.origin.y+ oldPasswordLabel.frame.size.height+10, 280, 40)];
    newPasswordTextField.borderStyle = UITextBorderStyleRoundedRect;
    [newPasswordTextField setReturnKeyType:UIReturnKeyNext];
    [newPasswordTextField setDelegate:self];

    [newPasswordTextField setFont:valuesFont];
    
    newPasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    newPasswordTextField.secureTextEntry = YES;
    
    UILabel *confirmPasswordLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, newPasswordLabel.frame.origin.y+ newPasswordLabel.frame.size.height+10, 220, 40)];
    confirmPasswordLabel.text = @"Confirm Password:";
    [confirmPasswordLabel setFont:valuesFont];
    
    confirmPasswordLabel.textAlignment = NSTextAlignmentRight;
    
    confirmPasswordTextField = [[UITextField alloc]initWithFrame:CGRectMake(confirmPasswordLabel.frame.origin.x+confirmPasswordLabel.frame.size.width+10, newPasswordLabel.frame.origin.y+ newPasswordLabel.frame.size.height+10, 280, 40)];
    confirmPasswordTextField.borderStyle = UITextBorderStyleRoundedRect;
    [confirmPasswordTextField setFont:valuesFont];
    confirmPasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [confirmPasswordTextField setReturnKeyType:UIReturnKeyDone];
    [confirmPasswordTextField setFont:valuesFont];
    [confirmPasswordTextField setDelegate:self];

    confirmPasswordTextField.secureTextEntry = YES;
    
  
    oldPasswordTextField.keyboardType=UIKeyboardTypeDefault;
    newPasswordTextField.keyboardType=UIKeyboardTypeDefault;
    confirmPasswordTextField.keyboardType=UIKeyboardTypeDefault;

    
    UIButton *saveBtn = [[UIButton alloc]initWithFrame:CGRectMake(100, confirmPasswordLabel.frame.origin.y+confirmPasswordLabel.frame.size.height+30, 150, 40)];
    [FAUtilities setBackgroundImagesForButton:saveBtn];

    
    [saveBtn setTitle:@"Save" forState:UIControlStateNormal];
    saveBtn.titleLabel.font = btnsFont;
    [saveBtn addTarget:self
                action:@selector(changePasswordSaveBtnClicked:)
      forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(318, confirmPasswordLabel.frame.origin.y+confirmPasswordLabel.frame.size.height+30, 150, 40)];
//    [cancelBtn setBackgroundImage:btnImageNormal forState:UIControlStateNormal];
//    [cancelBtn setBackgroundImage:btnImageActive forState:UIControlStateHighlighted];

    [FAUtilities setBackgroundImagesForButton:cancelBtn];

    
    [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = btnsFont;
    [cancelBtn addTarget:self
                  action:@selector(cancelBtnClicked:)
        forControlEvents:UIControlEventTouchUpInside];
    
    [addContactSubview addSubview:saveBtn];
    [addContactSubview addSubview:cancelBtn];
    
    
    [addContactSubview addSubview:oldPasswordLabel];
    [addContactSubview addSubview:newPasswordLabel];
    [addContactSubview addSubview:confirmPasswordLabel];
    
    [addContactSubview addSubview:oldPasswordTextField];
    [addContactSubview addSubview:newPasswordTextField];
    [addContactSubview addSubview:confirmPasswordTextField];
    
    [addContactSubview addSubview:addContactHeadingView];
    addContactSubview.backgroundColor = [FAUtilities getUIColorObjectFromHexString:@"#FCF9F2" alpha:1];
    [diabledview addSubview:addContactSubview];
}


-(void)cancelBtnClicked:(id)sender{
    [self.view endEditing:YES];
    [diabledview removeFromSuperview];
}

-(void)changePasswordSaveBtnClicked:(id)sender{
    [self.view endEditing:YES];
    NSString *validOldPassword = [profileDict objectForKey:@"Password"];
    
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
        
        [diabledview removeFromSuperview];
    }

    
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:    (NSString *)text {
    
    if (textView == addressTextField) {
        if( [text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]].location == NSNotFound ) {
            return YES;
        }
        else{
            [self saveBtnClicked:nil];
        }
        
    }
    
  
    return NO;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == mobileTextField) {
        /*
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
                        return YES;
                        
                        
                    }else{
                        return NO;
                    }
                    
                }
            }
        }
        
        
    }
    */
        
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSArray *components = [newString componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]];
        NSString *decimalString = [components componentsJoinedByString:@""];
        
       
        
        NSUInteger length = decimalString.length;
        BOOL hasLeadingOne = length > 0 && [decimalString characterAtIndex:0] == '1';
        
        if (length == 0 || (length > 10 && !hasLeadingOne) || (length > 11)) {
         //   textField.text = decimalString;
            if (length == 0) {
                textField.text=@"";
            }
            else
            {
            return NO;
            }
        }
        
        NSUInteger index = 0;
        NSMutableString *formattedString = [NSMutableString string];
        
        if (hasLeadingOne) {
            [formattedString appendString:@"1 "];
            index += 1;
        }
        
        if (length - index > 3) {
            NSString *areaCode = [decimalString substringWithRange:NSMakeRange(index, 3)];
            [formattedString appendFormat:@"(%@) ",areaCode];
            index += 3;
        }
        
        if (length - index > 3) {
            NSString *prefix = [decimalString substringWithRange:NSMakeRange(index, 3)];
            [formattedString appendFormat:@"%@-",prefix];
            index += 3;
        }
        
        NSString *remainder = [decimalString substringFromIndex:index];
        [formattedString appendString:remainder];
        
        textField.text = formattedString;
        
        
        
        
       // return NO;

    }
    else if (textField !=mobileTextField)
    {
        return YES;
    }
    return NO;
    

        
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

- (BOOL) textViewShouldBeginEditing:(UITextView *)textField{
    if (textField == addressTextField) {
        [self scrollViewAdaptToStartEditingTextView:textField];
    }

    return YES;
}
- (BOOL) textViewShouldReturn:(UITextView *)textField{


    
    [self.view endEditing:YES];
    
    if (textField == addressTextField ) {
        [self scrollVievEditingFinishedView:textField];
    }
    
    
  
    

    
    
    
    
    return YES;
}


- (void) scrollViewAdaptToStartEditingTextView:(UITextView*)textField{
    float val;
    
    if ([UIScreen mainScreen].bounds.size.height == 568) {  // iphone 4 inch
        val = 3 ;
    }else{
        val = 2.5 ;
    }
    
    CGPoint point = CGPointMake(0, textField.frame.origin.y - val * textField.frame.size.height);
    [myProfileScrollView setContentOffset:point animated:YES];
}


- (void) scrollVievEditingFinishedView:(UITextView*)textField{
    CGPoint point = CGPointMake(0, 0);
    [myProfileScrollView setContentOffset:point animated:YES];
}




- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == emailTextField) {
        [self scrollViewAdaptToStartEditingTextField:textField];
    }
    return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [self.view endEditing:YES];
    
    if (textField == emailTextField ) {
        [self scrollVievEditingFinished:textField];
    }
    
    
      if (textField == firstNameTextField) {
          [textField resignFirstResponder];
          [mobileTextField becomeFirstResponder];
   
      }
      else if (textField == mobileTextField)
      {
          [textField resignFirstResponder];
          [addressTextField becomeFirstResponder];
      }
    
    
    
    
    
    if (textField == oldPasswordTextField)
    {
        [textField resignFirstResponder];
        [newPasswordTextField becomeFirstResponder];
    }
    else if (textField == newPasswordTextField)
    {
        [textField resignFirstResponder];
        [confirmPasswordTextField becomeFirstResponder];
    }
    else if (textField == confirmPasswordTextField)
    {
        [textField resignFirstResponder];
        [self changePasswordSaveBtnClicked:nil];
        
    }

    
    return YES;
}

- (void) scrollViewAdaptToStartEditingTextField:(UITextField*)textField{
    float val;
    
    if ([UIScreen mainScreen].bounds.size.height == 568) {  // iphone 4 inch
        val = 3 ;
    }else{
        val = 2.5 ;
    }
    
    CGPoint point = CGPointMake(0, textField.frame.origin.y - val * textField.frame.size.height);
    [myProfileScrollView setContentOffset:point animated:YES];
}

- (void) scrollVievEditingFinished:(UITextField*)textField{
    CGPoint point = CGPointMake(0, 0);
    [myProfileScrollView setContentOffset:point animated:YES];
}







- (BOOL)validateEmailWithString:(NSString*)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    if ([[self.view subviews] count] > 0) {
        for (UIView *subView in self.view.subviews) {
            if ([subView isKindOfClass:[UIView class]]) {
                if (subView.tag == 401) {
                    [diabledview removeFromSuperview];
                    [self changePasswordSubView:nil];
                }else if(subView.tag == 501){
                     [subView removeFromSuperview];
                     [self loadCustomAlertSubView:alertMsg];
                    
                }else if (subView.tag == 700){
                    [disableCustomAlertView removeFromSuperview];
                    [self LoadCustomAlertWithMessage];
                }
            }
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
