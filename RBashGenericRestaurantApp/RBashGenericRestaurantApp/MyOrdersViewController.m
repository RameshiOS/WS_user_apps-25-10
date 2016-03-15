//
//  MyOrdersViewController.m
//  ThinkingCup
//
//  Created by Manulogix on 23/09/14.
//  Copyright (c) 2014 Manulogix. All rights reserved.
//

#import "MyOrdersViewController.h"
#import "FAUtilities.h"
#import "PlaceOrderViewController.h"
#import "SearchTextFieldViewController.h"

@interface MyOrdersViewController ()

@end

@implementation MyOrdersViewController

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
        navHeaderView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"pgm_HeaderLandscape.png"]];
        
    }else if(UIInterfaceOrientationIsPortrait(STATUSBAR_ORIENTATION)){
        
        navHeaderView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"pgm_Header.png"]];
    }
    
    
    tableColumns = [[NSMutableArray alloc]init];
    tableColumnKeys = [[NSMutableArray alloc]init];
    tableColumnWidths = [[NSMutableArray alloc]init];
    
    [tableColumns addObject:@"Order#"];
    [tableColumns addObject:@"Date"];
    [tableColumns addObject:@"Item"];
    [tableColumns addObject:@"Total($)"];
    
    [tableColumnKeys addObject:@"rest_order_id"];
    [tableColumnKeys addObject:@"created_on"];
    [tableColumnKeys addObject:@"order_itemName"];
    [tableColumnKeys addObject:@"total"];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
    
    }else{
        [tableColumnWidths addObject:@"38"];
        [tableColumnWidths addObject:@"55"];
        [tableColumnWidths addObject:@"150"];
        [tableColumnWidths addObject:@"70"];
    }
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        [[UISegmentedControl appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaNeue" size:24.0], NSFontAttributeName, nil] forState:UIControlStateNormal];
        CGRect frame= segCntl.frame;
        [segCntl setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 150)];
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:segCntl
                                                                      attribute:NSLayoutAttributeHeight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:nil
                                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                                     multiplier:1
                                                                       constant:40];
        [segCntl addConstraint:constraint];
    }else{
        [[UISegmentedControl appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaNeue" size:12.0], NSFontAttributeName, nil] forState:UIControlStateNormal];
    }
    
    [self postRequest:GET_ORDERS_LIST_REQ_TYPE];
    
    searchOptions = [[NSMutableArray alloc]init];
    
    [searchOptions addObject:@"Item Name"];
    [searchOptions addObject:@"Date"];
    
    popOverDict = [[NSMutableDictionary alloc]init];

    
    segmentedValue = @"0";
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        headerLabelFont = [UIFont fontWithName:@"Thonburi-Bold" size:20];
        cellLaebelFont = [UIFont fontWithName:@"Verdana" size:14];
    }else{
        headerLabelFont = [UIFont fontWithName:@"Thonburi-Bold" size:12];
        cellLaebelFont = [UIFont fontWithName:@"Verdana" size:8];
        
        int width = 0;
        for (int i=0; i<[tableColumnWidths count]; i++) {
            NSString *tempcolumn = [tableColumnWidths objectAtIndex:i];
            width = width + [tempcolumn intValue]+2;
        }
        tableViewWidth = width;
        tableViewHeight = myordersScrollView.frame.size.height;

        myOrdersTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, tableViewWidth, tableViewHeight)];
        myOrdersTableView.delegate = self;
        myOrdersTableView.dataSource = self;
        
        [myordersScrollView addSubview:myOrdersTableView];
        myordersScrollView.contentSize = CGSizeMake(tableViewWidth, tableViewHeight);
        [self performSelector:@selector(methodName) withObject:nil afterDelay:0.5];
    }
    
    
    if ([APP_NAME isEqualToString:@"Mario'sPizza"]) {
        segCntl.tintColor=[FAUtilities getUIColorObjectFromHexString:APP_HEADER_COLOR alpha:1.0];
        
    }else     {
        segCntl.tintColor=[FAUtilities getUIColorObjectFromHexString:ADD_TO_ORDER_VIEW_COLOR alpha:1.0];
    }
    
    
    
}

-(void)methodName{
    myordersScrollView.contentSize = CGSizeMake(tableViewWidth, tableViewHeight);
}

