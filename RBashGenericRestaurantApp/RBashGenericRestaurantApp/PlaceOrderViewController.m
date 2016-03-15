//
//  PlaceOrderViewController.m
//  ThinkingCup
//
//  Created by Manulogix on 09/09/14.
//  Copyright (c) 2014 Manulogix. All rights reserved.
//

#import "PlaceOrderViewController.h"
#import "AddTipViewController.h"
#import "FAUtilities.h"
#import "DishDetailsViewController.h"
#import "ShareDetailsViewController.h"

#define MIN_ITEM_FOLDER_HEIGHT_IPAD  120
#define MIN_ITEM_FOLDER_HEIGHT_IPHONE  70


@interface PlaceOrderViewController ()
{
    NSUserDefaults *restDetails;
}
@end

@implementation PlaceOrderViewController
@synthesize dishItemDetailsDict;
@synthesize orderItemsAry;
@synthesize subTotalVal;
@synthesize taxVal;
@synthesize tipVal;
@synthesize totalVal;

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
        placeOrderSubView.backgroundColor=[FAUtilities getUIColorObjectFromHexString:ADD_TO_ORDER_VIEW_COLOR alpha:1.0];
    }

    int addTipViewCornerRadious;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        addTipViewCornerRadious = 14;
        itemDescFont = [UIFont fontWithName:@"Verdana" size:16];
        itemInstFont = [UIFont fontWithName:@"Verdana" size:16];
      
        itemInstHeadingFont = [UIFont fontWithName:@"Trebuchet MS" size:20];
        modifierHeadingFont = [UIFont fontWithName:@"Thonburi-Bold" size:18];
        modifierOptionsFont = [UIFont fontWithName:@"Trebuchet MS" size:20];
    }else{
        addTipViewCornerRadious = 6;
        itemDescFont =  [UIFont fontWithName:@"Verdana" size:10];
        itemInstFont =  [UIFont fontWithName:@"Verdana" size:10];
       
        itemInstHeadingFont = [UIFont fontWithName:@"Trebuchet MS" size:14];
        modifierHeadingFont = [UIFont fontWithName:@"Thonburi-Bold" size:10];
        modifierOptionsFont = [UIFont fontWithName:@"Trebuchet MS" size:14];
    }
    
    addTipBtnView.layer.cornerRadius = addTipViewCornerRadious;
    addTipBtnView.layer.borderColor = [[FAUtilities getUIColorObjectFromHexString:@"DCDCDC" alpha:1]CGColor];
    addTipBtnView.layer.borderWidth = 2;
    
    addTipBtnViewDelivery.layer.cornerRadius = addTipViewCornerRadious;
    addTipBtnViewDelivery.layer.borderColor = [[FAUtilities getUIColorObjectFromHexString:@"DCDCDC" alpha:1]CGColor];
    addTipBtnViewDelivery.layer.borderWidth = 2;
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myKeyboardWillHideHandler:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        placeOrderCostSubView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"pgm_iPad_costLabel"]];
    }else{
        placeOrderCostSubView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"pgm_iPhone_costLabel.png"]];
    }
    
    NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
    NSString *placeOrderParentView = [defaults objectForKey:@"PlaceOrderParentView"];

    if ([placeOrderParentView isEqualToString:@"MyOrdersView"]) {
        itemsAry = [orderItemsAry mutableCopy];
    }else{
        itemsAry = [[NSMutableArray alloc]init];
        dbManager = [DataBaseManager dataBaseManager];
        [dbManager execute:[NSString stringWithFormat:@"SELECT * FROM OrderDetails "] resultsArray:itemsAry];
    }
  
    itemHeights     = [[NSMutableArray alloc]init];
    itemDescHeights = [[NSMutableArray alloc]init];
    itemInstHeights = [[NSMutableArray alloc]init];
    
    for (int i=0; i<[itemsAry count]; i++) {
        NSDictionary *currentItemDict = [itemsAry objectAtIndex:i];
        NSMutableArray *modifiersAry = [[NSMutableArray alloc]init];
        
        if ([placeOrderParentView isEqualToString:@"MyOrdersView"]) {
            modifiersAry = [currentItemDict objectForKey:@"item_modifiers"];
            NSMutableArray *finalModifierArray = [[NSMutableArray alloc]init];
            finalModifierArray = [self getFormattedModifiers:modifiersAry];

            NSMutableDictionary *tempOrderDict = [[NSMutableDictionary alloc]init];
            tempOrderDict = [currentItemDict mutableCopy];
            [tempOrderDict setObject:finalModifierArray forKeyedSubscript:@"item_modifiers"];
            [self caluclateHeights:tempOrderDict];
        }else{
            dbManager = [DataBaseManager dataBaseManager];
            [dbManager execute:[NSString stringWithFormat:@"SELECT * FROM OrderModifier where OrderDetailsID ='%@' ",[currentItemDict objectForKey:@"ID"]] resultsArray:modifiersAry];
        
            NSMutableDictionary *tempItemDict = [[NSMutableDictionary alloc]init];
            NSMutableArray *finalModifierArray = [[NSMutableArray alloc]init];
            finalModifierArray = [self getFormattedModifiers:modifiersAry];
            
            tempItemDict = [currentItemDict mutableCopy];
            [tempItemDict setObject:finalModifierArray forKeyedSubscript:@"Modifiers"];
            [self caluclateHeights:tempItemDict];
        }
    }
    
    [self drawAttchmentsView];

    NSString *currentTipValue = [defaults objectForKey:@"CurrentTipValue"];
    addTipValue.text = [NSString stringWithFormat:@"$%@",currentTipValue];
    addTipValueDelivery.text=[NSString stringWithFormat:@"$%@",currentTipValue];
    
    if (currentTipValue.length ==0 || [currentTipValue isEqualToString:@"0.00"]) {
        addTipHeading.hidden = YES;
        addTipValue.hidden = YES;
        addTipPlaceHolder.hidden = NO;
        addTipValue.text = @"Add Tip?";
        addTipHeadingDelivery.hidden = YES;
        addTipValueDelivery.hidden = YES;
        addTipPlaceHolderDelivery.hidden = NO;
        addTipValueDelivery.text = @"Add Tip?";
    }else{
        addTipValue.text = [NSString stringWithFormat:@"$%@",currentTipValue];
        addTipHeading.hidden = NO;
        addTipValue.hidden = NO;
        addTipPlaceHolder.hidden = YES;
        addTipValueDelivery.text = [NSString stringWithFormat:@"$%@",currentTipValue];
        addTipHeadingDelivery.hidden = NO;
        addTipValueDelivery.hidden = NO;
        addTipPlaceHolderDelivery.hidden = YES;
    }
    
    if ([placeOrderParentView isEqualToString:@"MyOrdersView"]) {
        [placeOrderHeadingBtn setTitle:@"Total" forState:UIControlStateNormal];
        placeOrderHeadingBtn.userInteractionEnabled = NO;
        placeOrderValueBtn.userInteractionEnabled = NO;
        tipBtn.userInteractionEnabled = NO;
        tipBtnDelivery.userInteractionEnabled=NO;
        cartSubView.hidden = YES;
        addTipValue.text = [NSString stringWithFormat:@"$%@",tipVal];
        addTipHeading.hidden = NO;
        addTipValue.hidden = NO;
        addTipPlaceHolder.hidden = YES;
        
        addTipValueDelivery.text = [NSString stringWithFormat:@"$%@",tipVal];
        addTipHeadingDelivery.hidden = NO;
        addTipValueDelivery.hidden = NO;
        addTipPlaceHolderDelivery.hidden = YES;
        
    }else{
        [placeOrderHeadingBtn setTitle:@"Place Order" forState:UIControlStateNormal];
        placeOrderHeadingBtn.userInteractionEnabled = YES;
        placeOrderValueBtn.userInteractionEnabled = YES;
        tipBtn.userInteractionEnabled = YES;
        tipBtnDelivery.userInteractionEnabled = YES;

        cartSubView.hidden = NO;
    }
    
    [self refreshCart];
    [self caluclateCost];
}



-(void)caluclateHeights:(NSDictionary *)itemDict{
    int itemFolderHeight;
    int modifierHeight;
    int optionHeight;
    int itemDescHeight;
    int itemInstHeight;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        itemFolderHeight = MIN_ITEM_FOLDER_HEIGHT_IPAD;
        modifierHeight = 34;
        optionHeight = 30;
    }else{
        itemFolderHeight = MIN_ITEM_FOLDER_HEIGHT_IPHONE;
        modifierHeight = 26;
        optionHeight = 22;
    }
    
    NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
    NSString *placeOrderParentView = [defaults objectForKey:@"PlaceOrderParentView"];
    NSString *itemDescStr;
    NSString *itemInst;
    NSString *modifierKeyValue;

    if ([placeOrderParentView isEqualToString:@"MyOrdersView"]) {
        itemDescStr = [itemDict objectForKey:@"description"];
        itemInst = [itemDict objectForKey:@"instructions"];
        modifierKeyValue = @"item_modifiers";
    }else{
        itemDescStr = [itemDict objectForKey:@"ItemDescription"];
        itemInst = [itemDict objectForKey:@"Instructions"];
        modifierKeyValue = @"Modifiers";
    }
    
    CGSize itemDescSize;
    
    if ([itemDescStr isEqual:[NSNull null]]) {
        NSLog(@"Item Desc is NULL");
        itemDescHeight = 0;
    }else{
        itemDescSize = [FAUtilities getHeightFromString:itemDescStr AndWidth:self.view.bounds.size.width - 20-20 AndFont:itemDescFont];
        itemDescHeight = itemDescSize.height+6;
    }
    
    if(itemInst.length > 0){
        NSString *tempInstructios = [NSString stringWithFormat:@"Instructions: %@",itemInst];
        CGSize itemInstSize = [FAUtilities getHeightFromString:tempInstructios AndWidth:self.view.bounds.size.width - 20-20 AndFont:itemDescFont];
        itemInstHeight = itemInstSize.height+12;
    }else{
        itemInstHeight = 0;
    }
        
    NSArray *itemModifiers = [itemDict objectForKey:modifierKeyValue];
    
    int modifiersHeight = modifierHeight * (int)[itemModifiers count];
   
    if (modifiersHeight >0 ) {
        int val;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            val = 10;
        }else{
            val = 4;
        }
        
        modifiersHeight = modifiersHeight+val;
    }else{
        modifiersHeight = 6;
    }
    
    int optionsHeight= 0;
    
    for (int i=0; i<[itemModifiers count]; i++) {
        NSDictionary *tempModifier = [itemModifiers objectAtIndex:i];
        NSArray *optionsAry = [tempModifier objectForKey:@"Options"];
        optionsHeight = optionsHeight + (optionHeight* (int)[optionsAry count])+4;
    }
    
    int sizeHeight;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        sizeHeight = 70;
    }else{
        sizeHeight = 46;
    }
    
    [itemDescHeights addObject:[NSString stringWithFormat:@"%d",itemDescHeight]];
    [itemInstHeights addObject:[NSString stringWithFormat:@"%d",itemInstHeight]];
    float finalHeight = itemFolderHeight + modifiersHeight + optionsHeight + itemInstHeight + itemDescHeight+sizeHeight;
    [itemHeights addObject:[NSString stringWithFormat:@"%f",finalHeight]];
}


- (void)drawAttchmentsView{
    
    CGFloat originX = 10;
    CGFloat originY = 0;
    CGFloat width = self.view.bounds.size.width - 20;
    CGFloat height = 0.0;
    CGFloat yGap = 8;
    
    for (UIView *view in placeOrderScrolView.subviews) {
        [view removeFromSuperview];
    }
    int foldersContainEachRow = 1;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
            foldersContainEachRow = 1;
        }
         originY = 10;
    }else{
        foldersContainEachRow = 1;
        originX = 10;
        originY = 8;
        width = self.view.bounds.size.width - 20;
    }
    
    NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
    NSString *placeOrderParentView = [defaults objectForKey:@"PlaceOrderParentView"];

    if ([placeOrderParentView isEqualToString:@"MyOrdersView"]) {
        itemsAry = [orderItemsAry mutableCopy];
    }else{
        itemsAry = [[NSMutableArray alloc]init];
        dbManager = [DataBaseManager dataBaseManager];
        [dbManager execute:[NSString stringWithFormat:@"SELECT * FROM OrderDetails "] resultsArray:itemsAry];
        
    }
    for (int i=0; i<[itemsAry count]; i++) {
        height = [[itemHeights objectAtIndex:i] floatValue];
        UIView *folderView = [self createFolderViewForTag:i withFrame:CGRectMake(originX, originY, width, height)];

        folderView.layer.borderColor = [[UIColor lightGrayColor]CGColor];
        folderView.layer.borderWidth = 2;
        folderView.layer.cornerRadius = 8;
        
        [placeOrderScrolView addSubview:folderView];
        int val = i+1;
        if(val%foldersContainEachRow != 0){
//            originX += width+xGap;
        }
        else{
            originY += height+yGap;
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                originX =10;
            }else{
                originX =10;
            }
        }
    }
    placeOrderScrolView.contentSize = CGSizeMake(0, originY+height);
    [self caluclateCost];
}


