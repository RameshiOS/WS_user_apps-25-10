
//
//  WebServiceInterface.m
//  DDMForms
//
//  Created by Manulogix on 19/07/13.
//  Copyright (c) 2013 Manulogix. All rights reserved.
//

#import "WebServiceInterface.h"
#import "ViewController.h"
//#import "WSLogin.h"
#import "SBJson.h"u
//#import "WSGetForm.h"
//#import "WSGetLookUp.h"
//#import "WSProfile.h"
//#import "WSSyncData.h"
//#import <QuartzCore/QuartzCore.h>
//#import "WSSyncDeletedData.h"
//#import "WSUploadDatabase.h"

@interface WebServiceInterface ()

@property(nonatomic, strong) UIViewController    *wsiParentVC;
@property(nonatomic, strong) MBProgressHUD       *wsiActivityIndicator;
@end

@implementation WebServiceInterface
@synthesize receivedData= _recievedData;
@synthesize delegate;
@synthesize wsiParentVC;
@synthesize wsiActivityIndicator;

#pragma mark -
#pragma mark init Methods
-(id) initWithVC: (UIViewController *)parentVC {
    self = [super init];
    if(self) {
        self.wsiParentVC = parentVC; // DO NOT allocate as we should point only
        //        self.delegate    = (id)parentVC; // DO NOT allocate as we should point only
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }return self;
}

#pragma mark -
#pragma mark Progress Bar Hud

#pragma mark - Indicator APIs

-(void) releaseActivityIndicator {
    if (wsiActivityIndicator) {
        [wsiActivityIndicator removeFromSuperview];
        //        RELEASE_MEM(wsiActivityIndicator);
    }
}
- (void) myTask {
	sleep(REQUEST_TIMEOUT_INTERVAL);
}

- (void) hideIndicator {
    [wsiActivityIndicator setHidden:YES];
}
- (void) showIndicator {
    [self releaseActivityIndicator];
    wsiActivityIndicator             = [[MBProgressHUD alloc] initWithView:wsiParentVC.view];
    wsiActivityIndicator.minShowTime = 30.0f;
    wsiActivityIndicator.delegate    = self;
    wsiActivityIndicator.labelText   = @"Loading...";
    [wsiParentVC.view addSubview:wsiActivityIndicator];
    [wsiActivityIndicator showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}

#pragma MBProgressHUD delegate methods
- (void) hudWasHidden:(MBProgressHUD *)hud {
	// Remove wsiActivityIndicator from screen when the wsiActivityIndicator was hidded
    [self releaseActivityIndicator];
}

#pragma mark -
#pragma mark Request Methods

-(void) sendRequest:(NSString *)postString PostJsonData:(NSData *)postData Req_Type:(NSString *)reqType Req_url:(NSString *)reqUrl{
    [self showIndicator];
    postReqString = postString;
    postReqData = postData;
    postReqType=reqType;
    postReqUrl = reqUrl;
    [self postRequest];
}

-(void)postRequest{
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postReqData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *poststring = [[NSString alloc]initWithData:postReqData encoding:NSUTF8StringEncoding];
    NSLog(@"postString : %@",poststring);
    NSLog(@"postReqUrl : %@",postReqUrl);

    NSString *posturl = [NSString stringWithFormat:@"%@",postReqUrl];
    
    [request setURL:[NSURL URLWithString:posturl]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postReqData];


    
    //HTTP Basic Authentication
//    NSString *authenticationString = [NSString stringWithFormat:@"%@:%@", username, password];
//    NSData *authenticationData = [authenticationString dataUsingEncoding:NSASCIIStringEncoding];
//    NSString *authenticationValue = [authenticationData base64EncodedStringWithOptions:0];
//
//    
//    [request setValue:[NSString stringWithFormat:@"Basic %@", authenticationValue] forHTTPHeaderField:@"Authorization"];

    
    //username and password value
    NSString *username = @"rbash";
    NSString *password = @"demo123";

    
    NSString *basicAuthCredentials = [NSString stringWithFormat:@"%@:%@", username, password];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", AFBase64EncodedStringFromString(basicAuthCredentials)];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];

    
    
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.connection = connection;
    [connection start];
  
}

/* this method might be calling more than one times according to incoming data size */
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    receivedData = data;
}