-(void)postRequest:(NSString *)reqType{

    NSString *finalReqUrl;
    NSMutableDictionary *test = [[NSMutableDictionary alloc]init];

    if ([reqType isEqualToString:GET_ORDERS_LIST_REQ_TYPE]) {
        finalReqUrl = [NSString stringWithFormat:@"%@%@",REQ_URL,GET_ORDERS_LIST_REQ_URL];
   
        NSMutableArray *loginArray = [[NSMutableArray alloc]init];
        
        dbManager = [DataBaseManager dataBaseManager];
        [dbManager execute:[NSString stringWithFormat:@"SELECT * FROM LoginDetails "] resultsArray:loginArray];
        
        NSDictionary *curentLoginDict = [loginArray objectAtIndex:0];
        NSString *custID = [curentLoginDict objectForKey:@"CustomerID"];
        NSUserDefaults *defaults=[[NSUserDefaults alloc]init];
        NSString *restID= [defaults objectForKey:@"RestaurantID"];
        
        [test setObject:custID forKey:@"CustomerID"];
        [test setObject:restID forKey:@"rest_Id"];
    }else if ([reqType isEqualToString:GET_ORDER_DETAILS_REQ_TYPE]){
        finalReqUrl = [NSString stringWithFormat:@"%@%@",REQ_URL,GET_ORDER_DETAILS_REQ_URL];
        [test setObject:[NSString stringWithFormat:@"%d",currentOrderID] forKey:@"OrderID"];
    }
    
    
    NSString *formattedBodyStr = [self jsonFormat:reqType withDictionary:test];
    NSString *dataInString = [NSString stringWithFormat: @"\"Data\":%@",formattedBodyStr];
    
    NSString *postDataInString = [NSString stringWithFormat:@"{\"Type\":\"%@\",%@}",reqType,dataInString];
    
    NSData *postJsonData = [postDataInString dataUsingEncoding:NSUTF8StringEncoding];
    webServiceInterface = [[WebServiceInterface alloc]initWithVC:self];
    webServiceInterface.delegate =self;
    [webServiceInterface sendRequest:postDataInString PostJsonData:postJsonData Req_Type:reqType Req_url:finalReqUrl];
}