/* Method to create Form folders */
- (UIView*)createFolderViewForTag:(int)tag withFrame:(CGRect)rect{
    UIView *folderVIew = [[UIView alloc]initWithFrame:rect];
    CGRect itemQtyFrame;

    CGRect itemNameLineFrame;
    CGRect itemCostLineFrame;
    UIFont *itemQtyFont;
    UIFont *itemNameFont;
    
    int normalAttributesFont;
    int smallAttributesFont;
    int qtyBorderWidth;
    int qtyCornerRadious;
    
    CGRect itemDescFrame;
    float descHeight = [[itemDescHeights objectAtIndex:tag] floatValue];
    
    CGRect itemInstFrame;
    float instHeight = [[itemInstHeights objectAtIndex:tag] floatValue];

    CGRect sizeHeadingFrame;
    CGRect sizeValueFrame;
    CGRect sizeValuePriceFrame;
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        itemQtyFrame = CGRectMake(8, 15, 100, 100);
        itemNameFrame = CGRectMake(itemQtyFrame.size.width+itemQtyFrame.origin.x+5, 15, rect.size.width - itemQtyFrame.size.width -150, 100);
        itemCostFrame = CGRectMake(itemNameFrame.size.width+itemNameFrame.origin.x+5, 15, 120, 100);
        itemQtyFont = [UIFont fontWithName:@"Verdana" size:36];
        itemNameFont = [UIFont fontWithName:@"Thonburi-Bold" size:24];

        normalAttributesFont = 34;
        smallAttributesFont = 28;
        
        qtyBorderWidth = 4;
        qtyCornerRadious = 14;
        
        itemDescFrame = CGRectMake(20, itemNameFrame.origin.y+itemNameFrame.size.height+1, rect.size.width - 40, descHeight);
        sizeHeadingFrame = CGRectMake(20, itemDescFrame.origin.y+itemDescFrame.size.height+6 , rect.size.width - 40, 28);
        sizeValueFrame = CGRectMake(50, sizeHeadingFrame.origin.y+sizeHeadingFrame.size.height+4 , itemDescFrame.size.width - 150, 30);
        
        sizeValuePriceFrame = CGRectMake(sizeValueFrame.origin.x+sizeValueFrame.size.width+6, sizeValueFrame.origin.y, 100, 30);
        
    }else{
        itemQtyFrame = CGRectMake(6, 15, 50, 50);
        itemNameFrame = CGRectMake(itemQtyFrame.size.width+itemQtyFrame.origin.x+2, 15, 162, 50);
        itemCostFrame = CGRectMake(itemNameFrame.size.width+itemNameFrame.origin.x+2, 10, 70, 60);
        
        itemNameLineFrame = CGRectMake(itemQtyFrame.size.width+itemQtyFrame.origin.x+2, 5, 162, 30);
        itemCostLineFrame = CGRectMake(itemNameFrame.size.width+itemNameFrame.origin.x+2, 20, 70, 30);
        
        itemQtyFont = [UIFont fontWithName:@"Verdana" size:26];
        itemNameFont = [UIFont fontWithName:@"Thonburi-Bold" size:14];
        
        normalAttributesFont = 24;
        smallAttributesFont = 18;
      
        qtyBorderWidth = 2;
        qtyCornerRadious = 8;
        
        itemDescFrame = CGRectMake(10, itemNameFrame.origin.y+itemNameFrame.size.height+1, rect.size.width - 20, descHeight);
        
        sizeHeadingFrame = CGRectMake(10, itemDescFrame.origin.y+itemDescFrame.size.height+4 , rect.size.width - 20, 18);
        sizeValueFrame = CGRectMake(30, sizeHeadingFrame.origin.y+sizeHeadingFrame.size.height+2 , itemDescFrame.size.width - 100, 20);
        
        sizeValuePriceFrame = CGRectMake(sizeValueFrame.origin.x+sizeValueFrame.size.width+6, sizeValueFrame.origin.y, 60, 20);

    }
    
    NSDictionary *tempDict = [itemsAry objectAtIndex:tag];
    
    NSString *qty = @"";
    float cost;
    NSString *itemName;
    NSString *itemDesctiption;
    NSString *itemServingName;
    NSString *itemInstructions;
    NSString *itemServingPrice;
    
    
    NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
    NSString *placeOrderParentView = [defaults objectForKey:@"PlaceOrderParentView"];
    itemQtyTextField = [[UITextField alloc]initWithFrame:itemQtyFrame];
    
    if ([placeOrderParentView isEqualToString:@"MyOrdersView"]) {
        qty = [NSString stringWithFormat:@"%@",[tempDict objectForKey:@"quantity"]];
        cost = [[tempDict objectForKey:@"price"] floatValue];
        itemName = [tempDict objectForKey:@"item_name"];
        itemDesctiption = [tempDict objectForKey:@"description"];
        
        itemQtyTextField.userInteractionEnabled = NO;
        itemServingName = [tempDict objectForKey:@"serving_name"];
        itemInstructions = [tempDict objectForKey:@"instructions"];
        itemServingPrice = [tempDict objectForKey:@"serving_price"];
    
    }else{
        qty = [NSString stringWithFormat:@"%@",[tempDict objectForKey:@"Quantity"]];
        NSString *itemPriceVal = [tempDict objectForKey:@"ItemPrice"];
        NSString *itemOptionsVal = [tempDict objectForKey:@"OptionsPrice"];
        float priceFloatVal = [itemPriceVal floatValue];
        float optionsFloatVal = [itemOptionsVal floatValue];
        cost = priceFloatVal + optionsFloatVal;
        itemName = [tempDict objectForKey:@"ItemName"];
        itemQtyTextField.userInteractionEnabled = YES;
        itemDesctiption = [tempDict objectForKey:@"desc"];
        itemServingName = [tempDict objectForKey:@"ServingName"];
        itemInstructions = [tempDict objectForKey:@"Instructions"];
        
        itemServingPrice = [tempDict objectForKey:@"ItemPrice"];

    }
    
    itemQtyTextField.layer.backgroundColor = [[UIColor clearColor]CGColor];
    itemQtyTextField.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    itemQtyTextField.layer.borderWidth=qtyBorderWidth;
    itemQtyTextField.layer.cornerRadius = qtyCornerRadious;
    itemQtyTextField.tag = tag;
    itemQtyTextField.text = qty;
    itemQtyTextField.textAlignment = NSTextAlignmentCenter;
    itemQtyTextField.font = itemQtyFont;
    itemQtyTextField.textColor = [UIColor darkGrayColor];
    itemQtyTextField.delegate = self;
    itemQtyTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    itemQtyTextField.returnKeyType = UIReturnKeyDone;
    
    
    UILabel *itemNameLabel = [[UILabel alloc]initWithFrame:itemNameFrame];
    itemNameLabel.text = itemName;
    itemNameLabel.font = itemNameFont;
    itemNameLabel.adjustsFontSizeToFitWidth=YES;
    [itemNameLabel setMinimumScaleFactor:12.0/[UIFont labelFontSize]];
    itemNameLabel.numberOfLines =5;
    
    UILabel *itemCostLabel = [[UILabel alloc]initWithFrame:itemCostFrame];
    itemCostLabel.textColor = [FAUtilities getUIColorObjectFromHexString:@"E79532" alpha:1];
    itemCostLabel.contentMode =UIViewContentModeTop;
    itemCostLabel.textAlignment = NSTextAlignmentRight;
    
    NSRange range = [[NSString stringWithFormat:@"$%0.2f",cost] rangeOfString:@"."];
    range.length = [NSString stringWithFormat:@"$%0.2f",cost].length - range.location;
    NSRange range1 = NSMakeRange(0, 1);
    
    NSDictionary *normalAttributes = @{ NSFontAttributeName : [UIFont fontWithName:@"Cochin-Bold" size:normalAttributesFont],
                                        NSForegroundColorAttributeName : [FAUtilities getUIColorObjectFromHexString:@"E79532" alpha:1] };
    
    NSDictionary *smallAttributes = @{ NSFontAttributeName : [UIFont fontWithName:@"Cochin" size:smallAttributesFont],
                                       NSForegroundColorAttributeName : [FAUtilities getUIColorObjectFromHexString:@"E79532" alpha:1] };
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"$%0.2f",cost] attributes:normalAttributes];
    [attributedString setAttributes:smallAttributes range:range];
    [attributedString setAttributes:smallAttributes range:range1];

    itemCostLabel.attributedText = attributedString;

    UILabel *itemDescLabel = [[UILabel alloc]initWithFrame:itemDescFrame];
    itemDescLabel.numberOfLines = 0;
    itemDescLabel.font = itemDescFont;
    itemDescLabel.text = itemDesctiption;
    
    UILabel *itemSizeHeadingLabel = [[UILabel alloc]initWithFrame:sizeHeadingFrame];
    itemSizeHeadingLabel.text = @"   Size";
    itemSizeHeadingLabel.backgroundColor = [UIColor lightGrayColor];
    itemSizeHeadingLabel.textColor = [UIColor whiteColor];
    itemSizeHeadingLabel.font = modifierHeadingFont;

    UILabel *itemSizeValueLabel = [[UILabel alloc]initWithFrame:sizeValueFrame];
    itemSizeValueLabel.text = itemServingName;
    itemSizeValueLabel.textColor = [UIColor blackColor];
    itemSizeValueLabel.font = modifierOptionsFont;
    
    UILabel *itemSizeValuePriceLabel = [[UILabel alloc]initWithFrame:sizeValuePriceFrame];
    itemSizeValuePriceLabel.text = [NSString stringWithFormat:@"$%@",itemServingPrice];
    itemSizeValuePriceLabel.textColor = [UIColor blackColor];
    itemSizeValuePriceLabel.font = modifierOptionsFont;
    itemSizeValuePriceLabel.textAlignment = NSTextAlignmentRight;
    
    [folderVIew addSubview:itemSizeValuePriceLabel];
    [folderVIew addSubview:itemSizeHeadingLabel];
    [folderVIew addSubview:itemSizeValueLabel];
    
    NSMutableArray *itemModifiersAry = [[NSMutableArray alloc]init];
  
    if ([placeOrderParentView isEqualToString:@"MyOrdersView"]) {
        itemModifiersAry = [tempDict objectForKey:@"item_modifiers"];
    }else{
        dbManager = [DataBaseManager dataBaseManager];
        [dbManager execute:[NSString stringWithFormat:@"SELECT * FROM OrderModifier where OrderDetailsID ='%@' ",[tempDict objectForKey:@"ID"]] resultsArray:itemModifiersAry];
    }
    
    NSMutableArray *finalModifierArray = [[NSMutableArray alloc]init];
    finalModifierArray = [self getFormattedModifiers:itemModifiersAry];

    int categoryX =0;
    int categoryY =0;
    int categoryWidth = 0;
    int categoryHeight =0;
    int instLabelYGap;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        categoryX       = 20;
        categoryY       = sizeValueFrame.origin.y+sizeValueFrame.size.height +6;
        categoryWidth   = sizeHeadingFrame.size.width;
        categoryHeight  = 28;
        instLabelYGap = 10;
    }else{
        categoryX       = 10;
        categoryY       = sizeValueFrame.origin.y+sizeValueFrame.size.height +6;
        categoryWidth   = sizeHeadingFrame.size.width;
        categoryHeight  = 20;
        instLabelYGap = 4;
    }
    
    CGRect lastModifierFrame;

    for (int i=0; i<[finalModifierArray count]; i++) {
        NSDictionary *modifierDict = [finalModifierArray objectAtIndex:i];
        NSString *modifierNameKey;
        NSString *modifierOptionKey;
        NSString *modifierPricekey;
        
        if ([placeOrderParentView isEqualToString:@"MyOrdersView"]) {
            modifierNameKey     = @"modifier_name";
            modifierOptionKey   = @"option_name";
            modifierPricekey    = @"option_price";
        }else{
            modifierNameKey     = @"ModifierName";
            modifierOptionKey   = @"OptionName";
            modifierPricekey    = @"OptionPrice";
        }
        
        NSString *itemModifier = [modifierDict objectForKey:modifierNameKey];
        
        UILabel *itemModifierLabel = [[UILabel alloc]initWithFrame:CGRectMake(categoryX, categoryY, categoryWidth, categoryHeight)];
        itemModifierLabel.text = [NSString stringWithFormat:@"   %@",itemModifier];
        itemModifierLabel.font = modifierHeadingFont;
        itemModifierLabel.backgroundColor = [UIColor lightGrayColor];
        itemModifierLabel.textColor = [UIColor whiteColor];

        int optionX = 0;
        int optionY = 0;
        int optionWidth = 0;
        int optionHeight = 0;
        
        int optionPriceX = 0;
        int optionPriceY =0;
        int optionPriceWidth = 0;
        int optionPriceHeight=0;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            optionX       = 50;
            optionY       = itemModifierLabel.frame.origin.y+itemModifierLabel.frame.size.height +2;
            optionWidth   = itemDescFrame.size.width-150;
            optionHeight  = 28;
            
            optionPriceX = optionX + optionWidth +6;
            optionPriceY = optionY;
            optionPriceWidth = 100;
            optionPriceHeight = 28;
        }else{
            optionX       = 30;
            optionY       = itemModifierLabel.frame.origin.y+itemModifierLabel.frame.size.height +2;
            optionWidth   = itemDescFrame.size.width-100;
            optionHeight  = 20;
            
            optionPriceX = optionX + optionWidth +6;
            optionPriceY = optionY;
            optionPriceWidth = 60;
            optionPriceHeight = 20;
        }
        
        NSArray *itemModifierOptions = [modifierDict objectForKey:@"Options"];
        
        for (int j=0; j<[itemModifierOptions count]; j++) {
            categoryY = optionY + optionHeight +4;
            
            NSDictionary *itemModifierOptionsDict  = [itemModifierOptions objectAtIndex:j];
            NSString *itemModifierOptionName = [itemModifierOptionsDict objectForKey:modifierOptionKey];
            NSString *itemModifierOptionPrice = [itemModifierOptionsDict objectForKey:modifierPricekey];
            UILabel *itemModifierOptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(optionX, optionY, optionWidth, optionHeight)];
            itemModifierOptionLabel.text = itemModifierOptionName;
            itemModifierOptionLabel.font = modifierOptionsFont;
            itemModifierOptionLabel.textColor = [UIColor blackColor];

            UILabel *itemModifierOptionPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(optionPriceX, optionPriceY, optionPriceWidth, optionPriceHeight)];
            
            if ([itemModifierOptionPrice floatValue] > 0) {
                itemModifierOptionPriceLabel.text =[NSString stringWithFormat:@"$%@",itemModifierOptionPrice] ;
            }else{
                itemModifierOptionPriceLabel.text =@"---" ;
            }
            
            itemModifierOptionPriceLabel.font = modifierOptionsFont;
            itemModifierOptionPriceLabel.textAlignment = NSTextAlignmentRight;
            
            optionPriceY = optionPriceY + optionHeight +2;
            optionY = optionY + optionHeight +2;
            
            [folderVIew addSubview:itemModifierOptionLabel];
            [folderVIew addSubview:itemModifierOptionPriceLabel];
            
            lastModifierFrame = itemModifierOptionLabel.frame;
            int qtyVal = [qty intValue];
            
            if (qtyVal <= 0) {
                itemModifierLabel.textColor= [FAUtilities getUIColorObjectFromHexString:@"C9C9C9" alpha:1];
                itemModifierOptionLabel.textColor= [FAUtilities getUIColorObjectFromHexString:@"C9C9C9" alpha:1];
                itemModifierOptionPriceLabel.textColor = [FAUtilities getUIColorObjectFromHexString:@"C9C9C9" alpha:1];
            }
        }
        [folderVIew addSubview:itemModifierLabel];
    }
    
    if ([finalModifierArray count] ==0) {
        lastModifierFrame = itemSizeValueLabel.frame;
    }
    
    itemInstFrame = CGRectMake(20, lastModifierFrame.origin.y+lastModifierFrame.size.height+instLabelYGap, rect.size.width - 40, instHeight);
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:itemInstHeadingFont
                                                                forKey:NSFontAttributeName];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"Instructions: " attributes:attrsDictionary];
    
    NSDictionary *attrsDictionary1 = [NSDictionary dictionaryWithObject:itemInstFont
                                                                forKey:NSFontAttributeName];
    NSAttributedString *attrString1 = [[NSAttributedString alloc] initWithString:itemInstructions attributes:attrsDictionary1];
    [attrString appendAttributedString:attrString1];
    
    
    UILabel *instructionsLabel = [[UILabel alloc]initWithFrame:itemInstFrame];
    instructionsLabel.numberOfLines = 0;
    instructionsLabel.attributedText = attrString;
    
    if (itemInstructions.length != 0) {
        [folderVIew addSubview:instructionsLabel];
    }
    
    [folderVIew addSubview:itemDescLabel];
    [folderVIew addSubview:itemQtyTextField];
    [folderVIew addSubview:itemNameLabel];
    [folderVIew addSubview:itemCostLabel];
    
    int qtyVal = [qty intValue];
    
    if (qtyVal <= 0) {
        
        NSAttributedString * title =
        [[NSAttributedString alloc] initWithString:itemNameLabel.text
                                        attributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle)}];
        [itemNameLabel setAttributedText:title];
        
        
        NSAttributedString * title1 =
        [[NSAttributedString alloc] initWithString:itemCostLabel.text
                                        attributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle)}];
        [itemCostLabel setAttributedText:title1];

        itemCostLabel.textColor = [UIColor blackColor];
        
        itemQtyTextField.text  = @"0";
        
        
        itemDescLabel.textColor = [FAUtilities getUIColorObjectFromHexString:@"C9C9C9" alpha:1];
        itemSizeHeadingLabel.textColor= [FAUtilities getUIColorObjectFromHexString:@"C9C9C9" alpha:1];
        itemSizeValueLabel.textColor= [FAUtilities getUIColorObjectFromHexString:@"C9C9C9" alpha:1];
        instructionsLabel.textColor = [FAUtilities getUIColorObjectFromHexString:@"C9C9C9" alpha:1];
        itemSizeValuePriceLabel.textColor = [FAUtilities getUIColorObjectFromHexString:@"C9C9C9" alpha:1];
    }
    return folderVIew;
}


