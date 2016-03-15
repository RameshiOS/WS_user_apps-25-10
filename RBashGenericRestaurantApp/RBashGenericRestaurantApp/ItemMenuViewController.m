//
//  ItemMenuViewController.m
//  ThinkingCup
//
//  Created by Manulogix on 05/09/14.
//  Copyright (c) 2014 Manulogix. All rights reserved.
//

#import "ItemMenuViewController.h"
#import "LoginViewController.h"
#import "FAUtilities.h"
#import "SettingsViewController.h"
#import "PlaceOrderViewController.h"
#import "MyProfileViewController.h"
#import "MyOrdersViewController.h"

@interface ItemMenuViewController ()

@end

@implementation ItemMenuViewController

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
}


-(void)viewWillAppear:(BOOL)animated{
    
 
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
            self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"pgm_ipad-Background-Landscape.png"]];
        }else if(UIInterfaceOrientationIsPortrait(STATUSBAR_ORIENTATION)){
            self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"pgm_ipad-Background-Potrait.png"]];
        }
    }else{
        self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"pgm_iphone-Background-Potrait.png"]];
    }
    
    
    itemMenuListAry = [[NSMutableArray alloc]init];
    NSMutableArray *loginArray = [[NSMutableArray alloc]init];
    
    dbManager = [DataBaseManager dataBaseManager];
    [dbManager execute:[NSString stringWithFormat:@"SELECT * FROM LoginDetails "] resultsArray:loginArray];
    
    if (loginArray.count ==0) {
        [itemMenuListAry addObject:@"Login"];
    }else{
        [itemMenuListAry addObject:@"My Profile"];
        [itemMenuListAry addObject:@"My Orders"];
    }
    
    [itemMenuListAry addObject:@"Cancel This Order"];
    [itemMenuListAry addObject:@"Current Order"];
    [itemMenuListAry addObject:@"Settings"];
    
    if (loginArray.count ==0) {
    }else{
        [itemMenuListAry addObject:@"Logout"];
    }

    [itemMenuTableView reloadData];
}


#pragma mark
#pragma mark TableView Datasource
/* number of sections in form list record table */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

/* number of rows in form list record table based on records saved in database */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [itemMenuListAry count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [itemMenuTableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyIdentifier"];
    }
    cell.textLabel.text = [itemMenuListAry objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [FAUtilities getUIColorObjectFromHexString:MENU_CELL_TEXT_COLOR alpha:1];

    UIFont *cellFont;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        cellFont =[UIFont fontWithName:SIDE_MENU_CELL_FONT_NAME size:22];
    }else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        cellFont =[UIFont fontWithName:SIDE_MENU_CELL_FONT_NAME size:16];
    }
        cell.textLabel.font = cellFont;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        if ([cell.textLabel.text isEqualToString:@"Current Order"]) {
            cell.contentView.backgroundColor = [FAUtilities getUIColorObjectFromHexString:APP_HEADER_COLOR alpha:1];
            cell.textLabel.textColor = [UIColor whiteColor];

            UIView *countSubView = [[UIView alloc]initWithFrame:CGRectMake(170, 10, 80, 40)];
            countSubView.backgroundColor = [UIColor whiteColor];
            countSubView.layer.cornerRadius = 20;
            countSubView.tag = 504;
            
            UIImageView *cartImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 30, 30)];
            cartImage.image = [UIImage imageNamed:@"pgm_itemMenuCart.png"];
            [countSubView addSubview:cartImage];
            
            UIFont *cartLabelFont =[UIFont fontWithName:@"Thonburi-bold" size:22];

            
            UILabel *cartCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(cartImage.frame.origin.x+cartImage.frame.size.width+4, 5, 40, 30)];
            cartCountLabel.text = [self refreshCart];
           cartCountLabel.textColor = [FAUtilities getUIColorObjectFromHexString:APP_HEADER_COLOR alpha:1];
            cartCountLabel.font = cartLabelFont;
            [countSubView addSubview:cartCountLabel];
            
            
            [cell.contentView addSubview:countSubView];
            
            
            UIView *bgColorView = [[UIView alloc] init];
            bgColorView.backgroundColor = [FAUtilities getUIColorObjectFromHexString:APP_HEADER_COLOR alpha:0.8];
            cell.selectedBackgroundView = bgColorView;

        }else{
            UIView *bgColorView = [[UIView alloc] init];
            bgColorView.backgroundColor = [FAUtilities getUIColorObjectFromHexString:@"000000" alpha:0.3];
            cell.selectedBackgroundView = bgColorView;

            
            for (UIView *subView in cell.contentView.subviews) {
                if (subView.tag ==504) {
                    [subView removeFromSuperview];
                }
            }
        }
    return cell;
}