-(void)getResponse:(NSDictionary *)resp type:(NSString *)respType{

    if ([respType isEqualToString:GET_ORDERS_LIST_REQ_TYPE]) {
        NSDictionary *statusDict = [resp objectForKey:@"Status"];
        NSString *status = [NSString stringWithFormat:@"%@",[statusDict objectForKey:@"status"]];
        NSString *statusDesc = [statusDict objectForKey:@"desc"];
        
        dbManager = [DataBaseManager dataBaseManager];

        if ([status isEqualToString:@"1"]) {
            NSArray *respAry = [resp objectForKey:@"Data"];
           
            NSString *cartQuery = [NSString stringWithFormat:@"DELETE FROM OrderMaster"];
            [dbManager execute:cartQuery];

            if (respAry.count == 0) {
                customAlertMessage = @"No orders available";
                customAlertTitle = @"Alert";
                [self LoadCustomAlertWithMessage];
            }
            [self insertOrders:respAry];
        }else{
            
            NSString *communicationStr = [resp objectForKey:@"CommunicationAlert"];
            alertMsg = communicationStr;
            if (communicationStr.length == 0) {
                customAlertMessage = statusDesc;
                customAlertTitle = @"Alert";
                [self LoadCustomAlertWithMessage];
            }else{
                [self loadCustomAlertSubView:alertMsg];
            }
           
            NSString *cartQuery = [NSString stringWithFormat:@"DELETE FROM OrderMaster"];
            [dbManager execute:cartQuery];
            [myOrdersTableView reloadData];

            
        }
    }else if ([respType isEqualToString:GET_ORDER_DETAILS_REQ_TYPE]) {
        NSDictionary *statusDict = [resp objectForKey:@"Status"];
        
        NSString *status = [NSString stringWithFormat:@"%@",[statusDict objectForKey:@"status"]];
        NSString *statusDesc = [statusDict objectForKey:@"desc"];
        
        if ([status isEqualToString:@"1"]) {
            NSArray *respAry = [resp objectForKey:@"Data"];
            NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
            [defaults setObject:@"MyOrdersView" forKey:@"PlaceOrderParentView"];
            [defaults synchronize];
            
            PlaceOrderViewController *placeOrder = [self.storyboard instantiateViewControllerWithIdentifier:@"PlaceOrderViewController"];
            placeOrder.orderItemsAry = respAry;
            placeOrder.subTotalVal =  currentSubTotalVal;
            placeOrder.taxVal = currentTaxVal;
            placeOrder.tipVal = currentTipVal;
            placeOrder.totalVal = currentTotalVal;
            [self presentViewController:placeOrder animated:YES completion:nil];
            
        }else{
            NSString *communicationStr = [resp objectForKey:@"CommunicationAlert"];
            alertMsg = communicationStr;
            if (communicationStr.length == 0) {
                customAlertMessage = statusDesc;
                customAlertTitle = @"Alert";
                [self LoadCustomAlertWithMessage];
            }else{
                [self loadCustomAlertSubView:alertMsg];
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



-(void)insertOrders:(NSArray *)respAry{
    
    for (int i=0; i<[respAry count]; i++) {
        NSDictionary *tempDict = [respAry objectAtIndex:i];
        NSString *tempDate = [tempDict objectForKey:@"created_on"];
        
        NSDateFormatter *complexdateFormater = [[NSDateFormatter alloc] init];
        [complexdateFormater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

        NSDate* complexdate = [complexdateFormater dateFromString:tempDate];

        NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
        [dateFormatter2 setDateFormat:@"MM-dd-yy"];
        NSString *newDateString = [dateFormatter2 stringFromDate:complexdate];

        NSString *itemName = [FAUtilities formatJSONStr:[tempDict objectForKey:@"item_name"]];

        [dbManager execute:[NSString stringWithFormat: @"INSERT INTO 'OrderMaster' (rest_id,rest_location,menu_id,coupon_code,cust_id,cust_name,card_number,txn_ref,sub_total,tax,tip,total,status_id,created_on,type_id,type_name,order_id,order_itemName,rest_order_id)VALUES ('%@', '%@','%@','%@','%@','%@','%@','%@','%@', '%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",@"",@"",@"",@"",@"",@"",@"",@"",[tempDict objectForKey:@"sub_total"],[tempDict objectForKey:@"tax"],[tempDict objectForKey:@"tip"],[tempDict objectForKey:@"total"],[tempDict objectForKey:@"status_id"],newDateString,@"",[tempDict objectForKey:@"type"],[tempDict objectForKey:@"order_id"],itemName,[tempDict objectForKey:@"rest_order_id"]]];
    }
    [myOrdersTableView reloadData];
}


-(NSString*)jsonFormat:(NSString *)type withDictionary:(NSMutableDictionary *)formatDict{
    
    NSString *bodyStr;
    
    if ([type isEqualToString:GET_ORDERS_LIST_REQ_TYPE]) {
        bodyStr =[NSString stringWithFormat: @"{\"cust_id\":\"%@\",\"rest_id\":\"%@\"}",[formatDict objectForKey:@"CustomerID"],[formatDict objectForKey:@"rest_Id"]];
    }else if ([type isEqualToString:GET_ORDER_DETAILS_REQ_TYPE]){
        bodyStr =[NSString stringWithFormat: @"{\"order_id\":\"%@\"}",[formatDict objectForKey:@"OrderID"]];
    }
    return bodyStr;
}

-(IBAction)backBtnClicked:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark
#pragma mark TableView Datasource
/* number of sections in form list record table */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    NSString *query;
    
    if ([segmentedValue isEqualToString:@"0"]) {
        query = [NSString stringWithFormat:@"SELECT * FROM OrderMaster where status_id = %@ or status_id = %@",@"1",@"2"];
    }else {
        query = [NSString stringWithFormat:@"SELECT * FROM OrderMaster where status_id = %@",segmentedValue];
    }
    
    NSMutableArray *tempOrdersAry = [[NSMutableArray alloc]init];
    [dbManager execute:query resultsArray:tempOrdersAry];
    resultsArray = tempOrdersAry;
    
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    if (tableView == myOrdersTableView) {
        float cellWidth = myOrdersTableView.bounds.size.width;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            tableColumnWidths = [[NSMutableArray alloc]init];
            
            int column1width = cellWidth*1/6-2;
            int column2width = cellWidth*1/6-2;
            int column3width = cellWidth*1/2-2;
            int column4width = cellWidth*1/6-2;
            
            [tableColumnWidths addObject:[NSString stringWithFormat:@"%d",column1width]];
            [tableColumnWidths addObject:[NSString stringWithFormat:@"%d",column2width]];
            [tableColumnWidths addObject:[NSString stringWithFormat:@"%d",column3width]];
            [tableColumnWidths addObject:[NSString stringWithFormat:@"%d",column4width]];
        }
        return [resultsArray count];
    }else{
        return [searchOptions count];
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == myOrdersTableView) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            return 50;
        }else{
            return 40;
        }
    }
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (tableView == myOrdersTableView) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            return 55;
        }else{
            return 45;
        }
    }else if ( tableView == searchOptionListTableView){
        return 0;
    }

    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    float cellWidth;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        cellWidth = myOrdersTableView.frame.size.width;
    }else{
        cellWidth = tableViewWidth;
    }

        CGFloat originX = 0.0f;
        CGFloat originY = 0.0f;
        CGFloat width = 0.0f;
        CGFloat height = 0.0f;
        UIView *headerView = [[UIView alloc] init];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
                headerView.frame = CGRectMake(0, 0, myOrdersTableView.frame.size.width, 55);
            }else if(UIInterfaceOrientationIsPortrait(STATUSBAR_ORIENTATION)){
                headerView.frame = CGRectMake(0, 0, myOrdersTableView.frame.size.width, 55);
            }

            height = 55.0f;
        }else{
            headerView.frame = CGRectMake(0, 0, myOrdersTableView.frame.size.width, 45);

            height = 45.0f;
        }
    
        for (int i=0; i<[tableColumns count]; i++) {

            NSString *widthVal = [tableColumnWidths objectAtIndex:i];
            
            width = [widthVal floatValue];
            
            headerLabelView = [[UILabel alloc]initWithFrame:CGRectMake(originX, originY, width, height)];
            headerLabelView.text = [tableColumns objectAtIndex:i];
            headerLabelView.backgroundColor = [FAUtilities getUIColorObjectFromHexString:LIST_COUNT_SUBVIEW_BG_COLOR alpha:1];
            headerLabelView.textColor = [UIColor whiteColor];
            headerLabelView.font=headerLabelFont;
            headerLabelView.numberOfLines=0;
            headerLabelView.textAlignment = NSTextAlignmentCenter;
            [headerView addSubview:headerLabelView];
            originX += width+2;
            headerLabelView.tag = 100+i;
        }
    return headerView;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    if (tableView == myOrdersTableView) {
        NSDictionary *currentDictionary = [[NSDictionary alloc]init];
        currentDictionary = [resultsArray objectAtIndex:indexPath.row];
        
        int columns = (int)[tableColumns count];
        
        [self tableViewCell:cell withColumns:columns withDictonary:currentDictionary];//creating number of cells with columns in table view cell
        
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [FAUtilities getUIColorObjectFromHexString:@"000000" alpha:0.3];
        cell.selectedBackgroundView = bgColorView;
    }else if (tableView == searchOptionListTableView){
        cell.textLabel.text = [searchOptions objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [popOverDict objectForKey:[searchOptions objectAtIndex:indexPath.row]];
    }
    return cell;
}