-(NSMutableArray *)getFormattedModifiers:(NSMutableArray *)modifiersArray{

    NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
    NSString *placeOrderParentView = [defaults objectForKey:@"PlaceOrderParentView"];
    NSString *modifierNameKey;
    
    if ([placeOrderParentView isEqualToString:@"MyOrdersView"]) {
        modifierNameKey = @"modifier_name";
    }else{
        modifierNameKey = @"ModifierName";
    }
    
    NSMutableArray *termpModofierNameArray = [[NSMutableArray alloc]init];
    
    for (int i=0; i<[modifiersArray count]; i++) {
        NSString *tempModifierName = [[modifiersArray objectAtIndex:i]objectForKey:modifierNameKey];
        [termpModofierNameArray addObject:tempModifierName];
    }
    
    
    NSMutableArray *finalModifierAry = [[NSMutableArray alloc]init];
    [finalModifierAry addObjectsFromArray:[[NSSet setWithArray:termpModofierNameArray] allObjects]];
    
    NSMutableArray *modifiersAry = [[NSMutableArray alloc]init];
    
    for (int i=0; i<[finalModifierAry count]; i++) {
        NSMutableDictionary *tempModifierDict = [[NSMutableDictionary alloc]init];
        NSString *finalModifierName = [finalModifierAry objectAtIndex:i];
        NSMutableArray *optionAry = [[NSMutableArray alloc]init];
        for (int j=0; j<[modifiersArray count]; j++) {
            NSDictionary *tempDict = [modifiersArray objectAtIndex:j];
            if ([[tempDict objectForKey:modifierNameKey] isEqualToString:finalModifierName]) {
                [optionAry addObject:tempDict];
            }
        }
        [tempModifierDict setObject:finalModifierName forKey:modifierNameKey];
        [tempModifierDict setObject:optionAry forKey:@"Options"];
        [modifiersAry addObject:tempModifierDict];
    }
    return modifiersAry;
}



-(void)caluclateCost{
    totalCost = 0.0;
    totalTaxesVal = 0.0;
    
    for (int i=0; i<[itemsAry count]; i++) {
        NSDictionary *tempDict = [[NSDictionary alloc]init];
        tempDict = [itemsAry objectAtIndex:i];
        int qty = [[tempDict objectForKey:@"Quantity"] intValue];
        float cost = [[tempDict objectForKey:@"ItemPrice"] floatValue] + [[tempDict objectForKey:@"OptionsPrice"] floatValue];
        float tempCost = qty * cost;
        float taxes = [[tempDict objectForKey:@"ItemSalesTax"] floatValue];
        float tempSalesTax = qty * taxes;
        totalCost = totalCost + tempCost;
        totalTaxesVal = totalTaxesVal + tempSalesTax;
    }

    float completeCost = totalCost + totalTaxesVal;
    
    
    NSString *tempTipstring;
    NSUserDefaults *deliveryDefaults=[NSUserDefaults standardUserDefaults];
    
    NSString *deliveryFee=[deliveryDefaults objectForKey:@"delivery_fee"];
    float deliveryValue=[deliveryFee floatValue];
    
   // deliveryFee=@"2.00";
    
    NSString *orderTypeString = [deliveryDefaults objectForKey:@"OrderType"];
    
    if ([orderTypeString isEqualToString:@"Delivery"]) {
        [restDetailsDict setObject:@"delivery" forKey:@"typeName"];

        if ([deliveryFee isEqualToString:@"0.00"] || [deliveryFee isEqualToString:nil] ) {
            pickUpView.hidden=NO;
            deliveryView.hidden=YES;
            
            subtotalValLabel.text = [NSString stringWithFormat:@"$%0.2f",totalCost];
            subTotalTaxLabel.text = [NSString stringWithFormat:@"$%0.2f",totalTaxesVal];
            tempTipstring = [addTipValue.text substringFromIndex:1];
            tempFloatVal = [tempTipstring floatValue];
        }else{
            pickUpView.hidden=YES;
            deliveryView.hidden=NO;
            
            subtotalValLabelDelivery.text = [NSString stringWithFormat:@"$%0.2f",totalCost];
            subTotalTaxLabelDelivery.text = [NSString stringWithFormat:@"$%0.2f",totalTaxesVal];
            deliveryFeeLabel.text=[NSString stringWithFormat:@"$%0.2f",deliveryValue];
            
            tempTipstring = [addTipValueDelivery.text substringFromIndex:1];
            tempFloatVal = [tempTipstring floatValue];
            tempFloatVal +=deliveryValue;
        }
    }else{
        [restDetailsDict setObject:@"pick up" forKey:@"typeName"];
        
        pickUpView.hidden=NO;
        deliveryView.hidden=YES;
        
        subtotalValLabel.text = [NSString stringWithFormat:@"$%0.2f",totalCost];
        subTotalTaxLabel.text = [NSString stringWithFormat:@"$%0.2f",totalTaxesVal];
        tempTipstring = [addTipValue.text substringFromIndex:1];
        tempFloatVal = [tempTipstring floatValue];
    }
    
    
    
    if ([addTipValue.text isEqualToString:@"Add Tip?"] || [addTipValueDelivery.text isEqualToString:@"Add Tip?"]) {
        if ([orderTypeString isEqualToString:@"Delivery"]) {
            if (deliveryValue>0.00) {
                completeCost +=deliveryValue;
            }
        }else{
            
        }
    }else{
        completeCost = completeCost + tempFloatVal;
    }
    
    totalOrderCostLabel.text = [NSString stringWithFormat:@"$%0.2f",completeCost];
    NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
    NSString *placeOrderParentView = [defaults objectForKey:@"PlaceOrderParentView"];
    
    if ([placeOrderParentView isEqualToString:@"MyOrdersView"]) {
        subtotalValLabel.text = [NSString stringWithFormat:@"$%@",subTotalVal];
        subTotalTaxLabel.text = [NSString stringWithFormat:@"$%@",taxVal];
        totalOrderCostLabel.text = [NSString stringWithFormat:@"$%@",totalVal];
        
        subtotalValLabelDelivery.text = [NSString stringWithFormat:@"$%@",subTotalVal];
        subTotalTaxLabelDelivery.text = [NSString stringWithFormat:@"$%@",taxVal];
    }
}