/* this method called to store cached response for this connection  */
- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

/* if there is an error occured, this method will be called by connection */
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [self hideIndicator];
    if (statusCode!=200) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"")
                                    message:[error localizedDescription]
                                   delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"OK", @"")
                          otherButtonTitles:nil] show];
    }
    NSLog(@"FailWithError %@" , error);
}

/* if data is successfully received, this method will be called by connection */
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{

    [NSThread sleepForTimeInterval:1.0];
 
    receivedData = [[NSMutableData alloc] init];
    NSHTTPURLResponse *httpResponse;
    httpResponse = (NSHTTPURLResponse *)response;
    statusCode = [httpResponse statusCode];
//    NSLog(@"Status code  %f", statusCode);
    if (statusCode == 200) {
        
    }else{
//        [FAUtilities showAlert:[NSString stringWithFormat:@"Status Code: %f: ",statusCode]];
//        [self hideIndicator];
    }
    
}

/* if data is finished loading, this method will be called by connection */
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    responseString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    NSLog(@"responseString %@" , responseString);

    if (statusCode != 200) {

//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        BOOL enabled = [defaults boolForKey:@"Debug_Comm"];
//
//        
//        NSLog(@"enabled %hhd",enabled);
//        
//        NSDate * now = [NSDate date];
//        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
//        [outputFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
//        NSString *newDateString = [outputFormatter stringFromDate:now];
//        NSLog(@"newDateString %@", newDateString);
//        
//        NSString *tempString = [NSString stringWithFormat:@"Date : %@ \n\n Request: %@ \n\n\n Status Code: %f \n\n\n  Response: %@",newDateString, postReqString,statusCode,responseString];
//        alertMsg = tempString;
//
//        
//        if (enabled == 1) {
//            NSDate * now = [NSDate date];
//            NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
//            [outputFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
//            NSString *newDateString = [outputFormatter stringFromDate:now];
//            NSLog(@"newDateString %@", newDateString);
//            
//            NSString *tempString = [NSString stringWithFormat:@"Date : %@ \n\n Request: %@ \n\n\n Status Code: %f \n\n\n  Response: %@",newDateString, postReqString,statusCode,responseString];
//            [self hideIndicator];
//            
//            
//            NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]init];
//            [tempDict setObject:tempString forKey:@"CommunicationAlert"];
//            
//            [delegate getResponse:tempDict type:postReqType];
//            
//        }else{
//            NSString *message = [NSString stringWithFormat:@"Sorry, your request was not able to be processed. Please click OK below, to send the information to the support team. For support, please call the restaurant at \n(781) 724-9366"];
//            
//            customAlertMessage = message;
//            customAlertTitle = @"Alert";
//            buttons = 1;
//            [self LoadCustomAlertWithMessage];
//            [self sendEmailInBackground:nil];
//            [self hideIndicator];
//        }

        
        
        NSLog(@"request type %@", postReqType);
        
        if ([postReqType isEqualToString:GET_RESTAURANT_LOCATION_COUNT_REQ_TYPE] || [postReqType isEqualToString:GET_RESTAURANT_LOCATIONS_REQ_TYPE]) {
           
            NSMutableDictionary *temDict = [[NSMutableDictionary alloc]init];
            
            
            NSMutableDictionary *statusDict = [[NSMutableDictionary alloc]init];
            [statusDict setObject:@"1" forKey:@"status"];
            [statusDict setObject:@"Success" forKey:@"statusDesc"];
            
            
            NSMutableDictionary *dataDict = [[NSMutableDictionary alloc]init];
            
            [dataDict setObject:@"1" forKey:@"count"];
            
            [dataDict setObject:SINGLE_RESTAURANT_ID forKey:@"rest_id"];

    
            
            [temDict setObject:statusDict forKey:@"Status"];
            [temDict setObject:dataDict forKey:@"Data"];
            
            
            [self sendResponse:temDict];

        }
        
        
    }else{
        if (IS_EMPTY(responseString) || [responseString isEqualToString:@"0"]) {
            [self hideIndicator];

        }else{
            [self doParse:receivedData];
        }
    }
}

