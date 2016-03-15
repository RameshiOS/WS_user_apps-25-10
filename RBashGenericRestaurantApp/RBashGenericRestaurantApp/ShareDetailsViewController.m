//
//  ShareDetailsViewController.m
//  RBashGenericRestaurantApp
//
//  Created by Ramesh on 3/7/15.
//  Copyright (c) 2015 Manulogix. All rights reserved.
//

#import "ShareDetailsViewController.h"
#import "FAUtilities.h"
#import "DataBaseManager.h"
#import "LoginViewController.h"
#import "PlaceOrderViewController.h"
#import "SignUpViewController.h"
#import "DishDetailsViewController.h"

#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"
#import <TwitterKit/TwitterKit.h>
#import <Twitter/Twitter.h>
#import <Pinterest/Pinterest.h>

@interface ShareDetailsViewController ()
{
    NSString *itemDataLink;
    NSString *completeImagepath;
    Pinterest *pinterest;
}
@end

@implementation ShareDetailsViewController
@synthesize addToOrderBtn;
@synthesize itemDetailsDict;
@synthesize categeriName;


- (void)viewDidLoad {
    
    
    parentTempView = shareView;

    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    pinterest = [[Pinterest alloc]initWithClientId:PINTEREST_CLIENTID];

    if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
        headerView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"pgm_HeaderLandscape.png"]];
    }else if(UIInterfaceOrientationIsPortrait(STATUSBAR_ORIENTATION)){
        headerView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"pgm_Header.png"]];
        addToOrderSubView.backgroundColor=[FAUtilities getUIColorObjectFromHexString:ADD_TO_ORDER_VIEW_COLOR alpha:1.0];
    }
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        numberBtnFont =[UIFont fontWithName:@"Thonburi" size:38];
        dynamicLabelsFont = [UIFont fontWithName:@"Thonburi" size:30];
        addToCostSubView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"pgm_iPad_costLabel"]];
    }else{
        numberBtnFont =[UIFont fontWithName:@"Thonburi" size:26];
        dynamicLabelsFont = [UIFont fontWithName:@"Thonburi" size:20];
        addToCostSubView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"pgm_iPhone_costLabel.png"]];
    }
    
    itemImageVW.layer.borderColor=[[UIColor grayColor] CGColor];
    itemImageVW.layer.borderWidth=2.0;
    itemLabel.text = [itemDetailsDict objectForKey:@"name"];
    itemTextVw.text =[itemDetailsDict objectForKey:@"desc"];
    itemLabel.adjustsFontSizeToFitWidth=YES;
    [itemLabel setMinimumScaleFactor:12.0/[UIFont labelFontSize]];
    itemLabel.numberOfLines =0;
    
    NSString *itemImagePath = [itemDetailsDict objectForKey:@"item_image"];
    itemDataLink=[itemDetailsDict objectForKey:@"item_image_link"];
    
    completeImagepath = [NSString stringWithFormat:@"%@%@",REQ_URL,itemImagePath];
    
    itemImageVW.animationImages = [NSArray arrayWithObjects:
                                   [UIImage imageNamed:@"Loading_1.png"],
                                   [UIImage imageNamed:@"Loading_2.png"],
                                   [UIImage imageNamed:@"Loading_3.png"],
                                   [UIImage imageNamed:@"Loading_4.png"],
                                   [UIImage imageNamed:@"Loading_5.png"],
                                   [UIImage imageNamed:@"Loading_6.png"],
                                   [UIImage imageNamed:@"Loading_7.png"],
                                   [UIImage imageNamed:@"Loading_8.png"],
                                   [UIImage imageNamed:@"Loading_9.png"],
                                   [UIImage imageNamed:@"Loading_10.png"],
                                   [UIImage imageNamed:@"Loading_11.png"],nil];
    itemImageVW.animationDuration = 1.0f;
    itemImageVW.animationRepeatCount = 0;
    [itemImageVW startAnimating];
    
    itemSizes = [itemDetailsDict valueForKey:@"servings"];
    addToCostLabel.text= [NSString stringWithFormat:@"$%@",[[itemSizes objectAtIndex:0]objectForKey:@"price"]];
}

-(UIImage *)adjustImageSizeWhenCropping:(UIImage *)image{
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 1.0);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


