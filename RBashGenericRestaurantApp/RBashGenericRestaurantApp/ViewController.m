//
//  ViewController.m
//  ThinkingCup
//
//  Created by Manulogix on 01/09/14.
//  Copyright (c) 2014 Manulogix. All rights reserved.
//

#import "ViewController.h"
#import "HomeViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad{
    sleep(2);
    
    NSString *source;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        source = @"iPad";
        if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
            [iPadImageView setImage:[UIImage imageNamed:@"iPad_landscape-1.png"]];
        }else if(UIInterfaceOrientationIsPortrait(STATUSBAR_ORIENTATION)){
            [iPadImageView setImage:[UIImage imageNamed:@"iPad_potrait-1.png"]];
        }
    }else{
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [imageView setImage:[UIImage imageNamed:@"iPad_potrait-1.png"]];
        [self.view addSubview:imageView];
        source = @"iPhone";
    }
    
    
    NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
    [defaults setObject:RESTAURANT_ID forKey:@"RestaurantID"];
    //Fuel America live id=1 for test 6
    // Marios pizza live id =7 test 30
    //style cafe live id=4 test 37
    //Casablanca House of Pastry live=8 test =41
    //prosepect cafe Live id=9  test id =42
    [defaults setObject:@"Boston" forKey:@"RestaurantLocation"];
    [defaults setObject:source forKey:@"source"];

    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}


-(void)viewWillAppear:(BOOL)animated{
}


-(void)postRequest:(NSString *)reqType{
    NSString *finalReqUrl;
    NSMutableDictionary *test = [[NSMutableDictionary alloc]init];

    if ([reqType isEqualToString:GET_RESTAURANT_LOCATION_COUNT_REQ_TYPE]) {
        finalReqUrl = [NSString stringWithFormat:@"%@%@",REQ_URL,GET_RESTAURANT_LOCATION_COUNT_REQ];
        [test setObject:RESTAURANT_NAME forKey:@"RestaurantName"];
    }
    
    NSString *formattedBodyStr = [self jsonFormat:reqType withDictionary:test];
    NSString *dataInString = [NSString stringWithFormat: @"\"Data\":%@",formattedBodyStr];
    NSString *postDataInString = [NSString stringWithFormat:@"{\"Type\":\"%@\",%@}",reqType,dataInString];
    NSData *postJsonData = [postDataInString dataUsingEncoding:NSUTF8StringEncoding];
    webServiceInterface = [[WebServiceInterface alloc]initWithVC:self];
    webServiceInterface.delegate =self;
    [webServiceInterface sendRequest:postDataInString PostJsonData:postJsonData Req_Type:reqType Req_url:finalReqUrl];
}


-(NSString*)jsonFormat:(NSString *)type withDictionary:(NSMutableDictionary *)formatDict{
    NSString *bodyStr;
    if ([type isEqualToString:GET_RESTAURANT_LOCATION_COUNT_REQ_TYPE]){
        bodyStr =[NSString stringWithFormat: @"{\"rest_name\":\"%@\"}",[formatDict objectForKey:@"RestaurantName"]];
    }
    return bodyStr;
}



-(void)getResponse:(NSDictionary *)resp type:(NSString *)respType{
    
    if ([respType isEqualToString:GET_RESTAURANT_LOCATION_COUNT_REQ_TYPE]){
        NSDictionary *statusDict = [resp objectForKey:@"Status"];
        NSString *status = [NSString stringWithFormat:@"%@",[statusDict objectForKey:@"status"]];
        NSString *statusDesc = [statusDict objectForKey:@"desc"];
            
        if ([status isEqualToString:@"1"]) {
            NSDictionary *dataDict = [resp objectForKey:@"Data"];
            NSString *countStr = [dataDict objectForKey:@"count"];
            
            NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
            [defaults setObject:countStr forKey:@"CountValue"];
                
            int count = [countStr intValue];
                
            if(count == 1){
                NSString *restID = [dataDict objectForKey:@"rest_id"];
                NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
                [defaults setObject:restID forKey:@"RestaurantID"];
                [defaults synchronize];

                [self performSegueWithIdentifier:@"SegueLoginToDashboard" sender:self];
                
            }else if((count >=1)){
                    
                NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
                [defaults setObject:@"Multiple" forKey:@"LocationsStatus"];
                [defaults synchronize];
                
                NSDictionary *selectedDict = [defaults objectForKey:@"UserSelectedLocationDetails"];
                
                if (selectedDict == nil) {
                    [self performSegueWithIdentifier:@"segueVCToSelectLocation" sender:self];
                }else{
                    
                    NSString *restID = [selectedDict objectForKey:@"id"];
                    [defaults setObject:restID forKey:@"RestaurantID"];
                    [self performSegueWithIdentifier:@"SegueLoginToDashboard" sender:self];
                }
                
            }
                
            
        }else{
            customAlertMessage = statusDesc;
            customAlertTitle = @"Alert";
//                [self LoadCustomAlertWithMessageinView:@""];
        }
    }
}






-(void)viewDidAppear:(BOOL)animated{
//    [self performSegueWithIdentifier:@"SegueLoginToDashboard" sender:self];
    
    if([RESTAURANT_ID isEqualToString:@""]){
        [self postRequest:GET_RESTAURANT_LOCATION_COUNT_REQ_TYPE];  // if Web is ready
    }else{
        [self performSegueWithIdentifier:@"SegueLoginToDashboard" sender:self];
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