-(IBAction)backBtnClicked:(id)sender{
    
    NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
    NSString *placeOrderParentView = [defaults objectForKey:@"PlaceOrderParentView"];

    if ([placeOrderParentView isEqualToString:@"DishDetailsView"] || [placeOrderParentView isEqualToString:@"itemMenu"] || [placeOrderParentView isEqualToString:@"CategoryListView"] || [placeOrderParentView isEqualToString:@"MyOrdersView"]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if ([placeOrderParentView isEqualToString:@"LoginViewFromOrder"]){
        NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
        [defaults setObject:@"placeOrderView" forKey:@"DishDetailsParentView"];
        [defaults synchronize];
        
        DishDetailsViewController *selectItem = [self.storyboard instantiateViewControllerWithIdentifier:@"DishDetailsViewController"];
        selectItem.itemDetailsDict = dishItemDetailsDict;
        [self presentViewController:selectItem animated:YES completion:nil];

    }else if ([placeOrderParentView isEqualToString:@"LoginViewFromSharingVC"]){

        NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
        [defaults setObject:@"placeOrderView" forKey:@"SharingVCParentView"];
        [defaults synchronize];
        
        ShareDetailsViewController *selectItemVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ShareDetailsViewController"];
        selectItemVC.itemDetailsDict = dishItemDetailsDict;
        [self presentViewController:selectItemVC animated:YES completion:nil];
    }
    else if ([placeOrderParentView isEqualToString:@"LoginViewCategoryList"]){
        [self performSegueWithIdentifier:@"PlaceOrderToCustomTable" sender:self];
    }
}


-(IBAction)placeOrderBtnClicked:(id)sender{
    
    NSMutableArray *itemDetailsAry = [[NSMutableArray alloc]init];
    dbManager = [DataBaseManager dataBaseManager];
    [dbManager execute:[NSString stringWithFormat:@"SELECT * FROM OrderDetails where OrderID ='%@' and Quantity > 0 ",@""] resultsArray:itemDetailsAry];

    if (itemDetailsAry.count > 0) {
        subViewAlertStr = @"LoadPayment";
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];

        NSString *orderTypeString = [def objectForKey:@"OrderType"];
        NSString* deliveryFee=[def objectForKey:@"delivery_fee"];
        float deliFee = [deliveryFee floatValue];
        if ([orderTypeString isEqualToString:@"Delivery"] ) {
            
            NSString *minCartAmount = [def objectForKey:@"min_cart_amount"];
            NSString *subTotal =  [NSString stringWithFormat:@"%0.2f",totalCost];
            NSLog(@"minCartAmount:%@\n%@",minCartAmount,subTotal);
            
            if ([subTotal floatValue] >=[minCartAmount floatValue]) {
                [self loadPaymentSubView];

            }else{
                customAlertMessage = [NSString stringWithFormat:@"Unfortunately, your order does not meet the minimum purchase requirement of $%@. Please make sure your cart amount exceeds this minimum.",minCartAmount];
                customAlertTitle = @"Alert";
                [self LoadCustomAlertWithMessage];
            }
  
        }else{
            [self loadPaymentSubView];

        }
        
        
        
        
        
    }else{
        customAlertMessage = @"Your cart is empty";
        customAlertTitle = @"Alert";
        [self LoadCustomAlertWithMessage];
    }
}


