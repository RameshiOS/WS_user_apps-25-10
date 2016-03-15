//
//  WebViewController.h
//  RBashGenericRestaurantApp
//
//  Created by Manulogix on 04/02/15.
//  Copyright (c) 2015 Manulogix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController<UIScrollViewDelegate,UIWebViewDelegate>{
    IBOutlet UIWebView *webPageView;
    IBOutlet UILabel *headingLabel;
    IBOutlet UIView *headerView;
    
    
    
}

@property(nonatomic,retain)NSString *webUrlStr;
@property(nonatomic,retain)NSString *headingLabelStr;


-(IBAction)backBtnClicked:(id)sender;


@end