-(void) sendEmailInBackground:(NSString *)user{
    NSLog(@"Start Sending Mail %@",user);
    
    // format it
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"MM-dd-YYYY"];
    // convert it to a string
    NSString *currentDateString = [dateFormat stringFromDate:date];
    NSLog(@"currentDate:%@",currentDateString);
    
//    SKPSMTPMessage *emailMessage = [[SKPSMTPMessage alloc] init];
//    emailMessage.relayHost = @"smtpout.secureserver.net";
//    emailMessage.requiresAuth = YES;
//    emailMessage.login = @"afsara@manulogix.com"; //sender email address
//    emailMessage.pass = @"afsara123"; //sender email password
//    emailMessage.wantsSecure = YES;
//    emailMessage.delegate = self;
//    emailMessage.fromEmail = @"test1@manulogix.com"; //sender email address
    
    SKPSMTPMessage *emailMessage = [[SKPSMTPMessage alloc] init];
    emailMessage.relayHost = @"smtpout.secureserver.net";
    emailMessage.requiresAuth = YES;
    emailMessage.login = @"test1@manulogix.com"; //sender email address
    emailMessage.pass = @"demo123"; //sender email password
    emailMessage.wantsSecure = YES;
    emailMessage.delegate = self;
    emailMessage.fromEmail = @"afsara@manulogix.com"; //sender email address

    
    NSString *messageBody;

    emailMessage.toEmail = @"rameshg@manulogix.com";  //receiver email address
    emailMessage.subject = @"Error From Fuel America";
//    messageBody= alertMsg;

    messageBody = @"test";
    
    NSDictionary *plainMsg = [NSDictionary  dictionaryWithObjectsAndKeys:@"text/plain",kSKPSMTPPartContentTypeKey,
                              messageBody,kSKPSMTPPartMessageKey,@"8bit",kSKPSMTPPartContentTransferEncodingKey,nil];
    emailMessage.parts = [NSArray arrayWithObjects:plainMsg,nil];
    [emailMessage send];
}


// On success
-(void)messageSent:(SKPSMTPMessage *)message{
    NSLog(@"delegate - message sent");
}

// On Failure
-(void)messageFailed:(SKPSMTPMessage *)message error:(NSError *)error{
    NSLog(@"Error %@", error);

    NSLog(@"message %@", message);
}



- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    
    for (UIView *subView in self.view.subviews) {
        if (subView.tag ==501) {
            [customView removeFromSuperview];
            [self loadCustomAlertSubView:alertMsg];
        }else if (subView.tag == 700){
            [disableCustomAlertView removeFromSuperview];
            [self LoadCustomAlertWithMessage];
        }
    }
}