-(void)loadPaymentSubView{
    CGRect cardHolderNameFrame;
    CGRect cardIconsSubViewFrame;
    
    CGRect cardNumberFrame;
    CGRect cardExpDateLabelFrame;
    CGRect cardExpDateValueFrame;
    CGRect cardCvvLabelFrame;
    CGRect cardCvvValueFrame;
    CGRect cancelBtnFrame;
    CGRect submitBtnFrame;
    
    CGRect creditIcon1Frame;
    CGRect creditIcon2Frame;
    CGRect creditIcon3Frame;
    CGRect creditIcon4Frame;
    
    CGRect paymentSubViewFrame;
    
    CGRect headingViewPlaceholderFrame;
    CGRect headingViewFrame;
    CGRect headingLabelFrame;
    
    UIFont *headingLabelFont;
    
    CGRect cardHolderUndelineLabelFrame;
    
    CGRect cardNumberUnderlineLabelFrame;
    UIFont *valuesFont;
    UIFont *msgLabelFont;

    CGRect cardExpDateUnderLineLabelFrame;
    CGRect cardCvvUnderLineLabelFrame;
    
    UIFont *btnFonts;
    
    CGRect disableViewFrame;
    
    // for custom success mesages
    CGRect paymentSuccessCancelButtonFrame;
    CGRect paymenySuccessLabelFrame;

    CGRect paymenySuccessLabelFrameLine1;
    CGRect paymenySuccessLabelRestNameFrame;
    CGRect paymenySuccessLabelAddressFrame;

    CGRect paymentSuccessLabelPhoneMsgLabelFrame;
    CGRect paymentSuccessLabelPhoneNumberLabelFrame;
    CGRect paymentSuccessUndeLineLabelFrame;

    
    CGRect paymentOrerIDLabelFrame;
    CGRect paymentTotalValueLabelFrame;
    
    UIFont *boldFont;
    CGFloat paymentSubViewiPadHeight=0.0;
    CGFloat paymentSubViewiPhoneHeight=0.0;

    
    if ([subViewAlertStr isEqualToString:@"LoadPayment"]) {
        
        paymentSubViewiPadHeight=450;
        paymentSubViewiPhoneHeight=40;
    }else if ([subViewAlertStr isEqualToString:@"PaymentResponseSuccess"])
    {
        paymentSubViewiPadHeight=550;
        paymentSubViewiPhoneHeight=80;

    }
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
            paymentSubViewFrame = CGRectMake(262, 159, 500, paymentSubViewiPadHeight);
            disableViewFrame = CGRectMake(0, 0, 1024, 768);
        }else if(UIInterfaceOrientationIsPortrait(STATUSBAR_ORIENTATION)){
            paymentSubViewFrame = CGRectMake(134, 287-50, 500, paymentSubViewiPadHeight);
            disableViewFrame = CGRectMake(0, 0, 768, 1024);
        }
        
        headingViewPlaceholderFrame = CGRectMake(0, 0, paymentSubViewFrame.size.width, 10);
        headingViewFrame = CGRectMake(0, 8, paymentSubViewFrame.size.width, 45);
        headingLabelFrame = CGRectMake(12, 0, headingViewFrame.size.width-24, 45);
        headingLabelFont = [UIFont fontWithName:@"Thonburi" size:32];
        valuesFont = [UIFont fontWithName:@"Thonburi" size:28];
        msgLabelFont = [UIFont fontWithName:@"Thonburi" size:23];

        btnFonts = [UIFont fontWithName:@"Verdana" size:30];
        
        cardHolderNameFrame = CGRectMake(20, headingViewFrame.origin.y + headingViewFrame.size.height +8, paymentSubViewFrame.size.width-40, 60);
        
        cardIconsSubViewFrame = CGRectMake(20, cardHolderNameFrame.origin.y + cardHolderNameFrame.size.height +8, paymentSubViewFrame.size.width-40, 60);

        
        creditIcon1Frame = CGRectMake(107-20, 10, 60, 40);
        creditIcon2Frame = CGRectMake(creditIcon1Frame.origin.x+creditIcon1Frame.size.width+15, 10, 60, 40);
        creditIcon3Frame = CGRectMake(creditIcon2Frame.origin.x+creditIcon2Frame.size.width+15, 10, 60, 40);
        creditIcon4Frame = CGRectMake(creditIcon3Frame.origin.x+creditIcon3Frame.size.width+15, 10, 60, 40);

        cardNumberFrame = CGRectMake(20, cardIconsSubViewFrame.origin.y + cardIconsSubViewFrame.size.height +12, paymentSubViewFrame.size.width-40, 60);

        cardExpDateLabelFrame = CGRectMake(10, cardNumberFrame.origin.y + cardNumberFrame.size.height +12, 80, 60);

        cardExpDateValueFrame = CGRectMake(cardExpDateLabelFrame.origin.x+cardExpDateLabelFrame.size.width+4, cardNumberFrame.origin.y + cardNumberFrame.size.height +12, 149, 60);

        cardCvvLabelFrame = CGRectMake(cardExpDateValueFrame.origin.x+cardExpDateValueFrame.size.width+20, cardNumberFrame.origin.y + cardNumberFrame.size.height +12, 80, 60);
       
        cardCvvValueFrame = CGRectMake(cardCvvLabelFrame.origin.x+cardCvvLabelFrame.size.width+4, cardNumberFrame.origin.y + cardNumberFrame.size.height +12, 149, 60);

        cancelBtnFrame = CGRectMake(100, cardCvvValueFrame.origin.y + cardCvvValueFrame.size.height +30, 150, 60);
      
        submitBtnFrame = CGRectMake(cancelBtnFrame.origin.x+cancelBtnFrame.size.width+20, cardCvvValueFrame.origin.y + cardCvvValueFrame.size.height +30, 150, 60);

        cardHolderUndelineLabelFrame = CGRectMake(cardHolderNameFrame.origin.x, cardHolderNameFrame.origin.y+34, cardHolderNameFrame.size.width, 24);

        
        cardNumberUnderlineLabelFrame = CGRectMake(cardNumberFrame.origin.x, cardNumberFrame.origin.y+34, cardNumberFrame.size.width, 24);
        
        cardExpDateUnderLineLabelFrame = CGRectMake(cardExpDateLabelFrame.origin.x, cardExpDateLabelFrame.origin.y+34, cardExpDateLabelFrame.size.width+cardExpDateValueFrame.origin.x+cardExpDateValueFrame.size.width, 24);

        cardCvvUnderLineLabelFrame = CGRectMake(cardCvvLabelFrame.origin.x, cardCvvLabelFrame.origin.y+34, cardCvvLabelFrame.size.width+cardCvvValueFrame.origin.x+cardCvvValueFrame.size.width, 24);

        
        
        
        paymentOrerIDLabelFrame = CGRectMake(10, headingViewFrame.origin.y + headingViewFrame.size.height +2, paymentSubViewFrame.size.width-24, 30);
        paymentTotalValueLabelFrame = CGRectMake(10, paymentOrerIDLabelFrame.origin.y + paymentOrerIDLabelFrame.size.height-2 ,paymentOrerIDLabelFrame.size.width, 70);
        
        paymenySuccessLabelFrameLine1 = CGRectMake(10, paymentTotalValueLabelFrame.origin.y + paymentTotalValueLabelFrame.size.height , paymentTotalValueLabelFrame.size.width, paymentTotalValueLabelFrame.size.height);
        
        
        int restNameHeight;
        int addressHeight;

        if ([orderTypeStr isEqualToString:@"delivery"]) {
            restNameHeight = 10;

            CGSize size = [paymentResponseAlertMsgAddress sizeWithFont:msgLabelFont
                           constrainedToSize:(CGSize){paymenySuccessLabelFrameLine1.size.width, CGFLOAT_MAX}];
            
            float height = size.height;
            
            if (height <= 50) {
                addressHeight = 50;
            }else{
                addressHeight = 70;
            }

        }else{
            restNameHeight = 50;
            addressHeight = 70;
        }

        
        paymenySuccessLabelRestNameFrame = CGRectMake(10, paymenySuccessLabelFrameLine1.origin.y+ paymenySuccessLabelFrameLine1.size.height+2, paymenySuccessLabelFrameLine1.size.width, restNameHeight);
        
        paymenySuccessLabelAddressFrame = CGRectMake(10, paymenySuccessLabelRestNameFrame.origin.y+ paymenySuccessLabelRestNameFrame.size.height+2-10, paymenySuccessLabelRestNameFrame.size.width, addressHeight);
    
        paymentSuccessUndeLineLabelFrame = CGRectMake(10, paymenySuccessLabelAddressFrame.origin.y+ paymenySuccessLabelAddressFrame.size.height+2-20, paymenySuccessLabelAddressFrame.size.width, 20);
        
        paymentSuccessLabelPhoneMsgLabelFrame = CGRectMake(10, paymenySuccessLabelAddressFrame.origin.y + paymenySuccessLabelAddressFrame.size.height +12, paymenySuccessLabelAddressFrame.size.width-24, 70);
        
        paymentSuccessLabelPhoneNumberLabelFrame = CGRectMake(10, paymentSuccessLabelPhoneMsgLabelFrame.origin.y + paymentSuccessLabelPhoneMsgLabelFrame.size.height +6, paymentSuccessLabelPhoneMsgLabelFrame.size.width-24, 50);
        
        paymenySuccessLabelFrame = CGRectMake(10, headingViewFrame.origin.y + headingViewFrame.size.height +4, paymentSubViewFrame.size.width-24, 400);
        
        paymentSuccessCancelButtonFrame = CGRectMake(170, paymenySuccessLabelFrame.origin.y + paymenySuccessLabelFrame.size.height +8, 170, 60);

        boldFont = [UIFont fontWithName:@"Thonburi-Bold" size:26];
        
    }else{
        if ([UIScreen mainScreen].bounds.size.height == 568) {  // iphone 4 inch
            paymentSubViewFrame = CGRectMake(18, 98, 320-36, 250+4+50+paymentSubViewiPhoneHeight);
            
        }else{
            paymentSubViewFrame = CGRectMake(18, 78, 320-36, 250+4+50+paymentSubViewiPhoneHeight);
        }
        
        
        headingViewPlaceholderFrame = CGRectMake(0, 0, paymentSubViewFrame.size.width, 10);
        headingViewFrame = CGRectMake(0, 8, paymentSubViewFrame.size.width, 35);
        headingLabelFrame = CGRectMake(8, 0, headingViewFrame.size.width-16, 35);
        headingLabelFont = [UIFont fontWithName:@"Thonburi" size:24];
        
        valuesFont = [UIFont fontWithName:@"Thonburi" size:14];
        msgLabelFont = [UIFont fontWithName:@"Thonburi" size:12];
        btnFonts = [UIFont fontWithName:@"Verdana" size:22];

        cardHolderNameFrame = CGRectMake(10, headingViewFrame.origin.y + headingViewFrame.size.height +8, paymentSubViewFrame.size.width-20, 40);
        
        cardIconsSubViewFrame = CGRectMake(10, cardHolderNameFrame.origin.y + cardHolderNameFrame.size.height +2, paymentSubViewFrame.size.width-20, 40);
        
        creditIcon1Frame = CGRectMake(15, 5, 50, 30);
        creditIcon2Frame = CGRectMake(creditIcon1Frame.origin.x+creditIcon1Frame.size.width+10, 5, 50, 30);
        creditIcon3Frame = CGRectMake(creditIcon2Frame.origin.x+creditIcon2Frame.size.width+10, 5, 50, 30);
        creditIcon4Frame = CGRectMake(creditIcon3Frame.origin.x+creditIcon3Frame.size.width+10, 5, 50, 30);

        cardNumberFrame = CGRectMake(10, cardIconsSubViewFrame.origin.y + cardIconsSubViewFrame.size.height +8, paymentSubViewFrame.size.width-20, 40);
        
        cardExpDateLabelFrame = CGRectMake(10, cardNumberFrame.origin.y + cardNumberFrame.size.height +8, 40, 40);


        cardExpDateValueFrame = CGRectMake(cardExpDateLabelFrame.origin.x+cardExpDateLabelFrame.size.width+1, cardNumberFrame.origin.y + cardNumberFrame.size.height +8, 70, 40);
        
        cardCvvLabelFrame = CGRectMake(cardExpDateValueFrame.origin.x+cardExpDateValueFrame.size.width+6, cardNumberFrame.origin.y + cardNumberFrame.size.height +8, 40, 40);

        cardCvvValueFrame = CGRectMake(cardCvvLabelFrame.origin.x+cardCvvLabelFrame.size.width+1, cardNumberFrame.origin.y + cardNumberFrame.size.height +8, 70, 40);
        
        cancelBtnFrame = CGRectMake(20, cardCvvValueFrame.origin.y + cardCvvValueFrame.size.height +10, 110, 40);

        submitBtnFrame = CGRectMake(cancelBtnFrame.origin.x+cancelBtnFrame.size.width+20, cardCvvValueFrame.origin.y + cardCvvValueFrame.size.height +10, 110, 40);

        
        cardHolderUndelineLabelFrame = CGRectMake(cardHolderNameFrame.origin.x, cardHolderNameFrame.origin.y+16, cardHolderNameFrame.size.width, 24);
        
        
        cardNumberUnderlineLabelFrame = CGRectMake(cardNumberFrame.origin.x, cardNumberFrame.origin.y+16, cardNumberFrame.size.width, 24);

        cardExpDateUnderLineLabelFrame = CGRectMake(cardExpDateLabelFrame.origin.x, cardExpDateLabelFrame.origin.y+16, cardExpDateLabelFrame.size.width+cardExpDateValueFrame.origin.x+cardExpDateValueFrame.size.width, 24);

        cardCvvUnderLineLabelFrame = CGRectMake(cardCvvLabelFrame.origin.x, cardCvvLabelFrame.origin.y+16, cardCvvLabelFrame.size.width+cardCvvValueFrame.origin.x+cardCvvValueFrame.size.width, 24);
  
    
        disableViewFrame = self.view.frame;
        
        paymentOrerIDLabelFrame = CGRectMake(10, headingViewFrame.origin.y + headingViewFrame.size.height +2, paymentSubViewFrame.size.width-24, 20);
         paymentTotalValueLabelFrame = CGRectMake(10, paymentOrerIDLabelFrame.origin.y + paymentOrerIDLabelFrame.size.height-2 ,paymentOrerIDLabelFrame.size.width, 40);
        
        paymenySuccessLabelFrameLine1 = CGRectMake(10, paymentTotalValueLabelFrame.origin.y + paymentTotalValueLabelFrame.size.height , paymentTotalValueLabelFrame.size.width, paymentTotalValueLabelFrame.size.height);
        
        int restNameHeight;
        int addressHeight;
        
        if ([orderTypeStr isEqualToString:@"delivery"]) {
            restNameHeight = 5;
       
            CGSize size = [paymentResponseAlertMsgAddress sizeWithFont:msgLabelFont
                                                     constrainedToSize:(CGSize){paymenySuccessLabelFrameLine1.size.width, CGFLOAT_MAX}];
            
            float height = size.height;
            
            if (height <= 30) {
                addressHeight = 40;//40
            }else{
                addressHeight = 60;//60
            }
            
        }else{
            restNameHeight = 30;
            CGSize size = [paymentResponseAlertMsgAddress sizeWithFont:msgLabelFont
                                                     constrainedToSize:(CGSize){paymenySuccessLabelFrameLine1.size.width, CGFLOAT_MAX}];
            
            float height = size.height;
            
            if (height <= 20) {
                addressHeight = 25;
            }else{
                addressHeight = 40;
            }
        }

        
        
       paymenySuccessLabelRestNameFrame = CGRectMake(10, paymenySuccessLabelFrameLine1.origin.y+ paymenySuccessLabelFrameLine1.size.height+2, paymenySuccessLabelFrameLine1.size.width, restNameHeight);
        
        
        paymenySuccessLabelAddressFrame = CGRectMake(10, paymenySuccessLabelRestNameFrame.origin.y+ paymenySuccessLabelRestNameFrame.size.height+2, paymenySuccessLabelRestNameFrame.size.width, addressHeight);
        
        paymentSuccessLabelPhoneMsgLabelFrame = CGRectMake(10, paymenySuccessLabelAddressFrame.origin.y + paymenySuccessLabelAddressFrame.size.height +12, paymenySuccessLabelAddressFrame.size.width-24, 40);

        paymentSuccessLabelPhoneNumberLabelFrame = CGRectMake(10, paymentSuccessLabelPhoneMsgLabelFrame.origin.y + paymentSuccessLabelPhoneMsgLabelFrame.size.height +6, paymentSuccessLabelPhoneMsgLabelFrame.size.width-24, 30);
        
        paymenySuccessLabelFrame = CGRectMake(10, headingViewFrame.origin.y + headingViewFrame.size.height +6, paymentSubViewFrame.size.width-24, 270);
        
        paymentSuccessCancelButtonFrame = CGRectMake(85, paymenySuccessLabelFrame.origin.y + paymenySuccessLabelFrame.size.height +4, 110, 40);
        boldFont = [UIFont fontWithName:@"Thonburi-Bold" size:20];
    }
    
    diabledview = [[UIView alloc]initWithFrame:disableViewFrame];
    diabledview.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pgm_gallery.png"]];
    
    if([subViewAlertStr isEqualToString:@"LoadPayment"]){
        diabledview.tag = 500;
    }else{
        diabledview.tag = 504;
    }
    UIView *paymentSubView1 = [[UIView alloc]initWithFrame:paymentSubViewFrame];
    paymentSubView1.backgroundColor = [UIColor whiteColor];
    paymentSubView1.layer.cornerRadius = 8;
   
    paymentSubView = [[UIScrollView alloc]initWithFrame:CGRectMake(2, 2, paymentSubView1.frame.size.width-4, paymentSubView1.frame.size.height-4)];

    paymentSubView.backgroundColor = [FAUtilities getUIColorObjectFromHexString:@"EFF0F2" alpha:1];
    paymentSubView.layer.borderColor = [[UIColor grayColor]CGColor];
    paymentSubView.layer.borderWidth = 2;
    paymentSubView.layer.cornerRadius = 8;
    
    
    UIView *headingViewPlaceholder = [[UIView alloc]initWithFrame:headingViewPlaceholderFrame];
    headingViewPlaceholder.backgroundColor = [FAUtilities getUIColorObjectFromHexString:APP_HEADER_COLOR alpha:1];
    headingViewPlaceholder.layer.cornerRadius = 8;

    UIView *headingView = [[UIView alloc]initWithFrame:headingViewFrame];
    headingView.backgroundColor = [FAUtilities getUIColorObjectFromHexString:APP_HEADER_COLOR alpha:1];//#1B3745//A2439D
    
    UILabel *headingLabel = [[UILabel alloc]initWithFrame:headingLabelFrame];
    headingLabel.textColor = [UIColor whiteColor];
    
    if([subViewAlertStr isEqualToString:@"LoadPayment"]){
        headingLabel.text = @"Payment Method";
    }else{
        headingLabel.text = @"Payment Success";
    }
        
    headingLabel.textAlignment = NSTextAlignmentCenter;
    headingLabel.font = headingLabelFont;
    
    cardHolderNameTextField = [[UITextField alloc]initWithFrame:cardHolderNameFrame];
    cardHolderNameTextField.placeholder = @"Cardholder Name";
    cardHolderNameTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    [cardHolderNameTextField becomeFirstResponder];
    [cardHolderNameTextField setReturnKeyType:UIReturnKeyNext];
    cardHolderNameTextField.keyboardType=UIKeyboardTypeDefault;
    UIView *tempView = [[UIView alloc]initWithFrame:cardIconsSubViewFrame];
    
    
    creditIcon1Btn = [[UIButton alloc]initWithFrame:creditIcon1Frame];
    [creditIcon1Btn setBackgroundImage:[UIImage imageNamed:@"pgm_americanExpress_creditCard_Icon.png"] forState:UIControlStateNormal];
   
    
    
    creditIcon2Btn = [[UIButton alloc]initWithFrame:creditIcon2Frame];
    [creditIcon2Btn setBackgroundImage:[UIImage imageNamed:@"pgm_discover_CreditCard_Icon"] forState:UIControlStateNormal];
   
    creditIcon3Btn = [[UIButton alloc]initWithFrame:creditIcon3Frame];
    [creditIcon3Btn setBackgroundImage:[UIImage imageNamed:@"pgm_visa_CreditCard_Icon"] forState:UIControlStateNormal];
   
    creditIcon4Btn = [[UIButton alloc]initWithFrame:creditIcon4Frame];
    [creditIcon4Btn setBackgroundImage:[UIImage imageNamed:@"pgm_master_Creditcard_Icon"] forState:UIControlStateNormal];
   
    
    [tempView addSubview:creditIcon1Btn];
    [tempView addSubview:creditIcon2Btn];
    [tempView addSubview:creditIcon3Btn];
    [tempView addSubview:creditIcon4Btn];
    
    
    cardNumberTextField = [[UITextField alloc]initWithFrame:cardNumberFrame];
    cardNumberTextField.placeholder = @"xxxx-xxxx-xxxx-xxxx";
    [cardNumberTextField setReturnKeyType:UIReturnKeyNext];

    [cardHolderNameTextField setBorderStyle:UITextBorderStyleNone];
    [cardNumberTextField setBorderStyle:UITextBorderStyleNone];


    
    UILabel *cardExpDateLabel = [[UILabel alloc]initWithFrame:cardExpDateLabelFrame];
    cardExpDateLabel.text = @"Exp:";
    
    
    cardExpDateTextField = [[UITextField alloc]initWithFrame:cardExpDateValueFrame];
    [cardExpDateTextField setBorderStyle:UITextBorderStyleNone];
    cardExpDateTextField.placeholder = @"xx/xxxx";
    [cardExpDateTextField setReturnKeyType:UIReturnKeyNext];

   

    
    UILabel *cardCvvLabel = [[UILabel alloc]initWithFrame:cardCvvLabelFrame];
    cardCvvLabel.text = @"Cvv:";
    
    cardCvvTextField = [[UITextField alloc]initWithFrame:cardCvvValueFrame];
    [cardCvvTextField setBorderStyle:UITextBorderStyleNone];
    cardCvvTextField.placeholder = @"xxx";
    [cardCvvTextField setReturnKeyType:UIReturnKeyDone];

    cardCancelBtn = [[UIButton alloc]initWithFrame:cancelBtnFrame];
    cardSubmitBtn = [[UIButton alloc]initWithFrame:submitBtnFrame];
    paymentSuccessCancelBtn = [[UIButton alloc]initWithFrame:paymentSuccessCancelButtonFrame];
    
    UILabel *cardHolderUndelineLabel = [[UILabel alloc]initWithFrame:cardHolderUndelineLabelFrame];
    UILabel *cardNumberUndelineLabel = [[UILabel alloc]initWithFrame:cardNumberUnderlineLabelFrame];
    UILabel *cardExpDateUndelineLabel = [[UILabel alloc]initWithFrame:cardExpDateUnderLineLabelFrame];
    UILabel *cardCvvUndelineLabel = [[UILabel alloc]initWithFrame:cardCvvUnderLineLabelFrame];
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        cardHolderUndelineLabel.text = @"_____________________________________________________";
        cardHolderUndelineLabel.textColor = [UIColor grayColor];
        
        cardNumberUndelineLabel.text = @"_____________________________________________________";
        cardNumberUndelineLabel.textColor = [UIColor grayColor];
        
        cardExpDateUndelineLabel.text = @"__________________________";
        cardExpDateUndelineLabel.textColor = [UIColor grayColor];
        
        cardCvvUndelineLabel.text = @"__________________________";
        cardCvvUndelineLabel.textColor = [UIColor grayColor];
    
    }else{
        cardHolderUndelineLabel.text = @"______________________________";
        cardHolderUndelineLabel.textColor = [UIColor grayColor];
        
        cardNumberUndelineLabel.text = @"______________________________";
        cardNumberUndelineLabel.textColor = [UIColor grayColor];
        
        cardExpDateUndelineLabel.text = @"_____________";
        cardExpDateUndelineLabel.textColor = [UIColor grayColor];
        
        cardCvvUndelineLabel.text = @"_____________";
        cardCvvUndelineLabel.textColor = [UIColor grayColor];
    
    }
    
    
    
    
    cardCancelBtn.titleLabel.font = btnFonts;
    cardSubmitBtn.titleLabel.font = btnFonts;
    paymentSuccessCancelBtn.titleLabel.font = btnFonts;
    
    [cardCancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    [cardCancelBtn addTarget:self action:@selector(doneBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [FAUtilities setBackgroundImagesForButton:cardCancelBtn];
    
    
    [cardSubmitBtn setTitle:@"Submit" forState:UIControlStateNormal];
    [cardSubmitBtn addTarget:self action:@selector(cardSubmitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [FAUtilities setBackgroundImagesForButton:cardSubmitBtn];

    
    [paymentSuccessCancelBtn setTitle:@"Ok" forState:UIControlStateNormal];
    [paymentSuccessCancelBtn addTarget:self action:@selector(paymentSuccessCancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [FAUtilities setBackgroundImagesForButton:paymentSuccessCancelBtn];


    
    cardNumberTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;

    cardExpDateTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;

    cardCvvTextField.returnKeyType = UIReturnKeyDone;
    cardCvvTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    cardCvvTextField.secureTextEntry = YES;
    
    
    cardHolderNameTextField.delegate = self;
    cardNumberTextField.delegate = self;
    cardExpDateTextField.delegate = self;
    cardCvvTextField.delegate = self;

    cardHolderNameTextField.font = valuesFont;
    cardNumberTextField.font = valuesFont;
    cardExpDateTextField.font = valuesFont;
    cardCvvTextField.font = valuesFont;
    
    cardExpDateLabel.font = valuesFont;
    cardCvvLabel.font = valuesFont;
    
    cardCvvLabel.textAlignment = NSTextAlignmentRight;
    cardExpDateLabel.textAlignment = NSTextAlignmentRight;

    
    
    UILabel *paymentOrderIdLabel = [[UILabel alloc]initWithFrame:paymentOrerIDLabelFrame];
    paymentOrderIdLabel.numberOfLines = 0;
    paymentOrderIdLabel.font = msgLabelFont;
    paymentOrderIdLabel.text = paymentOrderId;
    paymentOrderIdLabel.textAlignment = NSTextAlignmentLeft;
    
    UILabel *paymentTotalValueLabel = [[UILabel alloc]initWithFrame:paymentTotalValueLabelFrame];
    paymentTotalValueLabel.numberOfLines = 0;
    paymentTotalValueLabel.font = msgLabelFont;
    paymentTotalValueLabel.text = paymentOrderTotalValue;
    paymentTotalValueLabel.textAlignment = NSTextAlignmentLeft;
    
    UILabel *paymenySuccessLabelFrameLine1Label = [[UILabel alloc]initWithFrame:paymenySuccessLabelFrameLine1];
    paymenySuccessLabelFrameLine1Label.numberOfLines = 0;
    paymenySuccessLabelFrameLine1Label.font = msgLabelFont;
    paymenySuccessLabelFrameLine1Label.text = paymentResponseAlertMsgLine1;
    paymenySuccessLabelFrameLine1Label.textAlignment = NSTextAlignmentLeft;
    
    UILabel *paymenySuccessLabelRestNameLabel = [[UILabel alloc]initWithFrame:paymenySuccessLabelRestNameFrame];
    paymenySuccessLabelRestNameLabel.numberOfLines = 0;
    paymenySuccessLabelRestNameLabel.font = boldFont;
    paymenySuccessLabelRestNameLabel.text=[restDetails objectForKey:@"RestaurantName"];
    paymenySuccessLabelRestNameLabel.textAlignment = NSTextAlignmentLeft;
    
    
    UILabel *paymenySuccessLabelAddressLabel = [[UILabel alloc]initWithFrame:paymenySuccessLabelAddressFrame];
    paymenySuccessLabelAddressLabel.numberOfLines = 0;
    paymenySuccessLabelAddressLabel.font = msgLabelFont;
    paymenySuccessLabelAddressLabel.text = paymentResponseAlertMsgAddress;
    paymenySuccessLabelAddressLabel.textAlignment = NSTextAlignmentLeft;

    CALayer *layer2 = [CALayer layer];
    layer2.frame = CGRectMake(0, paymenySuccessLabelAddressLabel.layer.frame.size.height - 2, paymenySuccessLabelAddressLabel.layer.frame.size.width, 2);
    layer2.backgroundColor = [UIColor blackColor].CGColor;
    [paymenySuccessLabelAddressLabel.layer addSublayer:layer2];
    
    NSMutableArray *loginArray = [[NSMutableArray alloc]init];
    dbManager = [DataBaseManager dataBaseManager];
    [dbManager execute:[NSString stringWithFormat:@"SELECT * FROM LoginDetails "] resultsArray:loginArray];
    
    
    UILabel *paymentSuccessLabelPhoneMsgLabel = [[UILabel alloc]initWithFrame:paymentSuccessLabelPhoneMsgLabelFrame];
    paymentSuccessLabelPhoneMsgLabel.numberOfLines = 0;
    paymentSuccessLabelPhoneMsgLabel.font = msgLabelFont;
    paymentSuccessLabelPhoneMsgLabel.text = @"We'll also call you at this number if we have any questions.";
    paymentSuccessLabelPhoneMsgLabel.textAlignment = NSTextAlignmentLeft;

    
    UILabel *paymentSuccessLabelPhoneNumberLabel = [[UILabel alloc]initWithFrame:paymentSuccessLabelPhoneNumberLabelFrame];
    paymentSuccessLabelPhoneNumberLabel.numberOfLines = 0;
    paymentSuccessLabelPhoneNumberLabel.font = boldFont;
    paymentSuccessLabelPhoneNumberLabel.text = [[loginArray objectAtIndex:0]valueForKey:@"Phone"];
    paymentSuccessLabelPhoneNumberLabel.textAlignment = NSTextAlignmentLeft;
    
    
  
    [headingView addSubview:headingLabel];
    [paymentSubView addSubview:headingView];
   
    [paymentSubView addSubview:headingViewPlaceholder];
    
    if ([subViewAlertStr isEqualToString:@"LoadPayment"]) {
        
        [paymentSubView addSubview:cardHolderNameTextField];
        [paymentSubView addSubview:cardHolderUndelineLabel];
        [paymentSubView addSubview:cardNumberTextField];
        [paymentSubView addSubview:cardNumberUndelineLabel];
        [paymentSubView addSubview:cardExpDateTextField];
        [paymentSubView addSubview:cardExpDateUndelineLabel];
        [paymentSubView addSubview:tempView];
        
        
        [paymentSubView addSubview:cardCvvTextField];
        [paymentSubView addSubview:cardCvvUndelineLabel];
        
        [paymentSubView addSubview:cardExpDateLabel];
        [paymentSubView addSubview:cardCvvLabel];
        [paymentSubView addSubview:cardCancelBtn];
        [paymentSubView addSubview:cardSubmitBtn];
        
    }else{
        [paymentSubView addSubview:paymentSuccessCancelBtn];
        
        [paymentSubView addSubview:paymentOrderIdLabel];
        [paymentSubView addSubview:paymentTotalValueLabel];

        
        [paymentSubView addSubview:paymenySuccessLabelFrameLine1Label];
        [paymentSubView addSubview:paymenySuccessLabelRestNameLabel];
        
        if ([orderTypeStr isEqualToString:@"delivery"]) {
            paymenySuccessLabelRestNameLabel.hidden = YES;
        }else{
            paymenySuccessLabelRestNameLabel.hidden = NO;
        }
        
        [paymentSubView addSubview:paymenySuccessLabelAddressLabel];
        
        if ([paymentSuccessLabelPhoneNumberLabel.text isEqualToString:nil] || [paymentSuccessLabelPhoneNumberLabel.text isEqualToString:@""] ) {
            
            [paymentSuccessLabelPhoneNumberLabel removeFromSuperview];
            [paymentSuccessLabelPhoneMsgLabel removeFromSuperview];

            //no phone num we are not adding phone and msg label
            
        }else{
            [paymentSubView addSubview:paymentSuccessLabelPhoneMsgLabel];
            [paymentSubView addSubview:paymentSuccessLabelPhoneNumberLabel];
        }
    }
    
    [paymentSubView1 addSubview:paymentSubView];

    [diabledview addSubview:paymentSubView1];

    [self.view addSubview:diabledview];

}





- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [self drawAttchmentsView];
    
    for (UIView *subView in self.view.subviews) {
        if (subView.tag ==501) {
            [subView removeFromSuperview];
            [self loadCustomAlertSubView:alertMsg];
        }else if (subView.tag == 500){
            [diabledview removeFromSuperview];
            subViewAlertStr = @"LoadPayment";
            [self loadPaymentSubView];
     }else if (subView.tag == 504){
            [diabledview removeFromSuperview];
            subViewAlertStr = @"PaymentResponseSuccess";
            [self loadPaymentSubView];
        }else if (subView.tag == 700){
            [disableCustomAlertView removeFromSuperview];
            [self LoadCustomAlertWithMessage];
        }
    }
}

-(void)paymentSuccessCancelBtnClicked:(id)sender{
    [diabledview removeFromSuperview];
    [self backBtnClicked:nil];
}


-(void)doneBtnClicked:(id)sender{
    [diabledview removeFromSuperview];
}

-(void)cardSubmitBtnClicked:(id)sender{
    [self.view endEditing:YES];
    
    if (cardHolderNameTextField.text.length ==0) {
        customAlertMessage = @"Please enter your full name";
        customAlertTitle = @"Alert";
        [self LoadCustomAlertWithMessage];
    }else if (cardNumberTextField.text.length ==0){
        customAlertMessage = @"Please enter your card number";
        customAlertTitle = @"Alert";
        [self LoadCustomAlertWithMessage];
    }else if (cardExpDateTextField.text.length ==0){
        customAlertMessage = @"Please enter your expiration date";
        customAlertTitle = @"Alert";
        [self LoadCustomAlertWithMessage];
    }else if (cardCvvTextField.text.length ==0){
        customAlertMessage = @"Please enter your CVV";
        customAlertTitle = @"Alert";
        [self LoadCustomAlertWithMessage];
    }else if (cardNumberTextField.text.length <17 && cardNumberTextField.text.length > 0){
         customAlertMessage = @"Please enter a valid card number";
         customAlertTitle = @"Alert";
         [self LoadCustomAlertWithMessage];
    }else  if ( cardNum==15) {
         if ([cardCvvTextField.text length]==3) {
              customAlertMessage = @"Please enter a valid 4 Digits CVV number";
              customAlertTitle = @"Alert";
              [self LoadCustomAlertWithMessage];
         }else{
              [self postOrder:PLACE_ORDER_REQ_TYPE];
         }
    }else{
        [self postOrder:PLACE_ORDER_REQ_TYPE];
    }
}

-(IBAction)addTipBtnClicked:(id)sender{
    AddTipViewController *addTipVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddTipViewController"];
    addTipVC.totalCostVal = [NSString stringWithFormat:@"%f",totalCost];
    [self presentViewController:addTipVC animated:YES completion:nil];
}


- (void) scrollViewAdaptToStartEditingPaymentTextField:(UITextField*)textField{
    float val;
    if ([UIScreen mainScreen].bounds.size.height == 568) {  // iphone 4 inch
        val = 3 ;
    }else{
        val = 2.5 ;
    }
    CGPoint point = CGPointMake(0, textField.frame.origin.y - val * textField.frame.size.height);
    [paymentSubView setContentOffset:point animated:YES];
}

- (void) scrollVievEditingPaymentFinished:(UITextField*)textField{
    CGPoint point = CGPointMake(0, 0);
    [paymentSubView setContentOffset:point animated:YES];
}


- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == cardHolderNameTextField || textField == cardNumberTextField || textField ==cardExpDateTextField || textField ==  cardCvvTextField) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
                if (textField == cardNumberTextField || textField ==cardExpDateTextField || textField ==  cardCvvTextField){
                    [self scrollViewAdaptToStartEditingPaymentTextField:textField];
                }
            }else if(UIInterfaceOrientationIsPortrait(STATUSBAR_ORIENTATION)){

            }
        }else{
            if ([UIScreen mainScreen].bounds.size.height == 568) {  // iphone 4 inch
                if ( textField ==cardExpDateTextField || textField ==  cardCvvTextField){
                    [self scrollViewAdaptToStartEditingPaymentTextField:textField];
                }
            }else{
                if (textField == cardNumberTextField || textField ==cardExpDateTextField || textField ==  cardCvvTextField){
                    [self scrollViewAdaptToStartEditingPaymentTextField:textField];
                }
            }
            
        }
    }else{
        currentEditingTextField = textField;
        [self scrollViewAdaptToStartEditingTextField:textField];
    }
    return YES;
}

