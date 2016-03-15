//
//  SettingsViewController.m
//  ThinkingCup
//
//  Created by Manulogix on 05/09/14.
//  Copyright (c) 2014 Manulogix. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsCustomTableViewCell.h"
#import "FAUtilities.h"
#import "ColorToImage.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

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
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
            if ([APP_NAME isEqualToString:@"FuelAmericaAirport"]) {
                bgImageView.image = [UIImage imageNamed:@"iPad_landscape.png"];
            }else if ([APP_NAME isEqualToString:@"Mario'sPizza"]){
            }

            bgImageView.alpha = 0.7;
            
        }else if(UIInterfaceOrientationIsPortrait(STATUSBAR_ORIENTATION)){
            if ([APP_NAME isEqualToString:@"FuelAmericaAirport"]) {
                bgImageView.image = [UIImage imageNamed:@"iPad_potrait.png"];
            }else if ([APP_NAME isEqualToString:@"Mario'sPizza"]){
            }
            bgImageView.alpha = 0.7;
            
        }
    }
    settingsAry= [[NSMutableArray alloc]init];
    settingsImgsAry= [[NSMutableArray alloc]init];

    [settingsAry addObject:@"Notifications"];
    [settingsAry addObject:@"Terms of Service"];

    
    [settingsImgsAry addObject:@"pgm_notificationIcon.png"];
    [settingsImgsAry addObject:@"pgm_termsIcon.png"];
    acc_settingsLbl.textColor=[FAUtilities getUIColorObjectFromHexString:APP_HEADER_COLOR alpha:1.0];
    //APP_HEADER_COLOR
    
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark
#pragma mark TableView Datasource
/* number of sections in form list record table */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

/* number of rows in form list record table based on records saved in database */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [settingsAry count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
  
    static NSString *CellIdentifier = @"SettingsCustomTableViewCell";
    SettingsCustomTableViewCell *cell = [tableView
                                           dequeueReusableCellWithIdentifier:CellIdentifier
                                           forIndexPath:indexPath];

    [cell setBackgroundColor:[UIColor clearColor]];

    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [FAUtilities getUIColorObjectFromHexString:MENU_CELL_TEXT_COLOR alpha:1];

    cell.settingName.text = [settingsAry objectAtIndex:indexPath.row];
    cell.cellIcon.image = [UIImage imageNamed:[settingsImgsAry objectAtIndex:indexPath.row]];

    if ([[settingsAry objectAtIndex:indexPath.row] isEqualToString:@"Notifications"]) {
        cell.cellSwitch.hidden = NO;
        [cell.cellSwitch addTarget:self action:@selector(notificationSwitchChanged:) forControlEvents:UIControlEventValueChanged];

    }else{
        cell.cellSwitch.hidden = YES;
    }
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [FAUtilities getUIColorObjectFromHexString:@"000000" alpha:0.3];
    cell.selectedBackgroundView = bgColorView;

     [cell.cellSwitch setOnTintColor:[UIColor greenColor]];
    
//    cell.cellSwitch.backgroundColor=[UIColor redColor];
    
    
    
//    if ([APP_NAME isEqualToString:@"Mario'sPizza"] || [APP_NAME isEqualToString:@"The Fours"] || [APP_NAME isEqualToString:@"Prospect Cafe"]) {
//        [cell.cellSwitch setOnTintColor:[FAUtilities getUIColorObjectFromHexString:APP_HEADER_COLOR alpha:1]];
//    }else{
//        [cell.cellSwitch setOnTintColor:[FAUtilities getUIColorObjectFromHexString:MENU_CELL_TEXT_COLOR alpha:1]];
//    }
//    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    float cellHeight;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        cellHeight=60;
    }else{
        cellHeight=44;
    }
    
    return cellHeight;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath {
    
    if ([[settingsAry objectAtIndex:indexPath.row] isEqualToString:@"Terms of Service"]) {
    
        NSString *terms = [NSString stringWithFormat:@"%@index/terms",REQ_URL];
        
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:terms]];
    
    }
}


- (void)notificationSwitchChanged: (id)sender
{
    UISwitch* notificationSwitch = (UISwitch*) sender;
    
    
    if ([sender isOn]) {
        [sender setTintColor:[UIColor greenColor]];
    }else{
        notificationSwitch.backgroundColor=[UIColor redColor];
        notificationSwitch.layer.cornerRadius=16;
        
    }
    notificationSwitch.tintColor=[UIColor whiteColor];

}


-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
            if ([APP_NAME isEqualToString:@"FuelAmericaAirport"]) {
                bgImageView.image = [UIImage imageNamed:@"iPad_potrait.png"];
            }else if ([APP_NAME isEqualToString:@"Mario'sPizza"]){
            }

            bgImageView.alpha = 0.7;
        }else if(UIInterfaceOrientationIsPortrait(STATUSBAR_ORIENTATION)){
            if ([APP_NAME isEqualToString:@"FuelAmericaAirport"]) {
                bgImageView.image = [UIImage imageNamed:@"iPad_landscape.png"];
            }else if ([APP_NAME isEqualToString:@"Mario'sPizza"]){
            }
            bgImageView.alpha = 0.7;
            
        }
    }
}


-(IBAction)backBtnClicked:(id)sender{
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
