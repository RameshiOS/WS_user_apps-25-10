//
//  AddTipViewController.m
//  ThinkingCup
//
//  Created by Manulogix on 10/09/14.
//  Copyright (c) 2014 Manulogix. All rights reserved.
//

#import "AddTipViewController.h"
#import "FAUtilities.h"

@interface AddTipViewController ()

@end

@implementation AddTipViewController
@synthesize totalCostVal;

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
    
    
    if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
        headerView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"pgm_HeaderLandscape.png"]];
        
    }else if(UIInterfaceOrientationIsPortrait(STATUSBAR_ORIENTATION)){
        
        headerView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"pgm_Header.png"]];
    }

    
     tipValueSubView.backgroundColor = [FAUtilities getUIColorObjectFromHexString:LIST_COUNT_SUBVIEW_BG_COLOR alpha:1];
    
    int cornerRadious;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        cornerRadious = 50;
    }else{
        cornerRadious = 30;
    }
    
    percentage1Subview.layer.cornerRadius = cornerRadious;
    percentage2Subview.layer.cornerRadius = cornerRadious;
    percentage3Subview.layer.cornerRadius = cornerRadious;
    percentage4Subview.layer.cornerRadius = cornerRadious;
    

    [self viewShadows:percentage1Subview];
    [self viewShadows:percentage2Subview];
    [self viewShadows:percentage3Subview];
    [self viewShadows:percentage4Subview];
    
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



-(void)viewShadows:(UIView *)currentView{
 
    [currentView.layer setBorderColor:[UIColor grayColor].CGColor];
    [currentView.layer setBorderWidth:1.5f];
    
    // drop shadow
    [currentView.layer setShadowColor:[UIColor whiteColor].CGColor];
    [currentView.layer setShadowOpacity:0.8];
    [currentView.layer setShadowRadius:3.0];
    [currentView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];

    
    
}



