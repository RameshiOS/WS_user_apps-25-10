//
//  SRExampleTableViewController.h
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

#import <UIKit/UIKit.h>
#import "SRExpandableTableViewController.h"
#import "DataBaseManager.h"
#import "ChooseItemCustomTableViewCell.h"

@interface SRExampleTableViewController : SRExpandableTableViewController <UIActionSheetDelegate, UIAlertViewDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate>{
    UILabel *itemNameLabel;
    UITextField *itemDescTextField;
    UIView *itemCountCustomView;
    UILabel *itemCountLabel;
    NSMutableArray *categoriesAry;
    UILabel *cartCountLabel;
    DataBaseManager *dbManager;
    UIFont *fontForCellText;
    int descCellTextWidth;
    int defaultCellHeight;
    int descTextViewOriginY;
    
    UIView *disableCustomAlertView;
    NSString *customAlertMessage;
    NSString *customAlertTitle;
    

    NSMutableArray *categoriesArray;

    NSDictionary *currentDict;
    NSArray *arrayForSection;
    NSInteger  indexValue;
}

- (IBAction)actionButtonPressed:(id)sender;
@end
