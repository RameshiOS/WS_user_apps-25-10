//
//  SRExampleTableViewController.m
//  SRExpandableTableView
//
//  Created by Scot Reichman on 8/9/13.
//  Copyright (c) 2013 i2097i. All rights reserved.
//
//    DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
//    Version 2, December 2004
//
//    Copyright (C) 2004 Sam Hocevar <sam@hocevar.net>
//
//    Everyone is permitted to copy and distribute verbatim or modified
//    copies of this license document, and changing it is allowed as long
//    as the name is changed.
//
//    DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
//    TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
//
//    0. You just DO WHAT THE FUCK YOU WANT TO.

#import "SRExampleTableViewController.h"
#import "ChooseItemCustomTableViewCell.h"
#import "FAUtilities.h"
#import "DishDetailsViewController.h"
#import "PlaceOrderViewController.h"
#import "LoginViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"
#import <TwitterKit/TwitterKit.h>
#import "ShareDetailsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>

@interface SRExampleTableViewController ()
@property (nonatomic) IBOutlet UIBarButtonItem* revealButtonItem;

@end

@implementation SRExampleTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    NSUserDefaults *defautls = [[NSUserDefaults alloc]init];
    
    NSDate *requestedTime = [defautls objectForKey:@"RequestedTime"];
    NSDate *respRecvdTime = [defautls objectForKey:@"ResponseRecivedTime"];
    
    NSLog(@"Seconds --------> %f",[respRecvdTime timeIntervalSinceDate:requestedTime]);

    float secs = [respRecvdTime timeIntervalSinceDate:requestedTime];
    