-(NSString *)refreshCart{
    
    NSMutableArray *itemsAry = [[NSMutableArray alloc]init];
    dbManager = [DataBaseManager dataBaseManager];
    [dbManager execute:[NSString stringWithFormat:@"SELECT * FROM OrderDetails where Quantity > '0'"] resultsArray:itemsAry];
    return [NSString stringWithFormat:@"%lu",(unsigned long)[itemsAry count]];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath {
    NSString *selectedValue = [itemMenuListAry objectAtIndex:indexPath.row];
    if ([selectedValue isEqualToString:@"Login"]) {
        NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
        [defaults setObject:@"ItemMenu" forKey:@"LoginParentView"];
        [defaults synchronize];
        LoginViewController *login = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self presentViewController:login animated:YES completion:nil];
    }
    
    if ([selectedValue isEqualToString:@"My Profile"]) {
        MyProfileViewController *myProfile = [self.storyboard instantiateViewControllerWithIdentifier:@"MyProfileViewController"];
        [self presentViewController:myProfile animated:YES completion:nil];
    }
   
    if ([selectedValue isEqualToString:@"My Orders"]) {
        MyOrdersViewController *myOrders = [self.storyboard instantiateViewControllerWithIdentifier:@"MyOrdersViewController"];
        [self presentViewController:myOrders animated:YES completion:nil];
    }
    
    if ([selectedValue isEqualToString:@"Cancel This Order"]) {
      
        customAlertTitle  = @"Cancel Order";
        customAlertMessage = @"Are you sure you want to cancel this order?";
        buttons = 2;

        [self LoadCustomAlertWithMessage];
        
        NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
        [defaults setObject:@"0.00" forKey:@"min_cart_amount"];

        
    }
    
    if ([selectedValue isEqualToString:@"Current Order"]) {
        NSMutableArray *itemDetailsAry = [[NSMutableArray alloc]init];
        dbManager = [DataBaseManager dataBaseManager];
        [dbManager execute:[NSString stringWithFormat:@"SELECT * FROM OrderDetails "] resultsArray:itemDetailsAry];
        
        if (itemDetailsAry.count ==0) {
            customAlertTitle  = @"Alert";
            customAlertMessage = @"Your Cart is empty";
            buttons = 1;
            [self LoadCustomAlertWithMessage];
                        
        }else{
            NSMutableArray *loginArray = [[NSMutableArray alloc]init];
            dbManager = [DataBaseManager dataBaseManager];
            [dbManager execute:[NSString stringWithFormat:@"SELECT * FROM LoginDetails "] resultsArray:loginArray];
            if (loginArray.count == 0) {
                NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
                [defaults setObject:@"CategoryList" forKey:@"LoginParentView"];
                [defaults synchronize];
                LoginViewController *login = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
                [self presentViewController:login animated:YES completion:nil];
            }else{
                NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
                [defaults setObject:@"itemMenu" forKey:@"PlaceOrderParentView"];
                [defaults synchronize];
                PlaceOrderViewController *placeOrder = [self.storyboard instantiateViewControllerWithIdentifier:@"PlaceOrderViewController"];
                [self presentViewController:placeOrder animated:YES completion:nil];
            }
        }
    }

    
    
    if ([selectedValue isEqualToString:@"Settings"]) {
        
        
 
        
        
        SettingsViewController *settings = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
        [self presentViewController:settings animated:YES completion:nil];
     
    }
    
    if ([selectedValue isEqualToString:@"Logout"]) {
        dbManager = [DataBaseManager dataBaseManager];
        NSString *cartQuery = [NSString stringWithFormat:@"DELETE FROM LoginDetails "];
        [dbManager execute:cartQuery];
        
        
        NSString *cartQuery1 = [NSString stringWithFormat:@"DELETE FROM OrderMaster "];
        [dbManager execute:cartQuery1];

        [self viewWillAppear:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 60;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100) {
        if (buttonIndex ==1) {
            [self performSegueWithIdentifier:@"cancelSegue" sender:self];
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
    UIView *customAlertView = [FAUtilities customAlert:customAlertTitle withStr:customAlertMessage withColor:@"992d2d" withFrame:frame withNumberOfButtons:buttons withOnlyCancelBtnMessage:@"Ok" WithCancelBtnMessage:@"No" WithDoneBtnMessage:@"Yes"];
    
    
    UIButton *cancelBtn;
    UIButton *doneBtn;
    UIButton *onlyCancelBtn;
    
    
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
//    [self.view addSubview:disableCustomAlertView];

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
    [disableCustomAlertView removeFromSuperview];

    [self performSegueWithIdentifier:@"cancelSegue" sender:self];
    dbManager = [DataBaseManager dataBaseManager];
    NSString *cartQuery = [NSString stringWithFormat:@"DELETE FROM OrderDetails "];
    [dbManager execute:cartQuery];
    NSString *cartQuery1 = [NSString stringWithFormat:@"DELETE FROM OrderModifier "];
    [dbManager execute:cartQuery1];
    NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
    [defaults setObject:@"0.00" forKey:@"CurrentTipValue"];

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
