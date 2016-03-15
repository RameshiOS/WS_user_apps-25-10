//
//  ShareDetailsViewController.h
//  RBashGenericRestaurantApp
//
//  Created by Ramesh on 3/7/15.
//  Copyright (c) 2015 Manulogix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBaseManager.h"
#import "UPStackMenu.h"

@interface ShareDetailsViewController : UIViewController<UPStackMenuDelegate>

{
    
    UIFont *numberBtnFont;
    UIFont *dynamicLabelsFont;
    DataBaseManager *dbManager;
    NSArray *itemSizes;

    IBOutlet UIScrollView *ShareDetailsScrollview;

    IBOutlet UIImageView *itemImageVW;
    IBOutlet UILabel *itemLabel;
    IBOutlet UITextView *itemTextVw;
     IBOutlet UILabel *catergerieLabel;

    IBOutlet UIView *addToCostSubView;
    IBOutlet UIView *addToOrderSubView;
    IBOutlet UILabel *countLabel;
    IBOutlet UIView *headerView;
    
    
    IBOutlet UIButton *addToCostBtn;
    
    
    IBOutlet UILabel *addToCostLabel;
    
    
    
    
    NSString *customAlertMessage;
    NSString *customAlertTitle;
    UIView *disableCustomAlertView;
   IBOutlet  UIView *shareView;
    
    
    UIImageView * itemImageView;
    
    UIView *parentTempView;
    
    UIView *contentView;
    UPStackMenu *stack;
    
    UPStackMenuItem *fbItem ;
    CGFloat shareViewWidth;
    CGFloat shareViewHeight;
    
}

@property(nonatomic,retain) NSDictionary *itemDetailsDict;
@property(nonatomic,retain) NSString *categeriName;

@property (strong, nonatomic) IBOutlet UIButton *addToOrderBtn;
- (IBAction)cartBtnClicked:(id)sender;
- (IBAction)addToOrderBtnClicked:(id)sender;
-(IBAction)backBtnClicked:(id)sender;

@end