-(void)loadCustomAlertSubView:(NSString *)message{
    
    customView = [[UIView alloc]init];
    customView.tag = 501;
    
    
    CGRect textViewFrame;
    CGRect cancelBtnFrame;
    CGRect emailBtnFrame;

    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
            customView.frame = CGRectMake(262, 159, 500, 450);
        }else if(UIInterfaceOrientationIsPortrait(STATUSBAR_ORIENTATION)){
            customView.frame = CGRectMake(134, 287-50, 500, 450);
        }
        
        textViewFrame = CGRectMake(20, 10, 460, 350);
        cancelBtnFrame = CGRectMake(140, 380, 100, 40);
        emailBtnFrame = CGRectMake(cancelBtnFrame.origin.x+cancelBtnFrame.size.width+10, 380, 100, 40);
        
    }else{
        if ([UIScreen mainScreen].bounds.size.height == 568) {  // iphone 4 inch
            customView.frame = CGRectMake(18, 98, 320-36, 250+4+50);
        }else{
            customView.frame = CGRectMake(18, 78, 320-36, 250+4+50);
        }

        textViewFrame = CGRectMake(10, 10, 264, 224);
        cancelBtnFrame = CGRectMake(70, 250, 70, 30);
        emailBtnFrame = CGRectMake(cancelBtnFrame.origin.x+cancelBtnFrame.size.width+5, 250, 70, 30);
        
    }
    
    

    customView.layer.borderColor = [[UIColor grayColor]CGColor];
    customView.layer.borderWidth = 2;
    customView.layer.cornerRadius = 6;
    
    customView.backgroundColor = [FAUtilities getUIColorObjectFromHexString:@"ECDDEC" alpha:1];
    
    UITextView *requestTextView = [[UITextView alloc]initWithFrame:textViewFrame];
    requestTextView.text = message;
    
    [customView addSubview:requestTextView];

    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:cancelBtnFrame];
    [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelBtn setTintColor:[UIColor blueColor]];

    [cancelBtn addTarget:self
               action:@selector(cancelBtn:)
     forControlEvents:UIControlEventTouchUpInside];

    
    
    [FAUtilities setBackgroundImagesForButton:cancelBtn];

    
    [customView addSubview:cancelBtn];

    
    UIButton *emailBtn = [[UIButton alloc]initWithFrame:emailBtnFrame];
    [emailBtn setTitle:@"Email" forState:UIControlStateNormal];
    [emailBtn setTintColor:[UIColor blueColor]];
    
    [emailBtn addTarget:self
                  action:@selector(emailBtn:)
        forControlEvents:UIControlEventTouchUpInside];
    
    
    [FAUtilities setBackgroundImagesForButton:emailBtn];

    [customView addSubview:emailBtn];

    
    [wsiParentVC.view addSubview:customView];
    
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
    [wsiParentVC presentViewController:mc animated:YES completion:NULL];
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
    [wsiParentVC dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark -
#pragma mark Response Methods
-(void)doParse:(NSData *)data{
    NSDictionary *responseDict;
    responseDict = [self parseJsonResponse:data];

    NSString *respResult = [responseDict valueForKey:@"ProcessRequestResult"];
    NSDictionary *tempResp = [respResult JSONValue];

    
//    if ([postReqType isEqualToString:LOGIN_TYPE] || [postReqType isEqualToString:FIND_DEALS_REQ_TYPE]) {
//        [self sendResponse:tempResp];
//    }else{
        [self sendResponse:responseDict];
//    }
}






-(NSDictionary *) parseJsonResponse:(NSData *)response{
    NSString *respStr;
    NSData *respData = [respStr dataUsingEncoding:NSUTF8StringEncoding];
    
    if ([postReqType isEqualToString:PLACE_ORDER_REQ_TYPE] || [postReqType isEqualToString:SIGN_UP_REQ_TYPE] || [postReqType isEqualToString:GET_MENU_REQ_TYPE] || [postReqType isEqualToString:GET_ORDERS_LIST_REQ_TYPE] || [postReqType isEqualToString:GET_ORDER_DETAILS_REQ_TYPE] || [postReqType isEqualToString:UPDATE_MY_PROFILE_REQ_TYPE] || [postReqType isEqualToString:LOGIN_REQ_TYPE] || [postReqType isEqualToString:GET_RESTAURANT_DETAILS_REQ_TYPE] || [postReqType isEqualToString:GET_REST_MENU_TYPE] || [postReqType isEqualToString:GET_RESTAURANT_LOCATION_COUNT_REQ_TYPE] || [postReqType isEqualToString:GET_RESTAURANT_LOCATIONS_REQ_TYPE] || [postReqType isEqualToString:GET_REST_TIMING_TYPE]) {
        respData = response;
    }
    
    
    NSDictionary *rspDic = [self getJSONObjectFromData:respData];
//    NSArray *rspAry = [self getJSONObjectFromData:respData];
    
    return rspDic;
}




// for fuelamericca: magalhaes@fuelamerica.us/Isabella1978*


-(id) getJSONObjectFromData:(NSData *)data {
    if ((!data) || ([data length] <=0)) return nil;
    
    if (SYSTEM_VERSION_LESS_THAN(@"6.0")) {
        //#if (__has_feature(objc_arc))
        NSString *dataInString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //#else
        //        NSString *dataInString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
        //#endif
        return [dataInString JSONValue];
    } else {
        return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    }
    return nil;
}


-(void) sendResponse:(NSDictionary *)respDict{
    [self hideIndicator];
    [delegate getResponse:respDict type:postReqType];
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
        disableCustomAlertViewFrame =  CGRectMake(0, 0, 320, 568);
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

    UIView *customAlertView = [FAUtilities customAlert:customAlertTitle withStr:customAlertMessage withColor:@"992d2d" withFrame:frame withNumberOfButtons:buttons withOnlyCancelBtnMessage:@"Ok" WithCancelBtnMessage:@"No" WithDoneBtnMessage:@"YES"];
    
    
    UIButton *onlyCancelBtn;
    UIButton *cancelBtn;
    UIButton *doneBtn;
    
    
    for (UIView *subview in [[[customAlertView subviews] objectAtIndex:0] subviews]){
        if([subview isKindOfClass:[UIButton class]]){
            if (subview.tag == 1001) {
                onlyCancelBtn = (UIButton *)subview;
                [onlyCancelBtn addTarget:self action:@selector(cancelCustomAlertSubViewBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                
            }else if (subview.tag == 1002) {
                cancelBtn = (UIButton *)subview;
                [cancelBtn addTarget:self action:@selector(cancelCustomAlertSubViewBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            }else if (subview.tag == 1003){
                doneBtn = (UIButton *)subview;
                [doneBtn addTarget:self action:@selector(doneCustomAlertSubViewBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                
            }
        }
    }
    
    [disableCustomAlertView addSubview:customAlertView];
    [[[UIApplication sharedApplication] keyWindow] addSubview:disableCustomAlertView];
}



-(void)cancelCustomAlertSubViewBtnClicked:(id)sender{
    [disableCustomAlertView removeFromSuperview];
}

-(void)doneCustomAlertSubViewBtnClicked:(id)sender{
}

- (void)viewDidLoad{
    [super viewDidLoad];
}




static NSString * AFBase64EncodedStringFromString(NSString *string) {
    NSData *data = [NSData dataWithBytes:[string UTF8String] length:[string lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    NSUInteger length = [data length];
    NSMutableData *mutableData = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    
    uint8_t *input = (uint8_t *)[data bytes];
    uint8_t *output = (uint8_t *)[mutableData mutableBytes];
    
    for (NSUInteger i = 0; i < length; i += 3) {
        NSUInteger value = 0;
        for (NSUInteger j = i; j < (i + 3); j++) {
            value <<= 8;
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        static uint8_t const kAFBase64EncodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
        
        NSUInteger idx = (i / 3) * 4;
        output[idx + 0] = kAFBase64EncodingTable[(value >> 18) & 0x3F];
        output[idx + 1] = kAFBase64EncodingTable[(value >> 12) & 0x3F];
        output[idx + 2] = (i + 1) < length ? kAFBase64EncodingTable[(value >> 6)  & 0x3F] : '=';
        output[idx + 3] = (i + 2) < length ? kAFBase64EncodingTable[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:mutableData encoding:NSASCIIStringEncoding];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