- (BOOL) textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField==cardCvvTextField){
        textField.text=nil;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == currentEditingTextField) {
        if (textField.text.length ==0) {
            currentEditingTextField.text = 0;
        }
        NSString *itemID = [[itemsAry objectAtIndex:textField.tag] objectForKey:@"ID"];
        dbManager = [DataBaseManager dataBaseManager];
        [dbManager execute:[NSString stringWithFormat:@"Update OrderDetails set Quantity='%@' where ID = '%@'",textField.text,itemID]];
        [self drawAttchmentsView];
        [self refreshCart];
    }
    if (textField ==cardExpDateTextField) {
        if (textField.text && textField.text.length > 0) {
            
            BOOL valid = [self getDateFromString:textField.text];
            if (valid == NO) {
                customAlertMessage = @"Invalid Date";
                customAlertTitle = @"Alert";
                [self LoadCustomAlertWithMessage];
                textField.text=nil;
            }
        }else{//with out enter any text in expiryDate textfield
            customAlertMessage = @"Invalid Date";
            customAlertTitle = @"Alert";
            [self LoadCustomAlertWithMessage];
            textField.text=nil;
        }
    }else if (textField == cardNumberTextField) {
        NSString *filtered = [[textField.text componentsSeparatedByString:@"-"] componentsJoinedByString:@""];
        if (filtered.length==15) {
            cardNum=15;// digits for american express card
            
            NSMutableString *str=[[NSMutableString alloc]initWithString:filtered];
            [str insertString:@"-" atIndex:4];
            [str insertString:@"-" atIndex:11];
            textField.text=str;
            
        }else if (filtered.length==16){
            cardNum=16; // digits for other cards
            NSMutableString *str=[[NSMutableString alloc]initWithString:filtered];
            [str insertString:@"-" atIndex:4];
            [str insertString:@"-" atIndex:9];
            [str insertString:@"-" atIndex:14];
            textField.text=str;
        }
        cardCvvTextField.text=nil;
        
        if (filtered.length <15  && filtered.length > 0) {
            
            customAlertMessage = @"Please enter a valid card number";
            customAlertTitle = @"Alert";
            [self LoadCustomAlertWithMessage];

        }
        
    }else if (textField == cardCvvTextField) {
      if ( cardNum==15) {
          if ([cardCvvTextField.text integerValue]==3) {
              customAlertMessage = @"Please enter a valid CVV number";
              customAlertTitle = @"Alert";
              [self LoadCustomAlertWithMessage];
          }
      }
    }
  
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if (textField == cardHolderNameTextField || textField == cardNumberTextField || textField ==cardExpDateTextField || textField ==  cardCvvTextField) {
        if ([UIScreen mainScreen].bounds.size.height == 568) {  // iphone 4 inch
            if (textField ==cardExpDateTextField || textField ==  cardCvvTextField){
                [self scrollVievEditingPaymentFinished:textField];
            }
        }else{
            if (textField == cardNumberTextField ||textField ==cardExpDateTextField || textField ==  cardCvvTextField){
                [self scrollVievEditingPaymentFinished:textField];
            }
        }
    }else{
        if (textField.text.length ==0) {
            currentEditingTextField.text = 0;
        }
        NSString *itemID = [[itemsAry objectAtIndex:textField.tag] objectForKey:@"ID"];
        dbManager = [DataBaseManager dataBaseManager];
        [dbManager execute:[NSString stringWithFormat:@"Update OrderDetails set Quantity='%@' where ID = '%@'",textField.text,itemID]];
        [self drawAttchmentsView];
        [self scrollVievEditingFinished:textField];
        [self refreshCart];
    }
    
    
    
    
    if (textField == cardHolderNameTextField) {
        [textField resignFirstResponder];
        [cardNumberTextField becomeFirstResponder];
    }else if (textField == cardNumberTextField){
        [textField resignFirstResponder];
        [cardExpDateTextField becomeFirstResponder];
    }else if (textField == cardExpDateTextField){
        [textField resignFirstResponder];
        [cardCvvTextField becomeFirstResponder];
    }else if (textField == cardCvvTextField){
        [textField resignFirstResponder];
        [self cardSubmitBtnClicked:nil];
    }
    
    return YES;
}


