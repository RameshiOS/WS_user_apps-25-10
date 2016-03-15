//
//  MenuViewController.m
//  ThinkingCup
//
//  Created by Manulogix on 03/09/14.
//  Copyright (c) 2014 Manulogix. All rights reserved.
//

#import "MenuViewController.h"
#import "FAUtilities.h"
#import "LoginViewController.h"
#import "SettingsViewController.h"
#import "MyProfileViewController.h"
#import "MyOrdersViewController.h"
//#import <Crashlytics/Crashlytics.h>

@interface MenuViewController ()

@end

@implementation MenuViewController

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
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
            self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"pgm_ipad-Background-Landscape.png"]];
        }else if(UIInterfaceOrientationIsPortrait(STATUSBAR_ORIENTATION)){
            self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"pgm_ipad-Background-Potrait.png"]];
        }
    }else{
        self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"pgm_iphone-Background-Potrait.png"]];
    }
    
    menuListAry = [[NSMutableArray alloc]init];
    NSMutableArray *loginArray = [[NSMutableArray alloc]init];
    dbManager = [DataBaseManager dataBaseManager];
    [dbManager execute:[NSString stringWithFormat:@"SELECT * FROM LoginDetails "] resultsArray:loginArray];
    if (loginArray.count ==0) {
        [menuListAry addObject:@"Login"];
    }else{
        [menuListAry addObject:@"My Profile"];
        [menuListAry addObject:@"My Orders"];
    }
    
    

    NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
    NSString *locationsStatus = [defaults objectForKey:@"LocationsStatus"];
    
    if ([locationsStatus isEqualToString:@"Multiple"]) {
        [menuListAry addObject:@"Change Location"];   
    }
    

    [menuListAry addObject:@"Settings"];
    if (loginArray.count ==0) {
    }else{
        [menuListAry addObject:@"Logout"];
    }
    

    [menuTableView reloadData];
}


#pragma mark
#pragma mark TableView Datasource
/* number of sections in form list record table */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

/* number of rows in form list record table based on records saved in database */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [menuListAry count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [menuTableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyIdentifier"];
    }
   
    cell.textLabel.text = [menuListAry objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [FAUtilities getUIColorObjectFromHexString:MENU_CELL_TEXT_COLOR alpha:1];
   
    UIFont *cellFont ;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        cellFont =[UIFont fontWithName:SIDE_MENU_CELL_FONT_NAME size:22];
    }else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        cellFont =[UIFont fontWithName:SIDE_MENU_CELL_FONT_NAME size:16];
    }
    cell.textLabel.font = cellFont;
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [FAUtilities getUIColorObjectFromHexString:@"000000" alpha:0.3];
   
    cell.selectedBackgroundView = bgColorView;
    
    
    
    if ([[menuListAry objectAtIndex:indexPath.row] isEqualToString:@"Change Location"]) {
        cell.contentView.backgroundColor = [FAUtilities getUIColorObjectFromHexString:APP_HEADER_COLOR alpha:1];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath {
    NSString *selectedValue = [menuListAry objectAtIndex:indexPath.row];
    if ([selectedValue isEqualToString:@"Login"]) {
        NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
        [defaults setObject:@"Menu" forKey:@"LoginParentView"];
        [defaults synchronize];
        LoginViewController *login = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self presentViewController:login animated:YES completion:nil];
    }
    if ([selectedValue isEqualToString:@"My Profile"]) {
        MyProfileViewController *myProfile = [self.storyboard instantiateViewControllerWithIdentifier:@"MyProfileViewController"];
        [self presentViewController:myProfile animated:YES completion:nil];
    }
    if ([selectedValue isEqualToString:@"My Orders"]) {
        MyOrdersViewController *myOrders = [self.storyboard instantiateViewControllerWithIdentifier:@"MyOrdersViewController"];
        [self presentViewController:myOrders animated:YES completion:nil];
    }
    if ([selectedValue isEqualToString:@"Settings"]) {
        if ([RESTAURANT_NAME isEqualToString:@"Prospect Cafe & Pizzeria"]) {
          //  [[Crashlytics sharedInstance] crash];
        }

        SettingsViewController *settings = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
        [self presentViewController:settings animated:YES completion:nil];
    }
    if ([selectedValue isEqualToString:@"Logout"]) {
        dbManager = [DataBaseManager dataBaseManager];
        NSString *cartQuery = [NSString stringWithFormat:@"DELETE FROM LoginDetails "];
        [dbManager execute:cartQuery];
        
        NSString *cartQuery1 = [NSString stringWithFormat:@"DELETE FROM OrderMaster "];
        [dbManager execute:cartQuery1];

        [self viewWillAppear:YES];
    }
    
    
    if ([selectedValue isEqualToString:@"Change Location"]) {
        [self performSegueWithIdentifier:@"MenuToSelectLocations" sender:self];
    }
}

- (void)didReceiveMemoryWarning{
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
