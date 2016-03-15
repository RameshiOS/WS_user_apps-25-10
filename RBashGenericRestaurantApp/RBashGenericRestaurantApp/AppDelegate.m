//
//  AppDelegate.m
//  ThinkingCup
//
//  Created by Manulogix on 01/09/14.
//  Copyright (c) 2014 Manulogix. All rights reserved.
//

#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Fabric/Fabric.h>
#import <TwitterKit/TwitterKit.h>
#import <Crashlytics/Crashlytics.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    dbManager = [DataBaseManager dataBaseManager];
    
    [dbManager execute:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS 'OrderMaster'(ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,'rest_id' TEXT NOT NULL,'rest_location' TEXT NOT NULL,'menu_id' TEXT NOT NULL ,'coupon_code' TEXT NOT NULL ,'cust_id' TEXT NOT NULL ,'cust_name' TEXT,'card_number' TEXT,'txn_ref' TEXT,'sub_total' TEXT NOT NULL,'tax' TEXT NOT NULL ,'tip' TEXT,'total' TEXT,'status_id' TEXT,'created_on' TEXT NOT NULL,'type_id' TEXT,'type_name' TEXT NOT NULL,'order_id' TEXT NOT NULL,'order_itemName' TEXT NOT NULL,'rest_order_id' TEXT NOT NULL)", nil]];

    
    
    [dbManager execute:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS 'OrderDetails'(ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,'OrderID' TEXT NOT NULL,'CategoryName' TEXT NOT NULL,'ItemName' TEXT NOT NULL ,'ItemDescription' TEXT NOT NULL ,'ServingName' TEXT NOT NULL ,'Quantity' TEXT NOT NULL ,'ItemPrice' TEXT,'OptionsPrice' TEXT,'Instructions' TEXT,'ItemSalesTax' TEXT NOT NULL)", nil]];

    
    
    [dbManager execute:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS 'OrderModifier'(ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,'OrderDetailsID' TEXT NOT NULL,'ModifierName' TEXT NOT NULL,'OptionName' TEXT NOT NULL,'OptionPrice' TEXT NOT NULL)", nil]];

    [dbManager execute:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS 'OrderStatus'(ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,'OrderID' TEXT NOT NULL,'Status' TEXT NOT NULL)", nil]];

    
    
    [dbManager execute:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS 'LoginDetails'(ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,'UserName' TEXT NOT NULL , 'Password' TEXT, 'CustomerID' TEXT, 'Phone' TEXT, 'Email' TEXT, 'Address' TEXT)", nil]];

    
    
    
    // for saving menu in data base
    
    [dbManager execute:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS 'RestaurantMenuDetails'(ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,'RestaurantID' TEXT NOT NULL,'MenuID' TEXT NOT NULL , 'MenuName' TEXT, 'Tax' TEXT, 'UpdatedOn' TEXT,'MenuFilePath' TEXT NOT NULL)", nil]];

    
    
    if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"pgm_HeaderLandscape.png"] forBarMetrics:UIBarMetricsDefault];
    }else if(UIInterfaceOrientationIsPortrait(STATUSBAR_ORIENTATION)){
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"pgm_Header.png"] forBarMetrics:UIBarMetricsDefault];
    }
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }else{
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }

    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *appDefaults = [NSDictionary dictionaryWithObject:@"NO"
                                                            forKey:@"Debug_Comm"];
    [defaults registerDefaults:appDefaults];
    [defaults synchronize];
    
    [[Twitter sharedInstance] startWithConsumerKey:TWITTER_CONSUMER_KEY
                                    consumerSecret:TWITTER_CONSUMER_SECRET];
   // [Fabric with:@[TwitterKit]];
//    if ([RESTAURANT_NAME isEqualToString:@"Prospect Cafe & Pizzeria"]) {
//
//   // [Fabric with:@[TwitterKit, CrashlyticsKit,[Twitter sharedInstance]]];
//    }else{
//     [Fabric with:@[TwitterKit]];
//        [Fabric with:@[[Twitter sharedInstance]]];
//
// 
//    }
    [Fabric with:@[TwitterKit, CrashlyticsKit,[Twitter sharedInstance]]];
    
    
    return YES;
}


- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
  
    NSString *tempStr = [NSString stringWithFormat:@"%@",deviceToken];
    NSString *tempApnID = tempStr;
    tempApnID = [tempApnID substringFromIndex:1];
    tempApnID = [tempApnID substringToIndex:[tempApnID length]-1];
    [tempApnID stringByReplacingOccurrencesOfString:@" " withString:@""];

    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:tempApnID forKey:@"DeviceToken"];
    [defaults synchronize];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    [FAUtilities showAlert:@"Unable to connect aps-environment"];
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {

    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    
    NSDictionary *alertsDict = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    NSString *alertMsg = [alertsDict objectForKey:@"body"];
    customAlertTitle = @"Alert";
    
    NSString *customAlertString;
    NSString *orderStatus = [userInfo objectForKey:@"status"];
    NSString *orderIdStr = [userInfo objectForKey:@"order_id"];
    
   if (orderStatus !=nil) {
       customAlertTitle = [NSString stringWithFormat:@"Order %@",orderStatus];
   }
   
   
   customAlertString = @"";
   
   if ([orderStatus isEqualToString:@"accepted"]) {
       customAlertString = [NSString stringWithFormat:@"Your order has been accepted and your order id is %@ \n %@ ",orderIdStr,alertMsg];
   }else if ([orderStatus isEqualToString:@"cancelled"]){
       customAlertString = alertMsg;
   }
   
    customAlertMessage = customAlertString;
    buttons = 1;
    [self LoadCustomAlertWithMessage];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to resto re your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSMutableArray *itemsAry = [[NSMutableArray alloc]init];
    dbManager = [DataBaseManager dataBaseManager];
    [dbManager execute:[NSString stringWithFormat:@"SELECT * FROM OrderDetails"] resultsArray:itemsAry];
    
    if (itemsAry.count >0) {
        customAlertMessage = @"Your cart is not empty, items were added earlier, do you want to clear?";
        customAlertTitle = @"Alert";
        buttons = 2;
        [self LoadCustomAlertWithMessage];
    }
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 500) {
        if (buttonIndex ==0) {
            dbManager = [DataBaseManager dataBaseManager];
            NSString *cartQuery = [NSString stringWithFormat:@"DELETE FROM OrderDetails "];
            [dbManager execute:cartQuery];

            NSString *cartQuery1 = [NSString stringWithFormat:@"DELETE FROM OrderModifier "];
            [dbManager execute:cartQuery1];
           
            NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
            [defaults setObject:@"0.00" forKey:@"CurrentTipValue"];
            
        }
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

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    for (UIView *subView in [[[UIApplication sharedApplication] keyWindow] subviews]) {
        if (subView.tag == 700){
            [disableCustomAlertView removeFromSuperview];
            [self LoadCustomAlertWithMessage];
        }
    }
}

-(void)cancelCustomAlertSubViewBtnClicked:(id)sender{
    [disableCustomAlertView removeFromSuperview];
}

-(void)doneCustomAlertSubViewBtnClicked:(id)sender{
    
    [self cancelCustomAlertSubViewBtnClicked:nil];
    
    dbManager = [DataBaseManager dataBaseManager];
    NSString *cartQuery = [NSString stringWithFormat:@"DELETE FROM OrderDetails "];
    [dbManager execute:cartQuery];
    
    NSString *cartQuery1 = [NSString stringWithFormat:@"DELETE FROM OrderModifier "];
    [dbManager execute:cartQuery1];
    
    NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
    [defaults setObject:@"0.00" forKey:@"CurrentTipValue"];

}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    BOOL urlWasHandled =
    [FBAppCall handleOpenURL:url
           sourceApplication:sourceApplication
             fallbackHandler:
     ^(FBAppCall *call) {
         // Parse the incoming URL to look for a target_url parameter
         NSString *query = [url query];
         NSDictionary *params = [self parseURLParams:query];
         // Check if target URL exists
         NSString *appLinkDataString = [params valueForKey:@"al_applink_data"];
         if (appLinkDataString) {
             NSError *error = nil;
             NSDictionary *applinkData =
             [NSJSONSerialization JSONObjectWithData:[appLinkDataString dataUsingEncoding:NSUTF8StringEncoding]
                                             options:0
                                               error:&error];
             if (!error &&
                 [applinkData isKindOfClass:[NSDictionary class]] &&
                 applinkData[@"target_url"]) {
              //   self.refererAppLink = applinkData[@"referer_app_link"];
                 NSString *targetURLString = applinkData[@"target_url"];
                 // Show the incoming link in an alert
                 // Your code to direct the user to the
                 // appropriate flow within your app goes here
                 [[[UIAlertView alloc] initWithTitle:@"Received link:"
                                             message:targetURLString
                                            delegate:nil
                                   cancelButtonTitle:@"OK"
                                   otherButtonTitles:nil] show];
             }
         }
     }];
    
    return urlWasHandled;
}

// A function for parsing URL parameters
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val = [[kv objectAtIndex:1]
                         stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [params setObject:val forKey:[kv objectAtIndex:0]];
    }
    return params;
}

+ (BOOL)openActiveSessionWithReadPermissions:(NSArray*)readPermissions
                                allowLoginUI:(BOOL)allowLoginUI
                           completionHandler:(FBSessionStateHandler)handler
{
    return YES;
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    // Logs 'install' and 'app activate' App Events.
    [FBAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



@end