- (void) myKeyboardWillHideHandler:(NSNotification *)notification {
    CGPoint point = CGPointMake(0, 0);
    [placeOrderScrolView setContentOffset:point animated:YES];
}


- (void) scrollViewAdaptToStartEditingTextField:(UITextField*)textField
{
    float val;
    NSInteger tagVal = textField.tag;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
            val = -1.4 * (int)tagVal;
        }else if(UIInterfaceOrientationIsPortrait(STATUSBAR_ORIENTATION)){
            val = -1 * (int)tagVal;
        }
    }else{
        if ([UIScreen mainScreen].bounds.size.height == 568) {  // iphone 4 inch
            val = -1.5 * (int)tagVal;
        }else{
            val = -1.6 * (int)tagVal;
        }
    }
    CGPoint point = CGPointMake(0, textField.frame.origin.y - val * textField.frame.size.height);
    [placeOrderScrolView setContentOffset:point animated:YES];
}

- (void) scrollVievEditingFinished:(UITextField*)textField
{
    CGPoint point = CGPointMake(0, 0);
    [placeOrderScrolView setContentOffset:point animated:YES];
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


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == currentEditingTextField){
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
                    return [string isEqualToString:filtered];
                    return YES;
                }
            }
        }
    }else if (textField == cardCvvTextField) {
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
                if (cardNum == 16) {
                    if (cleanedString.length > 2) {//accessing max characters in textfield
                        return NO;
                    }else{
                        return [string isEqualToString:filtered];
                        return YES;
                    }
                    
                }
                else if (cardNum==15)
                {
                    if (cleanedString.length > 3) {//accessing max characters in textfield
                        return NO;
                    }else{
                        return [string isEqualToString:filtered];
                        return YES;
                    }
                    
                }

                
                
            }
        }
    }else if (textField == cardNumberTextField) {
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
                if (cleanedString.length > 15) {
                    return NO;
                }else{
                    if ([string isEqualToString:filtered] == YES) {
                        if ((range.location == 4) || (range.location == 9) || (range.location == 14))
                        {
                            NSString *str    = [NSString stringWithFormat:@"%@-",textField.text];
                            textField.text   = str;
                        }
                        return YES;
                    }else{
                        return NO;
                    }
                }
            }
        }
    }else if (textField == cardExpDateTextField) {
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        if (filtered) {
            if ([string isEqualToString:@""]) {
                return YES;
            }else{
                NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:@"[-()-/]"
                                                                                            options:0
                                                                                              error:NULL];
                NSString *cleanedString = [expression stringByReplacingMatchesInString:textField.text
                                                                               options:0
                                                                                 range:NSMakeRange(0, [self getLength:textField.text])
                                                                          withTemplate:@""];
                if (cleanedString.length > 5) {
                    return NO;
                }else{
                    if ([string isEqualToString:filtered] == YES) {
                        if (range.location == 2)
                        {
                            NSString *str    = [NSString stringWithFormat:@"%@/",textField.text];
                            textField.text   = str;
                        }
                        return YES;
                    }else{
                        return NO;
                    }
                }
            }
        }
    }
    return YES;
}

-(void)refreshCart{
    NSMutableArray *itemsArray = [[NSMutableArray alloc]init];
    dbManager = [DataBaseManager dataBaseManager];
    [dbManager execute:[NSString stringWithFormat:@"SELECT * FROM OrderDetails where Quantity > '0'"] resultsArray:itemsArray];
    cartCountLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[itemsArray count]];
}

-(BOOL)getDateFromString:(NSString *)string{
    NSString *dateEnter=[NSString stringWithFormat: @"%@",string];
    NSArray *dateArr = [dateEnter componentsSeparatedByString:@"/"];
    NSString *monthStr=[NSString stringWithFormat:@"%@",[dateArr objectAtIndex:0]];
    NSString *yearStr=[NSString stringWithFormat:@"%@",[dateArr objectAtIndex:1]];
    
    NSString *combinedStr=[NSString stringWithFormat:@"%@-%@-%@",yearStr,monthStr,@"01"];//we wre entered Date in string
    NSDateFormatter *dateformater=[[NSDateFormatter alloc]init];
    [dateformater setDateFormat:@"yyyy-MM-dd"];
    NSDate *enteredDate=[dateformater dateFromString:combinedStr];
    
    NSString *dateCurrentString = [dateformater stringFromDate:[NSDate date]];//today Date
    NSDate *currentDate = [dateformater dateFromString:dateCurrentString];
    
    
    NSComparisonResult result1;
    result1 = [currentDate compare:enteredDate];
    if(result1==NSOrderedAscending)
    {
        return YES;
    }else{
        return NO;
    }
}



-(void)postOrder:(NSString *)type{
    NSMutableArray *itemDetailsAry = [[NSMutableArray alloc]init];
    dbManager = [DataBaseManager dataBaseManager];
    [dbManager execute:[NSString stringWithFormat:@"SELECT * FROM OrderDetails where OrderID ='%@' and Quantity > 0 ",@""] resultsArray:itemDetailsAry];
    NSMutableString *itemStr = [[NSMutableString alloc]init];
    
    if ([itemDetailsAry count] <= 0) {
        [self backBtnClicked:nil];
        return;
    }
    
    
    for (int i=0; i<[itemDetailsAry count]; i++) {
        NSDictionary *currentItemDict = [itemDetailsAry objectAtIndex:i];
        NSString *orderDetailsID = [currentItemDict objectForKey:@"ID"];
        NSMutableArray *modifiersAry = [[NSMutableArray alloc]init];
        dbManager = [DataBaseManager dataBaseManager];
        [dbManager execute:[NSString stringWithFormat:@"SELECT * FROM OrderModifier where OrderDetailsID ='%@' ",orderDetailsID] resultsArray:modifiersAry];
        NSString *itemValStr = [self itemJsonFormatWithDictionary:currentItemDict WithModifierArray:modifiersAry];
        [itemStr appendString:[NSString stringWithFormat:@"%@,",itemValStr]];
    }
    
    
    [itemStr deleteCharactersInRange:NSMakeRange([itemStr length]-1, 1)];
    NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
    NSString *resID = [defaults objectForKey:@"RestaurantID"];
    NSString *resLocation = [defaults objectForKey:@"RestaurantLocation"];
    NSString *menuID =    [defaults objectForKey:@"MenuID"];
    NSString *source =    [defaults objectForKey:@"source"];
    NSString *deviceToken = [defaults objectForKey:@"DeviceToken"];
    
    if(deviceToken.length ==0){
        deviceToken = @"0be724e8be3d7d18d177c2221405e40e73f27fc9994766cb420c2047f4d6b28b";
    }
        
    
    restDetailsDict = [[NSMutableDictionary alloc]init];
    [restDetailsDict setObject:resID forKey:@"restID"];
    [restDetailsDict setObject:resLocation forKey:@"restLocation"];
    [restDetailsDict setObject:menuID forKey:@"menuID"];
    [restDetailsDict setObject:@"" forKey:@"couponCode"];
    [restDetailsDict setObject:[deviceToken stringByReplacingOccurrencesOfString:@" " withString:@""] forKey:@"DeviceToken"];
    
    
    NSUserDefaults *deliveryDefaults=[NSUserDefaults standardUserDefaults];
    
    NSString *deliveryFee=[deliveryDefaults objectForKey:@"delivery_fee"];
    [restDetailsDict setObject:source forKey:@"source"];
    
    NSString *orderTypeString = [defaults objectForKey:@"OrderType"];
    
    if ([orderTypeString isEqualToString:@"Delivery"]) {
        
        if ([deliveryFee isEqualToString:@"0.00"] || [deliveryFee isEqualToString:nil] ) {
            [restDetailsDict setObject:[subtotalValLabel.text stringByReplacingOccurrencesOfString:@"$" withString:@""] forKey:@"subTotal"];
            [restDetailsDict setObject:[subTotalTaxLabel.text stringByReplacingOccurrencesOfString:@"$" withString:@""] forKey:@"tax"];
            NSString *tipValue;
            if ([addTipValue.text isEqualToString:@"Add Tip?"]) {
                tipValue = @"0.00";
            }else{
                tipValue = addTipValue.text;
            }
            [restDetailsDict setObject:[tipValue stringByReplacingOccurrencesOfString:@"$" withString:@""] forKey:@"tip"];
            
        }else{
            [restDetailsDict setObject:[subtotalValLabelDelivery.text stringByReplacingOccurrencesOfString:@"$" withString:@""] forKey:@"subTotal"];
            [restDetailsDict setObject:[subTotalTaxLabelDelivery.text stringByReplacingOccurrencesOfString:@"$" withString:@""] forKey:@"tax"];
            NSString *tipValue;
            if ([addTipValueDelivery.text isEqualToString:@"Add Tip?"]) {
                tipValue = @"0.00";
            }else{
                tipValue = addTipValueDelivery.text;
            }
            [restDetailsDict setObject:[tipValue stringByReplacingOccurrencesOfString:@"$" withString:@""] forKey:@"tip"];
            
        }
        [restDetailsDict setObject:@"delivery" forKey:@"typeName"];
        [restDetailsDict setObject:deliveryFee forKey:@"deliveryFee"];
        
    }else{
        
        [restDetailsDict setObject:[subtotalValLabel.text stringByReplacingOccurrencesOfString:@"$" withString:@""] forKey:@"subTotal"];
        [restDetailsDict setObject:[subTotalTaxLabel.text stringByReplacingOccurrencesOfString:@"$" withString:@""] forKey:@"tax"];
        NSString *tipValue;
        
        if ([addTipValue.text isEqualToString:@"Add Tip?"]) {
            tipValue = @"0.00";
        }else{
            tipValue = addTipValue.text;
        }
        
        [restDetailsDict setObject:[tipValue stringByReplacingOccurrencesOfString:@"$" withString:@""] forKey:@"tip"];
        [restDetailsDict setObject:@"pick up" forKey:@"typeName"];
    }
   
    
    [restDetailsDict setObject:[totalOrderCostLabel.text stringByReplacingOccurrencesOfString:@"$" withString:@""] forKey:@"totalCost"];
    NSDate *localDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *dateString = [dateFormatter stringFromDate: localDate];
    [restDetailsDict setObject:dateString forKey:@"CreatedOn"];
    paymentDict = [[NSMutableDictionary alloc]init];
    NSString *cardNumStr = cardNumberTextField.text;
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:@"[-()-]"
                                                                                options:0
                                                                                  error:NULL];
    NSString *cleanedString = [expression stringByReplacingMatchesInString:cardNumStr
                                                                   options:0
                                                                     range:NSMakeRange(0, [self getLength:cardNumStr])
                                                              withTemplate:@""];
    NSMutableArray *loginArray = [[NSMutableArray alloc]init];
    dbManager = [DataBaseManager dataBaseManager];
    [dbManager execute:[NSString stringWithFormat:@"SELECT * FROM LoginDetails "] resultsArray:loginArray];
    NSDictionary *curentLoginDict = [loginArray objectAtIndex:0];
    NSString *custID = [curentLoginDict objectForKey:@"CustomerID"];
    [paymentDict setObject:cardHolderNameTextField.text forKey:@"cardHolderName"];
    [paymentDict setObject:cleanedString forKey:@"cardNumber"];
    [paymentDict setObject:cardExpDateTextField.text forKey:@"expiryDate"];
    [paymentDict setObject:cardCvvTextField.text forKey:@"cardCvv"];
    [paymentDict setObject:custID forKey:@"custID"];
    NSString *remianingData = [self jsonFormatWithDictionary:restDetailsDict WithPaymentDIct:paymentDict];
    NSString *dataStr = [NSString stringWithFormat:@"{%@,\"items\":[%@]}",remianingData,itemStr];
    NSString *finalReqStr = [NSString stringWithFormat: @"{\"Type\":\"%@\",\"Data\":%@}",type,dataStr];
    NSString *finalReqUrl = [NSString stringWithFormat:@"%@%@",REQ_URL,PLACE_ORDER_REQ_URL];
    NSData *postJsonData = [finalReqStr dataUsingEncoding:NSUTF8StringEncoding];
    webServiceInterface = [[WebServiceInterface alloc]initWithVC:self];
    webServiceInterface.delegate =self;
    [webServiceInterface sendRequest:finalReqStr PostJsonData:postJsonData Req_Type:type Req_url:finalReqUrl];
}

