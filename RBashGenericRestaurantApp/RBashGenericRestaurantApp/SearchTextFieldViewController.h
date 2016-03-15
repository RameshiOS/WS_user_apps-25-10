//
//  SearchTextFieldViewController.h
//  FuelAmerica
//
//  Created by Manulogix on 15/10/14.
//  Copyright (c) 2014 Manulogix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTextFieldViewController : UIViewController<UITextFieldDelegate>{
    UITextField *searchTextField;
    UIImageView *searchImage;
    UIView* popoverView;
    UIViewController *popVController;
    NSString *selectedControlType;
    
    
    UITextField *fromDateTextField;
    UITextField *toDateTextField;
    NSString*SearchByName;
    UIView *leftView1;
    UIView *leftView2;
    UIView *leftView3;
    
    NSString *detailTextSearch;
    
}

@property(nonatomic,retain)NSMutableDictionary *popOverDict;
@property(nonatomic,retain)UITableView *searchOptionListTableView;


-(id)initwithName:(NSString *)SearchName initWithDetailText:(NSString*)detailText popoverContent:(UIViewController*)popover columnType:(NSString *)controlType referenceId:(NSString *)refrenceIdValue;



@end
