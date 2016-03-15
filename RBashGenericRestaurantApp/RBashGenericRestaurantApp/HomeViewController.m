//
//  HomeViewController.m
//  ThinkingCup
//
//  Created by Manulogix on 01/09/14.
//  Copyright (c) 2014 Manulogix. All rights reserved.
//

#import "HomeViewController.h"
#import "SRExampleTableViewController.h"
#import "WebViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>
#import "SWRevealViewController.h"
#import "CustomTimeCell.h"
#import "SSZipArchive.h"
#import <Crashlytics/Crashlytics.h>


@interface HomeViewController ()
@property (nonatomic) IBOutlet UIBarButtonItem* revealButtonItem;
@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self postRequest:GET_RESTAURANT_DETAILS_REQ_TYPE];


    orderTypeStr = @"PickUp";
    restDetails = [[NSMutableDictionary alloc]init];

    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    [self.revealButtonItem setTarget: self.revealViewController];
    [self.revealButtonItem setAction: @selector( revealToggle: )];
    [self.navigationController.navigationBar addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];

    pickUrOrderSubView.layer.cornerRadius = 6;
    orderView.layer.cornerRadius = 6;

    
    float addressViewLayerBorderWidth;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        poweredByViewLayerBorderWidth = 1.5;
        addressViewLayerBorderWidth  = 2;
    }else{
        poweredByViewLayerBorderWidth = 0.2;
        addressViewLayerBorderWidth  = 0.5;
    }
    
    [FAUtilities borderForBottomLineLayer:restaurantAddressView withHexColor:APP_HEADER_COLOR borderWidth:addressViewLayerBorderWidth];

    
    anotherLocationBtn.backgroundColor = [FAUtilities getUIColorObjectFromHexString:APP_HEADER_COLOR alpha:1];
    anotherLocationBtn.alpha = 7;
    anotherLocationBtn.layer.cornerRadius = 4;
    anotherLocationBtn.layer.borderColor = [[FAUtilities getUIColorObjectFromHexString:APP_HEADER_COLOR alpha:1]CGColor];
    anotherLocationBtn.tintColor = [UIColor whiteColor];
    
}


-(void)viewWillAppear:(BOOL)animated{

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
            resLogo.hidden = YES;
            self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"pgm_ipad-Background-Landscape.png"]];
        }else if(UIInterfaceOrientationIsPortrait(STATUSBAR_ORIENTATION)){
            self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"pgm_ipad-Background-Potrait.png"]];
            resLogo.hidden = NO;
        }
    }else{
        if ([UIScreen mainScreen].bounds.size.height >= 568) {  // iphone 4 inch
            resLogo.hidden = NO;
            self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"pgm_iphone-Background-Potrait.png"]];
        }else{
            self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"pgm_iphone-Background-Potrait.png"]];
            resLogo.hidden = YES;
        }
    }
    
    
    if ([APP_NAME isEqualToString:@"Mario'sPizza"] || [APP_NAME isEqualToString:@"The Fours"]|| [APP_NAME isEqualToString:@"Prospect Cafe"] || [APP_NAME isEqualToString:@"Heav'nly Cafe & Catering"]) {
        orderDetailsLbl.textColor = [FAUtilities getUIColorObjectFromHexString:APP_HEADER_COLOR alpha:1];
        self.revealButtonItem.tintColor=[FAUtilities getUIColorObjectFromHexString:APP_HEADER_COLOR alpha:1.0];
    }else{
        orderDetailsLbl.textColor = [FAUtilities getUIColorObjectFromHexString:MENU_CELL_TEXT_COLOR alpha:1];
        self.revealButtonItem.tintColor=[FAUtilities getUIColorObjectFromHexString:MENU_CELL_TEXT_COLOR alpha:1.0];
    }
    
    //MENU_CELL_TEXT_COLOR

    for (UIView *subView in self.view.subviews) {
        if (subView.tag == 5003){
            [diabledview removeFromSuperview];
            [self loadMapSubView:@"Menu"];
        }
    }

    
    UIButton *poweredBtn=[[UIButton alloc]initWithFrame:CGRectMake(poweredByLinkView.frame.origin.x,0,poweredByLinkView.frame.size.width, poweredByLinkView.frame.size.height)];
   
   [poweredBtn setUserInteractionEnabled:YES];
    [poweredBtn addTarget:self action:@selector(poweredByViewBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
   [poweredByLinkView addSubview:poweredBtn];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    countStr=[defaults objectForKey:@"CountValue"];
    int count = [countStr intValue];
    
    
    if (count>1) {
        if (anotherLoctionView.hidden == YES) {
            anotherLoctionView.hidden=NO;
        }
        [FAUtilities borderForBottomLineLayer:anotherLoctionView withHexColor:MENU_CELL_TEXT_COLOR borderWidth:1.0f];
    }else{
        anotherLoctionView.hidden=YES;
    }
}


-(IBAction)nearAddressBtnClicked:(id)sender{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setValue:@"" forKey:@"Current_Location"];
    [self performSegueWithIdentifier:@"HomeViewToSelectLocations" sender:self];
}

-(IBAction)CurrentLoctionBtnClicked:(id)sender{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setValue:@"Current Location" forKey:@"Current_Location"];
    [self performSegueWithIdentifier:@"HomeViewToSelectLocations" sender:self];
}


-(IBAction)poweredByViewBtnClicked:(id)sender{
    NSString *powerdByLink = [NSString stringWithFormat:@"%@",REQ_URL];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"powerdByLink" forKey:@"ParentView"];
   
    WebViewController *webView = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
    webView.webUrlStr=powerdByLink;
    webView.headingLabelStr = @"RestaurantBash";
   
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:transition forKey:nil];
    
    [self presentViewController:webView animated:NO completion:nil];
}


-(IBAction)chooseItemBtn:(id)sender{
    if ([orderTypeStr isEqualToString:@"PickUp"]) {
        [self postRequest:GET_MENU_REQ_TYPE];
    }else if ([orderTypeStr isEqualToString:@"Delivery"]){
        [self loadDeliveryAddressSubView];
    }
//    if ([RESTAURANT_NAME isEqualToString:@"Prospect Cafe & Pizzeria"]) {
 //       [[Crashlytics sharedInstance] crash];
//    }
}


