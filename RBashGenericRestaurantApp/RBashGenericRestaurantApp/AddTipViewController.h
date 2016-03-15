//
//  AddTipViewController.h
//  ThinkingCup
//
//  Created by Manulogix on 10/09/14.
//  Copyright (c) 2014 Manulogix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddTipViewController : UIViewController{
    IBOutlet UIView *tipValueSubView;
    IBOutlet UIView *tipPercentageSubView;
    IBOutlet UITextField *tipValueTextField;
    IBOutlet UITextField *tipPercentageTextField;
    IBOutlet UISwitch *tipSelectionSwitch;
    IBOutlet UIView *percentage1Subview;
    IBOutlet UIView *percentage2Subview;
    IBOutlet UIView *percentage3Subview;
    IBOutlet UIView *percentage4Subview;
    IBOutlet UIButton *percentage1SubviewBtn;
    IBOutlet UIButton *percentage2SubviewBtn;
    IBOutlet UIButton *percentage3SubviewBtn;
    IBOutlet UIButton *percentage4SubviewBtn;
    UIButton *doneButton;
    float currentPercentage;

    IBOutlet UILabel *dollorLabel;
    IBOutlet UILabel *percentLabel;
    IBOutlet UIView *headerView;


}


@property (nonatomic,retain) NSString *totalCostVal;
-(IBAction)backBtnClicked:(id)sender;
-(IBAction)percentage1SubviewBtnClicked:(id)sender;
-(IBAction)percentage2SubviewBtnClicked:(id)sender;
-(IBAction)percentage3SubviewBtnClicked:(id)sender;
-(IBAction)percentage4SubviewBtnClicked:(id)sender;
-(IBAction)switchValueChanged:(id)sender;
-(IBAction)noTipBtnClicked:(id)sender;

@end
