//
//  SearchTextFieldViewController.m
//  FuelAmerica
//
//  Created by Manulogix on 15/10/14.
//  Copyright (c) 2014 Manulogix. All rights reserved.
//

#import "SearchTextFieldViewController.h"

@implementation SearchTextFieldViewController
@synthesize popOverDict,searchOptionListTableView;

-(id)initwithName:(NSString *)SearchName initWithDetailText:(NSString*)detailText popoverContent:(UIViewController*)popover columnType:(NSString *)controlType referenceId:(NSString *)refrenceIdValue{
    
    if (self) {
        NSLog(@"%@",SearchName);
        selectedControlType = controlType;
        SearchByName = SearchName;
        detailTextSearch =detailText;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    
    searchTextField = [[UITextField alloc]init];
    searchTextField.frame = CGRectMake(20,50, 250, 40);
    [self textFieldValue:searchTextField withVal:nil];
    
    
    fromDateTextField = [[UITextField alloc]init];
    fromDateTextField.frame = CGRectMake(20,50, 250, 40);
    [self textFieldValue:fromDateTextField withVal:nil];
    
    
    toDateTextField = [[UITextField alloc]init];
    toDateTextField.frame = CGRectMake(20,130, 250, 40);
    [self textFieldValue:toDateTextField withVal:nil];
    
    //    searchTextField.text =detailTextSearch;
    
    
    
    popoverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300,500)];
    popVController.preferredContentSize = CGSizeMake(300,500);
    
    
    popoverView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:popoverView];
    
    if ([selectedControlType isEqualToString:@"Item Name"]) {
        
        UILabel*searchlbl = [[UILabel alloc]init];
        searchlbl.frame = CGRectMake(20,10, 250, 30);
        [popoverView addSubview:searchlbl];
        [popoverView addSubview:searchTextField];
        
        [self lableValues:searchlbl withValue:selectedControlType];
        
        if ([selectedControlType isEqualToString:@"Phone"]) {
            searchTextField.keyboardType = UIKeyboardTypePhonePad;
        }
        
    }else if ([selectedControlType isEqualToString:@"Date"]){
        UILabel*searchlbl = [[UILabel alloc]init];
        searchlbl.frame = CGRectMake(20,10, 250, 30);
        [self lableValues:searchlbl withValue:@"From Date"];
        
        UILabel*searchlbl1 = [[UILabel alloc]init];
        searchlbl1.frame = CGRectMake(20,90, 250, 30);
        [self lableValues:searchlbl1 withValue:@"To Date"];
        
        
        [popoverView addSubview:fromDateTextField];
        [popoverView addSubview:toDateTextField];
        
        [popoverView addSubview:searchlbl];
        [popoverView addSubview:searchlbl1];
        
    }
    // Do any additional setup after loading the view.
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.text != nil) {
        if (textField == searchTextField) {
            [popOverDict setValue:textField.text forKey:SearchByName];
        }else{
            NSString *fromDate = fromDateTextField.text;
            NSString *todate = toDateTextField.text;
            
            [popOverDict setValue:[NSString stringWithFormat:@"%@ to %@", fromDate, todate] forKey:SearchByName];
        }
    }
}


-(void)lableValues:(UILabel *)label withValue:(NSString *)val{
    if ([selectedControlType isEqualToString:@"Customer"]||[selectedControlType isEqualToString:@"Phone"]) {
        label.text =[NSString stringWithFormat:@"Searching By %@",val];
    }else{
        label.text =val;
        //        label.textAlignment = NSTextAlignmentCenter;
    }
    
    [label setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:20]];
    label.textColor = [UIColor colorWithRed:50.0f/255.0f green:116.0f/255.0f blue:168.0f/255.0f alpha:1];
}

- (IBAction)backButtonClick:(id)sender{
    [searchOptionListTableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [searchOptionListTableView reloadData];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender{
    NSLog(@"decelerate is NO");
    UIScrollView  *scrollView = (UIScrollView *)sender;
    
    if (scrollView.tag == 1000) {
        return;
    }
    
    float endScrolling = scrollView.contentOffset.y + scrollView.frame.size.height;
    
    if (endScrolling == scrollView.contentSize.height)
    {
        [self performSelector:@selector(loadMoreDataDelayed) withObject:nil afterDelay:1];
        //        NSLog(@"call more data request");
    }
}



-(void)textFieldValue:(UITextField *)textField withVal:(NSString *)val{
    textField.borderStyle = UITextBorderStyleLine;
    textField.delegate=self;
    textField.font = [UIFont fontWithName:@"Thonburi-Bold" size:20];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    UIImage*search = [UIImage imageNamed:@"pgm_search.png"];
    searchImage = [[UIImageView alloc]initWithImage:search];
    searchImage.frame = CGRectMake(2, 5, 30,30);
    [textField addSubview:searchImage];
    
    
    leftView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 35)];
    textField.leftView = leftView1;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    textField.text = detailTextSearch;
    
}




@end