-(void)tableViewCell:(UITableViewCell *) cell withColumns:(int)columns withDictonary:(NSDictionary *)dict{
    float cellWidth;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        cellWidth = myOrdersTableView.frame.size.width;
    }else{
        cellWidth = tableViewWidth;
    }
    
    float cellHeight;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        cellHeight = 50;
    }else{
        cellHeight = 40;
    }
    
    NSMutableArray *values = [[NSMutableArray alloc]init];
    CGFloat originX = 0.0f;
    CGFloat originY = 0.0f;
    CGFloat width = 0.0f;
    CGFloat height = cellHeight;
    
    NSMutableArray *labelsArray = [[NSMutableArray alloc]init];
    NSMutableArray *costLabelsAry = [[NSMutableArray alloc]init];
    
    for (int i=0 ; i<[tableColumnKeys count]; i++) {
        NSString *heading = [tableColumnKeys objectAtIndex:i];
        NSString *val = [dict objectForKey:heading];
        [values addObject:val];
    }
    
    for (int i=0; i<columns; i++) {
        width = [[tableColumnWidths objectAtIndex:i] floatValue];
        UILabel *tempLabelView;
        if ([[tableColumnKeys objectAtIndex:i] isEqualToString:@"total"]) {
            tempLabelView = [self createLabelViewForTag:i withFrame:CGRectMake(originX, originY, width-20, height)];
            tempLabelView.textAlignment = NSTextAlignmentRight;
        }
        
        labelView = [self createLabelViewForTag:i withFrame:CGRectMake(originX, originY, width, height)];
        
        if([[tableColumns objectAtIndex:i] isEqualToString:@"Total($)"]){
            labelView.textAlignment = NSTextAlignmentRight;
        }else if ([[tableColumns objectAtIndex:i] isEqualToString:@"Date"]){
            labelView.textAlignment = NSTextAlignmentCenter;
        }else{
            labelView.textAlignment = NSTextAlignmentLeft;
        }
            
        
        for (UIView *subView in cell.contentView.subviews) {
            if (subView.tag == i) {
                [subView removeFromSuperview];
            }
        }
        
        [cell.contentView addSubview:labelView];
       
        if ([[tableColumnKeys objectAtIndex:i] isEqualToString:@"total"]) {
            [cell.contentView addSubview:tempLabelView];
            [costLabelsAry addObject:tempLabelView];
        }
        
        originX += width+2;
        labelView.tag = i;
        [labelsArray addObject:labelView];
    }
    [self constructLabels:labelsArray WithValues:values WithHeadingTypes:tableColumns WithCostLabelAry:costLabelsAry];
}