-(IBAction)backBtnClicked:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)makeActiveView:(UIView *)activeView WithBtn:(UIButton *)Btn{
    activeView.backgroundColor = [FAUtilities getUIColorObjectFromHexString:LIST_COUNT_SUBVIEW_BG_COLOR alpha:1];
    Btn.titleLabel.textColor = [UIColor whiteColor];
    [activeView.layer setBorderWidth:0.0f];
    [Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

}

-(void)makeNormalView:(UIView *)normalView withBtn:(UIButton *)Btn{
    [normalView.layer setBorderColor:[UIColor grayColor].CGColor];
    [normalView.layer setBorderWidth:1.5f];
    normalView.backgroundColor = [UIColor clearColor];
    Btn.titleLabel.textColor = [UIColor blackColor];

}


-(IBAction)percentage1SubviewBtnClicked:(id)sender{
    
    currentPercentage = 10;
    
    [self makeActiveView:percentage1Subview WithBtn:percentage1SubviewBtn];
    
    [self makeNormalView:percentage2Subview withBtn:percentage2SubviewBtn];
    [self makeNormalView:percentage3Subview withBtn:percentage3SubviewBtn];
    [self makeNormalView:percentage4Subview withBtn:percentage4SubviewBtn];

    

    [self calculateTip];
    if ([tipSelectionSwitch isOn]) {
        [tipValueTextField becomeFirstResponder];
    }else{
        [tipPercentageTextField becomeFirstResponder];
    }
}

-(IBAction)percentage2SubviewBtnClicked:(id)sender{
    
    currentPercentage = 15;

    
    
    [self makeActiveView:percentage2Subview WithBtn:percentage2SubviewBtn];
    
    [self makeNormalView:percentage1Subview withBtn:percentage1SubviewBtn];
    [self makeNormalView:percentage3Subview withBtn:percentage3SubviewBtn];
    [self makeNormalView:percentage4Subview withBtn:percentage4SubviewBtn];

    [tipValueTextField becomeFirstResponder];
    [self calculateTip];

    if ([tipSelectionSwitch isOn]) {
        [tipValueTextField becomeFirstResponder];
    }else{
        [tipPercentageTextField becomeFirstResponder];
    }

}

-(IBAction)percentage3SubviewBtnClicked:(id)sender{
    
    currentPercentage = 20;

    
    [self makeActiveView:percentage3Subview WithBtn:percentage3SubviewBtn];
    
    [self makeNormalView:percentage1Subview withBtn:percentage1SubviewBtn];
    [self makeNormalView:percentage2Subview withBtn:percentage2SubviewBtn];
    [self makeNormalView:percentage4Subview withBtn:percentage4SubviewBtn];

    
    [self calculateTip];

    if ([tipSelectionSwitch isOn]) {
        [tipValueTextField becomeFirstResponder];
    }else{
        [tipPercentageTextField becomeFirstResponder];
    }

}

-(IBAction)percentage4SubviewBtnClicked:(id)sender{
    
    currentPercentage = 25;

    
    
    [self makeActiveView:percentage4Subview WithBtn:percentage4SubviewBtn];
    
    [self makeNormalView:percentage1Subview withBtn:percentage1SubviewBtn];
    [self makeNormalView:percentage2Subview withBtn:percentage2SubviewBtn];
    [self makeNormalView:percentage3Subview withBtn:percentage3SubviewBtn];

    
    [self calculateTip];
 
    if ([tipSelectionSwitch isOn]) {
        [tipValueTextField becomeFirstResponder];
    }else{
        [tipPercentageTextField becomeFirstResponder];
    }
    

}


-(IBAction)switchValueChanged:(id)sender{
    
    if([sender isOn]){
        tipValueSubView.backgroundColor = [FAUtilities getUIColorObjectFromHexString:LIST_COUNT_SUBVIEW_BG_COLOR alpha:1];//9B6227//E79532
        tipPercentageSubView.backgroundColor = [FAUtilities getUIColorObjectFromHexString:@"DCDCDC" alpha:1];

        tipValueTextField.textColor = [UIColor whiteColor];
        tipValueTextField.userInteractionEnabled = YES;
        
        dollorLabel.textColor = [UIColor whiteColor];
        percentLabel.textColor = [UIColor darkGrayColor];
        
        tipPercentageTextField.textColor = [UIColor darkGrayColor];
        tipPercentageTextField.userInteractionEnabled = NO;
    } else{
        tipPercentageSubView.backgroundColor = [FAUtilities getUIColorObjectFromHexString:LIST_COUNT_SUBVIEW_BG_COLOR alpha:1];//E79532
        tipValueSubView.backgroundColor = [FAUtilities getUIColorObjectFromHexString:@"DCDCDC" alpha:1];
        tipPercentageTextField.textColor = [UIColor whiteColor];
        tipPercentageTextField.userInteractionEnabled = YES;
        tipValueTextField.textColor = [UIColor darkGrayColor];
        tipValueTextField.userInteractionEnabled = NO;

        dollorLabel.textColor = [UIColor darkGrayColor];
        percentLabel.textColor = [UIColor whiteColor];

    }
}



- (void)addButtonToKeyboard {
    // create custom button
    if (doneButton == nil) {
        doneButton  = [[UIButton alloc] initWithFrame:CGRectMake(0, 163, 106, 53)];
    }
    else {
        [doneButton setHidden:NO];
    }
    
    [doneButton addTarget:self action:@selector(doneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    // locate keyboard view
//    UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
    
    UIView* keyboard = nil;
    for(int i=0; i<[self.view.subviews count]; i++) {
        keyboard = [self.view.subviews objectAtIndex:i];
        // keyboard found, add the button
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2) {
            if([[keyboard description] hasPrefix:@"<UIPeripheralHost"] == YES)
                [keyboard addSubview:doneButton];
        } else {
            if([[keyboard description] hasPrefix:@"<UIKeyboard"] == YES)
                [keyboard addSubview:doneButton];
        }
    }
}
- (void)doneButtonClicked:(id)Sender {
    // Here we'll write our code to for button action
}




-(void)calculateTip{
    
    float totalCost = [totalCostVal floatValue];
    float percentVal = currentPercentage/100;
    float tipVal = totalCost * percentVal;
    tipValueTextField.text = [NSString stringWithFormat:@"%0.2f",tipVal];
    tipPercentageTextField.text = [NSString stringWithFormat:@"%0.2f",currentPercentage];
}


- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
    [defaults setObject:tipValueTextField.text forKey:@"CurrentTipValue"];
    [defaults synchronize];

    [self dismissViewControllerAnimated:YES completion:nil];

    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == tipValueTextField || textField == tipPercentageTextField){
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890."] invertedSet];
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
                    
                    
                    
                    
                    NSString *tempValStr = [NSString stringWithFormat:@"%@%@",textField.text,string];
                    
                    if(textField == tipPercentageTextField){
                        [self calculateTipFromTextFields:@"percentage" withStr:tempValStr];
                    }else if (textField == tipValueTextField){
                        [self calculateTipFromTextFields:@"value" withStr:tempValStr];
                    }

                    return [string isEqualToString:filtered];
                    return YES;
                }
            }
        }
    }
    
   

    return YES;
}


-(void)calculateTipFromTextFields:(NSString *)val withStr:(NSString *)textStr{
    float totalCost = [totalCostVal floatValue];
    if ([val isEqualToString:@"percentage"]) {
        float percentVal = [textStr floatValue]/100;
        float tipVal = totalCost * percentVal;
        tipValueTextField.text = [NSString stringWithFormat:@"%0.2f",tipVal];
    }else if([val isEqualToString:@"value"]){
        float tempVal = [textStr floatValue]*100;
        float tipPercent = tempVal/totalCost;
        tipPercentageTextField.text = [NSString stringWithFormat:@"%0.2f",tipPercent];
    }
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


-(IBAction)noTipBtnClicked:(id)sender{
    
    tipValueTextField.text= @"0.00";
    
    NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
    [defaults setObject:tipValueTextField.text forKey:@"CurrentTipValue"];
    [defaults synchronize];
    
    [self dismissViewControllerAnimated:YES completion:nil];

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