//    [FAUtilities showAlert:[NSString stringWithFormat:@"time taken in secs %f if Zip = %@",secs, IS_MENU_READ_AS_ZIP_FILE]];
    
    [self.revealButtonItem setTarget: self.revealViewController];
    [self.revealButtonItem setAction: @selector( revealToggle: )];
    self.navigationItem.leftBarButtonItem = self.revealButtonItem;
    [[UINavigationBar appearance] setTintColor:[FAUtilities getUIColorObjectFromHexString:@"9A349D" alpha:1]]; // this will change the back button tint
    [self.navigationController.navigationBar addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    UIView *tempView = [[UIView alloc]initWithFrame:CGRectMake(-10, 70, 70, 40)];
    UIButton *tempBtn = [[UIButton alloc]initWithFrame:CGRectMake(12, 0, tempView.frame.size.width, tempView.frame.size.height)];
    [tempBtn addTarget:self action:@selector(handleTapGesture:) forControlEvents:UIControlEventTouchUpInside];
    cartCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(37, 2, 32, 35)];
    cartCountLabel.textColor = [UIColor whiteColor];
    [tempBtn addSubview:cartCountLabel];
    UIImageView *cartBtnImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 2, 35, 35)];
    [cartBtnImage setImage:[UIImage imageNamed:@"pgm_cart.png"]];
    [tempBtn addSubview:cartBtnImage];
    [tempView addSubview:tempBtn];
    UIBarButtonItem* cartBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:tempView];
    self.navigationItem.rightBarButtonItem = cartBarButtonItem;
    [[UINavigationBar appearance] setTintColor:[FAUtilities getUIColorObjectFromHexString:@"9A349D" alpha:1]]; // this will change the back button tint
    categoriesAry = [[NSMutableArray alloc]init];
    NSUserDefaults *defaults = [[NSUserDefaults alloc]init];

    
    NSMutableArray *contentArray = [[NSMutableArray alloc]init];
    NSMutableArray *labelArray = [[NSMutableArray alloc]init];

    categoriesArray = [[NSMutableArray alloc]init];

    if ([[defaults objectForKey:@"LoadMenus"] isEqualToString:@"LoadFromDefaults"]) {
        labelArray = [defaults objectForKey:@"LabelsAry"];
        contentArray =  [defaults objectForKey:@"ContentItemsArray"];
        categoriesArray = labelArray;
    }else{
        // getting menu from Database

        NSString *menuID = [defaults objectForKey:@"MenuID"];
        
        NSMutableArray *menuPathAry = [[NSMutableArray alloc]init];
        dbManager = [DataBaseManager dataBaseManager];

        [dbManager execute:[NSString stringWithFormat:@"Select MenuFilePath From RestaurantMenuDetails Where MenuID = '%@'",menuID] resultsArray:menuPathAry];
        
        NSString *menufilePath = [[menuPathAry objectAtIndex:0]objectForKey:@"MenuFilePath"];
        NSArray *catArray = [NSArray arrayWithContentsOfFile:menufilePath];
        
        if([catArray count] == 0){
            NSData *JSONData = [NSData dataWithContentsOfFile:menufilePath];
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:JSONData
                                                                 options:kNilOptions
                                                                   error:nil];
            catArray = [json objectForKey:@"categories"];
        }
        
        
        if([catArray count] == 0){
            dbManager = [DataBaseManager dataBaseManager];
            [dbManager execute:[NSString stringWithFormat:@"Update RestaurantMenuDetails set UpdatedOn='%@' where MenuID = '%@'",@"-1",menuID]];
            [FAUtilities showAlert:@"Unable to load menus, Please try again" withHeading:@"Sorry!"];
        }

        
        for (int i=0; i<[catArray count]; i++) {
            NSDictionary *currentCategoryDict = [catArray objectAtIndex:i];
            
            NSArray *itemsArray = [[NSArray alloc]init];
            itemsArray = [currentCategoryDict objectForKey:@"items"];
            [contentArray addObject:itemsArray];
            NSMutableDictionary *tempCatDict = [[NSMutableDictionary alloc]init];
            [tempCatDict setObject:[currentCategoryDict objectForKey:@"name"] forKey:@"name"];
            [tempCatDict setObject:[NSString stringWithFormat:@"%lu",(unsigned long)[itemsArray count]] forKey:@"CategoryCount"];
            [labelArray addObject:tempCatDict];
        }
        categoriesArray = labelArray;
    }
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        fontForCellText = [UIFont fontWithName:@"Thonburi" size:24.0];
        descCellTextWidth = 745;
        defaultCellHeight = 84;
        descTextViewOriginY = 61+10;
    }else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        fontForCellText = [UIFont fontWithName:@"Thonburi" size:16.0];
        descCellTextWidth = 300;
        defaultCellHeight = 70;
        descTextViewOriginY =52;
    }
    [self refreshCart];
    [self setSRExpandableTableViewControllerWithContent:contentArray andSectionLabels:labelArray];
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [self refreshCart];
 
}

-(void)viewDidAppear:(BOOL)animated
{
    CGRect frame = CGRectMake(0, 0, 200, 44);//TODO: Can we get the size of the text?
    UILabel* label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        label.font = [UIFont fontWithName:@"Verdana" size:25.0];
        NSDictionary *itemTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                            [UIColor whiteColor],NSForegroundColorAttributeName,
                                            [UIColor whiteColor],NSBackgroundColorAttributeName,
                                            [UIFont fontWithName:@"Verdana" size:18],NSFontAttributeName,
                                            nil];
        [[UIBarButtonItem appearance] setTitleTextAttributes:itemTextAttributes forState:UIControlStateNormal];
    }else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        label.font = [UIFont fontWithName:@"Verdana" size:20.0];
        NSDictionary *itemTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                            [UIColor whiteColor],NSForegroundColorAttributeName,
                                            [UIColor whiteColor],NSBackgroundColorAttributeName,
                                            [UIFont fontWithName:@"Verdana" size:16],NSFontAttributeName,
                                            nil];
        [[UIBarButtonItem appearance] setTitleTextAttributes:itemTextAttributes forState:UIControlStateNormal];
    }
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text=@"Choose Items";
    self.navigationItem.titleView = label;
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    
    for (UIView *subView in self.view.subviews) {
      if (subView.tag == 700){
            [disableCustomAlertView removeFromSuperview];
            [self LoadCustomAlertWithMessage];
        }
    }
    
    [self.tableView reloadData];
}


