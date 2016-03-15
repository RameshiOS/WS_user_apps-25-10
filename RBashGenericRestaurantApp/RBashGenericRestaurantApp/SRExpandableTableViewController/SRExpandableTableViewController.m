//
//  SRExpandableTableViewController.m
//  SRExpandableTableView
//
//  Created by Scot Reichman on 8/8/13.
//  Copyright (c) 2013 i2097i. All rights reserved.
//
//    DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
//    Version 2, December 2004
//
//    Copyright (C) 2004 Sam Hocevar <sam@hocevar.net>
//
//    Everyone is permitted to copy and distribute verbatim or modified
//    copies of this license document, and changing it is allowed as long
//    as the name is changed.
//
//    DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
//    TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
//
//    0. You just DO WHAT THE FUCK YOU WANT TO.

#import "SRExpandableTableViewController.h"
#import "FAUtilities.h"
//#import <FacebookSDK/FacebookSDK.h>
//#import "AppDelegate.h"
//#import <TwitterKit/TwitterKit.h>

//#define HEADER_BACKGROUND_COLOR [UIColor lightGrayColor]
//#define HEADER_BORDER_COLOR [[UIColor whiteColor]CGColor]
#define HEADER_FONT [UIFont fontWithName:@"Thonburi" size:22]
#define HEADER_FONT_COLOR [UIColor blackColor]

const double headerHeight = 50.0f;
const float headerLabelInset = 10.0f;
const float headerBorderWidth = 1.0f;
const float headerArrowInset = 20.0f;
const float footerHeight = 0.0f;

@interface SRExpandableTableViewController ()

@property (strong, nonatomic) NSArray *sectionLabels;
@property(strong,nonatomic) UIButton *buttonsArray;
@property (strong, nonatomic) NSArray *sectionContent;
@property (strong, nonatomic) NSMutableArray *expandedSectionContent;
@property (strong, nonatomic) NSMutableArray *collapsedSectionContent;
@property NSInteger expandedSection;
@property BOOL arrowsVisible;
@property BOOL allowsMultipleExpanded;

@end

@implementation SRExpandableTableViewController
@synthesize sectionLabels,sectionContent,expandedSectionContent,collapsedSectionContent,arrowsVisible,allowsMultipleExpanded,expandedSection;


-(void)viewDidLoad
{
//    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    if (delegate.refererAppLink) {
//       // self.backLinkInfo = delegate.refererAppLink;
//      //  [self _showBackLink];
//    }
//    delegate.refererAppLink = nil;
    
   //*********** share twitt **************
//    [[Twitter sharedInstance] logInGuestWithCompletion:^(TWTRGuestSession *guestSession, NSError *error) {
//        [[[Twitter sharedInstance] APIClient] loadTweetWithID:@"20" completion:^(TWTRTweet *tweet, NSError *error) {
//            TWTRTweetView *tweetView = [[TWTRTweetView alloc] initWithTweet:tweet style:TWTRTweetViewStyleRegular];
//            [self.view addSubview:tweetView];
//        }];
//    }];

    
    
    
}

#pragma mark - Table view data source

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.sectionLabels objectAtIndex:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionLabels.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.expandedSectionContent objectAtIndex:section] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        return 90;
        
    }else{
        return 50;
    }

    return 50;
    
    //	return headerHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	return footerHeight;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self getTableViewHeaderViewForSection:section];
}

#pragma mark - SRExpandableTableViewController custom methods

-(void)setSRExpandableTableViewControllerWithContent:(NSArray *)contentArray andSectionLabels:(NSArray *)labelsArray
{
    self.sectionContent = contentArray;
    self.sectionLabels = labelsArray;
    
    
    
    if(!sectionContent)
    {
        self.sectionContent = [NSArray array];
    }
    if(!sectionLabels)
    {
        self.sectionLabels = [NSArray array];
    }
    
    [self setupContentArrays];
    
    [self.tableView reloadData];

}

-(NSArray *)getSectionContentForSection:(NSInteger)section
{

    return [self.sectionContent objectAtIndex:section];
}

-(void)setMultiExpanded:(BOOL)multiExpanded
{
    self.allowsMultipleExpanded = multiExpanded;
    [self setupContentArrays];
    [self.tableView reloadData];
}