-(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


-(void)borderForBottomLayer:(UIView *)view withHexColor:(NSString *)hexColor borderWidth:(int)width{
    CALayer *bottomLayer = [CALayer layer];
    bottomLayer.frame = CGRectMake(10, view.layer.frame.size.height - width, view.layer.frame.size.width-20, width);
    bottomLayer.backgroundColor = [[FAUtilities getUIColorObjectFromHexString:hexColor alpha:1]CGColor];
    [view.layer addSublayer:bottomLayer];
}


-(void)viewWillAppear:(BOOL)animated{
    shareView.hidden = YES;
    [self borderForBottomLayer:itemLabel withHexColor:@"D3D3D3" borderWidth:1];
    [self refreshCart];

    CGFloat imageViewWidth;
    CGFloat imageViewHeight = 0.0;
    
    CGFloat loadingVwWidth;
    CGFloat loadingVwHeight;
    
    CGFloat shareViewX;
    CGFloat shareViewY;
    
    
    NSString *shareImageName;
    NSString *fbImageName;

    NSString *twitterImageName;

    NSString *pinitImageName;

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
            imageViewWidth=1024;
            imageViewHeight=720;
              shareViewX=ShareDetailsScrollview.frame.size.width-100;
         

        }else if(UIInterfaceOrientationIsPortrait(STATUSBAR_ORIENTATION)){
            imageViewWidth=768;
            imageViewHeight=720;
            shareViewX=ShareDetailsScrollview.frame.size.width-100;
        }
        loadingVwWidth=200;
        loadingVwHeight=200;
        
        
        shareViewY=25;
        shareViewWidth=50;
        shareViewHeight=50;
        shareImageName=@"share";
        fbImageName=@"fb-icon";
        twitterImageName=@"Twitter-icon";
        pinitImageName=@"PinIt-icon";
        
        
    }else{
        imageViewWidth=320;
        imageViewHeight=300;
        loadingVwWidth=100;
        loadingVwHeight=100;
        
        shareViewX=imageViewWidth-50;
        shareViewY=5;
        
        shareViewWidth=35;
        shareViewHeight=35;
        shareImageName=@"share_iphone";
        fbImageName=@"fb_iphone";
        twitterImageName=@"Twitter_iphone";
        pinitImageName=@"PinIt_iphone";

    }
    

    UIImageView *imageVW;
    if (!itemImageView) {
        imageVW=[[UIImageView alloc]initWithFrame:CGRectMake(imageViewWidth/2-loadingVwWidth/2, imageViewHeight/2-loadingVwHeight/2, loadingVwWidth,loadingVwHeight)];
        imageVW.animationImages = [NSArray arrayWithObjects:
                                   [UIImage imageNamed:@"Loading_1.png"],
                                   [UIImage imageNamed:@"Loading_2.png"],
                                   [UIImage imageNamed:@"Loading_3.png"],
                                   [UIImage imageNamed:@"Loading_4.png"],
                                   [UIImage imageNamed:@"Loading_5.png"],
                                   [UIImage imageNamed:@"Loading_6.png"],
                                   [UIImage imageNamed:@"Loading_7.png"],
                                   [UIImage imageNamed:@"Loading_8.png"],
                                   [UIImage imageNamed:@"Loading_9.png"],
                                   [UIImage imageNamed:@"Loading_10.png"],
                                   [UIImage imageNamed:@"Loading_11.png"],nil];
        imageVW.animationDuration = 1.0f;
        imageVW.animationRepeatCount = 0;
        [imageVW startAnimating];
        [self.view addSubview:imageVW];
        
    }else{
        [imageVW stopAnimating];
        [imageVW removeFromSuperview];
    }
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        // the slow stuff to be done in the background
        
        
        
    NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:completeImagepath]];
        if (imgData) {
            UIImage *image = [UIImage imageWithData:imgData];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [itemImageVW stopAnimating];
                    
                    CGFloat picwidth=image.size.width;
                    CGFloat picHeight=image.size.height;
                    
                    
                    CGFloat widratio;
                    CGFloat heightratio;
                    CGFloat newImagewidth;
                    CGFloat newImageHeight;
                    
                    widratio = picwidth/imageViewWidth;
                    heightratio = picHeight/imageViewHeight;
                    
                    if ( imageViewWidth <= picwidth && imageViewHeight <= picHeight){
                       
                        
                        // picture is bigger than device
                        // now figure out if widh is bigger or hyt is bigger
                        
                        if (widratio >= heightratio ){
                            // use the hytRatio to reduce the width
                            newImagewidth = picwidth / widratio;
                            newImageHeight   = picHeight / widratio;
                        }else{
                            newImagewidth = picwidth / heightratio;
                            newImageHeight   = picHeight / heightratio;
                        }
                        
                    }else if ( picwidth <= imageViewWidth && picHeight <= imageViewHeight){
                        
                        //picturte height and width both low campare to device
                        // show the same image
                        // itemImageVW.image=image;
                        newImagewidth=picwidth;
                        newImageHeight=picHeight;
                        
                    }else if ( picwidth <=imageViewWidth && picHeight >= imageViewHeight){// portrait Picture
                        
                        newImagewidth = picwidth /heightratio;
                        newImageHeight = picHeight /heightratio;
                        
                        if (imageViewHeight <= newImageHeight) {
                            newImageHeight=imageViewHeight;
                        }
                    }else if ( picwidth > imageViewWidth && picHeight < imageViewHeight ){
                        newImagewidth = picwidth/widratio;
                        newImageHeight = picHeight/widratio;
                    }
 
                    CGFloat xAxis=(imageViewWidth-newImagewidth)/2;
                    if (imageViewWidth == 1024) {
                        xAxis=(ShareDetailsScrollview.frame.size.width-newImagewidth)/2;
                    }
                    
                
                   itemImageView=[[UIImageView alloc]initWithFrame:CGRectMake(xAxis, 0, newImagewidth, newImageHeight)];
                    itemImageView.image=image;

                    [imageVW stopAnimating];
                    [imageVW removeFromSuperview];
                    
                    [ShareDetailsScrollview addSubview:itemImageView];

                    
                    contentView = [[UIView alloc] initWithFrame:CGRectMake(shareViewX, shareViewY,shareViewWidth,shareViewHeight )];
                    [contentView setBackgroundColor:[UIColor whiteColor] ];
                    [contentView.layer setCornerRadius:6.];
                    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:shareImageName]];
                    [icon setTintColor:[FAUtilities getUIColorObjectFromHexString:APP_HEADER_COLOR alpha:1.0]];
                    
                    [icon setContentMode:UIViewContentModeScaleToFill];
                    [contentView addSubview:icon];

                    [ShareDetailsScrollview insertSubview:contentView aboveSubview:itemImageView];

                    if(stack){
                        [stack removeFromSuperview];
                    }
                    
                    stack = [[UPStackMenu alloc] initWithContentView:contentView];
                    [stack setDelegate:self];
                    

                    fbItem = [[UPStackMenuItem alloc] initWithImage:[UIImage imageNamed:fbImageName] highlightedImage:nil title:@""];
                    
                    UPStackMenuItem *twitterItem = [[UPStackMenuItem alloc] initWithImage:[UIImage imageNamed:twitterImageName] highlightedImage:nil title:@""];
 
                    
                   UPStackMenuItem *pinItItem = [[UPStackMenuItem alloc] initWithImage:[UIImage imageNamed:pinitImageName] highlightedImage:nil title:@""];

                    
                    NSMutableArray *items = [[NSMutableArray alloc] initWithObjects:fbItem, twitterItem, pinItItem, nil];
                    [items enumerateObjectsUsingBlock:^(UPStackMenuItem *item, NSUInteger idx, BOOL *stop) {
                        [item setTitleColor:[UIColor whiteColor]];
                    }];
                    
                    
                    
                    [stack setAnimationType:UPStackMenuAnimationType_linear];
                    [stack setStackPosition:UPStackMenuStackPosition_down];
                    [stack setOpenAnimationDuration:.3];
                    [stack setCloseAnimationDuration:.3];
                    
                    [items enumerateObjectsUsingBlock:^(UPStackMenuItem *item, NSUInteger idx, BOOL *stop) {
                        [item setLabelPosition:UPStackMenuItemLabelPosition_right];
                    }];
                    [stack addItems:items];
                    [ShareDetailsScrollview insertSubview:stack aboveSubview:itemImageView];
                    
                });
            }
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [itemImageVW stopAnimating];
            });
        }
    });
    
    [self performSelector:@selector(methodName) withObject:nil afterDelay:0.1];

}


