//
//  ViewController.h
//  ThinkingCup
//
//  Created by Manulogix on 01/09/14.
//  Copyright (c) 2014 Manulogix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServiceInterface.h"

@interface ViewController : UIViewController<WebServiceInterfaceDelegate>{
    IBOutlet UIImageView *iPadImageView;
    WebServiceInterface *webServiceInterface;
    
    UIView *disableCustomAlertView;
    NSString *customAlertMessage;
    NSString *customAlertTitle;

}

@end