/* Method for constructing heading labels */
-(void)constructLabels:(NSArray *)LabelsArray WithValues:(NSArray *)ValuesArray WithHeadingTypes:(NSArray*)tableClmns WithCostLabelAry:(NSArray *)costLabelAry{
    
    for (int i=0; i<[LabelsArray count]; i++) {
        UILabel *testLabel = [LabelsArray objectAtIndex:i];
        
        NSString *tempStr = [NSString stringWithFormat:@"%@",[ValuesArray objectAtIndex:i]];
        NSInteger contentLen = [tempStr length] * 2;
        NSMutableString *content = [[NSMutableString alloc]init];
        int labelWidth = testLabel.frame.size.width;
        int textLen = labelWidth/10;
        
        NSString *cellStr;
        
        if (contentLen > labelWidth*2) {
            NSString *tempStr = [NSString stringWithFormat:@"%@",[ValuesArray objectAtIndex:i]];
            NSString *str = [tempStr substringToIndex:textLen];
            [content appendString:str];
            [content appendString:@"....."];
            cellStr = content ;
        }else{
            cellStr = [ValuesArray objectAtIndex:i] ;
        }
       
        NSString *columnName = [tableClmns objectAtIndex:i];

        if ([columnName isEqualToString:@"Order#"]) {
            testLabel.text = [NSString stringWithFormat:@"   %@",cellStr];

        }else if ([columnName isEqualToString:@"Total($)"]){
            UILabel *costTestLabel = [costLabelAry objectAtIndex:0];
            costTestLabel.text = cellStr;
        }else if ([columnName isEqualToString:@"Item"]){
            
            testLabel.text = [NSString stringWithFormat:@" %@",cellStr];

        }else{
            testLabel.text = cellStr;
        }
     }
}