#pragma mark - UPStackMenuDelegate

- (void)stackMenuWillOpen:(UPStackMenu *)menu{
    if([[contentView subviews] count] == 0)
        return;
}

- (void)stackMenuWillClose:(UPStackMenu *)menu{
    if([[contentView subviews] count] == 0)
        return;
}

- (void)stackMenu:(UPStackMenu *)menu didTouchItem:(UPStackMenuItem *)item atIndex:(NSUInteger)index{
   
    if (index == 0) {
        [self FbBtnClicked:nil];
    }else if (index == 1){
        [self twitterBtnClicked:nil];
    }else if (index == 2){
        [self pinItBtnClicked:nil];
    }
}


- (void)layoutIfNeeded{
    
}

-(void)methodName{
    ShareDetailsScrollview.contentSize = CGSizeMake(ShareDetailsScrollview.frame.size.width, itemTextVw.frame.origin.y+350);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cartBtnClicked:(id)sender {
    
    
    NSMutableArray *itemDetailsAry = [[NSMutableArray alloc]init];
    dbManager = [DataBaseManager dataBaseManager];
    [dbManager execute:[NSString stringWithFormat:@"SELECT * FROM OrderDetails "] resultsArray:itemDetailsAry];
    
    if (itemDetailsAry.count ==0) {
        customAlertMessage = @"Your Cart is empty";
        customAlertTitle = @"Alert";
        [self LoadCustomAlertWithMessage];
    }else{
        NSMutableArray *loginArray = [[NSMutableArray alloc]init];
        dbManager = [DataBaseManager dataBaseManager];
        [dbManager execute:[NSString stringWithFormat:@"SELECT * FROM LoginDetails "] resultsArray:loginArray];
        if (loginArray.count == 0) {
            NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
            [defaults setObject:@"OrderCartFromSharingVC" forKey:@"LoginParentView"];
            [defaults synchronize];
            LoginViewController *login = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            login.dishItemDetailsDict = itemDetailsDict;
            [self presentViewController:login animated:YES completion:nil];
        }else{
            NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
            [defaults setObject:@"DishDetailsView" forKey:@"PlaceOrderParentView"];
            [defaults synchronize];
            PlaceOrderViewController *placeOrder = [self.storyboard instantiateViewControllerWithIdentifier:@"PlaceOrderViewController"];
            [self presentViewController:placeOrder animated:YES completion:nil];
        }
    }

    
}

- (IBAction)addToOrderBtnClicked:(id)sender {
    
    NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
    [defaults setObject:@"SRTableView" forKey:@"DishDetailsParentView"];
    [defaults synchronize];
    
    DishDetailsViewController *selectItem = [self.storyboard instantiateViewControllerWithIdentifier:@"DishDetailsViewController"];
    selectItem.itemDetailsDict = itemDetailsDict;
    selectItem.catgName = categeriName;
    UIViewController *sourceViewController = (UIViewController*)self;
    
    CATransition* transition = [CATransition animation];
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromRight;

    [selectItem.view.layer addAnimation:transition forKey:kCATransition];
    [sourceViewController presentViewController:selectItem animated:NO completion:nil];
}


-(void)refreshCart{
    NSMutableArray *itemsAry = [[NSMutableArray alloc]init];
    dbManager = [DataBaseManager dataBaseManager];
    [dbManager execute:[NSString stringWithFormat:@"SELECT * FROM OrderDetails where Quantity > '0'"] resultsArray:itemsAry];
    countLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[itemsAry count]];
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
    
    UIView *customAlertView = [FAUtilities customAlert:customAlertTitle withStr:customAlertMessage withColor:APP_HEADER_COLOR withFrame:frame withNumberOfButtons:1 withOnlyCancelBtnMessage:@"Ok" WithCancelBtnMessage:@"" WithDoneBtnMessage:@""];
    
    
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


-(IBAction)backBtnClicked:(id)sender{
    [self performSegueWithIdentifier:@"DishImageToCustumTable" sender:self];
}


-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [self performSelector:@selector(methodName) withObject:nil afterDelay:0.1];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [self performSelector:@selector(methodName) withObject:nil afterDelay:0.1];
}