-(void)loadDeliveryAddressSubView{
    CGRect deliveryAddressSubViewFrame;
    
    CGRect headingViewPlaceholderFrame;
    CGRect headingViewFrame;
    CGRect headingLabelFrame;
    
    UIFont *headingLabelFont;
    UIFont *btnFonts;
    
    CGRect disableViewFrame;
    
    UIFont *boldFont;
    
    
    CGRect deliveryAddressFrame;
    CGRect deliveryNotesFrame;
    CGRect deliveryCityFrame;
    CGRect deliveryStateFrame;
    CGRect deliveryPinFrame;

    CGRect cancelBtnFrame;
    CGRect doneBtnFrame;
    
    UIFont *valuesFont;
    
    CGRect deliveryAddressUndelineLabelFrame;
    CGRect deliveryNotesUndelineLabelFrame;
    CGRect deliveryCityUndelineLabelFrame;
    CGRect deliveryStateUndelineLabelFrame;
    CGRect deliveryPinUndelineLabelFrame;
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        
        if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
            deliveryAddressSubViewFrame = CGRectMake(262, 159-60, 500, 500);
            disableViewFrame = CGRectMake(0, 0, 1024, 768);
        }else if(UIInterfaceOrientationIsPortrait(STATUSBAR_ORIENTATION)){
            deliveryAddressSubViewFrame = CGRectMake(134, 287-90, 500, 500);
            disableViewFrame = CGRectMake(0, 0, 768, 1024);
        }
        
        headingViewPlaceholderFrame = CGRectMake(0, 0, deliveryAddressSubViewFrame.size.width, 10);
        headingViewFrame = CGRectMake(0, 8, deliveryAddressSubViewFrame.size.width, 45);
        headingLabelFrame = CGRectMake(12, 0, headingViewFrame.size.width-24, 45);
        
        headingLabelFont = [UIFont fontWithName:@"Thonburi" size:32];
        
        btnFonts = [UIFont fontWithName:@"Verdana" size:30];
        
        
        
        deliveryAddressFrame = CGRectMake(10, headingViewFrame.origin.y + headingViewFrame.size.height +10, deliveryAddressSubViewFrame.size.width-20, 64);

        
        float cityWidth = (deliveryAddressSubViewFrame.size.width-20)/2-4;

        
        deliveryCityFrame = CGRectMake(10, deliveryAddressFrame.origin.y + deliveryAddressFrame.size.height +10, cityWidth, 64);
    
        deliveryStateFrame = CGRectMake(deliveryCityFrame.origin.x+deliveryCityFrame.size.width+6, deliveryAddressFrame.origin.y + deliveryAddressFrame.size.height +10, cityWidth, 64);

        deliveryPinFrame = CGRectMake(10, deliveryStateFrame.origin.y + deliveryStateFrame.size.height +10, deliveryAddressSubViewFrame.size.width-20, 64);

        deliveryNotesFrame = CGRectMake(10, deliveryPinFrame.origin.y + deliveryPinFrame.size.height +10, deliveryPinFrame.size.width-20, 64);

        
        cancelBtnFrame = CGRectMake(60, deliveryNotesFrame.origin.y + deliveryNotesFrame.size.height +30, 180, 60);
        
        doneBtnFrame = CGRectMake(cancelBtnFrame.origin.x+cancelBtnFrame.size.width+20, deliveryNotesFrame.origin.y + deliveryNotesFrame.size.height +30, 180, 60);
        
        boldFont = [UIFont fontWithName:@"Thonburi-Bold" size:26];
        valuesFont = [UIFont fontWithName:@"Thonburi" size:28];

        
        
        deliveryAddressUndelineLabelFrame = CGRectMake(deliveryAddressFrame.origin.x, deliveryAddressFrame.origin.y+38, deliveryAddressFrame.size.width, 24);
        
        deliveryNotesUndelineLabelFrame = CGRectMake(deliveryNotesFrame.origin.x, deliveryNotesFrame.origin.y+38, deliveryNotesFrame.size.width, 24);

        
        deliveryCityUndelineLabelFrame = CGRectMake(deliveryCityFrame.origin.x, deliveryCityFrame.origin.y+38, deliveryCityFrame.size.width, 24);
        deliveryStateUndelineLabelFrame= CGRectMake(deliveryStateFrame.origin.x, deliveryStateFrame.origin.y+38, deliveryStateFrame.size.width, 24);
        deliveryPinUndelineLabelFrame= CGRectMake(deliveryPinFrame.origin.x, deliveryPinFrame.origin.y+38, deliveryPinFrame.size.width, 24);
        
        
    }else{
        if ([UIScreen mainScreen].bounds.size.height == 568) {  // iphone 4 inch
            deliveryAddressSubViewFrame = CGRectMake(18, 98, 284, 304+50);
            
        }else{
            deliveryAddressSubViewFrame = CGRectMake(18, 78, 284, 304+50);
        }
        
        
        headingViewPlaceholderFrame = CGRectMake(0, 0, deliveryAddressSubViewFrame.size.width, 10);
        headingViewFrame = CGRectMake(0, 8, deliveryAddressSubViewFrame.size.width, 35);
        headingLabelFrame = CGRectMake(8, 0, headingViewFrame.size.width-16, 35);
        headingLabelFont = [UIFont fontWithName:@"Thonburi" size:24];
        
        btnFonts = [UIFont fontWithName:@"Verdana" size:22];
        valuesFont = [UIFont fontWithName:@"Thonburi" size:14];

        
        deliveryAddressFrame = CGRectMake(10, headingViewFrame.origin.y + headingViewFrame.size.height +10, deliveryAddressSubViewFrame.size.width-20, 40);
      
        float cityWidth = (deliveryAddressSubViewFrame.size.width-20)/2-4;
        
        deliveryCityFrame = CGRectMake(10, deliveryAddressFrame.origin.y + deliveryAddressFrame.size.height +10, cityWidth, 40);
        
        deliveryStateFrame = CGRectMake(deliveryCityFrame.origin.x+deliveryCityFrame.size.width+6, deliveryAddressFrame.origin.y + deliveryAddressFrame.size.height +10, cityWidth, 40);
        
        deliveryPinFrame = CGRectMake(10, deliveryStateFrame.origin.y + deliveryStateFrame.size.height +10, deliveryAddressSubViewFrame.size.width-20, 40);
        
        deliveryNotesFrame = CGRectMake(10, deliveryPinFrame.origin.y + deliveryPinFrame.size.height +10, deliveryAddressSubViewFrame.size.width-20, 40);

        
        cancelBtnFrame = CGRectMake(20, deliveryNotesFrame.origin.y + deliveryNotesFrame.size.height +30, 110, 40);
        
        doneBtnFrame = CGRectMake(cancelBtnFrame.origin.x+cancelBtnFrame.size.width+20, deliveryNotesFrame.origin.y + deliveryNotesFrame.size.height +30, 110, 40);
       
        deliveryAddressUndelineLabelFrame = CGRectMake(deliveryAddressFrame.origin.x, deliveryAddressFrame.origin.y+16, deliveryAddressFrame.size.width, 24);
        
        deliveryNotesUndelineLabelFrame = CGRectMake(deliveryNotesFrame.origin.x, deliveryNotesFrame.origin.y+16, deliveryNotesFrame.size.width, 24);
        
        deliveryCityUndelineLabelFrame = CGRectMake(deliveryCityFrame.origin.x, deliveryCityFrame.origin.y+16, deliveryCityFrame.size.width, 24);
        deliveryStateUndelineLabelFrame= CGRectMake(deliveryStateFrame.origin.x, deliveryStateFrame.origin.y+16, deliveryStateFrame.size.width, 24);
        deliveryPinUndelineLabelFrame= CGRectMake(deliveryPinFrame.origin.x, deliveryPinFrame.origin.y+16, deliveryPinFrame.size.width, 24);

        disableViewFrame = self.view.frame;
        boldFont = [UIFont fontWithName:@"Thonburi-Bold" size:20];
    }
    
    disabledview = [[UIView alloc]initWithFrame:disableViewFrame];
    disabledview.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pgm_gallery.png"]];
    disabledview.tag = 600;
  
    UIView *deliveryAddressSubView1 = [[UIView alloc]initWithFrame:deliveryAddressSubViewFrame];
    deliveryAddressSubView1.backgroundColor = [UIColor whiteColor];
    deliveryAddressSubView1.layer.cornerRadius = 8;
    
    deliveryAddressSubView = [[UIScrollView alloc]initWithFrame:CGRectMake(2, 2, deliveryAddressSubView1.frame.size.width-4, deliveryAddressSubView1.frame.size.height-4)];
    
    deliveryAddressSubView.backgroundColor = [FAUtilities getUIColorObjectFromHexString:@"EFF0F2" alpha:1];
    deliveryAddressSubView.layer.borderColor = [[UIColor grayColor]CGColor];
    deliveryAddressSubView.layer.borderWidth = 2;
    deliveryAddressSubView.layer.cornerRadius = 8;
    
    
    UIView *headingViewPlaceholder = [[UIView alloc]initWithFrame:headingViewPlaceholderFrame];
    headingViewPlaceholder.backgroundColor = [FAUtilities getUIColorObjectFromHexString:APP_HEADER_COLOR alpha:1];
    headingViewPlaceholder.layer.cornerRadius = 8;
    
    UIView *headingView = [[UIView alloc]initWithFrame:headingViewFrame];
    headingView.backgroundColor = [FAUtilities getUIColorObjectFromHexString:APP_HEADER_COLOR alpha:1];//1B3745
    
    UILabel *headingLabel = [[UILabel alloc]initWithFrame:headingLabelFrame];
    headingLabel.textColor = [UIColor whiteColor];
    headingLabel.text = @"Delivery Address";
    headingLabel.textAlignment = NSTextAlignmentCenter;
    
    headingLabel.font = headingLabelFont;
    
    deliveryAddressTextField = [[UITextField alloc]initWithFrame:deliveryAddressFrame];
    deliveryAddressTextField.placeholder = @"Address";
    deliveryAddressTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    deliveryAddressTextField.font = valuesFont;
    [deliveryAddressTextField setReturnKeyType:UIReturnKeyNext];
    deliveryAddressTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    deliveryAddressTextField.delegate=self;
    
    
    deliveryNotesTextField = [[UITextField alloc]initWithFrame:deliveryNotesFrame];
    deliveryNotesTextField.placeholder = @"Delivery Instructions";
    deliveryNotesTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    deliveryNotesTextField.font = valuesFont;
    deliveryNotesTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [deliveryNotesTextField setReturnKeyType:UIReturnKeyDone];
    deliveryNotesTextField.delegate = self;
    
    
    deliveryCityTextField = [[UITextField alloc]initWithFrame:deliveryCityFrame];
    deliveryCityTextField.placeholder = @"Boston";
    [deliveryCityTextField setReturnKeyType:UIReturnKeyNext];

    deliveryCityTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    deliveryCityTextField.font = valuesFont;
    deliveryCityTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    deliveryCityTextField.delegate = self;
    
    deliveryStateTextField = [[UITextField alloc]initWithFrame:deliveryStateFrame];
    deliveryStateTextField.placeholder = @"MA";
    [deliveryStateTextField setReturnKeyType:UIReturnKeyNext];

    deliveryStateTextField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    deliveryStateTextField.font = valuesFont;
    deliveryStateTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    deliveryStateTextField.delegate = self;
    
    deliveryPinTextField = [[UITextField alloc]initWithFrame:deliveryPinFrame];
    deliveryPinTextField.placeholder = @"Zip Code";
    [deliveryPinTextField setReturnKeyType:UIReturnKeyNext];

    deliveryPinTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    deliveryPinTextField.font = valuesFont;
    deliveryPinTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    deliveryPinTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    deliveryPinTextField.delegate = self;
    
    UILabel *deliveryAddressUndelineLabel = [[UILabel alloc]initWithFrame:deliveryAddressUndelineLabelFrame];
    UILabel *deliveryNotesUndelineLabel = [[UILabel alloc]initWithFrame:deliveryNotesUndelineLabelFrame];
    UILabel *deliveryCityUndelineLabel = [[UILabel alloc]initWithFrame:deliveryCityUndelineLabelFrame];
    UILabel *deliveryStateUndelineLabel = [[UILabel alloc]initWithFrame:deliveryStateUndelineLabelFrame];
    UILabel *deliveryPinUndelineLabel = [[UILabel alloc]initWithFrame:deliveryPinUndelineLabelFrame];
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        deliveryAddressUndelineLabel.text = @"_____________________________________________________";
        deliveryAddressUndelineLabel.textColor = [UIColor grayColor];
        
        deliveryNotesUndelineLabel.text = @"_____________________________________________________";
        deliveryNotesUndelineLabel.textColor = [UIColor grayColor];
        
        deliveryCityUndelineLabel.text = @"__________________________";
        deliveryCityUndelineLabel.textColor = [UIColor grayColor];
        
        deliveryStateUndelineLabel.text = @"__________________________";
        deliveryStateUndelineLabel.textColor = [UIColor grayColor];
       
        deliveryPinUndelineLabel.text = @"_____________________________________________________";
        deliveryPinUndelineLabel.textColor = [UIColor grayColor];

    }else{
        deliveryAddressUndelineLabel.text = @"______________________________";
        deliveryAddressUndelineLabel.textColor = [UIColor grayColor];
        
        deliveryNotesUndelineLabel.text = @"______________________________";
        deliveryNotesUndelineLabel.textColor = [UIColor grayColor];
        
        deliveryCityUndelineLabel.text = @"_____________";
        deliveryCityUndelineLabel.textColor = [UIColor grayColor];
        
        deliveryStateUndelineLabel.text = @"_____________";
        deliveryStateUndelineLabel.textColor = [UIColor grayColor];
        
        deliveryPinUndelineLabel.text = @"______________________________";
        deliveryPinUndelineLabel.textColor = [UIColor grayColor];

    }

    
    deliveryAddrSubViewCancelBtn = [[UIButton alloc]initWithFrame:cancelBtnFrame];
    [deliveryAddrSubViewCancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    [deliveryAddrSubViewCancelBtn addTarget:self action:@selector(deliveryAddrSubViewCancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [FAUtilities setBackgroundImagesForButton:deliveryAddrSubViewCancelBtn];

    deliveryAddrSubViewCancelBtn.titleLabel.font = btnFonts;


    
    deliveryAddrSubViewDoneBtn = [[UIButton alloc]initWithFrame:doneBtnFrame];
    [deliveryAddrSubViewDoneBtn setTitle:@"Done" forState:UIControlStateNormal];
    [deliveryAddrSubViewDoneBtn addTarget:self action:@selector(deliveryAddrSubViewDoneBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [FAUtilities setBackgroundImagesForButton:deliveryAddrSubViewDoneBtn];

    deliveryAddrSubViewDoneBtn.titleLabel.font = btnFonts;

    
    [deliveryAddressSubView addSubview:deliveryAddressTextField];
    [deliveryAddressSubView addSubview:deliveryNotesTextField];
    [deliveryAddressSubView addSubview:deliveryCityTextField];
    [deliveryAddressSubView addSubview:deliveryStateTextField];
    [deliveryAddressSubView addSubview:deliveryPinTextField];

    
    [deliveryAddressSubView addSubview:deliveryAddressUndelineLabel];
    [deliveryAddressSubView addSubview:deliveryNotesUndelineLabel];
    [deliveryAddressSubView addSubview:deliveryCityUndelineLabel];
    [deliveryAddressSubView addSubview:deliveryStateUndelineLabel];
    [deliveryAddressSubView addSubview:deliveryPinUndelineLabel];
  
    [deliveryAddressSubView addSubview:deliveryAddrSubViewCancelBtn];
    [deliveryAddressSubView addSubview:deliveryAddrSubViewDoneBtn];

    
    [headingView addSubview:headingLabel];
    [deliveryAddressSubView addSubview:headingView];
    
    [deliveryAddressSubView addSubview:headingViewPlaceholder];
    
    [deliveryAddressSubView1 addSubview:deliveryAddressSubView];
    [disabledview addSubview:deliveryAddressSubView1];
    [self.view addSubview:disabledview];
    
}



- (void) scrollViewAdaptToStartEditingAddressTextField:(UITextField*)textField{
    float val;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        val = 1;
    }else{
        if ([UIScreen mainScreen].bounds.size.height == 568) {  // iphone 4 inch
            val = 3;
        }else{
            val = 2;
        }
    }
    
    CGPoint point = CGPointMake(0, textField.frame.origin.y - val * textField.frame.size.height);
    [deliveryAddressSubView setContentOffset:point animated:YES];
}

- (void) scrollVievEditingAddressFinished:(UITextField*)textField{
    CGPoint point = CGPointMake(0, 0);
    [deliveryAddressSubView setContentOffset:point animated:YES];
}


- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == deliveryNotesTextField || textField == deliveryCityTextField || textField == deliveryStateTextField || textField ==  deliveryPinTextField) {
      
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
                if (textField == deliveryNotesTextField || textField ==deliveryCityTextField || textField ==  deliveryStateTextField || textField ==  deliveryPinTextField){
                    [self scrollViewAdaptToStartEditingAddressTextField:textField];
                }
            }else if(UIInterfaceOrientationIsPortrait(STATUSBAR_ORIENTATION)){
                
            }
        }else{
            if ([UIScreen mainScreen].bounds.size.height == 568) {  // iphone 4 inch
                if ( textField ==deliveryNotesTextField  || textField ==  deliveryPinTextField){
                    [self scrollViewAdaptToStartEditingAddressTextField:textField];
                }
            }else{
                if (textField ==deliveryNotesTextField || textField ==deliveryCityTextField || textField ==  deliveryStateTextField || textField ==  deliveryPinTextField){
                    [self scrollViewAdaptToStartEditingAddressTextField:textField];
                }
            }
            
        }
    }
  
    
    return YES;
}


- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField == deliveryNotesTextField || textField == deliveryCityTextField || textField == deliveryStateTextField || textField ==  deliveryPinTextField) {
        if ([UIScreen mainScreen].bounds.size.height == 568) {  // iphone 4 inch
            if (textField == deliveryCityTextField || textField == deliveryStateTextField || textField ==  deliveryPinTextField){
                [self scrollVievEditingAddressFinished:textField];
            }
        }else{
            if (textField == deliveryNotesTextField || textField == deliveryCityTextField || textField == deliveryStateTextField || textField ==  deliveryPinTextField){
                [self scrollVievEditingAddressFinished:textField];
            }
        }
        
    }
    
    
    if (textField == deliveryAddressTextField) {
        [textField resignFirstResponder];
        [deliveryCityTextField becomeFirstResponder];
        
    }else if (textField==deliveryCityTextField){
        [textField resignFirstResponder];
        [deliveryStateTextField becomeFirstResponder];
    }else if (textField==deliveryStateTextField){
        [textField resignFirstResponder];
        [deliveryPinTextField becomeFirstResponder];
    }else if (textField==deliveryPinTextField){
        [textField resignFirstResponder];
        [deliveryNotesTextField becomeFirstResponder];
    }else if (textField==deliveryNotesTextField){
        [textField resignFirstResponder];
        [self deliveryAddrSubViewDoneBtnClicked:nil];
    }
    
    return YES;
}




- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == deliveryPinTextField) {
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


-(void)deliveryAddrSubViewCancelBtnClicked:(id)sender{
    [disabledview removeFromSuperview];
}


-(void)deliveryAddrSubViewDoneBtnClicked:(id)sender{
    
    if (deliveryAddressTextField.text.length ==0) {
        customAlertMessage = @"Please enter address";
        customAlertTitle = @"Alert";
        [self LoadCustomAlertWithMessageinView:@""];
    }else if (deliveryCityTextField.text.length ==0){
        customAlertMessage = @"Please enter city";
        customAlertTitle = @"Alert";
        [self LoadCustomAlertWithMessageinView:@""];
    }else if (deliveryStateTextField.text.length ==0){
        customAlertMessage = @"Please enter state";
        customAlertTitle = @"Alert";
        [self LoadCustomAlertWithMessageinView:@""];
    }else if (deliveryPinTextField.text.length ==0){
        customAlertMessage = @"Please enter zip Code";
        customAlertTitle = @"Alert";
        [self LoadCustomAlertWithMessageinView:@""];
    }else{
        [self.view endEditing:YES];
        deliveryDataDict = [[NSMutableDictionary alloc]init];
        [deliveryDataDict setObject:deliveryAddressTextField.text forKey:@"DeliveryAddress"];
        [deliveryDataDict setObject:deliveryNotesTextField.text forKey:@"DeliveryNotes"];
        [deliveryDataDict setObject:deliveryCityTextField.text forKey:@"DeliveryCity"];
        [deliveryDataDict setObject:deliveryStateTextField.text forKey:@"DeliveryState"];
        [deliveryDataDict setObject:deliveryPinTextField.text forKey:@"DeliveryPin"];
        [self postRequest:GET_MENU_REQ_TYPE];//
    }
}


-(void)postRequest:(NSString *)reqType{
    NSString *finalReqUrl;
    if ([reqType isEqualToString:GET_MENU_REQ_TYPE]) {
        
        NSDate *now = [NSDate date];
        NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
        [defaults setObject:now forKey:@"RequestedTime"];
        [defaults synchronize];

        finalReqUrl = [NSString stringWithFormat:@"%@%@",REQ_URL,GET_MENU_REQ_URL];
    }else if([reqType isEqualToString:GET_RESTAURANT_DETAILS_REQ_TYPE]){
        finalReqUrl = [NSString stringWithFormat:@"%@%@",REQ_URL,GET_RESTAURANT_DETAILS_REQ_URL];
    }else if ([reqType isEqualToString:GET_REST_MENU_TYPE]) {
        finalReqUrl = [NSString stringWithFormat:@"%@%@",REQ_URL,GET_REST_MENU_URL];
    }else if ([reqType isEqualToString:GET_REST_TIMING_TYPE]) {
        finalReqUrl = [NSString stringWithFormat:@"%@%@",REQ_URL,GET_REST_TIMING_URL];
    }
    
    
    NSMutableDictionary *test = [[NSMutableDictionary alloc]init];
    NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
    NSString *resID = [defaults objectForKey:@"RestaurantID"];
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
    NSString *bodyStr;
    
    if ([type isEqualToString:GET_MENU_REQ_TYPE]) {
        
        NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
        
        NSMutableArray *restaurntMenuDetailsAry = [[NSMutableArray alloc]init];
        dbManager = [DataBaseManager dataBaseManager];
        [dbManager execute:[NSString stringWithFormat:@"SELECT * FROM RestaurantMenuDetails Where RestaurantID = %@",[defaults objectForKey:@"RestaurantID"]] resultsArray:restaurntMenuDetailsAry];
        
        if ([restaurntMenuDetailsAry count] == 0) {
            localUpdatedOnstr = @"-1";
        }else{
            NSDictionary *tempDict = [restaurntMenuDetailsAry objectAtIndex:0];
            localUpdatedOnstr = [tempDict objectForKey:@"UpdatedOn"];
        }
        
        if ([orderTypeStr isEqualToString:@"Delivery"]) {
            
            NSLog(@"restaurantDetailsDict %@",restaurantDetailsDict);
            NSString *radius = [restaurantDetailsDict objectForKey:@"delivery_radius"];
            
            NSString *deliveryAddress = [NSString stringWithFormat:@"%@, %@, %@, %@",[deliveryDataDict objectForKey:@"DeliveryAddress"],[deliveryDataDict objectForKey:@"DeliveryCity"],[deliveryDataDict objectForKey:@"DeliveryState"],[deliveryDataDict objectForKey:@"DeliveryPin"]];

            NSString *deliveryNotes = [deliveryDataDict objectForKey:@"DeliveryNotes"];
            
            radius = [FAUtilities formatJSONStr:radius];
            deliveryAddress = [FAUtilities formatJSONStr:deliveryAddress];
            deliveryNotes = [FAUtilities formatJSONStr:deliveryNotes];
            
            bodyStr = [NSString stringWithFormat: @"{\"rest_id\":\"%@\",\"updated_on\":\"%@\",\"order_type\":\"%@\",\"radius\":\"%@\",\"deliveryAddress\":\"%@\",\"deliveryInstructions\":\"%@\",\"is_zip\":\"%@\"}",[formatDict objectForKey:@"RestaurantID"],localUpdatedOnstr,@"delivery",radius,deliveryAddress,deliveryNotes,IS_MENU_READ_AS_ZIP_FILE];
        }else{
            bodyStr =[NSString stringWithFormat: @"{\"rest_id\":\"%@\",\"updated_on\":\"%@\",\"is_zip\":\"%@\"}",[formatDict objectForKey:@"RestaurantID"],localUpdatedOnstr,IS_MENU_READ_AS_ZIP_FILE];
        }
        
    }else if ([type isEqualToString:GET_RESTAURANT_DETAILS_REQ_TYPE]){
        bodyStr =[NSString stringWithFormat: @"{\"rest_id\":\"%@\"}",[formatDict objectForKey:@"RestaurantID"]];
    }else if ([type isEqualToString:GET_REST_MENU_TYPE]){
        bodyStr =[NSString stringWithFormat: @"{\"id\":\"%@\"}",[formatDict objectForKey:@"RestaurantID"]];
    }
    else if ([type isEqualToString:GET_REST_TIMING_TYPE]){
        bodyStr =[NSString stringWithFormat: @"{\"rest_id\":\"%@\"}",[formatDict objectForKey:@"RestaurantID"]];
    }
    
    return bodyStr;
}

-(void)getResponse:(NSDictionary *)resp type:(NSString *)respType{
    
    if ([respType isEqualToString:GET_MENU_REQ_TYPE]) {
        NSDictionary *statusDict = [resp objectForKey:@"Status"];
        NSString *status = [NSString stringWithFormat:@"%@",[statusDict objectForKey:@"status"]];
        NSString *statusDesc = [statusDict objectForKey:@"desc"];
        
        NSDictionary *resposneDataMenuDict;
        
        if ([status isEqualToString:@"1"]) {
            resposneDataMenuDict  = resp;

            NSArray *menuAry = [[resposneDataMenuDict objectForKey:@"Data"] objectForKey:@"menus"];
            NSDictionary *TagsDic=[[resposneDataMenuDict objectForKey:@"Data"] objectForKey:@"profile"];
            NSString *twitterTag = [TagsDic objectForKey:@"twitter_tag"];
            NSString *fbCaption = [TagsDic objectForKey:@"facebook_caption"];
            
            NSString *facebookAppId = [TagsDic objectForKey:@"facebook_app_id"];
            
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            [defaults setObject:twitterTag forKey:@"twitter_tag"];
            [defaults setObject:facebookAppId forKey:@"facebook_app_id"];
            [defaults setObject:fbCaption forKey:@"facebook_caption"];
            
            NSDictionary *deliveryDic=[[resposneDataMenuDict objectForKey:@"Data"] objectForKey:@"delivery_charge"];
            NSString *deliveryChargeStr = [deliveryDic objectForKey:@"delivery_fee"];
            NSString *minCartAmount = [deliveryDic objectForKey:@"min_cart_amount"];

            [defaults setObject:deliveryChargeStr forKey:@"delivery_fee"];
            [defaults setObject:minCartAmount forKey:@"min_cart_amount"];            // for min delivery fee


            
            if (menuAry.count ==0) {
                customAlertMessage = @"No menus found";
                customAlertTitle = @"Alert";
                [self LoadCustomAlertWithMessageinView:@""];
            }else{
                NSString *salesTax = [[menuAry objectAtIndex:0] objectForKey:@"tax"];
                NSString *menuID = [[menuAry objectAtIndex:0] objectForKey:@"id"];
                NSString *menuName = [[menuAry objectAtIndex:0] objectForKey:@"name"];
                NSString *updatedTime = [[menuAry objectAtIndex:0] objectForKey:@"updated_on"];
                NSArray *catArray;
                
                if ([[[menuAry objectAtIndex:0] allKeys] containsObject:@"zip_data"]) {
                    NSDictionary *zipDataDict = [[menuAry objectAtIndex:0] objectForKey:@"zip_data"];
                    NSString *webStringURL = [NSString stringWithFormat:@"%@%@",REQ_URL,[zipDataDict objectForKey:@"url"]];
                    NSArray *ary = [[zipDataDict objectForKey:@"url"] componentsSeparatedByString:@"/"];
                    NSString *lastObject = [ary lastObject];
                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *documentsDirectory = [paths objectAtIndex:0];
                    NSString *storePath = [documentsDirectory stringByAppendingPathComponent:@"RbashUser"];
                    NSString *fileSavePath = [storePath stringByAppendingPathComponent:lastObject];
                    
                    [[NSData dataWithContentsOfURL:[NSURL URLWithString:webStringURL]] writeToFile:fileSavePath atomically:YES];
                    
                    NSString *fileName = [lastObject stringByReplacingOccurrencesOfString:@".zip" withString:@""];
                    NSString *destinationFile = [storePath stringByAppendingPathComponent:fileName];
                    
                    // Unzipping
                    [SSZipArchive unzipFileAtPath:fileSavePath toDestination:storePath];
                    
                    NSString *dataFilePath = [NSString stringWithFormat:@"%@.txt",destinationFile];
                    NSData *JSONData = [NSData dataWithContentsOfFile:dataFilePath];
                    
                    NSError* error;
                    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:JSONData
                                                                         options:kNilOptions
                                                                           error:&error];
                    
                    catArray = [json objectForKey:@"categories"];
                    
                }else{
                    catArray = [[menuAry objectAtIndex:0] objectForKey:@"categories"];
                }
                
                dbManager = [DataBaseManager dataBaseManager];

                NSMutableArray *menuDetailsAry = [[NSMutableArray alloc]init];
                [dbManager execute:[NSString stringWithFormat:@"SELECT * FROM RestaurantMenuDetails Where MenuID = %@",menuID] resultsArray:menuDetailsAry];
                
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                NSString *storePath = [documentsDirectory stringByAppendingPathComponent:@"RbashUser"];

                NSString *fileDestinationUrl = [storePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt",menuID]];
                
                if ([menuDetailsAry  count] == 0) {
                    [dbManager execute:[NSString stringWithFormat: @"INSERT INTO 'RestaurantMenuDetails' (RestaurantID,MenuID,MenuName,Tax,UpdatedOn,MenuFilePath)VALUES ('%@','%@','%@', '%@','%@','%@')",[defaults objectForKey:@"RestaurantID"],menuID,menuName,salesTax,updatedTime,fileDestinationUrl]];
                    [catArray writeToFile:fileDestinationUrl atomically:YES];
                }else{
                    [dbManager execute:[NSString stringWithFormat:@"Update RestaurantMenuDetails set MenuName='%@',Tax='%@',UpdatedOn='%@' where MenuID = '%@'",menuName,salesTax,updatedTime,menuID]];
                    
                    [catArray writeToFile:fileDestinationUrl atomically:YES];
                }
                
                if (catArray.count ==0) {
                    
                    if ([localUpdatedOnstr isEqualToString:updatedTime]) {
                        NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
                        if ([salesTax isEqual:NULL] || [salesTax isEqual:[NSNull null]]) {
                            [defaults setObject:@"0.00" forKey:@"salestax"];
                        }else{
                            [defaults setObject:salesTax forKey:@"salestax"];
                        }
                        
                        [defaults setObject:menuID forKey:@"MenuID"];
                        [defaults setObject:orderTypeStr forKey:@"OrderType"];
                        [defaults setObject:deliveryDataDict forKey:@"OrderTypeDeliveryDetails"];
                        
                        [defaults setObject:@"LoadFromDB" forKey:@"LoadMenus"];
                        
                        [defaults synchronize];
                        [self performSegueWithIdentifier:@"SegueHomeToItems" sender:self];
                        
                    }else{
                        customAlertMessage = @"No menus found";
                        customAlertTitle = @"Alert";
                        [self LoadCustomAlertWithMessageinView:@""];
                    }
                }else{
                   
                    NSMutableArray *labelArray = [[NSMutableArray alloc]init];
                    NSMutableArray *contentItemsAry = [[NSMutableArray alloc]init];

                    for (int i=0; i<[catArray count]; i++) {
                        
                        NSDictionary *currentCategoryDict = [catArray objectAtIndex:i];
                        NSArray *itemsArray = [[NSArray alloc]init];
                        itemsArray = [currentCategoryDict objectForKey:@"items"];
                        [contentItemsAry addObject:itemsArray];
                        
                        NSMutableDictionary *tempCatDict = [[NSMutableDictionary alloc]init];
                        [tempCatDict setObject:[currentCategoryDict objectForKey:@"name"] forKey:@"name"];
                        [tempCatDict setObject:[NSString stringWithFormat:@"%lu",(unsigned long)[itemsArray count]] forKey:@"CategoryCount"];
                        [labelArray addObject:tempCatDict];

                    }
                    
                    
                    NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
                    [defaults setObject:labelArray forKey:@"LabelsAry"];
                    [defaults setObject:contentItemsAry forKey:@"ContentItemsArray"];

                    if ([salesTax isEqual:NULL] || [salesTax isEqual:[NSNull null]]) {
                        [defaults setObject:@"0.00" forKey:@"salestax"];
                    }else{
                        [defaults setObject:salesTax forKey:@"salestax"];
                    }
                    
                    [defaults setObject:menuID forKey:@"MenuID"];
                    [defaults setObject:orderTypeStr forKey:@"OrderType"];
                    [defaults setObject:deliveryDataDict forKey:@"OrderTypeDeliveryDetails"];
                    [defaults synchronize];
                    [defaults setObject:@"LoadFromDefaults" forKey:@"LoadMenus"];
                    [self performSegueWithIdentifier:@"SegueHomeToItems" sender:self];
                }
            }

        }else{
            NSString *communicationStr = [resp objectForKey:@"CommunicationAlert"];
            alertMsg = communicationStr;
            if (communicationStr.length == 0) {
                if ([statusDesc rangeOfString:@"unable to deliver"].location!=NSNotFound){
                    NSString *msgStr = @"Unfortunately, we dont have a delivery to that address. You can change this order to PICKUP or provide a different delivery location.";
                    [self deliveryAddrSubViewCancelBtnClicked:nil];
                    customAlertMessage = msgStr;
                    customAlertTitle = @"SORRY!";
                    [self postRequest:GET_REST_TIMING_TYPE];

                    [self LoadCustomAlertWithMessageinView:@""];
                }else{
                    
                    NSString *menuStr = [NSString stringWithFormat:@"%@",[[resp objectForKey:@"Status"] objectForKey:@"menu"]];
                    
                    customAlertMessage = statusDesc;
                    customAlertTitle = @"Restaurant Operating Hours";
                    [self postRequest:GET_REST_TIMING_TYPE];
                    timingsDic=[[resp objectForKey:@"Status"] objectForKey:@"timings"];

                    if ([menuStr isEqualToString:@"1"]) {
                        [self postRequest:GET_REST_MENU_TYPE];
                    }else{
                        [self LoadCustomAlertWithMessageinView:@""];
                    }
                }
                
            }else{
                [self loadCustomAlertSubView:alertMsg];
            }
        }
        
        NSDate *recivedResp = [NSDate date];
        NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
        [defaults setObject:recivedResp forKey:@"ResponseRecivedTime"];
        [defaults synchronize];
        
    }else if ([respType isEqualToString:GET_RESTAURANT_DETAILS_REQ_TYPE]){
        NSDictionary *statusDict = [resp objectForKey:@"Status"];
        NSString *status = [NSString stringWithFormat:@"%@",[statusDict objectForKey:@"status"]];
        NSString *statusDesc = [statusDict objectForKey:@"desc"];

        if ([status isEqualToString:@"1"]) {
        
            restaurantDetailsDict = [resp objectForKey:@"Data"];
            NSString *deliveryRadius = [restaurantDetailsDict objectForKey:@"delivery_radius"];
            
            int  normalAttributesFont;
            
            if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
                 normalAttributesFont = 20;
            }else{
                normalAttributesFont = 14;
            }

            phoneNumLabel.text=[restaurantDetailsDict objectForKey:@"phone"];
            phoneNumLabel.numberOfLines=0;

            
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            countStr=[defaults objectForKey:@"CountValue"];
            NSString *fromTimeStr;
            NSString *toTimeStr;
            
            NSDictionary *timngsDic=[restaurantDetailsDict objectForKey:@"pickup_timings"];
            
            if ([timngsDic isEqual:nil] || [timngsDic count]==0 || timngsDic == nil) {
                todayHoursLabel.hidden=YES;
            }else{
                fromTimeStr=[timngsDic objectForKey:@"from_time"];
                toTimeStr=[timngsDic objectForKey:@"to_time"];
                
                if ([fromTimeStr isEqual:[NSNull null]] || [toTimeStr isEqual:[NSNull null]]) {
                    todayHoursLabel.hidden=YES;
                }else{
                    todayHoursLabel.hidden=NO;
                    todayHoursLabel.text=[NSString stringWithFormat:@"Today's Hours %@ - %@",fromTimeStr,toTimeStr];
                }
            }
            
            
            restaurantAddress = [NSMutableString stringWithFormat:@"%@\n%@ %@ %@ ",[restaurantDetailsDict objectForKey:@"address"],[restaurantDetailsDict objectForKey:@"city"],[restaurantDetailsDict objectForKey:@"state"],[restaurantDetailsDict objectForKey:@"zip"]];
            
            NSString *resName=[restaurantDetailsDict objectForKey:@"res_name"];

            NSUserDefaults *def=[[NSUserDefaults alloc]init];
            [def setObject:resName forKey:@"RestaurantName"];
            [def setObject:restaurantAddress forKey:@"RestaurantAddress"];
            restaurantAddrLabel.text=restaurantAddress;
         
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                [restaurantAddrLabel setMinimumScaleFactor:12.0/[UIFont labelFontSize]];
                [todayHoursLabel setMinimumScaleFactor:7.0/[UIFont labelFontSize]];
            }
 
            restaurantName.text = resName;

            if ([deliveryRadius  floatValue] <= 0.00) {
                pickUpZeroRad.hidden = NO;
                pickUpBtn.hidden = YES;
                deliveryBtn.hidden = YES;
                orderView.hidden=YES;
            }else{
                pickUpZeroRad.hidden = YES;
                pickUpBtn.hidden = NO;
                deliveryBtn.hidden = NO;
                orderView.hidden=NO;
                [pickUpBtn setBackgroundImage:[UIImage imageNamed:@"pgm_pickUpBtn.png"] forState:UIControlStateNormal];
            }
            
        }else{
            customAlertMessage = statusDesc;
            customAlertTitle = @"Alert";
            [self LoadCustomAlertWithMessageinView:@""];
        }
        
    }else if ([respType isEqualToString:GET_REST_MENU_TYPE]) {
       
        NSDictionary *statusDict = [resp objectForKey:@"Status"];
        NSString *status = [statusDict objectForKey:@"status"];
        NSString *statusDesc = [statusDict objectForKey:@"desc"];
        if ([status isEqualToString:@"1"]) {
            restaurantMenuArray = [resp objectForKey:@"Data"];
            if (restaurantMenuArray.count >0) {
                [self LoadCustomAlertWithMessageinView:@"CurrentView"];
            }else{
                [FAUtilities showAlert:@"No menus available"];
            }
        }else if ([status isEqualToString:@"0"]){
            [FAUtilities showAlert:statusDesc];
        }

    }else if ([respType isEqualToString:GET_REST_TIMING_TYPE]){
        pickUpTimingsArray  =[[NSArray alloc]init];
        deliveryTimingsArray=[[NSArray alloc]init];
        timingDic=[[NSMutableDictionary alloc]init];
        timingDic = [resp objectForKey:@"Data"];
        
    
        pickUpTimingsArray=    [timingDic objectForKey:@"pickup_time"];//pickup_time
        deliveryTimingsArray=    [timingDic objectForKey:@"delivery_time"];//delivery Time
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
    
    NSString *emailTitle = @"Error from fuel america";
    NSString *messageBody = alertMsg;
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
}


- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
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

-(IBAction)pickUpBtnClicked:(id)sender{
    
    [pickUpBtn setBackgroundImage:[UIImage imageNamed:@"pgm_pickUpBtn.png"] forState:UIControlStateNormal];
    [pickUpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    orderTypeStr = @"PickUp";
    pickUpASAPLabe.text=@"Pick-up Your Order";
    [deliveryBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [deliveryBtn setBackgroundColor:[UIColor clearColor]];
    [deliveryBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
}

-(IBAction)deliveryBtnClicked:(id)sender{

    [deliveryBtn setBackgroundImage:[UIImage imageNamed:@"pgm_deliveryBtn.png"] forState:UIControlStateNormal];
    [deliveryBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    orderTypeStr = @"Delivery";
    pickUpASAPLabe.text=@"Your Order Will Be Delivered";
    
    [pickUpBtn setBackgroundColor:[UIColor clearColor]];
    [pickUpBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [pickUpBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
}


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    return NO;
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        
        [popoverController dismissPopoverAnimated:YES];

        if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
            resLogo.hidden = NO;
        }else if(UIInterfaceOrientationIsPortrait(STATUSBAR_ORIENTATION)){
            resLogo.hidden = YES;
        }
    }
}





- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
       
        if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
            resLogo.hidden = YES;
            self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"pgm_ipad-Background-Landscape.png"]];
        }else if(UIInterfaceOrientationIsPortrait(STATUSBAR_ORIENTATION)){
            resLogo.hidden = NO;
            self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"pgm_ipad-Background-Potrait.png"]];
        }
        
        CGRect popoverRect = [self.view convertRect:[seeHoursBtn frame] fromView:[seeHoursBtn superview]];
        popoverRect.size.width = MIN(popoverRect.size.width, 100) ;
        popoverRect.origin.x  = popoverRect.origin.x;
    }
    
    for (UIView *subView in self.view.subviews) {
        if (subView.tag ==501) {
            [subView removeFromSuperview];
            [self loadCustomAlertSubView:alertMsg];
        }else if (subView.tag == 600){
            [disabledview removeFromSuperview];
            [self loadDeliveryAddressSubView];
        }else if (subView.tag == 700){
            [disableCustomAlertView removeFromSuperview];
            [self LoadCustomAlertWithMessageinView:nil];
        }else if(subView.tag == 701){
            [disableCustomAlertView removeFromSuperview];
            [self LoadCustomAlertWithMessageinView:@"CurrentView"];
        }else if (subView.tag == 5003){
            [diabledview removeFromSuperview];
            [self loadMapSubView:@"Menu"];
        }else if (subView.tag == 800){
            [disabledSeeHrsView removeFromSuperview];
            [self seehoursCustomAlertSubViewBtnClicked:nil forEvent:UIControlStateNormal];
        }else if (subView.tag == 900){
            [disableCustomAlertViewNoTimings removeFromSuperview];
            [self seehoursCustomAlertSubViewBtnClicked:nil forEvent:UIControlStateNormal];
        }
    }
}