-(void)setArrowsHidden:(BOOL)arrowsHidden
{
    self.arrowsVisible = !arrowsHidden;
    [self.tableView reloadData];
}

-(void)headerTapped:(id)sender
{


    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    UIView *tappedView = tap.view;
    NSLog(@"header with tag %li was tapped",(long)tappedView.tag);
    if([[self.sectionContent objectAtIndex:tappedView.tag]count] == 0)
    {
        // No Content in selected section
    }
    else if([[self.expandedSectionContent objectAtIndex:tappedView.tag] count] == 0)
    {
        // Collapsed

        [self expandSection:tappedView.tag withReload:YES];
    }
    else
    {
        // Expanded

        [self closeSection:tappedView.tag];
    }
}

-(void)setupContentArrays
{
    if(self.allowsMultipleExpanded)
    {
        self.expandedSectionContent = [NSMutableArray arrayWithArray:[self.sectionContent copy]];
        self.collapsedSectionContent = [[NSMutableArray alloc] init];
        for(int i = 0; i < self.sectionContent.count; i++)
        {
            // Add placeholder to represent empty sections
            [self.collapsedSectionContent addObject:[[NSArray alloc]init]];
        }
    }
    else
    {
        self.collapsedSectionContent = [NSMutableArray arrayWithArray:[self.sectionContent copy]];
        self.expandedSectionContent = [[NSMutableArray alloc] init];
        for(int i = 0; i < self.sectionContent.count; i++)
        {
            // Add placeholder to represent empty sections
            [self.expandedSectionContent addObject:[[NSArray alloc]init]];
        }
//        self.expandedSection = 0;
//        [self expandSection:0 withReload:NO];
    }
}

-(void)closeSection:(NSInteger)section
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"NO" forKey:@"Expand"];
    [defaults synchronize];
    
	NSMutableArray *arrayToClose = [self.expandedSectionContent objectAtIndex:section];
	NSMutableArray *placeholderArray = [self.collapsedSectionContent objectAtIndex:section];
	if(placeholderArray.count == 0)
	{
        closeTapped = YES;
		[self.collapsedSectionContent replaceObjectAtIndex:section withObject:arrayToClose];
		[self.expandedSectionContent replaceObjectAtIndex:section withObject:placeholderArray];
		[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

-(void)expandSection:(NSInteger)section withReload:(BOOL)reload
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"YES" forKey:@"Expand"];
    [defaults synchronize];
    
    
	NSMutableArray *arrayToExpand = [self.collapsedSectionContent objectAtIndex:section];
    NSMutableArray *placeholderArray = [self.expandedSectionContent objectAtIndex:section];
    
	if(placeholderArray.count == 0)
	{
        if(!self.allowsMultipleExpanded)
        {
            [self closeSection:self.expandedSection];
        }
        self.expandedSection = section;
		[self.expandedSectionContent replaceObjectAtIndex:section withObject:arrayToExpand];
		[self.collapsedSectionContent replaceObjectAtIndex:section withObject:placeholderArray];
		
		if(reload)
		{
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];

		}
	}
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.tableView reloadData];
}