-(void)getResponse:(NSDictionary *)resp type:(NSString *)respType{
    if ([respType isEqualToString:PLACE_ORDER_REQ_TYPE]) {
        NSDictionary *statusDict = [resp objectForKey:@"Status"];
        NSDictionary *DataDict = [resp objectForKey:@"Data"];

        NSString *status = [NSString stringWithFormat:@"%@",[statusDict objectForKey:@"status"]];
        NSString *order_id = [NSString stringWithFormat:@"%@",[DataDict objectForKey:@"order_id"]];
        NSString *totalAmount = [NSString stringWithFormat:@"%@",[DataDict objectForKey:@"total_amount"]];

        NSString *statusDesc = [statusDict objectForKey:@"desc"];
        if ([status isEqualToString:@"1"]) {
            [self doneBtnClicked:nil];
            dbManager = [DataBaseManager dataBaseManager];
            NSString *cartQuery = [NSString stringWithFormat:@"DELETE FROM OrderDetails "];
            [dbManager execute:cartQuery];
            NSString *cartQuery1 = [NSString stringWithFormat:@"DELETE FROM OrderModifier "];
            [dbManager execute:cartQuery1];
            NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
            [defaults setObject:@"0.00" forKey:@"CurrentTipValue"];
            NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
            [timeFormatter setDateFormat:@"hh:mm a"];
            
            if ([[restDetailsDict objectForKey:@"typeName"] isEqualToString:@"delivery"]) {
                orderTypeStr = @"delivery";
                
                NSDictionary *deliveryDetailsDict =[defaults objectForKey:@"OrderTypeDeliveryDetails"];
                NSString *addressStr = [NSString stringWithFormat:@"%@\n%@ %@ %@", [deliveryDetailsDict objectForKey:@"DeliveryAddress"],[deliveryDetailsDict objectForKey:@"DeliveryCity"],[deliveryDetailsDict objectForKey:@"DeliveryState"],[deliveryDetailsDict objectForKey:@"DeliveryPin"]];
                    paymentResponseAlertMsgLine1 = @"When your food is ready, we'll deliver your order at this location:";
                    paymentResponseAlertMsgAddress = addressStr;
            }else{
                orderTypeStr = @"pickUp";

                paymentResponseAlertMsgLine1 = @"When your food is ready, you can pickup your order at this location:";
                restDetails=[[NSUserDefaults alloc]init];
                [restDetails objectForKey:@"RestaurantName"];
                [restDetails objectForKey:@"RestaurantAddress"];
                
                paymentResponseAlertMsgAddress=[restDetails objectForKey:@"RestaurantAddress"];
            }
            paymentOrderId=[NSString stringWithFormat:@"Thanks for your Order#%@",order_id];//total_amount
            paymentOrderTotalValue=[NSString stringWithFormat:@"Your payment of $%@ was charged successfully",totalAmount];
            
            
            subViewAlertStr = @"PaymentResponseSuccess";
            [self loadPaymentSubView];

            dbManager = [DataBaseManager dataBaseManager];
        }else{
            if ([statusDesc isEqual:NULL] || [statusDesc isEqual:nil] || statusDesc == NULL
                 || statusDesc == nil) {
                [FAUtilities showAlert:@"Error"];
            }else{
                customAlertMessage = statusDesc;
                customAlertTitle = @"Alert";
                [self LoadCustomAlertWithMessage];

            }
        }
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


- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
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


-(NSString*)jsonFormatWithDictionary:(NSMutableDictionary *)restDict WithPaymentDIct:(NSMutableDictionary *)paymentDictionary{
    
    NSString *deliveryDetailsStr;
    
    if ([[restDict objectForKey:@"typeName"] isEqualToString:@"delivery"]) {
        
        NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
        NSDictionary *tempDeliveryDetailsDict = [defaults objectForKey:@"OrderTypeDeliveryDetails"];
        
        
        NSString *deliveryAddress = [NSString stringWithFormat:@"%@, %@, %@, %@",[tempDeliveryDetailsDict objectForKey:@"DeliveryAddress"],[tempDeliveryDetailsDict objectForKey:@"DeliveryCity"],[tempDeliveryDetailsDict objectForKey:@"DeliveryState"],[tempDeliveryDetailsDict objectForKey:@"DeliveryPin"]];
        
        NSString *deliveryNotes = [tempDeliveryDetailsDict objectForKey:@"DeliveryNotes"];

    
        deliveryAddress = [FAUtilities formatJSONStr:deliveryAddress];
        deliveryNotes = [FAUtilities formatJSONStr:deliveryNotes];
        
        
        
        deliveryDetailsStr = [NSString stringWithFormat: @"\"delivery_address\":\"%@\",\"delivery_instructions\":\"%@\",\"delivery_fee\":\"%@\",",deliveryAddress,deliveryNotes,[restDict objectForKey:@"deliveryFee"]];
    }else{
        deliveryDetailsStr = [NSString stringWithFormat: @"\"delivery_address\":\"%@\",\"delivery_instructions\":\"%@\",",@"",@""];
    }

    
    NSString *paymentStr = [NSString stringWithFormat: @"{\"card_number\":\"%@\",\"expiry\":\"%@\",\"cvv\":\"%@\",\"cust_id\":\"%@\"}",[paymentDictionary objectForKey:@"cardNumber"],[paymentDictionary objectForKey:@"expiryDate"],[paymentDictionary objectForKey:@"cardCvv"],[paymentDictionary objectForKey:@"custID"]];
    
    NSString *dataStr =[NSString stringWithFormat: @"\"device_token\":\"%@\",\"rest_id\":\"%@\",\"rest_location\":\"%@\",\"menu_id\":\"%@\",\"coupon_code\":\"%@\",\"sub_total\":\"%@\",\"tax\":\"%@\",\"tip\":\"%@\",\"source\":\"%@\",\"created_on\":\"%@\",\"type_name\":\"%@\",\"total\":\"%@\",%@\"payment\":%@",[restDict objectForKey:@"DeviceToken"],[restDict objectForKey:@"restID"],[restDict objectForKey:@"restLocation"],[restDict objectForKey:@"menuID"],[restDict objectForKey:@"couponCode"],[restDict objectForKey:@"subTotal"],[restDict objectForKey:@"tax"],[restDict objectForKey:@"tip"],[restDict objectForKey:@"source"],[restDict objectForKey:@"CreatedOn"],[restDict objectForKey:@"typeName"],[restDict objectForKey:@"totalCost"],deliveryDetailsStr,paymentStr];
    return dataStr;
}



-(NSString*)itemJsonFormatWithDictionary:(NSDictionary *)itemDict WithModifierArray:(NSMutableArray *)modifierAry{
    NSString *itemStr;
    NSMutableString *modifierStr = [[NSMutableString alloc]init];
    for (int i=0; i<[modifierAry count]; i++) {
        NSDictionary *tempModifierDict = [modifierAry objectAtIndex:i];
        NSString *modifierName = [tempModifierDict objectForKey:@"ModifierName"];
        NSString *optionName = [tempModifierDict objectForKey:@"OptionName"];
        NSString *optionPrice = [tempModifierDict objectForKey:@"OptionPrice"];
        
        modifierName = [FAUtilities formatJSONStr:modifierName];
        optionName = [FAUtilities formatJSONStr:optionName];
        optionPrice = [FAUtilities formatJSONStr:optionPrice];
        
        [modifierStr appendString:[NSString stringWithFormat: @"{\"modifier_name\":\"%@\",\"option_name\":\"%@\",\"option_price\":\"%@\"},",modifierName,optionName,optionPrice]];
    }
    if (modifierAry.count ==0) {
        modifierStr = [@"" mutableCopy];
    }else{
        [modifierStr deleteCharactersInRange:NSMakeRange([modifierStr length]-1, 1)];
    }
    NSString *itemPriceVal = [itemDict objectForKey:@"ItemPrice"];
    NSString *itemOptionsVal = [itemDict objectForKey:@"OptionsPrice"];
    float priceFloatVal = [itemPriceVal floatValue];
    float optionsFloatVal = [itemOptionsVal floatValue];
    float cost = priceFloatVal + optionsFloatVal;
    
    
    NSString *categoryName      = [itemDict objectForKey:@"CategoryName"];
    NSString *itemName          = [itemDict objectForKey:@"ItemName"];
    NSString *itemDesc          = [itemDict objectForKey:@"ItemDescription"];
    NSString *itemServingType   = [itemDict objectForKey:@"ServingName"];
    itemPrice         = [itemDict objectForKey:@"ItemPrice"];
    NSString *itemQuantity      = [itemDict objectForKey:@"Quantity"];
    NSString *itemInstructions  = [itemDict objectForKey:@"Instructions"];

    categoryName = [FAUtilities formatJSONStr:categoryName];
    itemName = [FAUtilities formatJSONStr:itemName];
    itemDesc = [FAUtilities formatJSONStr:itemDesc];
    itemServingType = [FAUtilities formatJSONStr:itemServingType];
    itemPrice = [FAUtilities formatJSONStr:itemPrice];
    itemQuantity = [FAUtilities formatJSONStr:itemQuantity];
    itemInstructions = [FAUtilities formatJSONStr:itemInstructions];
    
    itemStr =[NSString stringWithFormat: @"{\"category_name\":\"%@\",\"item_name\":\"%@\",\"description\":\"%@\",\"serving_name\":\"%@\",\"serving_price\":\"%@\",\"quantity\":\"%@\",\"price\":\"%f\",\"instructions\":\"%@\"",categoryName,itemName,itemDesc,itemServingType,itemPrice,itemQuantity,cost,itemInstructions];
    NSString *finalItemsStr = [NSString stringWithFormat:@"%@,\"modifiers\":[%@]}",itemStr,modifierStr];
    return finalItemsStr;
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