-(void)LoadCustomAlertWithMessageinView:(NSString *)viewMsg{
    
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
   
    
    

  //  restaurantMenuArray;
    NSMutableDictionary *file_nameDic=[[NSMutableDictionary alloc]init];

    NSMutableDictionary *menuTypeDic=[[NSMutableDictionary alloc]init];
    NSMutableDictionary *pathDic=[[NSMutableDictionary alloc]init];
    NSMutableDictionary *thumbnail_pathDic=[[NSMutableDictionary alloc]init];
    
    dataDic=[[NSMutableDictionary alloc]init];
    NSMutableArray *file_nameArr=[[NSMutableArray alloc]init];
    NSMutableArray *menuTypeArr=[[NSMutableArray alloc]init];
    pathArr=[[NSMutableArray alloc]init];
    NSMutableArray *thumbnail_pathArr=[[NSMutableArray alloc]init];
  

    UIFont *msgLabelFont;
    CGSize messageSize;
    
    float frameSizeHeight;
    float frameSizeY;
    float frameSizeX;
    float frameWidth;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        msgLabelFont = [UIFont fontWithName:@"Thonburi" size:22];

        
        messageSize = [FAUtilities getHeightFromString:customAlertMessage AndWidth:500-40 AndFont:msgLabelFont];

        if ([customAlertTitle isEqualToString:@"Restaurant Operating Hours"]) {
            frameSizeHeight = messageSize.height + 55 + 100 +20+30;//msg hight +header+gap+seeHours
        }else{
            frameSizeHeight = messageSize.height + 55 + 100 +20;//msg hight +header+gap
        }

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
        
        
        if ([customAlertTitle isEqualToString:@"Restaurant Operating Hours"]) {
            frameSizeHeight = messageSize.height + 45 + 70 +20+15;
        }else{
          frameSizeHeight = messageSize.height + 45 + 70 +20;
        }
        
        frameSizeY = ((disableCustomAlertView.frame.size.height - frameSizeHeight)/2)-30;
        frameSizeX = 18;
        frameWidth = 284;
        
    }
    
    
    CGRect frame = CGRectMake(frameSizeX, frameSizeY, frameWidth, frameSizeHeight);

    if ([viewMsg isEqualToString:@"CurrentView"]) {
        
        for (int i=0; i<restaurantMenuArray.count; i++) {
            dataDic=[restaurantMenuArray objectAtIndex:i];
            menuTypeDic=[dataDic objectForKey:@"menu_type"];
            [menuTypeArr addObject:menuTypeDic];
            
            pathDic=[dataDic objectForKey:@"path"];
            [pathArr addObject: pathDic];
            
            thumbnail_pathDic=[dataDic objectForKey:@"thumbnail_path"];
            [thumbnail_pathArr addObject:thumbnail_pathDic];
            
            file_nameDic =[dataDic objectForKey:@"file_name"];
            [file_nameArr addObject:file_nameDic];
            
        }
        
        disableCustomAlertView.tag = 701;
        CGRect frame1;
        float count =restaurantMenuArray.count;
        float numOfColums=4;
        
        int height;
        int menuHeight;
        float colms = count/numOfColums;

        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            menuHeight=100;
            height=colms*menuHeight;
            
            if (height%menuHeight !=0) {
                int val = height%menuHeight;
                height = height+menuHeight-val;
                int tempVal = height/menuHeight;
                height = height +(tempVal*10)+60;
            }else{
                int tempVal = height/menuHeight;
                height = height +(tempVal*10)+60;
            }
            
            frame1 = CGRectMake(frameSizeX, frameSizeY-height/2, frameWidth, frameSizeHeight+height);
        }else{
            
            menuHeight=50;
            height=colms*menuHeight;
            
            if (height%menuHeight !=0) {
                int val = height%menuHeight;
                height = height+menuHeight-val;
                int tempVal = height/menuHeight;
                height = height +(tempVal*10)+36;
            }else{
                int tempVal = height/menuHeight;
                height = height +(tempVal*10)+36;
            }
            frame1 = CGRectMake(frameSizeX, frameSizeY-height/2, frameWidth, frameSizeHeight+height);
        }

        
   

        UIView *menuLinkAlertView = [FAUtilities customAlert:customAlertTitle withStr:customAlertMessage withColor:@"992d2d" withFrame:frame1 withNumberOfButtons:1 withOnlyCancelBtnMessage:@"Ok" WithCancelBtnMessage:@"" WithDoneBtnMessage:@"" withMenuMsg:@"Yes" numOfMenus:count numOfColums:numOfColums menuLabelName:menuTypeArr thumNailPathArr:thumbnail_pathArr fileNameArr:file_nameArr];

        UIButton *menuListBtn;
        UIButton *onlyCancelBtn;
     
        for (UIView *subview in [[[menuLinkAlertView subviews] objectAtIndex:0] subviews]){
            for (UIView *view in  [subview subviews]){
     
                if([view isKindOfClass:[UIButton class]]){
                    menuListBtn = (UIButton *)view;
                    [menuListBtn addTarget:self action:@selector(menuListBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                }
            }
                
            
            if([subview isKindOfClass:[UIButton class]]){
             
                 if (subview.tag == 1001) {
                    onlyCancelBtn = (UIButton *)subview;
                    [onlyCancelBtn addTarget:self action:@selector(cancelCustomAlertSubViewBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                }

            }
            
            if([subview isKindOfClass:[UIButton class]]){
                if (subview.tag == 1002) {
                    seeHoursBtn = (UIButton *)subview;
                    [seeHoursBtn addTarget:self action:@selector(seehoursCustomAlertSubViewBtnClicked:forEvent:) forControlEvents:UIControlEventTouchUpInside];
                }
            }
        }
      
      
        
        [disableCustomAlertView addSubview:menuLinkAlertView];
        [self.view addSubview:disableCustomAlertView];

        
    }else if ([viewMsg isEqualToString:@"No Timngs Found"]){ //No Timngs Found
        
        disableCustomAlertViewNoTimings = [[UIView alloc]initWithFrame:disableCustomAlertViewFrame];
        disableCustomAlertViewNoTimings.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pgm_gallery.png"]];
        disableCustomAlertViewNoTimings.tag = 900;
        
        UIView *customAlertViewNoTimngs = [FAUtilities customAlert:customAlertTitle withStr:customAlertMessage withColor:@"992d2d" withFrame:frame withNumberOfButtons:1 withOnlyCancelBtnMessage:@"Ok" WithCancelBtnMessage:@"" WithDoneBtnMessage:@""];
        UIButton *onlyCancelBtn;
        for (UIView *subview in [[[customAlertViewNoTimngs subviews] objectAtIndex:0] subviews]){
            if([subview isKindOfClass:[UIButton class]]){
                if (subview.tag == 1001) {
                    onlyCancelBtn = (UIButton *)subview;
                    [onlyCancelBtn addTarget:self action:@selector(cancelCustomAlertSubViewNoTimingsBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                }
            }
        }
        [disableCustomAlertViewNoTimings addSubview:customAlertViewNoTimngs];

        [self.view addSubview:disableCustomAlertViewNoTimings];
    }else{

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
        
//        UIButton *seeHoursBtn;
        for (UIView *subview in [[[customAlertView subviews] objectAtIndex:0] subviews]){
            if([subview isKindOfClass:[UIButton class]]){
                if (subview.tag == 1002) {
                    seeHoursBtn = (UIButton *)subview;
                    [seeHoursBtn addTarget:self action:@selector(seehoursCustomAlertSubViewBtnClicked:forEvent:) forControlEvents:UIControlEventTouchUpInside];
                }
            }
        }
        [disableCustomAlertView addSubview:customAlertView];
        [self.view addSubview:disableCustomAlertView];

    }

      
}

-(void)menuListBtnClicked:(id)sender{
    
    UIButton *menuButton=(UIButton *)sender;
    NSString *menuPath = [NSString stringWithFormat:@"%@%@",REQ_URL,[pathArr objectAtIndex:menuButton.tag-1]];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"Menu" forKey:@"ParentView"];
    
    WebViewController *webView = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
    webView.webUrlStr=menuPath;
    webView.headingLabelStr = @"Menu";
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:webView animated:NO completion:nil];
    
}

-(void)cancelCustomAlertSubViewBtnClicked:(id)sender{
    [disableCustomAlertView removeFromSuperview];
}


-(void)cancelCustomAlertSubViewNoTimingsBtnClicked:(id)sender{
    [disableCustomAlertViewNoTimings setHidden:YES];
}

-(void)seehoursCustomAlertSubViewBtnClicked:(id)sender forEvent:(UIEvent*)event{
    
    if (pickUpTimingsArray.count >0 || deliveryTimingsArray.count>0) {
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
            
            CGFloat heightTimingSubView_ipad_port;
            CGFloat heightTimingSubView_ipad_land;

            if (deliveryTimingsArray.count>0) {
                heightTimingSubView_ipad_port=500;
                heightTimingSubView_ipad_land=500;
         
            }else{
                heightTimingSubView_ipad_port=500;
                heightTimingSubView_ipad_land=500;
            }

            if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
                  timingsTableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 500, heightTimingSubView_ipad_land)];
            }else{
                   timingsTableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 500, heightTimingSubView_ipad_port)];
            }
            
            timingsTableview.delegate = self;
            timingsTableview.dataSource = self;
            timingsTableview.tag = 800;
        
            [self showPopOverForFilter:timingsTableview withButton:sender withTitle:@""];
        
        }else if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone){

            popupOverallView = [[UIView alloc]initWithFrame:self.view.bounds];
            popupOverallView.backgroundColor = [UIColor clearColor];
            popupOverallView.tag = 500;
            
            UIButton *disabledBtn = [[UIButton alloc]initWithFrame:disableCustomAlertView.frame];
            [disabledBtn addTarget:self
                            action:@selector(disablePopUp:)
                  forControlEvents:UIControlEventTouchUpInside];
            
            [popupOverallView addSubview:disabledBtn];
            
            CGRect popoverRect = [self.view convertRect:[seeHoursBtn frame] fromView:[seeHoursBtn superview]];
            
            CGFloat height_iPhone_5 = 0.0;
            CGFloat height_iPhone_4 = 0.0;
            CGFloat y_Axis_timingHrsSubView_iphone_4 = 0.0;
            CGFloat y_Axis_timingHrsSubView_iphone_5 = 0.0;

            CGRect timingHoursSubViewFrame;

            if (deliveryTimingsArray.count>0) {
                height_iPhone_5 = 280 ;
                height_iPhone_4 = 200;
                y_Axis_timingHrsSubView_iphone_5 = popoverRect.origin.y+10;
                y_Axis_timingHrsSubView_iphone_4 = popoverRect.origin.y+10;

            }else{
                height_iPhone_5 = 260 ;
                height_iPhone_4 = 200;
                y_Axis_timingHrsSubView_iphone_5 = popoverRect.origin.y+10;
                y_Axis_timingHrsSubView_iphone_4 = popoverRect.origin.y+10;
            }

            if ([UIScreen mainScreen].bounds.size.height == 568) {  // iphone 5 inch
                timingHoursSubViewFrame = CGRectMake(18, y_Axis_timingHrsSubView_iphone_5, 286, height_iPhone_5);
            }else{
                timingHoursSubViewFrame = CGRectMake(18, y_Axis_timingHrsSubView_iphone_4, 286, height_iPhone_4);
            }

            popFromView=[[UIView alloc]initWithFrame:timingHoursSubViewFrame];
            popFromView.backgroundColor=[UIColor clearColor];
            popupDropImage=[[UIImageView alloc]initWithFrame:CGRectMake(25, 10, 20, 20)];
            [popupDropImage setImage:[UIImage imageNamed:@"popupArrow.png"]];
            [popFromView addSubview:popupDropImage];
            popFromView.layer.cornerRadius=10;
            popFromView.layer.borderColor=[[UIColor darkGrayColor] CGColor];
            
            UIView *cornerView=[[UIView alloc]initWithFrame:CGRectMake(0,0, popFromView.frame.size.width, popFromView.frame.size.height-30)];
            cornerView.backgroundColor=[UIColor clearColor];
            popupView=[[UIView alloc]initWithFrame:CGRectMake(0,20, cornerView.frame.size.width, cornerView.frame.size.height)];
            popupView.backgroundColor=[UIColor whiteColor];    //set to popupimage here
            popupView.layer.cornerRadius=10;
            
            timingsTableview=[[UITableView alloc]initWithFrame:CGRectMake(0,0, popupView.frame.size.width-6, popupView.frame.size.height)];
            timingsTableview.layer.cornerRadius=10;
            timingsTableview.delegate = self;
            timingsTableview.dataSource = self;
            timingsTableview.tag = 100;
            
            [popupView addSubview:timingsTableview];
            [cornerView addSubview:popupView];
            [popFromView addSubview:cornerView];
            [popupOverallView addSubview:popFromView];
            [self.view addSubview:popupOverallView];
        }
    }else{
        customAlertMessage = [NSString stringWithFormat:@"No Timngs Found"];
        customAlertTitle = @"Alert";
        [self LoadCustomAlertWithMessageinView:@""];
    }
}