- (UILabel*)createLabelViewForTag:(int)tag withFrame:(CGRect)rect{

    UILabel *lblView = [[UILabel alloc]initWithFrame:rect];

    lblView.backgroundColor = [FAUtilities getUIColorObjectFromHexString:@"F9F4EB" alpha:1];
    lblView.text = @"";
    lblView.textColor = [UIColor blackColor];
    lblView.font=cellLaebelFont;
    lblView.numberOfLines=0;
    lblView.lineBreakMode= NSLineBreakByWordWrapping;
    return lblView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (tableView == myOrdersTableView) {
        NSDictionary *currentDict = [resultsArray objectAtIndex:indexPath.row];
        currentOrderID = [[currentDict objectForKey:@"order_id"] intValue];
        currentSubTotalVal = [currentDict objectForKey:@"sub_total"];
        currentTaxVal =[currentDict objectForKey:@"tax"];
        currentTipVal = [currentDict objectForKey:@"tip"];
        currentTotalVal = [currentDict objectForKey:@"total"];
        [self postRequest:GET_ORDER_DETAILS_REQ_TYPE];
    }else if(tableView == searchOptionListTableView){
        
        SearchTextFieldViewController* viewController = [[SearchTextFieldViewController alloc]initwithName:[searchOptions objectAtIndex:indexPath.row] initWithDetailText:[popOverDict objectForKey:[searchOptions objectAtIndex:indexPath.row]] popoverContent:popoverContent columnType:[searchOptions objectAtIndex:indexPath.row] referenceId:nil];
        
        viewController.popOverDict = popOverDict;
        viewController.searchOptionListTableView = searchOptionListTableView;
        popoverContent.preferredContentSize = CGSizeMake(300,200);
        viewController.preferredContentSize = CGSizeMake(300,200);
        [popOverNavigationController pushViewController:viewController animated:YES];
    }
}


-(IBAction)searchBtnVClicked:(id)sender{
    [self.view endEditing:YES];
    searchOptionListTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 300, 300) style:UITableViewStylePlain];
    searchOptionListTableView.delegate = self;
    searchOptionListTableView.dataSource = self;
    searchOptionListTableView.tag = 1000;
    [self showPopOverForFilter:searchOptionListTableView withButton:sender withTitle:@"Filter"];
    [myOrdersTableView reloadData];
}



#pragma mark Filter
/* Method for state picker popover */
-(void)showPopOverForFilter:(UIView *)aView withButton:(UIButton *)button withTitle:(NSString *)aTitle{
    popoverContent = [[UIViewController alloc] init];
    UIView* popoverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    popoverView.backgroundColor = [UIColor whiteColor];
    [popoverView addSubview:aView];
    popoverContent.view = popoverView;
    popoverContent.title = aTitle;
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(saveButtonClicked:)];
    popoverContent.navigationItem.leftBarButtonItem =saveButton;
    UIBarButtonItem *clearButton = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStylePlain target:self action:@selector(clearButtonClicked:)];
    
    popoverContent.navigationItem.rightBarButtonItem =clearButton;
    popOverNavigationController = [[UINavigationController alloc] initWithRootViewController:popoverContent];
//	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismissPopOverController:)];
//	popOverNavigationController.navigationItem.rightBarButtonItem = doneButton;
    
    popOverNavigationController.navigationBar.tintColor = [FAUtilities getUIColorObjectFromHexString:@"#236198" alpha:1];
    popOverNavigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [FAUtilities getUIColorObjectFromHexString:@"#236198" alpha:1]};
    
    popoverContent.preferredContentSize = CGSizeMake(300,300);
    popoverController = [[UIPopoverController alloc] initWithContentViewController:popOverNavigationController];
    CGRect popoverRect = [self.view convertRect:[button frame] fromView:[button superview]];
    popoverRect.size.width = MIN(popoverRect.size.width, 100) ;
    popoverController.delegate =self;
    popoverRect.origin.x  = popoverRect.origin.x;
    [popoverController presentPopoverFromRect:popoverRect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}


- (IBAction)saveButtonClicked:(id)sender{

}



- (IBAction)clearButtonClicked:(id)sender{
    [popoverController dismissPopoverAnimated:YES];
    [popOverDict removeAllObjects];
}


-(IBAction)segmentControlValChanged:(id)sender{
    
    if (segCntl.selectedSegmentIndex ==0) {
        segmentedValue = @"0";
    }else if (segCntl.selectedSegmentIndex == 1){
        segmentedValue = @"3";
    }
    [myOrdersTableView reloadData];
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    for (UIView *subView in self.view.subviews) {
        if (subView.tag ==501) {
            [subView removeFromSuperview];
            [self loadCustomAlertSubView:alertMsg];
        }else if (subView.tag == 700){
            [disableCustomAlertView removeFromSuperview];
            [self LoadCustomAlertWithMessage];
        }
    }

    [myOrdersTableView reloadData];
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