-(UIView *)getTableViewHeaderViewForSection:(NSInteger)section
{
    CGRect viewFrame = CGRectMake(0, 0, self.view.frame.size.width, headerHeight);
    
    CGRect countFrame;
    
    
    UIView *view = [[UIView alloc]initWithFrame:viewFrame];
    if(self.tableView.style == UITableViewStylePlain)
    {
       // if (closeTapped == NO) {
       //     [view setBackgroundColor:[FAUtilities getUIColorObjectFromHexString:@"DCB3DE" alpha:1]];

//        }else{
    //        [view setBackgroundColor:[FAUtilities getUIColorObjectFromHexString:@"F9F4EB" alpha:1]];
      //  }

        [view setBackgroundColor:[FAUtilities getUIColorObjectFromHexString:@"F9F4EB" alpha:1]];
    }
    else
    {
        [view setBackgroundColor:[UIColor clearColor]];
    }
    
    
    [view.layer setBorderColor:[[FAUtilities getUIColorObjectFromHexString:@"CCCAC5" alpha:1]CGColor ]];
    [view.layer setBorderWidth:headerBorderWidth];
    [view setTag:section];
    
    
   tempValDict = [self.sectionLabels objectAtIndex:section];
    
    CGRect labelFrame;
    
    UIFont *headerFont;
    UIFont *costLabelFont;
    int cornerRadious;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        headerFont = [UIFont fontWithName:@"Thonburi" size:36];
        labelFrame = CGRectMake(viewFrame.origin.x, viewFrame.origin.y+15, viewFrame.size.width, viewFrame.size.height);
      
//        if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
//            countFrame = CGRectMake(labelFrame.size.width-300, viewFrame.origin.y+15, 90, 90-30);
//
//        }
//        else if (UIInterfaceOrientationIsPortrait(STATUSBAR_ORIENTATION))
//        {
//            countFrame = CGRectMake(labelFrame.size.width-100, viewFrame.origin.y+15, 90, 90-30);
//   
//        }
        countFrame = CGRectMake(labelFrame.size.width-100, viewFrame.origin.y+15, 90, 90-30);

        costLabelFont = [UIFont fontWithName:@"Thonburi-Bold" size:32];
        cornerRadious= 20;
    }else{
        headerFont = [UIFont fontWithName:@"Thonburi" size:20];
        labelFrame = viewFrame;
        countFrame = CGRectMake(viewFrame.size.width-55, 10, 50, headerHeight-20);
        costLabelFont = [UIFont fontWithName:@"Thonburi-Bold" size:20];
        cornerRadious = 14;
        
    }

    
    labelFrame.origin.x = headerLabelInset;
    labelFrame.size.width = viewFrame.size.width - headerLabelInset - countFrame.size.width -10;
    UILabel *label = [[UILabel alloc]initWithFrame:labelFrame];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setText:[tempValDict objectForKey:@"name"]];
    
    

    
    [label setFont:headerFont];
  
    
    
    [label setTextColor:HEADER_FONT_COLOR];
    [label setTextAlignment:NSTextAlignmentLeft];
    [view addSubview:label];

    
    UIView *countSubView = [[UIView alloc]initWithFrame:countFrame];
    countSubView.layer.cornerRadius = cornerRadious;
    countSubView.backgroundColor = [FAUtilities getUIColorObjectFromHexString:LIST_COUNT_SUBVIEW_BG_COLOR alpha:1];
    UILabel *countLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, countFrame.size.width-10, countFrame.size.height-10)];
    [countLabel setBackgroundColor:[UIColor clearColor]];
    [countLabel setText:[tempValDict objectForKey:@"CategoryCount"]];
    [countLabel setFont:costLabelFont];
    [countLabel setTextAlignment:NSTextAlignmentCenter];
    [countLabel setTextColor:[UIColor whiteColor]];
    [countSubView addSubview:countLabel];
    [view addSubview:countSubView];
    
    

//UIButton *cameraBTn=[[UIButton alloc]initWithFrame:CGRectMake(550, label.frame.origin.y, 50, label.frame.size.height)];
//
//    
//    [cameraBTn setImage:[UIImage imageNamed:@"Camera-50.png"] forState:UIControlStateNormal];
//    
//    
//    [cameraBTn addTarget:self action:@selector(cameraClicked:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [view addSubview:cameraBTn];
    
    if(self.arrowsVisible){
        CGRect imageViewFrame = viewFrame;
        imageViewFrame.size.width = headerHeight/2;
        imageViewFrame.size.height = headerHeight/2;
        imageViewFrame.origin.x = viewFrame.size.width - headerArrowInset;
        imageViewFrame.origin.y = headerHeight/4;
        UIImageView *imageView = [[UIImageView alloc]init];
        [imageView setFrame:imageViewFrame];
        UIImage *image;
        if([self isSectionExpanded:section]){
            image = [UIImage imageNamed:@"arrow_down.png"];
        }else{
            image = [UIImage imageNamed:@"arrow_left.png"];
        }
        [imageView setImage:image];
        [view addSubview:imageView];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerTapped:)];
    [tap setNumberOfTapsRequired:1];
    [tap setNumberOfTouchesRequired:1];
    [view addGestureRecognizer:tap];
    
    return view;
}


-(BOOL)isSectionExpanded:(NSInteger)section
{
    return [[self.collapsedSectionContent objectAtIndex:section] count] == 0 || [[self.expandedSectionContent objectAtIndex:section]count] > 0 || [[self.sectionContent objectAtIndex:section]count] == 0;
}

@end
