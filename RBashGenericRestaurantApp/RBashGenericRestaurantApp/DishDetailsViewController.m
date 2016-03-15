//
//  DishDetailsViewController.m
//  ThinkingCup
//
//  Created by Manulogix on 01/09/14.
//  Copyright (c) 2014 Manulogix. All rights reserved.
//

#import "DishDetailsViewController.h"
#import "FAUtilities.h"
#import "LoginViewController.h"
#import "PlaceOrderViewController.h"
#import "SRExampleTableViewController.h"

#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"
#import <TwitterKit/TwitterKit.h>
#import <Twitter/Twitter.h>
#import <Pinterest/Pinterest.h>
@interface DishDetailsViewController ()
{
    Pinterest *pinterest;
}

@end

@implementation DishDetailsViewController
@synthesize itemDetailsDict;
@synthesize catgName;
@synthesize checkedIndexPath;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    
    if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
        headerView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"pgm_HeaderLandscape.png"]];
    }else if(UIInterfaceOrientationIsPortrait(STATUSBAR_ORIENTATION)){
        headerView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"pgm_Header.png"]];
        addToOrderSubView.backgroundColor=[FAUtilities getUIColorObjectFromHexString:ADD_TO_ORDER_VIEW_COLOR alpha:1.0];
    }
    
    
    
    selectedModifierAry = [[NSMutableArray alloc]init];
    sizeBtnSubView.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    sizeBtnSubView.layer.borderWidth = 2;
    sizeBtnSubView.layer.cornerRadius = 4;
    
    modifiersCostAry =  [[NSMutableArray alloc]init];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        numberBtnFont =[UIFont fontWithName:@"Thonburi" size:38];
        dynamicLabelsFont = [UIFont fontWithName:@"Thonburi" size:30];
        addToOrderCostSubView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"pgm_iPad_costLabel"]];
        itemCostSubView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"pgm_iPad_costBtn.png"]];
    }else{
        numberBtnFont =[UIFont fontWithName:@"Thonburi" size:26];
        dynamicLabelsFont = [UIFont fontWithName:@"Thonburi" size:20];
        addToOrderCostSubView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"pgm_iPhone_costLabel.png"]];
        itemCostSubView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"pgm_iPhone_costBtn.png"]];
    }
    itemName.text = [itemDetailsDict objectForKey:@"name"];
    itemDescTextView.text =[itemDetailsDict objectForKey:@"desc"];
    itemName.adjustsFontSizeToFitWidth=YES;
    [itemName setMinimumScaleFactor:12.0/[UIFont labelFontSize]];
    itemName.numberOfLines =0;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        origionY = 530;//530//670
        origionYForInstructions = 530;//530//670
    }else{
        origionY = 320;
        origionYForInstructions = 320;
    }
    
    int qtyBtnCornerRadious;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        qtyBtnCornerRadious =50;
    }else{
        qtyBtnCornerRadious =30;
    }
    
    qty1BtnSubView.layer.cornerRadius = qtyBtnCornerRadious;
    qty2BtnSubView.layer.cornerRadius = qtyBtnCornerRadious;
    qty3BtnSubView.layer.cornerRadius = qtyBtnCornerRadious;
    qtyPlusBtnSubView.layer.cornerRadius = qtyBtnCornerRadious;
    [qtyPlusBtnSubView.layer setBorderColor:[UIColor grayColor].CGColor];
    [qtyPlusBtnSubView.layer setBorderWidth:1.5f];
    
    // drop shadow
    [qtyPlusBtnSubView.layer setShadowColor:[UIColor whiteColor].CGColor];
    [qtyPlusBtnSubView.layer setShadowOpacity:0.8];
    [qtyPlusBtnSubView.layer setShadowRadius:3.0];
    [qtyPlusBtnSubView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    [qty1BtnSubView.layer setBorderColor:[UIColor grayColor].CGColor];
    [qty1BtnSubView.layer setBorderWidth:1.5f];
    
    // drop shadow
    [qty1BtnSubView.layer setShadowColor:[UIColor whiteColor].CGColor];
    [qty1BtnSubView.layer setShadowOpacity:0.8];
    [qty1BtnSubView.layer setShadowRadius:3.0];
    [qty1BtnSubView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    [qty2BtnSubView.layer setBorderColor:[UIColor grayColor].CGColor];
    [qty2BtnSubView.layer setBorderWidth:1.5f];
    
    // drop shadow
    [qty2BtnSubView.layer setShadowColor:[UIColor whiteColor].CGColor];
    [qty2BtnSubView.layer setShadowOpacity:0.8];
    [qty2BtnSubView.layer setShadowRadius:3.0];
    [qty2BtnSubView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    [qty3BtnSubView.layer setBorderColor:[UIColor grayColor].CGColor];
    [qty3BtnSubView.layer setBorderWidth:1.5f];
    
    // drop shadow
    [qty3BtnSubView.layer setShadowColor:[UIColor whiteColor].CGColor];
    [qty3BtnSubView.layer setShadowOpacity:0.8];
    [qty3BtnSubView.layer setShadowRadius:3.0];
    [qty3BtnSubView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    qty1BtnSubView.backgroundColor = [FAUtilities getUIColorObjectFromHexString:LIST_COUNT_SUBVIEW_BG_COLOR alpha:1];
    qty1Btn.titleLabel.textColor = [UIColor whiteColor];
    [qty1BtnSubView.layer setBorderWidth:0.0f];
    currentQuantity = 1;
    
    NSArray *optionsAry = [itemDetailsDict valueForKey:@"modifiers"];
    itemSizes = [itemDetailsDict valueForKey:@"servings"];
    
    if ([itemSizes count]>1) {
         [sizeBtn setTitle:@"Select A Size" forState:UIControlStateNormal];
    }else{
        [sizeBtn setTitle:[[itemSizes objectAtIndex:0]objectForKey:@"name"] forState:UIControlStateNormal];
        currentServingDict = [itemSizes objectAtIndex:0];
    }
    
    itemCost.text= [NSString stringWithFormat:@"$%@",[[itemSizes objectAtIndex:0]objectForKey:@"price"]];

    [self loadOptions:optionsAry];
    [self caluclateCost];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(applicationActive)
                                                name:UIApplicationDidBecomeActiveNotification
                                              object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myKeyboardWillHideHandler:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) myKeyboardWillHideHandler:(NSNotification *)notification {
    CGPoint point = CGPointMake(0, 0);
    [dishDeteailsScrollview setContentOffset:point animated:YES];
}


-(void)applicationActive{
    [self caluclateCost];
}

-(void)viewWillAppear:(BOOL)animated{
    isNumbersSubViewVisible = NO;
    [self refreshCart];
    [self performSelector:@selector(methodName) withObject:nil afterDelay:0.5];
}


-(void)methodName{
    dishDeteailsScrollview.contentSize = CGSizeMake(dishDeteailsScrollview.frame.size.width, spclInst.frame.origin.y+150);
}



-(void)loadOptions:(NSArray *)optionsAry{
    optionsListArray = optionsAry;
    
    for (int i=0; i<[optionsAry count]; i++) {
        NSDictionary *tempOptDict = [optionsAry objectAtIndex:i];
        NSString *minimunVal = [tempOptDict objectForKey:@"min"];
        NSString *mandatoryStr;
        
        if ([minimunVal intValue] >= 1) {
            mandatoryStr = @"*";
        }else{
            mandatoryStr = @"";
        }
        
        CGRect optionNameLabelFrame;
        CGRect optionDropDownViewFrame;
        CGRect optionDropDownBtnFrame;
        CGRect optionDropDownImgFrame;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            optionNameLabelFrame =CGRectMake(119, origionY, 531, 42);
            optionDropDownViewFrame = CGRectMake(119, optionNameLabelFrame.origin.y+ optionNameLabelFrame.size.height + 8, 531, 60);
            optionDropDownBtnFrame = CGRectMake(0, 0, 531, 60);
            optionDropDownImgFrame = CGRectMake(473, 7, 40, 40);
        }else{
            optionNameLabelFrame =CGRectMake(10, origionY, 320-20, 24);
            optionDropDownViewFrame = CGRectMake(10, optionNameLabelFrame.origin.y+ optionNameLabelFrame.size.height + 2, 296, 40);
            optionDropDownBtnFrame = CGRectMake(0, 0, 296, 40);
            optionDropDownImgFrame = CGRectMake(254, 7, 25, 25);
        }
        
        UILabel *optionNameLabel = [[UILabel alloc]initWithFrame:optionNameLabelFrame];
        optionNameLabel.text = [NSString stringWithFormat:@"%@%@",mandatoryStr,[tempOptDict objectForKey:@"name"]];
        optionNameLabel.font = dynamicLabelsFont;
        
        
        
        UIView *optionDropDownView = [[UIView alloc]initWithFrame:optionDropDownViewFrame];
        optionDropDownView.layer.borderColor = [[UIColor lightGrayColor]CGColor];
        optionDropDownView.layer.borderWidth = 2;
        optionDropDownView.layer.cornerRadius = 4;
        optionDropDownView.backgroundColor = [UIColor whiteColor];
        
        UIButton *optionDropDownBtn = [[UIButton alloc]initWithFrame:optionDropDownBtnFrame];
        optionDropDownBtn.tag = i;
        [optionDropDownBtn addTarget:self action:@selector(optionDropDownBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [optionDropDownBtn setTitle:@"Select An Option" forState:UIControlStateNormal];
        [optionDropDownBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        UIImageView *optionDropDownImg = [[UIImageView alloc]initWithFrame:optionDropDownImgFrame];
        optionDropDownImg.image = [UIImage imageNamed:@"pgm_downArrow.png"];
        optionDropDownImg.tag = i;

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(optionImageViewTap:)];
        [tap setNumberOfTapsRequired:1];
       
        [optionDropDownView addSubview:optionDropDownImg];
        [optionDropDownView addSubview:optionDropDownBtn];
        
        optionDropDownBtn.titleLabel.font = dynamicLabelsFont;
        origionY =  optionDropDownView.frame.size.height+ optionDropDownView.frame.origin.y+8;
        origionYForInstructions = optionDropDownView.frame.size.height+ optionDropDownView.frame.origin.y+10;
        [dishDeteailsScrollview addSubview:optionNameLabel];
        [dishDeteailsScrollview addSubview:optionDropDownView];
    }
    
    CGRect spclInstructionsLabelFrame;
    CGRect spclInstTextFieldFrame;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        spclInstructionsLabelFrame = CGRectMake(119, origionYForInstructions, 531, 42);
        spclInstTextFieldFrame = CGRectMake(119, spclInstructionsLabelFrame.origin.y+spclInstructionsLabelFrame.size.height+8, 531, 120);
    }else{
        spclInstructionsLabelFrame = CGRectMake(10, origionYForInstructions, 320-20, 40);
        spclInstTextFieldFrame = CGRectMake(10, spclInstructionsLabelFrame.origin.y+spclInstructionsLabelFrame.size.height+2, 320-20, 80);
    }
    
    UILabel *spclInstructionsLabel = [[UILabel alloc]initWithFrame:spclInstructionsLabelFrame];
    spclInstructionsLabel.text = @"Any Special Instructions?";
    spclInstructionsLabel.font = dynamicLabelsFont;
    
    spclInst = [[UITextView alloc]initWithFrame:spclInstTextFieldFrame];
    spclInst.layer.borderColor = [[UIColor grayColor]CGColor];
    spclInst.layer.borderWidth = 2;
    spclInst.font = dynamicLabelsFont;
    
    [spclInst setReturnKeyType:UIReturnKeyDone];
    spclInst.delegate = self;
    [dishDeteailsScrollview addSubview:spclInstructionsLabel];
    [dishDeteailsScrollview addSubview:spclInst];
    dishDeteailsScrollview.contentSize = CGSizeMake(dishDeteailsScrollview.frame.size.width, spclInst.frame.origin.y+150);
}


- (void)optionImageViewTap:(UIGestureRecognizer *)sender{
    [self.view endEditing:YES];
    UIView *view = sender.view; //cast pointer to the derived class if needed
    currentDropDownBtnTag = (int)view.tag;
    [self loadOptionDropDown];
}


-(IBAction)sizeBtnClicked:(id)sender{
    [self loadTableViewWithValues:itemSizes withValue:@"sizes" withMinVal:@"" withMaxVal:@"" withHeading:@"Select A Size"];
}



-(void)loadCustomTable:(NSArray *)arrayVals withValue:(NSString *)val{
    
    currentCustomTableViewArray = arrayVals;
    currentTableVal = val;
    UITableView *customDropDownTableView = [[UITableView alloc]init];
    customDropDownTableView.delegate = self;
    customDropDownTableView.dataSource = self;
    customDropDownTableView.tag = 500;
    
    if (isCustomDropDownVisible == NO) {
        CGRect tableFrame;
        if ([val isEqualToString:@"sizes"]) {
            tableFrame = CGRectMake(10, 264, 300, 0);
        }else{
            tableFrame = CGRectMake(10, 264, 300, 0);
        }
        
        customDropDownTableView.frame = tableFrame;
        [dishDeteailsScrollview addSubview:customDropDownTableView];
        
        tableFrame.size.height = 200; // give any value for display yourView
        [UIView animateWithDuration:0.75f
                         animations:^{
                             customDropDownTableView.frame = tableFrame;
                             [dishDeteailsScrollview addSubview:customDropDownTableView];
                         }
         ];
        isCustomDropDownVisible = YES;
        [customDropDownTableView reloadData];
        
    }else if(isCustomDropDownVisible == YES){
        
        CGRect frame = customDropDownTableView.frame;
        frame.size.height = 0; // give any value for display yourView
        
        [UIView animateWithDuration:0.75
                         animations:^{
                             customDropDownTableView.frame = frame;
                         }
                         completion:^(BOOL finished){
                             for (UIView *subView in dishDeteailsScrollview.subviews) {
                                 if (subView.tag ==500) {
                                     [subView removeFromSuperview];
                                 }
                             }
                             [customDropDownTableView removeFromSuperview];
                         }
         ];
        isCustomDropDownVisible = NO;
    }
}

- (void)optionsCloseBtn:(id)sender{
    [diabledview removeFromSuperview];
    [self performSelector:@selector(methodName) withObject:nil afterDelay:0.2];
}


-(void)loadTableViewWithValues:(NSArray*)arrayVals withValue:(NSString *)val withMinVal:(NSString *)minVal withMaxVal:(NSString *)maxVal withHeading:(NSString *)heading{
    currentTableVal = val;
    
    currentOptionsMinVal= minVal;
    currentOptionsMaxVal= maxVal;
    
    currentCustomTableViewArray = arrayVals;
    
    diabledview = [[UIView alloc]initWithFrame:self.view.bounds];
    diabledview.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pgm_gallery.png"]];
    diabledview.tag = 500;
    
    UIButton *disabledBtn = [[UIButton alloc]initWithFrame:diabledview.frame];
    [disabledBtn addTarget:self
                    action:@selector(optionsCloseBtn:)
          forControlEvents:UIControlEventTouchUpInside];
    
    [diabledview addSubview:disabledBtn];
    
    CGRect tableSubViewFrame;
    CGRect headingViewFrame;
    CGRect headingLabelFrame;
    UIFont *headingLabelFont;
    
    CGRect doneBtnFrame;
    CGRect customTableviewFrame;
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
            tableSubViewFrame =CGRectMake(237, 84, 550, 600);
            currentSubviewMode = @"Landscape";
        }else if(UIInterfaceOrientationIsPortrait(STATUSBAR_ORIENTATION)){
            tableSubViewFrame =CGRectMake(109, 212, 550, 600);
            currentSubviewMode = @"Portrait";
        }
        
        headingViewFrame = CGRectMake(0, 0, tableSubViewFrame.size.width, 60);
        headingLabelFrame = CGRectMake(8, 5, headingViewFrame.size.width-100, 50);
        headingLabelFont = [UIFont fontWithName:@"Thonburi" size:32];
        doneBtnFrame = CGRectMake(headingLabelFrame.origin.x+headingLabelFrame.size.width-10, 5, 100, 50);
        customTableviewFrame = CGRectMake(0, headingViewFrame.origin.y+headingViewFrame.size.height, headingViewFrame.size.width, tableSubViewFrame.size.height-60);
    }else{
        tableSubViewFrame =CGRectMake(20, 100, 320-40, 350);
        headingViewFrame = CGRectMake(0, 0, tableSubViewFrame.size.width, 50);
        headingLabelFrame = CGRectMake(8, 5, headingViewFrame.size.width-60, 40);
        headingLabelFont = [UIFont fontWithName:@"Thonburi" size:20];
        doneBtnFrame = CGRectMake(headingLabelFrame.origin.x+headingLabelFrame.size.width-10, 5, 60, 40);
        customTableviewFrame = CGRectMake(0, headingViewFrame.origin.y+headingViewFrame.size.height, headingViewFrame.size.width, 300);
    }
    UIView *tableSubView = [[UIView alloc]initWithFrame:tableSubViewFrame];
    tableSubView.backgroundColor = [FAUtilities getUIColorObjectFromHexString:@"F9F9F9" alpha:1];
    tableSubView.tag = 501;
    
    UIView *headingView = [[UIView alloc]initWithFrame:headingViewFrame];
    headingView.backgroundColor = [FAUtilities getUIColorObjectFromHexString:APP_HEADER_COLOR alpha:1];
    headingLabel = [[UILabel alloc]initWithFrame:headingLabelFrame];
    headingLabel.textColor = [UIColor whiteColor];
    headingLabel.font = headingLabelFont;
    
    if ([currentTableVal isEqualToString:@"sizes"]) {
        headingLabel.text = heading;
    }else{
        headingLabel.text = heading;
    }
    
    UIButton *doneBtn = [[UIButton alloc]initWithFrame:doneBtnFrame];
    [doneBtn setTitle:@"Done" forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(doneBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    doneBtn.titleLabel.font = headingLabelFont;
    
    
    [headingView addSubview:headingLabel];
    [headingView addSubview:doneBtn];
    
    customTableview = [[UITableView alloc]initWithFrame:customTableviewFrame];
    customTableview.backgroundColor = [UIColor clearColor];
    customTableview.delegate = self;
    customTableview.dataSource = self;
    [customTableview reloadData];
    [tableSubView addSubview:customTableview];
    [tableSubView addSubview:headingView];
    [diabledview addSubview:tableSubView];
    [self.view addSubview:diabledview];
}

#pragma mark
#pragma mark TableView Datasource
/* number of sections in form list record table */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

/* number of rows in form list record table based on records saved in database */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [currentCustomTableViewArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [customTableview dequeueReusableCellWithIdentifier:@"MyIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyIdentifier"];
    }
    NSDictionary *sizesDict;
    NSDictionary *optionsDict;
    
    
    if ([currentTableVal isEqualToString:@"sizes"]) {
        sizesDict = [currentCustomTableViewArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@($%@)",[sizesDict objectForKey:@"name"],[sizesDict objectForKey:@"price"]];
     
        // loading from DB
        if ([currentCustomTableViewArray count]>1) {
            if([self.checkedIndexPath isEqual:indexPath]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }else{
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }else{
            if(indexPath.row == selectedIndex){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }else{
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
    }else{
        NSArray *tempSelectedAry;
        
        for (int i=0; i<[selectedModifierAry count]; i++) {
            NSDictionary *tempSelectedDict = [selectedModifierAry objectAtIndex:i];
            tempSelectedAry = [tempSelectedDict objectForKey:[NSString stringWithFormat:@"%@",headingLabel.text]];
            
            if (tempSelectedAry.count ==0) {
                continue;
            }else{
                break;
            }
        }
        
        
        optionsDict = [currentCustomTableViewArray objectAtIndex:indexPath.row];
        BOOL isCheckCell= NO;
        
        for (int j=0; j<[tempSelectedAry count]; j++) {
            NSDictionary *tempOptionDict = [tempSelectedAry objectAtIndex:j];
            NSString *optionName = [tempOptionDict objectForKey:@"name"];
            if ([optionName isEqualToString:[optionsDict objectForKey:@"name"]]) {
                isCheckCell = YES;
                break;
            }else{
                isCheckCell = NO;
                continue;
            }
        }
        
        if (isCheckCell == YES) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [selectedOptionsAry addObject:optionsDict];
        }
        
        
        
        BOOL isSelectedCheckCell = NO;
        
        for (int i=0; i<[selectedOptionsAry count]; i++) {
            NSDictionary *tempDict = [selectedOptionsAry objectAtIndex:i];

            if ([[tempDict objectForKey:@"name"] isEqualToString:[optionsDict objectForKey:@"name"]]){
                isSelectedCheckCell = YES;
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                break;
            }else{
                isSelectedCheckCell = NO;
                continue;
            }
        }
        
        if (isSelectedCheckCell == NO) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }

        NSString *tempOptionPrice = [optionsDict objectForKey:@"price"];
        float optionPriceVal = [tempOptionPrice floatValue];
        
        NSString *optionVal;
        if (optionPriceVal <= 0.00) {
            optionVal = @"";
        }else{
            optionVal = [NSString stringWithFormat:@"%0.2f",optionPriceVal];
        }
        
        NSString *optionValStr;
        
        if (optionVal.length > 0) {
            optionValStr = [NSString stringWithFormat:@"%@($%@)",[optionsDict objectForKey:@"name"],[optionsDict objectForKey:@"price"]];
        }else{
            optionValStr = [NSString stringWithFormat:@"%@",[optionsDict objectForKey:@"name"]];
            
        }
        cell.textLabel.text = optionValStr;
    }
    
    cell.textLabel.textColor = [UIColor blackColor];
    UIFont *cellFont ;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        cellFont =[UIFont fontWithName:@"Thonburi" size:30];
    }else{
        cellFont =[UIFont fontWithName:@"Thonburi" size:18];
    }
    
    cell.textLabel.font = cellFont;
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [FAUtilities getUIColorObjectFromHexString:@"000000" alpha:0.3];
    cell.selectedBackgroundView = bgColorView;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    float cellHeight;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        cellHeight=60;
    }else{
        cellHeight=44;
    }
    
    return cellHeight;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath {
    NSDictionary *sizesDict;
    NSDictionary *optionsDict;
    
    if ([currentTableVal isEqualToString:@"sizes"]) {
        
        
        
        sizesDict = [currentCustomTableViewArray objectAtIndex:indexPath.row];
        /* loading from service
         [sizeBtn setTitle:[sizesDict objectForKey:@"name"] forState:UIControlStateNormal];
         itemCost.text= [NSString stringWithFormat:@"$%@",[sizesDict objectForKey:@"price"]];
         */
        
      
        
        if ([currentCustomTableViewArray count]>1) {
            if(self.checkedIndexPath)
            {
                UITableViewCell* uncheckCell = [tableView
                                                cellForRowAtIndexPath:self.checkedIndexPath];
                uncheckCell.accessoryType = UITableViewCellAccessoryNone;
            }
            if([self.checkedIndexPath isEqual:indexPath])
            {
                self.checkedIndexPath = nil;
            }
            else
            {
                UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                self.checkedIndexPath = indexPath;
                currentServingDict = sizesDict;
            }
        }
        else
        {
        selectedIndex = indexPath.row;
        currentServingDict = sizesDict;
            //        loading from DB
            [sizeBtn setTitle:[sizesDict objectForKey:@"name"] forState:UIControlStateNormal];
            itemCost.text= [NSString stringWithFormat:@"$%@",[sizesDict objectForKey:@"price"]];
            
            
            
        }
        [customTableview reloadData];
        
    }else{
        optionsDict = [currentCustomTableViewArray objectAtIndex:indexPath.row];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if (cell.accessoryType == UITableViewCellAccessoryNone) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [selectedOptionsAry addObject:optionsDict];
            [selectedOptionsIndexPathAry addObject:indexPath];
        }else {
            cell.accessoryType = UITableViewCellAccessoryNone;
            [selectedOptionsAry removeObject:optionsDict];
            [selectedOptionsIndexPathAry removeObject:indexPath];
        }
    }
}

-(void)doneBtnClicked:(id)sender{
    [self performSelector:@selector(methodName) withObject:nil afterDelay:0.5];
    
    if ([currentTableVal isEqualToString:@"sizes"]) {
        
        
        if ([currentCustomTableViewArray count]>1) {
        if (self.checkedIndexPath == nil) {
             customAlertMessage = [NSString stringWithFormat:@"Please select at least 1 size"];
            customAlertTitle = @"Alert";
            [self LoadCustomAlertWithMessage];
        }
        
        else if (self.checkedIndexPath != nil)
        {
               [sizeBtn setTitle:[currentServingDict objectForKey:@"name"] forState:UIControlStateNormal];
            itemCost.text= [NSString stringWithFormat:@"$%@",[currentServingDict objectForKey:@"price"]];
            
            
            [diabledview removeFromSuperview];
        }
      
        }
        else
        {
            
            [diabledview removeFromSuperview];
        }
        
    }else{
        
        if ( [currentOptionsMinVal intValue] >0 && selectedOptionsAry.count < [currentOptionsMinVal intValue]) {
            
            
            
            if ([currentOptionsMinVal intValue] == 1) {
                customAlertMessage = [NSString stringWithFormat:@"Please select at least %@ item",currentOptionsMinVal];
            }else{
                customAlertMessage = [NSString stringWithFormat:@"Please select %@ items",currentOptionsMinVal];
            }
            
            //            customAlertMessage = [NSString stringWithFormat:@"Please add %@ values",currentOptionsMinVal];
            customAlertTitle = @"Alert";
            [self LoadCustomAlertWithMessage];
        }else if ([currentOptionsMaxVal intValue] > 0 && selectedOptionsAry.count > [currentOptionsMaxVal intValue]){
            customAlertMessage = [NSString stringWithFormat:@"You can not select more than %@ items",currentOptionsMaxVal];
            customAlertTitle = @"Alert";
            [self LoadCustomAlertWithMessage];
        }else{
            float modifierCost = 0.0;
            NSMutableString *tempOptStr = [[NSMutableString alloc]init];
            for (int i=0; i<[selectedOptionsAry count]; i++) {
                NSDictionary *tempDict = [selectedOptionsAry objectAtIndex:i];
                
                // for service data
                //                NSString *cost = [tempDict objectForKey:@"price"];
                // from local DB
                
                NSString *cost = [tempDict objectForKey:@"price"];
                
                
                modifierCost = modifierCost + [cost floatValue];
                // form service data
                //                [tempOptStr appendString:[NSString stringWithFormat:@"%@,",[tempDict objectForKey:@"name"]]];
                // from loacl DB
                [tempOptStr appendString:[NSString stringWithFormat:@"%@,",[tempDict objectForKey:@"name"]]];
            }
            
            NSMutableDictionary *singleModifierDict = [[NSMutableDictionary alloc]init];
            [singleModifierDict setObject:[NSString stringWithFormat:@"%f",modifierCost] forKey:@"ModifierCost"];
            [singleModifierDict setObject:[[optionsListArray objectAtIndex:currentDropDownBtn.tag] objectForKey:@"id"] forKey:@"ModifierID"];
            [singleModifierDict setObject:selectedOptionsAry forKey:@"ModifierOptions"];
            
            NSString *modifierID;
            
            NSMutableArray *tempModifiersCostAry = [modifiersCostAry mutableCopy];
            
            for (NSDictionary *dict in modifiersCostAry)
            {
                modifierID = [NSString stringWithFormat:@"%@",[[optionsListArray objectAtIndex:currentDropDownBtn.tag] objectForKey:@"id"]];
                NSString *dictModifierID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"ModifierID"]];
                if ([modifierID isEqualToString:dictModifierID])
                {
                    [tempModifiersCostAry removeObject:dict];
                }
            }
            
            modifiersCostAry = [tempModifiersCostAry mutableCopy];
            [modifiersCostAry addObject:singleModifierDict];
            
            if (tempOptStr.length !=0) {
                NSString *tempStr = tempOptStr;
                tempStr = [tempStr substringToIndex:[tempStr length] - 1];
                [currentDropDownBtn setTitle:tempStr forState:UIControlStateNormal];
            }else{
                NSDictionary *tempDict = [optionsListArray objectAtIndex:currentDropDownBtn.tag];
                NSLog(@"tempDict %@",tempDict);
                [currentDropDownBtn setTitle:@"Select An Option" forState:UIControlStateNormal];
            }
            
            
            for (int i=0; i<[selectedModifierAry count]; i++) {
                NSArray *tempAry1 = [itemDetailsDict objectForKey:@"modifiers"];
                NSString *tempID = [[tempAry1 objectAtIndex:currentDropDownBtn.tag] objectForKey:@"Name"];
                NSDictionary *tempDict = [selectedModifierAry objectAtIndex:i];
                NSArray *tempAry = [tempDict objectForKey:tempID];
                if (tempAry.count !=0) {
                    [selectedModifierAry removeObjectAtIndex:i];
                }
            }
            
            NSArray *tempAry = [itemDetailsDict objectForKey:@"modifiers"];
            
            NSString *tempID = [[tempAry objectAtIndex:currentDropDownBtn.tag] objectForKey:@"name"];
            
            NSMutableDictionary *tempValuesDict = [[NSMutableDictionary alloc]init];
            
            [tempValuesDict setObject:selectedOptionsAry forKey:[NSString stringWithFormat:@"%@",tempID]];
            
            
            NSString *deletedDictKey = [NSString stringWithFormat:@"%@",tempID];
            
            for (int index=0; index<[selectedModifierAry count]; index++) {
                NSDictionary *tempDict  = [selectedModifierAry objectAtIndex:index];
                
                NSArray *tempAry =[tempDict objectForKey:deletedDictKey];
                
                if (tempAry.count > 0) {
                    [selectedModifierAry removeObjectAtIndex:index];
                }
                
            }
            
            [selectedModifierAry addObject:tempValuesDict];
            
            
            [diabledview removeFromSuperview];
            
            
            
        }
    }
    [self caluclateCost];
}