-(void)handleTapGesture:(id)sender{
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
            [defaults setObject:@"CategoryList" forKey:@"LoginParentView"];
            [defaults synchronize];
            LoginViewController *login = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            [self presentViewController:login animated:YES completion:nil];
        }else{
            NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
            [defaults setObject:@"CategoryListView" forKey:@"PlaceOrderParentView"];
            [defaults synchronize];
            PlaceOrderViewController *placeOrder = [self.storyboard instantiateViewControllerWithIdentifier:@"PlaceOrderViewController"];
            [self presentViewController:placeOrder animated:YES completion:nil];
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    arrayForSection = [self getSectionContentForSection:indexPath.section];
    static NSString *CellIdentifier = @"ChooseItemCustomTableViewCell";
    ChooseItemCustomTableViewCell *cell = [tableView
                                               dequeueReusableCellWithIdentifier:CellIdentifier
                                               forIndexPath:indexPath];
    currentDict = [arrayForSection objectAtIndex:indexPath.row];
    float cost = [[[[currentDict objectForKey:@"servings"]objectAtIndex:0]objectForKey:@"price"] floatValue]; // form loading DB
    
    cell.itemNameLabel.text = [currentDict objectForKey:@"name"];
    [cell.itemNameLabel setMinimumScaleFactor:12.0/[UIFont labelFontSize]];
    
    cell.itemCostLabel.text = [NSString stringWithFormat:@"$%.02f",cost];
    cell.cameraButton.tag=indexPath.row;
    cell.cameraButton.tintColor=[FAUtilities getUIColorObjectFromHexString:LIST_COUNT_SUBVIEW_BG_COLOR alpha:1];

    NSString *itemImagePath = [currentDict objectForKey:@"item_image"];
    
    if (itemImagePath.length == 0) {
        cell.cameraButton.hidden = YES;
    }else{
        cell.cameraButton.hidden = NO;
    }

    CGFloat descTextViewHeight = [self getHeightForText:[currentDict objectForKey:@"desc"]]+20;
    UITextView *itemDescTextView;
                itemDescTextView.text = @"";
    BOOL textViewAdded = NO;
    
    
    for(UIView * cellSubviews in cell.contentView.subviews){
        cellSubviews.userInteractionEnabled = NO;
        if ([cellSubviews isKindOfClass:[UITextView class]]){
            itemDescTextView = (UITextView *)cellSubviews;
            textViewAdded = NO;
            break;
        }else{
            textViewAdded = YES;
            continue;
        }
    }
    if (textViewAdded == YES) {
        [itemDescTextView removeFromSuperview];
        itemDescTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, descTextViewOriginY, descCellTextWidth,descTextViewHeight+10)];
        itemDescTextView.text = [currentDict objectForKey:@"desc"];
        NSLog(@"current dic:%@\n textVW:%@",currentDict,itemDescTextView.text);

        itemDescTextView.font= fontForCellText;
        itemDescTextView.editable = NO;
        itemDescTextView.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:itemDescTextView];
    }else{
        itemDescTextView.text = [currentDict objectForKey:@"desc"];
    }
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        cell.itemCostSubView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"pgm_iPadCell_CostBtn.png"]];
    }else{
        cell.itemCostSubView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"pgm_iPhone_costBtn.png"]];
        cell.itemCostSubView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    
    for(UIView * cellSubviews in cell.contentView.subviews){
        cellSubviews.userInteractionEnabled = NO;
    }
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [FAUtilities getUIColorObjectFromHexString:@"#E8E8EA" alpha:1];
    [cell setSelectedBackgroundView:bgColorView];

    indexValue=indexPath.section;

    cell.cameraButton.userInteractionEnabled=YES;
    [cell.cameraButton setImage:[UIImage imageNamed:@"Camera-50.png"] forState:UIControlStateNormal];
    [cell.cameraButton  addTarget:self action:@selector(cameraButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    return cell;

}

- (CGFloat)getHeightForText:(NSString *)strText{
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          fontForCellText, NSFontAttributeName,
                                          nil];
    
    CGRect frame = [strText boundingRectWithSize:CGSizeMake(descCellTextWidth, 2000.0)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:attributesDictionary
                                            context:nil];
    return frame.size.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    arrayForSection = [self getSectionContentForSection:indexPath.section];
    NSDictionary *currentDict = [arrayForSection objectAtIndex:indexPath.row];
    NSString *strText = [currentDict objectForKey:@"desc"];
    CGFloat cellHeight = defaultCellHeight + [self getHeightForText:strText]+10;
    return cellHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    arrayForSection = [self getSectionContentForSection:indexPath.section];
    NSString *catName = [[categoriesArray objectAtIndex:indexPath.section] objectForKey:@"name"];
    NSDictionary *currentDictinary = [arrayForSection objectAtIndex:indexPath.row];
    
    NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
    [defaults setObject:@"SRTableView" forKey:@"DishDetailsParentView"];
    [defaults synchronize];
 
    DishDetailsViewController *selectItem = [self.storyboard instantiateViewControllerWithIdentifier:@"DishDetailsViewController"];
    selectItem.itemDetailsDict = currentDictinary;
    selectItem.catgName = catName;
    UIViewController *sourceViewController = (UIViewController*)self;
    
    CATransition* transition = [CATransition animation];
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromRight;
    
    [selectItem.view.layer addAnimation:transition forKey:kCATransition];
    [sourceViewController presentViewController:selectItem animated:NO completion:nil];

}

