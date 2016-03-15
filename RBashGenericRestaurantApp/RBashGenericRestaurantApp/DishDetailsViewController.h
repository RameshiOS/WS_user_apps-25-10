//
//  DishDetailsViewController.h
//  ThinkingCup
//
//  Created by Manulogix on 01/09/14.
//  Copyright (c) 2014 Manulogix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBaseManager.h"

@interface DishDetailsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate>{
    
    IBOutlet UILabel *itemName;
    IBOutlet UIView  *itemCostSubView;
    IBOutlet UILabel *itemCost;
    IBOutlet UITextView *itemDescTextView;
    IBOutlet UIView *qty1BtnSubView;
    IBOutlet UIView *qty2BtnSubView;
    IBOutlet UIView *qty3BtnSubView;
    IBOutlet UIView *qtyPlusBtnSubView;
    IBOutlet UIButton *qty1Btn;
    IBOutlet UIButton *qty2Btn;
    IBOutlet UIButton *qty3Btn;
    IBOutlet UIButton *qtyPlusBtn;
    UIFont *numberBtnFont;
    UIFont *dynamicLabelsFont;
    NSArray *optionsListArray;
    NSArray *itemSizes;
    
    
    IBOutlet UITextField *itemSizeTextField;

    // need to check options and sides
    
    IBOutlet UIView *addToOrderSubView;
    IBOutlet UIView *addToOrderCostSubView;
    IBOutlet UIButton *addToOrderBtn;
    IBOutlet UIButton *addToOrderCostBtn;
    IBOutlet UILabel *addToOrderCostLabel;
    IBOutlet UIScrollView *dishDeteailsScrollview;
    IBOutlet UIButton *sizeBtn;
    int currentQuantity;
    BOOL isNumbersSubViewVisible;
    UITextView *spclInst;
    
    // sizes sub view
    UIView *diabledview;
    NSArray *currentCustomTableViewArray;
    NSString *currentTableVal;
    NSString *currentOptionsMinVal;
    NSString *currentOptionsMaxVal;
    UILabel *headingLabel;
    UIButton    *currentDropDownBtn;
    
    int currentDropDownBtnTag;
    BOOL isCustomDropDownVisible;
    
    int selectedIndex;
    UITableView *customTableview;
    NSMutableArray *selectedOptionsAry;
    NSMutableArray *selectedOptionsIndexPathAry;
    UILabel *valLabel;
    UIView *plusView;
    NSMutableArray *modifiersCostAry;
    DataBaseManager *dbManager;
    NSMutableArray *selectedSizesAry;
    NSMutableArray *selectedSizesIndexAry;
    NSInteger  indexLeng;
//    cart details
    IBOutlet UILabel *cartCountLabel;
    IBOutlet UIView *sizeBtnSubView;
    NSMutableArray *selectedModifierAry;
    NSDictionary *currentServingDict;
    float allTaxes;
    NSString *currentSubviewMode;    
    
    NSString *customAlertMessage;
    NSString *customAlertTitle;
    UIView *disableCustomAlertView;
    
    IBOutlet UIView *headerView;
    IBOutlet   UILabel *quentityNsizeLabel;
    IBOutlet  UILabel *optionsNsidesLabel;
    
    
    IBOutlet UIImageView *itemImgView;
    IBOutlet UIButton *pinItBtn;
    
    
//  For loading options
    
    
    float origionY;
    float origionYForInstructions;
    NSString *completeImagepath;
    NSString *itemDataLink;
    NSIndexPath* checkedIndexPath;
    
}

@property(nonatomic,retain) NSDictionary *itemDetailsDict;
@property(nonatomic,retain) NSString *catgName;
@property (nonatomic, retain) NSIndexPath* checkedIndexPath;

-(IBAction)qty1BtnClicked:(id)sender;
-(IBAction)qty2BtnClicked:(id)sender;
-(IBAction)qty3BtnClicked:(id)sender;
-(IBAction)qtyPlusBtnClicked:(id)sender;
-(IBAction)backBtnClicked:(id)sender;
-(IBAction)addToOrderBtnClicked:(id)sender;
-(IBAction)sizeBtnClicked:(id)sender;
-(IBAction)bgButtonClick:(id)sender;
-(IBAction)cartBtnClicked:(id)sender;

@end