-(float)caluclateCost{
    float modifiersCost = 0.0;
    
    float allModifiersTax =0.0;
    NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
    NSString *salesTax = [defaults objectForKey:@"salestax"];
    
    
    for (int i=0; i<[modifiersCostAry count]; i++) {
        NSDictionary *tempDict = [modifiersCostAry objectAtIndex:i];
        NSArray *modifierOptions = [tempDict objectForKey:@"ModifierOptions"];
        
        float allOptionsTax = 0.0;
        
        for (int j=0; j<[modifierOptions count]; j++) {
            float curentOptionTax = 0.0;
            
            NSDictionary *tempOptionsDict = [modifierOptions objectAtIndex:j];
            
//            NSString *tempModifierOptionCost = [tempOptionsDict objectForKey:@"price"];
            NSString *tempModifierOptionCost = [tempOptionsDict objectForKey:@"price"];
//            NSString *isTaxAvailable = [NSString stringWithFormat:@"%@",[tempOptionsDict objectForKey:@"is_tax"]];
            NSString *isTaxAvailable = [NSString stringWithFormat:@"%@",[tempOptionsDict objectForKey:@"is_tax"]];
            float optionCost = [tempModifierOptionCost floatValue];
            
            if ([isTaxAvailable isEqualToString:@"1"]) {
                
                float salesTaxFloatVal = [salesTax floatValue];
                float salesTaxValue = (optionCost * salesTaxFloatVal)/ 100;
                
                curentOptionTax = salesTaxValue;
                
            }else{
                curentOptionTax = 0.0;
            }
            
            allOptionsTax = allOptionsTax + curentOptionTax;
        }
        
        allModifiersTax = allModifiersTax + allOptionsTax;
        
        
    }
    
    
    
    
    NSString *tempCost = [itemCost.text substringFromIndex:1];
    
    float salesTaxFloatVal = [salesTax floatValue];
    
    
//    NSString *isItemTaxAvailable = [NSString stringWithFormat:@"%@",[currentServingDict objectForKey:@"is_tax"]];
    NSString *isItemTaxAvailable = [NSString stringWithFormat:@"%@",[currentServingDict objectForKey:@"is_tax"]];
    float itemSalesTaxValue;
    
    
    if ([isItemTaxAvailable isEqualToString:@"1"]) {
        itemSalesTaxValue = ([tempCost floatValue] * salesTaxFloatVal)/ 100;
    }else{
        itemSalesTaxValue = 0.0;
    }
    
    
    //    float itemSalesTaxValue = ([tempCost floatValue] * salesTaxFloatVal)/ 100;
    
    
    allTaxes = allModifiersTax + itemSalesTaxValue;
    
    
    
    for (int i=0; i<[modifiersCostAry count]; i++) {
        NSDictionary *tempDict = [modifiersCostAry objectAtIndex:i];
        NSString *tempModifierCost = [tempDict objectForKey:@"ModifierCost"];
        modifiersCost = modifiersCost + [tempModifierCost floatValue];
    }
    
    float itemCostWithModifiers = [tempCost floatValue] + modifiersCost;
    float totalCost = itemCostWithModifiers *currentQuantity;
    
    addToOrderCostLabel.text  = [NSString stringWithFormat:@"$%0.2f",totalCost];
    return  totalCost;
}