// Everything below this is just to show how to use the different
// features of the SRExpandableTableViewController


- (IBAction)actionButtonPressed:(id)sender
{
    UIActionSheet *as = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Toggle Multi Expanded",@"Toggle Show Arrows", nil];
    [as setTag:0];
    [as showFromBarButtonItem:(UIBarButtonItem *)sender animated:YES];
}

- (void)cameraButtonPressed:(id)sender{
    UIButton *cameraBtn = (UIButton *)sender;
    NSString *catName = [[categoriesArray objectAtIndex:indexValue] objectForKey:@"name"];
    
    NSDictionary *selectedDic = [arrayForSection objectAtIndex:cameraBtn.tag];

    ShareDetailsViewController *selectItem = [self.storyboard instantiateViewControllerWithIdentifier:@"ShareDetailsViewController"];
    selectItem.itemDetailsDict = selectedDic;
    selectItem.categeriName = catName;
    UIViewController *sourceViewController = (UIViewController*)self;
    
    
    CATransition* transition = [CATransition animation];
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromRight;
    
    
    
    [selectItem.view.layer addAnimation:transition forKey:kCATransition];
    [sourceViewController presentViewController:selectItem animated:NO completion:nil];
}

#pragma mark - Action sheet delegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(actionSheet.tag == 0){
        // Action Button Pressed
        if(buttonIndex == 0){
            // Multi Expanded Pressed
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Select An Option:" message:@"Change whether the tableView can have only one section opened at a time or multiple." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Single",@"Multiple", nil];
            [av setTag:10];
            [av show];
        }else if(buttonIndex == 1){
            // Show Arrows Pressed
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Select An Option:" message:@"Change whether the section arrows are hidden or shown." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Show",@"Hide", nil];
            [av setTag:11];
            [av show];
        }
    }
}


-(void)refreshCart{
    NSMutableArray *itemsArray = [[NSMutableArray alloc]init];
    dbManager = [DataBaseManager dataBaseManager];
    [dbManager execute:[NSString stringWithFormat:@"SELECT * FROM OrderDetails where Quantity > '0'"] resultsArray:itemsArray];
    cartCountLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[itemsArray count]];
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


#pragma mark - Alert view delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 10){
        if(buttonIndex == 1){
            [self setMultiExpanded:NO];
        }else if(buttonIndex == 2){
            [self setMultiExpanded:YES];
        }
    }
    
    if(alertView.tag == 11){
        // Show or Hide Arrows Option Selected
        if(buttonIndex == 1){
            // Show
            [self setArrowsHidden:NO];
        }else if(buttonIndex == 2){
            // Hide
            [self setArrowsHidden:YES];
        }
    }

}
@end