#pragma mark - FaceBook Integration methods


// A function for parsing URL parameters returned by the Feed Dialog.
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}



- (void)FbBtnClicked:(id)sender {
    
    NSUserDefaults *def=[[NSUserDefaults alloc]init];
    NSString *fbCaption=[def objectForKey:@"facebook_caption"];
    
    // Check if the Facebook app is installed and we can present the share dialog
    FBLinkShareParams *params = [[FBLinkShareParams alloc] init];
    // params.link = [NSURL URLWithString:@"http://test.restaurantbash.com/restaurant/deal/id/176"];r
    
    params.link=[NSURL URLWithString: [itemDetailsDict objectForKey:@"item_image_link"]];
    params.name= [itemDetailsDict objectForKey:@"name"];
    params.caption=fbCaption;
    
    
    NSURL *imageUrl=[NSURL URLWithString:completeImagepath];
    
    
    // If the Facebook app is installed and we can present the share dialog
    if ([FBDialogs canPresentShareDialogWithParams:params]) {
        
        
        
        // Present share dialog
        [FBDialogs presentShareDialogWithLink:params.link
                                         name: [itemDetailsDict objectForKey:@"name"]
                                      caption:params.caption
                                  description: [itemDetailsDict objectForKey:@"desc"]
                                      picture:imageUrl
                                  clientState:nil handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                             if(error) {
                                                 // An error occurred, we need to handle the error
                                                 // See: https://developers.facebook.com/docs/ios/errors
                                                 NSLog(@"Error publishing story: %@", error.description);
                                             } else {
                                                 // Success
                                                 NSLog(@"result %@", results);
                                                 NSLog(@"Parms through App  %@", params);
                                             }
                                         }];
        
        NSLog(@"fbCaption=== %@",fbCaption);
        
        
        
        // If the Facebook app is NOT installed and we can't present the share dialog
    } else {
        // FALLBACK: publish just a link using the Feed dialog
        
        // Put together the dialog parameters
        
  //
        NSHTTPCookie *cookie;
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (cookie in [storage cookies])
        {
            NSString* domainName = [cookie domain];
            NSRange domainRange = [domainName rangeOfString:@"facebook"];
            if(domainRange.length > 0)
            {
                [storage deleteCookie:cookie];
            }
        }
        
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       [itemDetailsDict objectForKey:@"name"], @"name",
                                       fbCaption, @"caption",
                                       [itemDetailsDict objectForKey:@"desc"], @"description",
                                        [itemDetailsDict objectForKey:@"item_image_link"], @"link",
                                       completeImagepath, @"picture",
                                       nil];

        // Show the feed dialog
        [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                               parameters:params
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      if (error) {
                                                          // An error occurred, we need to handle the error
                                                          // See: https://developers.facebook.com/docs/ios/errors
                                                          NSLog(@"Error publishing story: %@", error.description);
                                                      } else {
                                                          if (result == FBWebDialogResultDialogNotCompleted) {
                                                              // User canceled.
                                                              NSLog(@"User cancelled.");
                                                          } else {
                                                              // Handle the publish feed callback
                                                              NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                              
                                                              if (![urlParams valueForKey:@"post_id"]) {
                                                                  // User canceled.
                                                                  NSLog(@"User cancelled.");
                                                                  
                                                              } else {
                                                                  // User clicked the Share button
                                                                  NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                                  NSLog(@"result %@", result);
                                                                  NSLog(@"params %@", params);
                                                                  
                                                              }
                                                          }
                                                      }
                                                  }];
        
    }
}