-(IBAction)bgButtonClick:(id)sender{
    [self.view endEditing:YES];
    dishDeteailsScrollview.contentSize = CGSizeMake(dishDeteailsScrollview.frame.size.width, spclInst.frame.origin.y+150);
    
}

-(void)optionDropDownBtnClicked:(id)sender{
    
    [self.view endEditing:YES];
    currentDropDownBtn = (UIButton*)sender;
    
    currentDropDownBtnTag =currentDropDownBtn.tag;
    
    [self loadOptionDropDown];
}


-(void)loadOptionDropDown{
    selectedOptionsAry = [[NSMutableArray alloc]init];
    selectedOptionsIndexPathAry = [[NSMutableArray alloc]init];
    
    
    
    NSDictionary *tempDictionary = [optionsListArray objectAtIndex:currentDropDownBtnTag];
    
    NSArray *tempTableviewAry = [tempDictionary objectForKey:@"options"];
    NSString *minValue = [tempDictionary objectForKey:@"min"];
    NSString *maxValue = [tempDictionary objectForKey:@"max"];
    
    
    
    [self loadTableViewWithValues:tempTableviewAry withValue:@"options" withMinVal:minValue withMaxVal:maxValue withHeading:[tempDictionary objectForKey:@"name"]];
    
}

-(IBAction)qty1BtnClicked:(id)sender{
    [self performSelector:@selector(methodName) withObject:nil afterDelay:0.5];
    
    qty1BtnSubView.backgroundColor = [FAUtilities getUIColorObjectFromHexString:LIST_COUNT_SUBVIEW_BG_COLOR alpha:1];
    qty1Btn.titleLabel.textColor = [UIColor whiteColor];
    [qty1BtnSubView.layer setBorderWidth:0.0f];
    [qty1Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    currentQuantity = 1;
    
    [self normalQty2Btn];
    [self normalQty3Btn];
    
    [qtyPlusBtnSubView.layer setBorderColor:[UIColor grayColor].CGColor];
    [qtyPlusBtnSubView.layer setBorderWidth:1.5f];
    qtyPlusBtnSubView.backgroundColor = [UIColor clearColor];
    qtyPlusBtn.titleLabel.textColor = [UIColor blackColor];
    [qtyPlusBtn setTitle:@"Plus" forState:UIControlStateNormal];
    
    [qtyPlusBtn setImage:[UIImage imageNamed:@"pgm_plusBtn.png"] forState:UIControlStateNormal];
    
    
    if (isNumbersSubViewVisible == YES) {
        [self qtyPlusBtnClicked:nil];
    }
    
    [self caluclateCost];
    
    
}

-(IBAction)qty2BtnClicked:(id)sender{
    [self performSelector:@selector(methodName) withObject:nil afterDelay:0.5];
    
    qty2BtnSubView.backgroundColor = [FAUtilities getUIColorObjectFromHexString:LIST_COUNT_SUBVIEW_BG_COLOR alpha:1];
    qty2Btn.titleLabel.textColor = [UIColor whiteColor];
    [qty2BtnSubView.layer setBorderWidth:0.0f];
    [qty2Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    currentQuantity = 2;
    
    
    [self normalQty1Btn];
    [self normalQty3Btn];
    
    [qtyPlusBtnSubView.layer setBorderColor:[UIColor grayColor].CGColor];
    [qtyPlusBtnSubView.layer setBorderWidth:1.5f];
    qtyPlusBtnSubView.backgroundColor = [UIColor clearColor];
    qtyPlusBtn.titleLabel.textColor = [UIColor blackColor];
    [qtyPlusBtn setTitle:@"Plus" forState:UIControlStateNormal];
    
    [qtyPlusBtn setImage:[UIImage imageNamed:@"pgm_plusBtn.png"] forState:UIControlStateNormal];
    if (isNumbersSubViewVisible == YES) {
        [self qtyPlusBtnClicked:nil];
    }
    
    [self caluclateCost];
    
}

-(IBAction)qty3BtnClicked:(id)sender{
    [self performSelector:@selector(methodName) withObject:nil afterDelay:0.5];
    
    qty3BtnSubView.backgroundColor = [FAUtilities getUIColorObjectFromHexString:LIST_COUNT_SUBVIEW_BG_COLOR alpha:1];
    qty3Btn.titleLabel.textColor = [UIColor whiteColor];
    [qty3BtnSubView.layer setBorderWidth:0.0f];
    [qty3Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    currentQuantity = 3;
    
    
    [self normalQty1Btn];
    [self normalQty2Btn];
    
    [qtyPlusBtnSubView.layer setBorderColor:[UIColor grayColor].CGColor];
    [qtyPlusBtnSubView.layer setBorderWidth:1.5f];
    qtyPlusBtnSubView.backgroundColor = [UIColor clearColor];
    qtyPlusBtn.titleLabel.textColor = [UIColor blackColor];
    
    [qtyPlusBtn setTitle:@"Plus" forState:UIControlStateNormal];
    
    [qtyPlusBtn setImage:[UIImage imageNamed:@"pgm_plusBtn.png"] forState:UIControlStateNormal];
    
    if (isNumbersSubViewVisible == YES) {
        [self qtyPlusBtnClicked:nil];
    }
    
    [self caluclateCost];
    
}


-(IBAction)sunViewQtyBtnClicked:(id)sender{
    
    
    UIButton *qtyBtn = (UIButton *)sender;
    
    [self performSelector:@selector(methodName) withObject:nil afterDelay:0.5];
    
    
    qtyPlusBtnSubView.backgroundColor = [FAUtilities getUIColorObjectFromHexString:LIST_COUNT_SUBVIEW_BG_COLOR alpha:1];
    qtyPlusBtn.titleLabel.textColor = [UIColor whiteColor];
    [qtyPlusBtnSubView.layer setBorderWidth:0.0f];
    [qtyPlusBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [qtyPlusBtn setTitle:[NSString stringWithFormat:@"%ld",(long)qtyBtn.tag] forState:UIControlStateNormal];
    [qtyPlusBtn setImage:nil forState:UIControlStateNormal];
    qtyPlusBtn.titleLabel.font = numberBtnFont;
    
    
    currentQuantity = (int)qtyBtn.tag;
    
    [self normalQty1Btn];
    [self normalQty2Btn];
    [self normalQty3Btn];
    
    
    [self qtyPlusBtnClicked:nil];
    [self caluclateCost];
    
    
}


-(void)valGoBtnClicked:(id)sender{
    [self performSelector:@selector(methodName) withObject:nil afterDelay:0.5];
    
    if (valLabel.text.length ==0) {
        customAlertMessage = @"Enter a value";
        customAlertTitle = @"Alert";
        [self LoadCustomAlertWithMessage];
    }else{
        qtyPlusBtnSubView.backgroundColor = [FAUtilities getUIColorObjectFromHexString:LIST_COUNT_SUBVIEW_BG_COLOR alpha:1];
        qtyPlusBtn.titleLabel.textColor = [UIColor whiteColor];
        [qtyPlusBtnSubView.layer setBorderWidth:0.0f];
        [qtyPlusBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [qtyPlusBtn setTitle:valLabel.text forState:UIControlStateNormal];
        [qtyPlusBtn setImage:nil forState:UIControlStateNormal];
        qtyPlusBtn.titleLabel.font = numberBtnFont;
        currentQuantity = [valLabel.text intValue];
        
        [self normalQty1Btn];
        [self normalQty2Btn];
        [self normalQty3Btn];
        
        [self qtyPlusBtnClicked:nil];
        
        [self.view endEditing:YES];
        
    }
    [self caluclateCost];
    
}

-(void)normalQty1Btn{
    [qty1BtnSubView.layer setBorderColor:[UIColor grayColor].CGColor];
    [qty1BtnSubView.layer setBorderWidth:1.5f];
    qty1BtnSubView.backgroundColor = [UIColor clearColor];
    qty1Btn.titleLabel.textColor = [UIColor blackColor];
    
}

-(void)normalQty2Btn{
    [qty2BtnSubView.layer setBorderColor:[UIColor grayColor].CGColor];
    [qty2BtnSubView.layer setBorderWidth:1.5f];
    qty2BtnSubView.backgroundColor = [UIColor clearColor];
    qty2Btn.titleLabel.textColor = [UIColor blackColor];
}

-(void)normalQty3Btn{
    [qty3BtnSubView.layer setBorderColor:[UIColor grayColor].CGColor];
    [qty3BtnSubView.layer setBorderWidth:1.5f];
    qty3BtnSubView.backgroundColor = [UIColor clearColor];
    qty3Btn.titleLabel.textColor = [UIColor blackColor];
}




-(IBAction)qtyPlusBtnClicked:(id)sender{
    [self performSelector:@selector(methodName) withObject:nil afterDelay:0.5];
    
    CGRect plusViewFrame;
    int bottomViewHeight;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        
        if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
            plusViewFrame = CGRectMake(0, self.view.frame.size.height, 1024, 250);
        }else if(UIInterfaceOrientationIsPortrait(STATUSBAR_ORIENTATION)){
            plusViewFrame = CGRectMake(0, self.view.frame.size.height, 768, 250);
        }
        
        bottomViewHeight= 80;
    }else{
        if ([UIScreen mainScreen].bounds.size.height == 568) {  // iphone 4 inch
            plusViewFrame = CGRectMake(0, 650, 320, 150);
            
        }else{
            plusViewFrame = CGRectMake(0, 550, 320, 150);
        }
        
        bottomViewHeight = 40;
    }
    
    
    
    
    plusView = [[UIView alloc]initWithFrame:plusViewFrame];
    [plusView setBackgroundColor:[FAUtilities getUIColorObjectFromHexString:@"DCDCDC" alpha:1]];
    plusView.tag = 111;
    
    float subviewWidth  = plusView.frame.size.width/4;
    float subviewHeight = (plusView.frame.size.height-bottomViewHeight)/2;
    
    CGRect qty4BtnSubViewFrame = CGRectMake(0, 0, subviewWidth, subviewHeight);
    CGRect qty5BtnSubViewFrame = CGRectMake(qty4BtnSubViewFrame.size.width, 0, subviewWidth, subviewHeight);
    CGRect qty6BtnSubViewFrame = CGRectMake(qty5BtnSubViewFrame.origin.x+qty5BtnSubViewFrame.size.width, 0, subviewWidth, subviewHeight);
    CGRect qty7BtnSubViewFrame = CGRectMake(qty6BtnSubViewFrame.origin.x+qty6BtnSubViewFrame.size.width, 0, subviewWidth, subviewHeight);
    CGRect qty8BtnSubViewFrame = CGRectMake(0, qty4BtnSubViewFrame.origin.y+qty4BtnSubViewFrame.size.height, subviewWidth, subviewHeight);
    CGRect qty9BtnSubViewFrame = CGRectMake(0+qty8BtnSubViewFrame.size.width, qty4BtnSubViewFrame.origin.y+qty4BtnSubViewFrame.size.height, subviewWidth, subviewHeight);
    CGRect qty10BtnSubViewFrame = CGRectMake(qty9BtnSubViewFrame.origin.x+qty9BtnSubViewFrame.size.width, qty4BtnSubViewFrame.origin.y+qty4BtnSubViewFrame.size.height, subviewWidth, subviewHeight);
    CGRect qty11BtnSubViewFrame = CGRectMake(qty10BtnSubViewFrame.origin.x+qty10BtnSubViewFrame.size.width, qty4BtnSubViewFrame.origin.y+qty4BtnSubViewFrame.size.height, subviewWidth, subviewHeight);
    
    CGRect btnFrame = CGRectMake(0, 0, qty4BtnSubViewFrame.size.width, qty4BtnSubViewFrame.size.height);
    
    
    CGRect valMinusBtnFrame ;
    CGRect valLabelFrame;
    CGRect valPlusBtnFrame ;
    CGRect goBtnFrame ;
    
    
    UIFont *valGoBtnFont;
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        
        if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
            valMinusBtnFrame = CGRectMake(320, qty11BtnSubViewFrame.origin.y+qty11BtnSubViewFrame.size.height+15, 45, 45);
        }else if(UIInterfaceOrientationIsPortrait(STATUSBAR_ORIENTATION)){
            valMinusBtnFrame = CGRectMake(180, qty11BtnSubViewFrame.origin.y+qty11BtnSubViewFrame.size.height+15, 45, 45);
        }
        
        
        
        valLabelFrame = CGRectMake(valMinusBtnFrame.origin.x + valMinusBtnFrame.size.width+5, qty11BtnSubViewFrame.origin.y+qty11BtnSubViewFrame.size.height+15, 180, 55);
        valPlusBtnFrame = CGRectMake(valLabelFrame.origin.x+valLabelFrame.size.width+10, valMinusBtnFrame.origin.y, 45, 45);
        goBtnFrame = CGRectMake(valPlusBtnFrame.origin.x+20+valPlusBtnFrame.size.width, valLabelFrame.origin.y, 180, 55);
        
        valGoBtnFont = [UIFont fontWithName:@"Thonburi" size:30];
        
    }else{
        valMinusBtnFrame = CGRectMake(10, qty11BtnSubViewFrame.origin.y+qty11BtnSubViewFrame.size.height+5, 25, 25);
        valLabelFrame = CGRectMake(valMinusBtnFrame.origin.x + valMinusBtnFrame.size.width+5, qty11BtnSubViewFrame.origin.y+qty11BtnSubViewFrame.size.height+2, 80, 35);
        valPlusBtnFrame = CGRectMake(valLabelFrame.origin.x+valLabelFrame.size.width+10, valMinusBtnFrame.origin.y, 25, 25);
        goBtnFrame = CGRectMake(valPlusBtnFrame.origin.x+20+valPlusBtnFrame.size.width, valLabelFrame.origin.y, 80, 35);
        
        valGoBtnFont = [UIFont fontWithName:@"Thonburi" size:20];
        
    }
    
    
    UIView *qty4BtnSubView  = [[UIView alloc]initWithFrame:qty4BtnSubViewFrame];
    UIView *qty5BtnSubView  = [[UIView alloc]initWithFrame:qty5BtnSubViewFrame];
    UIView *qty6BtnSubView  = [[UIView alloc]initWithFrame:qty6BtnSubViewFrame];
    UIView *qty7BtnSubView  = [[UIView alloc]initWithFrame:qty7BtnSubViewFrame];
    UIView *qty8BtnSubView  = [[UIView alloc]initWithFrame:qty8BtnSubViewFrame];
    UIView *qty9BtnSubView  = [[UIView alloc]initWithFrame:qty9BtnSubViewFrame];
    UIView *qty10BtnSubView = [[UIView alloc]initWithFrame:qty10BtnSubViewFrame];
    UIView *qty11BtnSubView = [[UIView alloc]initWithFrame:qty11BtnSubViewFrame];
    
    
    UIButton *minusBtn = [[UIButton alloc]initWithFrame:valMinusBtnFrame];
    [minusBtn setBackgroundImage:[UIImage imageNamed:@"pgm_minusButton.png"] forState:UIControlStateNormal];
    [minusBtn addTarget:self action:@selector(minusBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    valLabel = [[UILabel alloc]initWithFrame:valLabelFrame];
    valLabel.text = @"12";
    valLabel.textAlignment = NSTextAlignmentCenter;
    valLabel.font = numberBtnFont;
    
    
    if (qtyPlusBtn.titleLabel.text.length == 0 || [qtyPlusBtn.titleLabel.text intValue] <= 11) {
        valLabel.text = @"12";
    }else{
        valLabel.text = qtyPlusBtn.titleLabel.text;
    }
    
    
    UIButton *plusBtn = [[UIButton alloc]initWithFrame:valPlusBtnFrame];
    [plusBtn setBackgroundImage:[UIImage imageNamed:@"pgm_plusButton.png"] forState:UIControlStateNormal];
    
    [plusBtn addTarget:self action:@selector(plusBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *valGoBtn = [[UIButton alloc]initWithFrame:goBtnFrame];
    [valGoBtn setTitle:@"Ok" forState:UIControlStateNormal];
    [FAUtilities setBackgroundImagesForButton:valGoBtn];
    
    
    valGoBtn.titleLabel.font = valGoBtnFont;
    
    
    valLabel.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    valLabel.layer.borderWidth = 2;
    valLabel.layer.cornerRadius = 4;
    
    UIButton *qty4Btn  = [[UIButton alloc]initWithFrame:btnFrame];
    UIButton *qty5Btn  = [[UIButton alloc]initWithFrame:btnFrame];
    UIButton *qty6Btn  = [[UIButton alloc]initWithFrame:btnFrame];
    UIButton *qty7Btn  = [[UIButton alloc]initWithFrame:btnFrame];
    UIButton *qty8Btn  = [[UIButton alloc]initWithFrame:btnFrame];
    UIButton *qty9Btn  = [[UIButton alloc]initWithFrame:btnFrame];
    UIButton *qty10Btn  = [[UIButton alloc]initWithFrame:btnFrame];
    UIButton *qty11Btn  = [[UIButton alloc]initWithFrame:btnFrame];
    
    
    qty4Btn.tag = 4;
    qty5Btn.tag = 5;
    qty6Btn.tag = 6;
    qty7Btn.tag = 7;
    qty8Btn.tag = 8;
    qty9Btn.tag = 9;
    qty10Btn.tag = 10;
    qty11Btn.tag= 11;
    
    
    [qty4Btn setTitle:@"4" forState:UIControlStateNormal];
    [qty5Btn setTitle:@"5" forState:UIControlStateNormal];
    [qty6Btn setTitle:@"6" forState:UIControlStateNormal];
    [qty7Btn setTitle:@"7" forState:UIControlStateNormal];
    [qty8Btn setTitle:@"8" forState:UIControlStateNormal];
    [qty9Btn setTitle:@"9" forState:UIControlStateNormal];
    [qty10Btn setTitle:@"10" forState:UIControlStateNormal];
    [qty11Btn setTitle:@"11" forState:UIControlStateNormal];
    
    qty4Btn.titleLabel.font = numberBtnFont;
    qty5Btn.titleLabel.font = numberBtnFont;
    qty6Btn.titleLabel.font = numberBtnFont;
    qty7Btn.titleLabel.font = numberBtnFont;
    qty8Btn.titleLabel.font = numberBtnFont;
    qty9Btn.titleLabel.font = numberBtnFont;
    qty10Btn.titleLabel.font = numberBtnFont;
    qty11Btn.titleLabel.font = numberBtnFont;
    
    
    [qty4Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [qty5Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [qty6Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [qty7Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [qty8Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [qty9Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [qty10Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [qty11Btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    
    [qty4Btn addTarget:self action:@selector(sunViewQtyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [qty5Btn addTarget:self action:@selector(sunViewQtyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [qty6Btn addTarget:self action:@selector(sunViewQtyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [qty7Btn addTarget:self action:@selector(sunViewQtyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [qty8Btn addTarget:self action:@selector(sunViewQtyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [qty9Btn addTarget:self action:@selector(sunViewQtyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [qty10Btn addTarget:self action:@selector(sunViewQtyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [qty11Btn addTarget:self action:@selector(sunViewQtyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [valGoBtn addTarget:self action:@selector(valGoBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [qty4BtnSubView addSubview:qty4Btn];
    [qty5BtnSubView addSubview:qty5Btn];
    [qty6BtnSubView addSubview:qty6Btn];
    [qty7BtnSubView addSubview:qty7Btn];
    [qty8BtnSubView addSubview:qty8Btn];
    [qty9BtnSubView addSubview:qty9Btn];
    [qty10BtnSubView addSubview:qty10Btn];
    [qty11BtnSubView addSubview:qty11Btn];
    
    
    
    qty4BtnSubView.backgroundColor = [UIColor clearColor];
    qty5BtnSubView.backgroundColor = [UIColor clearColor];
    qty6BtnSubView.backgroundColor = [UIColor clearColor];
    qty7BtnSubView.backgroundColor = [UIColor clearColor];
    qty8BtnSubView.backgroundColor = [UIColor clearColor];
    qty9BtnSubView.backgroundColor = [UIColor clearColor];
    qty10BtnSubView.backgroundColor = [UIColor clearColor];
    qty11BtnSubView.backgroundColor = [UIColor clearColor];
    
    
    if (qtyPlusBtn.titleLabel.text.length == 0 || [qtyPlusBtn.titleLabel.text intValue] > 11 || [qtyPlusBtn.titleLabel.text isEqualToString:@"Plus"]) {
        
    }else if([qtyPlusBtn.titleLabel.text isEqualToString:@"4"]){
        qty4BtnSubView.backgroundColor = [FAUtilities getUIColorObjectFromHexString:LIST_COUNT_SUBVIEW_BG_COLOR alpha:1];
    }else if([qtyPlusBtn.titleLabel.text isEqualToString:@"5"]){
        qty5BtnSubView.backgroundColor = [FAUtilities getUIColorObjectFromHexString:LIST_COUNT_SUBVIEW_BG_COLOR alpha:1];
    }else if([qtyPlusBtn.titleLabel.text isEqualToString:@"6"]){
        qty6BtnSubView.backgroundColor = [FAUtilities getUIColorObjectFromHexString:LIST_COUNT_SUBVIEW_BG_COLOR alpha:1];
    }else if([qtyPlusBtn.titleLabel.text isEqualToString:@"7"]){
        qty7BtnSubView.backgroundColor = [FAUtilities getUIColorObjectFromHexString:LIST_COUNT_SUBVIEW_BG_COLOR alpha:1];
    }else if([qtyPlusBtn.titleLabel.text isEqualToString:@"8"]){
        qty8BtnSubView.backgroundColor = [FAUtilities getUIColorObjectFromHexString:LIST_COUNT_SUBVIEW_BG_COLOR alpha:1];
    }else if([qtyPlusBtn.titleLabel.text isEqualToString:@"9"]){
        qty9BtnSubView.backgroundColor = [FAUtilities getUIColorObjectFromHexString:LIST_COUNT_SUBVIEW_BG_COLOR alpha:1];
    }else if([qtyPlusBtn.titleLabel.text isEqualToString:@"10"]){
        qty10BtnSubView.backgroundColor = [FAUtilities getUIColorObjectFromHexString:LIST_COUNT_SUBVIEW_BG_COLOR alpha:1];
    }else if([qtyPlusBtn.titleLabel.text isEqualToString:@"11"]){
        qty11BtnSubView.backgroundColor = [FAUtilities getUIColorObjectFromHexString:LIST_COUNT_SUBVIEW_BG_COLOR alpha:1];
    }
    
    [self addBGColor:qty4BtnSubView];
    [self addBGColor:qty5BtnSubView];
    [self addBGColor:qty6BtnSubView];
    [self addBGColor:qty7BtnSubView];
    [self addBGColor:qty8BtnSubView];
    [self addBGColor:qty9BtnSubView];
    [self addBGColor:qty10BtnSubView];
    [self addBGColor:qty11BtnSubView];
    
    
    if (isNumbersSubViewVisible == NO) {
        CGRect frame = plusView.frame;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
                frame.origin.y = 768-250;
            }else if(UIInterfaceOrientationIsPortrait(STATUSBAR_ORIENTATION)){
                frame.origin.y = 1024-250;
            }
        }else{
            if ([UIScreen mainScreen].bounds.size.height == 568) {  // iphone 4 inch
                frame.origin.y = 417;
                
            }else{
                frame.origin.y = 330;
            }
        }
        [UIView animateWithDuration:0.75f
                         animations:^{
                             plusView.frame = frame;
                             
                             [plusView addSubview:qty4BtnSubView];
                             [plusView addSubview:qty5BtnSubView];
                             [plusView addSubview:qty6BtnSubView];
                             [plusView addSubview:qty7BtnSubView];
                             [plusView addSubview:qty8BtnSubView];
                             [plusView addSubview:qty9BtnSubView];
                             [plusView addSubview:qty10BtnSubView];
                             [plusView addSubview:qty11BtnSubView];
                             [plusView addSubview:valLabel];
                             [plusView addSubview:plusBtn];
                             [plusView addSubview:valLabel];
                             [plusView addSubview:minusBtn];
                             [plusView addSubview:valGoBtn];
                             
                             [self.view addSubview:plusView];
                         }
         ];
        isNumbersSubViewVisible = YES;
        
    }else if(isNumbersSubViewVisible == YES){
        CGRect frame = plusView.frame;
        frame.origin.y = 600;
        [UIView animateWithDuration:0.75
                         animations:^{
                             plusView.frame = frame;
                         }
                         completion:^(BOOL finished){
                             for (UIView *subView in self.view.subviews) {
                                 if (subView.tag ==111) {
                                     [subView removeFromSuperview];
                                 }
                             }
                         }
         ];
        isNumbersSubViewVisible = NO;
    }
}


-(void)addBGColor:(UIView *)view{
    view.layer.borderColor = [[FAUtilities getUIColorObjectFromHexString:@"C5C5C5" alpha:1]CGColor];
    view.layer.borderWidth = 1;
}


-(void)minusBtnClicked:(id)sender{
    NSString *qtyLabelValue = valLabel.text;
    NSInteger value = [qtyLabelValue integerValue];
    value = value -1;
    if (value <=11) {
    }else{
        valLabel.text = [NSString stringWithFormat:@"%ld",(long)value];
    }
}


-(void)plusBtnClicked:(id)sender{
    NSString *qtyLabelValue = valLabel.text;
    NSInteger value = [qtyLabelValue integerValue];
    value = value +1;
    valLabel.text = [NSString stringWithFormat:@"%ld",(long)value];
}


-(IBAction)backBtnClicked:(id)sender{
    [self performSegueWithIdentifier:@"DishToCustumTable" sender:self];
}


-(IBAction)addToOrderBtnClicked:(id)sender{
    NSMutableArray *tempValicationAry = [[NSMutableArray alloc]init];
    for (int i=0; i<[[itemDetailsDict valueForKey:@"modifiers"] count]; i++) {
        NSDictionary *tempModifierDict = [[itemDetailsDict valueForKey:@"modifiers"] objectAtIndex:i];
        NSString *tempMinVal = [tempModifierDict objectForKey:@"min"];
        NSString *tempModifierID = [tempModifierDict objectForKey:@"id"];
        NSString *tempModifierName = [tempModifierDict objectForKey:@"name"];
        
        BOOL isModifierIDAvailabel = NO;
        NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]init];
        if ([tempMinVal intValue] >= 1) {
            for (int j=0; j<[modifiersCostAry count]; j++) {
                NSDictionary *tempAddedModfierDict = [modifiersCostAry objectAtIndex:j];
                NSString *modifierID = [tempAddedModfierDict objectForKey:@"ModifierID"];
                if ([modifierID isEqualToString:tempModifierID]) {
                    isModifierIDAvailabel = YES;
                    break;
                }else{
                    isModifierIDAvailabel = NO;
                    continue;
                }
            }
        }else{
            isModifierIDAvailabel = YES;
        }
        if (isModifierIDAvailabel == NO) {
            [tempDict setObject:tempModifierID forKey:@"ModifierID"];
            [tempDict setObject:[NSString stringWithFormat:@"%d",isModifierIDAvailabel] forKey:@"IsModAvailable"];
            [tempDict setObject:tempModifierName forKey:@"ModifierName"];
            
            [tempValicationAry addObject:tempDict];
        }
    }
    if (tempValicationAry.count == 0) {
        if ([sizeBtn.titleLabel.text isEqualToString:@"Select A Size"]) {
            customAlertMessage = @"Check to make sure you select a Size";
            customAlertTitle = @"Alert";
            [self LoadCustomAlertWithMessage];
        }
        else
        {
        float modifiersCost = 0.0;
        for (int i=0; i<[modifiersCostAry count]; i++) {
            NSDictionary *tempDict = [modifiersCostAry objectAtIndex:i];
            NSString *tempModifierCost = [tempDict objectForKey:@"ModifierCost"];
            modifiersCost = modifiersCost + [tempModifierCost floatValue];
        }
        
        NSString *tempCost = [itemCost.text substringFromIndex:1];
        dbManager = [DataBaseManager dataBaseManager];
        NSString *spclInstVal = [FAUtilities formatJSONStr:spclInst.text];
        
        catgName = [catgName stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        NSString *itemNameStr = [itemName.text stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        NSString *itemDescStr = [itemDescTextView.text stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        NSString *servingName = [[currentServingDict objectForKey:@"name"] stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        

      
        
        
        
        [dbManager execute:[NSString stringWithFormat: @"INSERT INTO 'OrderDetails' (OrderID,CategoryName,ItemName,ItemDescription,ServingName,Quantity,ItemPrice,OptionsPrice,Instructions,ItemSalesTax)VALUES ('%@', '%@','%@','%@','%@','%@','%@','%@','%@','%f')",@"",catgName,itemNameStr,itemDescStr,servingName,[NSString stringWithFormat:@"%d",currentQuantity],tempCost,[NSString stringWithFormat:@"%f",modifiersCost],spclInstVal,allTaxes]];
        
        
        NSMutableArray *idAry = [[NSMutableArray alloc]init];
        [dbManager execute:[NSString stringWithFormat:@"SELECT LAST_INSERT_ROWID()"] resultsArray:idAry];
        NSString *lastInsertedRowID = [[idAry objectAtIndex:0]objectForKey:@"LAST_INSERT_ROWID()"];
        NSArray *itemOptionsAry = [itemDetailsDict objectForKey:@"modifiers"];
        for (int i=0; i<[itemOptionsAry count]; i++) {
            NSString *itemModifierName = [[itemOptionsAry objectAtIndex:i]objectForKey:@"name"];
            for (int j=0; j<[selectedModifierAry count]; j++) {
                NSDictionary *tempDict = [selectedModifierAry objectAtIndex:j];
                NSArray *optionsAry = [tempDict objectForKey:itemModifierName];
                if (optionsAry.count !=0) {
                    for (int k=0; k<[optionsAry count]; k++) {
                        NSDictionary *tempDict = [optionsAry objectAtIndex:k];
                        
                        itemModifierName = [FAUtilities formatJSONStr:itemModifierName];
                        NSString *optionName = [FAUtilities formatJSONStr:[tempDict objectForKey:@"name"]];
                        NSString *optionPrice = [FAUtilities formatJSONStr:[tempDict objectForKey:@"price"]];
                        
                        
                        dbManager = [DataBaseManager dataBaseManager];
                        [dbManager execute:[NSString stringWithFormat: @"INSERT INTO 'OrderModifier' (OrderDetailsID,ModifierName,OptionName,OptionPrice)VALUES ('%@', '%@','%@','%@')",lastInsertedRowID,itemModifierName,optionName,optionPrice]];
                    }
                }
            }
        }
        [self performSegueWithIdentifier:@"DishToCustumTable" sender:self];
        }
    }else{
      
        if ([sizeBtn.titleLabel.text isEqualToString:@"Select A Size"]) {
            customAlertMessage = @"Check to make sure you select a Size";
            customAlertTitle = @"Alert";
            [self LoadCustomAlertWithMessage];
        }else{
            NSDictionary *tempAlertDict = [tempValicationAry objectAtIndex:0];
            NSString *modName = [tempAlertDict objectForKey:@"ModifierName"];
            NSString *tempMsg = [NSString stringWithFormat:@"Please choose options for %@",modName];
            
            
            customAlertMessage = tempMsg;
            //        customAlertMessage = @"Check to make sure you selected a size and all selected options";
            customAlertTitle = @"Alert";
            [self LoadCustomAlertWithMessage];
        }

    }
    [self refreshCart];
}


- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
    [self scrollViewAdaptToStartEditingTextField:textField];
    return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self scrollVievEditingFinished:textField];
    return YES;
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [self scrollViewAdaptToStartEditingTextView:textView];
    return YES;
}

- (BOOL)textViewShouldReturn:(UITextView *)textView{
    [textView resignFirstResponder];
    [self scrollVievEditingFinishedTextView:textView];
    return YES;
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}



- (void) scrollViewAdaptToStartEditingTextView:(UITextView*)textView{
    CGPoint point;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
            point = CGPointMake(0, textView.frame.origin.y - 1.5 * textView.frame.size.height);
        }else if(UIInterfaceOrientationIsPortrait(STATUSBAR_ORIENTATION)){
            point = CGPointMake(0, textView.frame.origin.y - 3 * textView.frame.size.height);
        }
    }else{
        point = CGPointMake(0, textView.frame.origin.y - 1.5 * textView.frame.size.height);
    }
    [dishDeteailsScrollview setContentOffset:point animated:YES];
}

- (void) scrollVievEditingFinishedTextView:(UITextView*)textView
{
    CGPoint point = CGPointMake(0, 0);
    [dishDeteailsScrollview setContentOffset:point animated:YES];
}




- (void) scrollViewAdaptToStartEditingTextField:(UITextField*)textField
{
    plusView.frame=CGRectMake(plusView.frame.origin.x, plusView.frame.origin.y-214, plusView.frame.size.width, plusView.frame.size.height);
}

- (void) scrollVievEditingFinished:(UITextField*)textField
{
    plusView.frame=CGRectMake(plusView.frame.origin.x, plusView.frame.origin.y+214, plusView.frame.size.width, plusView.frame.size.height);
}


-(void)refreshCart{
    dishDeteailsScrollview.contentSize = CGSizeMake(dishDeteailsScrollview.frame.size.width, spclInst.frame.origin.y+150);
    NSMutableArray *itemsAry = [[NSMutableArray alloc]init];
    dbManager = [DataBaseManager dataBaseManager];
    [dbManager execute:[NSString stringWithFormat:@"SELECT * FROM OrderDetails where Quantity > '0'"] resultsArray:itemsAry];
    cartCountLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[itemsAry count]];
}


-(IBAction)cartBtnClicked:(id)sender{
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
            [defaults setObject:@"OrderCart" forKey:@"LoginParentView"];
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

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        [self performSelector:@selector(methodName) withObject:nil afterDelay:0.5];
    }
    if (isNumbersSubViewVisible == YES) {
        [self qtyPlusBtnClicked:nil];
    }
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    for (UIView *subView in self.view.subviews) {
        if (subView.tag ==500) {
            [diabledview removeFromSuperview];
        }else if (subView.tag == 700){
            [disableCustomAlertView removeFromSuperview];
            [self LoadCustomAlertWithMessage];
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
