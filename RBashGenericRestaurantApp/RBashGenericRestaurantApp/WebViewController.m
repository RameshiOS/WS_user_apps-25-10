//
//  WebViewController.m
//  RBashGenericRestaurantApp
//
//  Created by Manulogix on 04/02/15.
//  Copyright (c) 2015 Manulogix. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController
@synthesize webUrlStr;
@synthesize headingLabelStr;

- (void)viewDidLoad {
    
    
    if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
        headerView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"pgm_HeaderLandscape.png"]];
        
    }else if(UIInterfaceOrientationIsPortrait(STATUSBAR_ORIENTATION)){
        
        headerView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"pgm_Header.png"]];
    }

    
    
    NSURL *url = [NSURL URLWithString:webUrlStr];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webPageView loadRequest:requestObj];
    
    headingLabel.text = headingLabelStr;
    webPageView.delegate=self;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


-(IBAction)backBtnClicked:(id)sender{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *parentView = [defaults objectForKey:@"ParentView"];
    
    if ([parentView isEqualToString:@"CheckOut"]) {
        
    }else{
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        [self.view.window.layer addAnimation:transition forKey:nil];
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    if ([webPageView isLoading]){
        [webPageView setDelegate:nil];
        [webPageView stopLoading];
        webPageView = nil;
    }
}


#pragma mark -
#pragma mark - UIScrollView Delegate Methods

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    webPageView.scrollView.maximumZoomScale = 20.0f; // set similar to previous.
}
#pragma mark - Webview Delegate Methods

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    webView.scrollView.delegate = self; // set delegate method of UISrollView
    webView.scrollView.maximumZoomScale = 20; // set as you want.
    webView.scrollView.minimumZoomScale = 1; // set as you want.
    
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