- (IBAction)twitterBtnClicked:(id)sender {
    
    NSUserDefaults *def=[[NSUserDefaults alloc]init];
    NSString *appName=[def objectForKey:@"twitter_tag"];
    
    NSArray* words = [appName componentsSeparatedByCharactersInSet :[NSCharacterSet whitespaceAndNewlineCharacterSet]];
      NSString *restaurantName = [words componentsJoinedByString:@""];
    
    
    [[Twitter sharedInstance] logInWithCompletion:^
     (TWTRSession *session, NSError *error) {
         if (session) {
             if ([session userName]) {
                 if ([UIAlertView superclass]) {
                     UIAlertView *alert;
                     [alert removeFromSuperview];
                 }
             }
             TWTRComposer *composer = [[TWTRComposer alloc] init];
             
             
             [composer setText:[NSString stringWithFormat:@"%@ %@ .... Via @%@",[itemDetailsDict objectForKey:@"name"],itemDataLink,restaurantName]];
             [composer setImage:[UIImage imageNamed:completeImagepath]];
             [composer showWithCompletion:^(TWTRComposerResult result) {
                 
                 
                 
                 if (result == TWTRComposerResultCancelled) {
                     NSLog(@"Tweet composition cancelled");
                 }
                 else {
                     NSLog(@"Sending Tweet!");
                 }
             }];
             NSLog(@"signed in as %@", [session userName]);
         }else {
             NSLog(@"error: %@", [error localizedDescription]);
         }
     }];
}


- (IBAction)pinItBtnClicked:(id)sender {
    
    if ([pinterest canPinWithSDK ]) {
        [pinterest createPinWithImageURL:[NSURL URLWithString:completeImagepath]
                               sourceURL:[NSURL URLWithString:itemDataLink]
                             description:[itemDetailsDict objectForKey:@"name"]];
    }else{
        customAlertTitle=@"Pinterest";
        customAlertMessage=@"Need Pinterest app on your device for this sharing functionalty";
        [self LoadCustomAlertWithMessage];
    }
}




/*    [self performSegueWithIdentifier:@"DishToCustumTable" sender:self];

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