- (void)disablePopUp:(id)sender{
    [popupOverallView removeFromSuperview];
}


- (void)clearButtonClicked:(id)sender{
    [popupOverallView removeFromSuperview];
}

-(void)showPopOverForFilter:(UIView *)aView withButton:(UIButton *)button withTitle:(NSString *)aTitle{
    popoverContent = [[UIViewController alloc] init];
    
    UIView* popoverView = [[UIView alloc] initWithFrame:CGRectMake(50, 0,aView.frame.size.width, aView.frame.size.height)];
    popoverView.backgroundColor = [UIColor whiteColor];
    [popoverView addSubview:aView];
    popoverContent.view = popoverView;
    popoverContent.title = aTitle;


     [timingsTableview reloadData];
    popoverContent.preferredContentSize = CGSizeMake(aView.frame.size.width,aView.frame.size.height);
    popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
    
    CGRect popoverRect = [self.view convertRect:[button frame] fromView:[button superview]];
    
    popoverRect.size.width = MIN(popoverRect.size.width, 100) ;
    popoverRect.origin.x  = popoverRect.origin.x+180;
    
    [self popOverWithBtnFrame:popoverRect];
}


-(void)popOverWithBtnFrame:(CGRect )popoverRect{
    [popoverController presentPopoverFromRect:popoverRect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
   
}


-(void)dismissPopOverController:(id)sender{
    NSLog(@"dismissPopOverController ");
}

-(void)loadMapSubView:(NSString *)Value{
    
    CGRect mapBGSubViewFrame;
    CGRect disableViewFrame;
    
    CGRect headingLabelFrame;
    UIFont *headingLabelFont;
    CGRect mapSourceTextFieldFrame;
    CGRect mapSourceGetDirectionsBtnFrame;
    
    CGRect mapViewframe;
    CGRect mapSubViewCloseBtnframe;
    
    NSString *headingText;
    
    UIFont *headingBtnFont;
    UIFont *getDirectionsBtnFont;
    
    
    CGRect instructionBtnFrame;
    int mapViewFrameAdjustHeight = 0;
    
    if ([Value isEqualToString:@"ShowOnMap"]) {
        mapViewFrameAdjustHeight = 48;
    }else if([Value isEqualToString:@"GetDirections"]){
        mapViewFrameAdjustHeight = 68;
    }else if ([Value isEqualToString:@"Menu"]){
        mapViewFrameAdjustHeight = 48;
    }
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        int textFieldsHeight;
        int mapBGSubViewFrameWidth = 0;
        int mapBGSubViewFrameXpotrait = 0;
        int mapBGSubViewFrameXlandScape = 0;
        
        if ([Value isEqualToString:@"ShowOnMap"]) {
            textFieldsHeight = 0;
            headingText = @"Restaurant Location";
            mapBGSubViewFrameWidth = 700;
            mapBGSubViewFrameXlandScape = 162;
            mapBGSubViewFrameXpotrait = 34;
        }else if([Value isEqualToString:@"GetDirections"]){
            textFieldsHeight = 40;
            headingText = @"Get Directions";
            mapBGSubViewFrameWidth = 700;
            mapBGSubViewFrameXlandScape = 162;
            mapBGSubViewFrameXpotrait = 34;
            
        }else if ([Value isEqualToString:@"Menu"]){
            textFieldsHeight = 0;
            headingText = @"Menus";
            mapBGSubViewFrameWidth = 500;
            mapBGSubViewFrameXlandScape = 262;
            mapBGSubViewFrameXpotrait = 134;
            
        }
        
        
        if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
            mapBGSubViewFrame = CGRectMake(mapBGSubViewFrameXlandScape, 109-75+40, mapBGSubViewFrameWidth, 500+150);
            disableViewFrame = CGRectMake(0, 0, 1024, 768);
        }else if(UIInterfaceOrientationIsPortrait(STATUSBAR_ORIENTATION)){
            mapBGSubViewFrame = CGRectMake(mapBGSubViewFrameXpotrait, 287-50-50-75+40, mapBGSubViewFrameWidth, 500+150);
            disableViewFrame = CGRectMake(0, 0, 768, 1024);
        }
        
        
        headingLabelFrame = CGRectMake(12, 0, mapBGSubViewFrame.size.width-24, 40);
        headingLabelFont = [UIFont fontWithName:@"Thonburi" size:32];
        
        headingBtnFont = [UIFont fontWithName:@"Thonburi" size:24];
        getDirectionsBtnFont = [UIFont fontWithName:@"Thonburi" size:28];
        
        mapSubViewFrame = CGRectMake(4,headingLabelFrame.origin.y+headingLabelFrame.size.height+2,mapBGSubViewFrame.size.width-8,mapBGSubViewFrame.size.height -(headingLabelFrame.origin.y+headingLabelFrame.size.height+8) );
        
        mapSourceTextFieldFrame = CGRectMake(10, 8, 300, textFieldsHeight);
        mapSourceGetDirectionsBtnFrame = CGRectMake(mapSourceTextFieldFrame.origin.x+mapSourceTextFieldFrame.size.width+10, mapSourceTextFieldFrame.origin.y, 200, textFieldsHeight);
        
        instructionBtnFrame = CGRectMake(mapSourceGetDirectionsBtnFrame.origin.x+mapSourceGetDirectionsBtnFrame.size.width+10, mapSourceTextFieldFrame.origin.y, 100, textFieldsHeight);
        
        mapViewframe = CGRectMake(10, mapSourceGetDirectionsBtnFrame.origin.y+mapSourceGetDirectionsBtnFrame.size.height +10, mapSubViewFrame.size.width-20, mapSubViewFrame.size.height-mapViewFrameAdjustHeight);
        
        
        mapSubViewCloseBtnframe = CGRectMake(mapBGSubViewFrame.size.width-60, 0, 40, 40);
    }else{
        if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
        }else if(UIInterfaceOrientationIsPortrait(STATUSBAR_ORIENTATION)){
            
            if ([UIScreen mainScreen].bounds.size.height == 568) {  // iphone 4 inch
                mapBGSubViewFrame = CGRectMake(10, 80, 300, 478);
            }else{
                mapBGSubViewFrame = CGRectMake(10, 80, 300, 390);
            }
            disableViewFrame = CGRectMake(0, 0, 320, 568);
            
        }
        
        
        headingLabelFrame = CGRectMake(8, 0, mapBGSubViewFrame.size.width-12, 30);
        headingLabelFont = [UIFont fontWithName:@"Thonburi" size:22];
        headingBtnFont = [UIFont fontWithName:@"Thonburi" size:12];
        getDirectionsBtnFont = [UIFont fontWithName:@"Thonburi" size:18];
        
        mapSubViewFrame = CGRectMake(4,headingLabelFrame.origin.y+headingLabelFrame.size.height+2,mapBGSubViewFrame.size.width-8,mapBGSubViewFrame.size.height -(headingLabelFrame.origin.y+headingLabelFrame.size.height+8) );
        
        int textFieldsHeight;
        
        if ([Value isEqualToString:@"ShowOnMap"]) {
            textFieldsHeight = 0;
        }else if([Value isEqualToString:@"GetDirections"]){
            textFieldsHeight = 30;
        }else if ([Value isEqualToString:@"Menu"]){
            textFieldsHeight = 0;
        }
        
        mapSourceTextFieldFrame = CGRectMake(10, 2, 280, textFieldsHeight);
        mapSourceGetDirectionsBtnFrame = CGRectMake(10, mapSourceTextFieldFrame.origin.y+mapSourceTextFieldFrame.size.height+2, 140, textFieldsHeight);
        
        
        instructionBtnFrame = CGRectMake(mapSourceGetDirectionsBtnFrame.origin.x+mapSourceGetDirectionsBtnFrame.size.width+10, mapSourceGetDirectionsBtnFrame.origin.y, 100, textFieldsHeight);
        
        
        mapViewframe = CGRectMake(10, mapSourceGetDirectionsBtnFrame.origin.y+mapSourceGetDirectionsBtnFrame.size.height +10, mapSubViewFrame.size.width-20, mapSubViewFrame.size.height-mapViewFrameAdjustHeight);
        mapSubViewCloseBtnframe = CGRectMake(mapBGSubViewFrame.size.width-50, 0, 30, 30);
    }
    
    diabledview = [[UIView alloc]initWithFrame:disableViewFrame];
    diabledview.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gallery.png"]];
    
    if ([Value isEqualToString:@"ShowOnMap"]) {
        diabledview.tag = 5001;
        headingText = @"Restaurant Location";
        
    }else if([Value isEqualToString:@"GetDirections"]){
        diabledview.tag = 5002;
        headingText = @"Get Directions";
        
    }

    
    UIView *mapBGSubView1 = [[UIView alloc]initWithFrame:mapBGSubViewFrame];
    mapBGSubView1.backgroundColor = [FAUtilities getUIColorObjectFromHexString:APP_HEADER_COLOR alpha:1];
    
    UILabel *headingLabel = [[UILabel alloc]initWithFrame:headingLabelFrame];
    headingLabel.textColor = [UIColor whiteColor];
    
    headingLabel.text = headingText;
    headingLabel.textAlignment = NSTextAlignmentCenter;
    headingLabel.font = headingLabelFont;
    
    UIImage *closeBtnimage = [UIImage imageNamed:@"pgm_closeButton.png"];
    
    UIButton *mapSubViewCloseBtn = [[UIButton alloc]initWithFrame:mapSubViewCloseBtnframe];
    [mapSubViewCloseBtn addTarget:self action:@selector(mapSubViewCloseBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [mapSubViewCloseBtn setBackgroundImage:closeBtnimage forState:UIControlStateNormal];
    
    mapSubView = [[UIScrollView alloc]initWithFrame:mapSubViewFrame];
    mapSubView.backgroundColor = [UIColor whiteColor];
    menuListTableView = [[UITableView alloc]initWithFrame:mapViewframe];
    menuListTableView.delegate = self;
    menuListTableView.dataSource = self;
    
    
    [mapBGSubView1 addSubview:mapSubView];
    [mapBGSubView1 addSubview:mapSubViewCloseBtn];
    [mapBGSubView1 addSubview:headingLabel];
    [diabledview addSubview:mapBGSubView1];
    [self.view addSubview:diabledview];
}

-(void)mapSubViewCloseBtnClicked:(id)sender{
    [diabledview removeFromSuperview];
}


#pragma mark TableView Datasource
/* number of sections in form list record table */

//

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (deliveryTimingsArray.count>0) {// delivery timings are their
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
                column1width   =85+47;
                column2width   =150+42;
                column3width   =150+8;//label width+reaming gap
            }else if (UIInterfaceOrientationIsPortrait(STATUSBAR_ORIENTATION)){
                column1width   =85+47;
                column2width   =150+42;
                column3width   =150+8;//label width+reaming gap
            }
        }else{
            column1width   =57+8;
            column2width   =95+12;
            column3width   =105;
        }
    
        tableColumnWidths = [[NSMutableArray alloc]init];
        [tableColumnWidths addObject:[NSString stringWithFormat:@"%f",column1width]];
        [tableColumnWidths addObject:[NSString stringWithFormat:@"%f",column2width]];
        [tableColumnWidths addObject:[NSString stringWithFormat:@"%f",column3width]];
    
        tableColumns=[[NSArray alloc]initWithObjects:@"Day",@"Pickup Hours",@"Delivery Hours" ,nil];

    }else{// no delivery timngs
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
                column1width   =150+17;//label+gap
                column2width   =300+25;//label+remainggap
            }else if (UIInterfaceOrientationIsPortrait(STATUSBAR_ORIENTATION)){
                column1width   =150+17;
                column2width   =300+25;
            }
        }else{
            column1width   =90+10;
            column2width   =200;
        }
        tableColumnWidths = [[NSMutableArray alloc]init];
        [tableColumnWidths addObject:[NSString stringWithFormat:@"%f",column1width]];
        [tableColumnWidths addObject:[NSString stringWithFormat:@"%f",column2width]];
        tableColumns=[[NSArray alloc]initWithObjects:@"Day",@"Pickup Hours" ,nil];
    }
    return 1;
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        return 40;
    }else{
        return 20;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (deliveryTimingsArray.count>0) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            return 80;
        }else{
            return 54;
        }
    }else{
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            return 60;
        }
        else{
            return 34;
        }
    }
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    CGFloat originX = 0.0f;
    CGFloat originY = 0.0f;
    CGFloat width = 0.0f;
    CGFloat height = 0.0f;
    UIView *headerView = [[UIView alloc] init];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
            headerView.frame = CGRectMake(0, 0,timingsTableview.frame.size.width, 40);

        }else if(UIInterfaceOrientationIsPortrait(STATUSBAR_ORIENTATION)){
            headerView.frame = CGRectMake(0, 0, timingsTableview.frame.size.width, 40);
        }
        headerLabelFont = [UIFont fontWithName:@"Thonburi-Bold" size:22];
        height = 44.0f;
    }else{
        headerView.frame = CGRectMake(0, 0,timingsTableview.frame.size.width, 20);
        headerLabelFont = [UIFont fontWithName:@"Thonburi-Bold" size:14];

        height = 20.0f;
    }
    
    for (int i=0; i<[tableColumnWidths count]; i++) {
        NSString *widthVal = [tableColumnWidths objectAtIndex:i];
        width = [widthVal floatValue];
        headerLabelView = [[UILabel alloc]initWithFrame:CGRectMake(originX, originY, width, height)];
        headerLabelView.text = [tableColumns objectAtIndex:i];
        headerLabelView.backgroundColor=[UIColor whiteColor];
        headerLabelView.textColor = [FAUtilities getUIColorObjectFromHexString:APP_HEADER_COLOR alpha:1];
        headerLabelView.font=headerLabelFont;
        headerLabelView.numberOfLines=0;
        headerLabelView.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:headerLabelView];
        originX += width+2;
        headerLabelView.tag = 100+i;
    }
    return headerView;
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==timingsTableview) {
        return 7;
    }
    return [restaurantMenuArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier;
    CustomTimeCell *cell;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        CellIdentifier = @"CustomTimeCell-ipad";//CustomTimeCell-ipad
        cell = (CustomTimeCell *)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    }else{
       CellIdentifier = @"CustomTimeCell";//CustomTimeCell-iphone
        cell = (CustomTimeCell *)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    }
  
    
    if (cell== nil) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [tableView registerNib:[UINib nibWithNibName:@"CustomTimeCell-ipad" bundle:nil] forCellReuseIdentifier:CellIdentifier];
            cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
        }else{
            [tableView registerNib:[UINib nibWithNibName:@"CustomTimeCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
            cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        
    }
    
   
    if (tableView == timingsTableview){
        NSDictionary *temppickUpDict;
        NSDictionary *tempDeliveryDict ;

        if (pickUpTimingsArray.count>0) {
            temppickUpDict = [pickUpTimingsArray objectAtIndex:indexPath.row];
        }else{
            
        }
        
        if (deliveryTimingsArray.count>0) {//Delivery timngs are available
            
            tempDeliveryDict = [deliveryTimingsArray objectAtIndex:indexPath.row];

            
            cell.pickOrDeliveryTimeLabel.hidden=YES;
            cell.daysOneTimeLabel.hidden=YES;
            
            cell.dayLabel.hidden=NO;
            cell.pickupFromTimeLabel.hidden=NO;
            cell.deliveryFromTimeLabel.hidden=NO;
   
            cell.dayLabel.text=[temppickUpDict objectForKey:@"day"];
            cell.dayLabel.textAlignment=NSTextAlignmentCenter;
            cell.pickupFromTimeLabel.textAlignment=NSTextAlignmentCenter;
            cell.deliveryFromTimeLabel.textAlignment=NSTextAlignmentCenter;
            cell.pickupFromTimeLabel.text=[NSString stringWithFormat:@"%@\nto\n%@",[temppickUpDict objectForKey:@"from_time"],[temppickUpDict objectForKey:@"to_time"]];

            cell.deliveryFromTimeLabel.text=[NSString stringWithFormat:@"%@\nto\n%@",[tempDeliveryDict objectForKey:@"from_time"],[tempDeliveryDict objectForKey:@"to_time"]];

        }else{//Delivery timngs not available
            cell.pickOrDeliveryTimeLabel.hidden=NO;
            cell.daysOneTimeLabel.hidden=NO;
            
            cell.dayLabel.hidden=YES;
            cell.pickupFromTimeLabel.hidden=YES;
            cell.deliveryFromTimeLabel.hidden=YES;
            
            
            cell.daysOneTimeLabel.text=[temppickUpDict objectForKey:@"day"];
                  cell.pickOrDeliveryTimeLabel.text=  cell.pickupFromTimeLabel.text=[NSString stringWithFormat:@"%@ to %@",[temppickUpDict objectForKey:@"from_time"],[temppickUpDict objectForKey:@"to_time"]];
        }
     }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath {
    
    
    if (tableView == menuListTableView){
        NSDictionary *tempDict = [restaurantMenuArray objectAtIndex:indexPath.row];
        NSString *menuPath = [NSString stringWithFormat:@"%@%@",REQ_URL,[tempDict objectForKey:@"path"]];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"Menu" forKey:@"ParentView"];

        
        WebViewController *webView = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
        webView.webUrlStr=menuPath;
        webView.headingLabelStr = @"Menu";
        
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromLeft;
        [self.view.window.layer addAnimation:transition forKey:nil];
        
        [self presentViewController:webView animated:NO completion:nil];
        
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
