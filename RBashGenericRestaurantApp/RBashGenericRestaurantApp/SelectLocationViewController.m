//
//  SelectLocationViewController.m
//  RBashGenericRestaurantApp
//
//  Created by Manulogix on 30/03/15.
//  Copyright (c) 2015 Manulogix. All rights reserved.
//

#import "SelectLocationViewController.h"
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface SelectLocationViewController ()

@end

@implementation SelectLocationViewController
@synthesize currentLocation;


- (void)viewDidLoad {
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
            self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"pgm_ipad-Background-Landscape.png"]];
        }else if(UIInterfaceOrientationIsPortrait(STATUSBAR_ORIENTATION)){
            self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"pgm_ipad-Background-Potrait.png"]];
        }
    }else{
        if ([UIScreen mainScreen].bounds.size.height >= 568) {  // iphone 4 inch
            self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"pgm_iphone-Background-Potrait.png"]];
        }else{
            self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"pgm_iphone-Background-Potrait.png"]];
        }
    }
    
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(IBAction)findLocationBtnClicked:(id)sender{
    [self performSegueWithIdentifier:@"SelectLocationToLocationsList" sender:self];
}



- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        
        if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
            self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"pgm_ipad-Background-Landscape.png"]];
        }else if(UIInterfaceOrientationIsPortrait(STATUSBAR_ORIENTATION)){
            self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"pgm_ipad-Background-Potrait.png"]];
        }
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
