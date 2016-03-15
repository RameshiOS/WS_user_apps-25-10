//
//  AppDelegate.h
//  ThinkingCup
//
//  Created by Manulogix on 01/09/14.
//  Copyright (c) 2014 Manulogix. All rights reserved.
//

#import "FAUtilities.h"
#import <mach/mach.h>
#import <QuartzCore/QuartzCore.h>
#include <sys/xattr.h>


@implementation FAUtilities


static char base64EncodingTable[64] = {
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
    'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
    'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
    'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'
};

+ (void)setBorderWithColor:(UIColor *)color toView:(UIView *)view withRadius:(CGFloat)radius{
    CALayer * layer = [view layer];
    [layer setMasksToBounds:YES];
    [layer setBorderWidth:1.0];
    [layer setBorderColor:[color CGColor]];
    [layer setCornerRadius:radius];
}
+ (UIBarButtonItem *)customButtonWithTitle:(NSString*)title style:(UIButtonType)buttonStyle target:(id)target action:(SEL)sel width:(CGFloat)width{
    UIButton *buttonView = [UIButton buttonWithType:buttonStyle];
    [buttonView setFrame:CGRectMake(0, 0, width, 30)];
	[buttonView setTitle:title forState:UIControlStateNormal];
	buttonView.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    buttonView.titleEdgeInsets = UIEdgeInsetsMake(0, 7, 3, 0);
    buttonView.titleLabel.textAlignment = NSTextAlignmentCenter;
	[buttonView addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    [buttonView setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
	UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:buttonView];
	return barButton  ;
}
+ (UIBarButtonItem *)customButtonWithImage:(NSString*)bgImage target:(id)target action:(SEL)sel width:(CGFloat)width{
    UIButton *buttonView = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonView setFrame:CGRectMake(0, 0, width, 30)];
    
	buttonView.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    buttonView.titleEdgeInsets = UIEdgeInsetsMake(0, 7, 3, 0);
    buttonView.titleLabel.textAlignment = NSTextAlignmentCenter;
	[buttonView addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    [buttonView setBackgroundImage:[UIImage imageNamed:bgImage] forState:UIControlStateNormal];
    //buttonView.imageView.layer.cornerRadius = 7.0f;
    buttonView.layer.shadowRadius = 5.0f;
    buttonView.layer.shadowColor = [[UIColor colorWithRed:248.0f/255.0f green:249.0f/255.0f blue:250.0f/255.0f alpha:1] CGColor];
    buttonView.layer.shadowOffset = CGSizeMake(-4.0f, 1.0f);
    buttonView.layer.shadowOpacity = 0.5f;
    buttonView.layer.masksToBounds = NO;
//    [buttonView.layer setCornerRadius: 4.0];
//    [buttonView.layer setBorderWidth:1.0];
    [buttonView.layer setBorderColor:[[UIColor colorWithRed:171.0f/255.0f green:171.0f/255.0f blue:171.0f/255.0f alpha:1] CGColor]];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:buttonView];
	return barButton  ;
}


+ (UIBarButtonItem *)customBackButtonWithtarget:(id)target action:(SEL)sel width:(CGFloat)width{
    UIButton *backButtonView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, width, 20)];
    backButtonView.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    backButtonView.titleLabel.textAlignment = NSTextAlignmentCenter;
    backButtonView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
	[backButtonView addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    [backButtonView setBackgroundImage:[UIImage imageNamed:@"backhome"] forState:UIControlStateNormal];
	UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButtonView];
	return backBarButton  ;
}
+ (UIBarButtonItem *)customBackButtonWithtarget:(id)target action:(SEL)sel width:(CGFloat)width title:(NSString *)title{
    UIButton *backButtonView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, width, 30)];
    backButtonView.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    backButtonView.titleLabel.textAlignment = NSTextAlignmentCenter;
    backButtonView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
	[backButtonView addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    [backButtonView setBackgroundImage:[UIImage imageNamed:@"button_black_1.png"] forState:UIControlStateNormal];
    [backButtonView setBackgroundImage:[UIImage imageNamed:@"button_black_2.png"] forState:UIControlStateHighlighted];

    [backButtonView setTitle:title forState:UIControlStateNormal];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButtonView];
	return backBarButton  ;
}
+ (UIBarButtonItem *)customInfoButtonWithtarget:(id)target action:(SEL)sel width:(CGFloat)width{
    UIButton *infoButtonView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, width, 20)];
    infoButtonView.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    infoButtonView.titleLabel.textAlignment = NSTextAlignmentCenter;
    infoButtonView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
	[infoButtonView addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    [infoButtonView setBackgroundImage:[UIImage imageNamed:@"Info"] forState:UIControlStateNormal];
	UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:infoButtonView];
	return backBarButton  ;
}
+ (NSData*)getImageDataFromView:(UIView*)view{
    UIGraphicsBeginImageContext([view bounds].size);
    [[view layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    NSData *data = UIImageJPEGRepresentation(image, 1);
    UIGraphicsEndImageContext();
    return data;
}

+ (CGFloat)convertBytesToMB:(CGFloat)bytes{
    CGFloat mbData = ((bytes/1024)/1024);
    return mbData;
}

+ (CGFloat)getTotalDiskspace{
    CGFloat totalSpace = 0.0f;
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    
    if (dictionary) {
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];
        totalSpace = [fileSystemSizeInBytes floatValue];
    } else {
        NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %ld", [error domain], (long)[error code]);
    }
     return totalSpace;
}

+ (CGFloat)getFreeDiskspace {
    CGFloat totalSpace = 0.0f;
    CGFloat totalFreeSpace = 0.0f;
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    
    if (dictionary) {
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];
        NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
        totalSpace = [fileSystemSizeInBytes floatValue];
        totalFreeSpace = [freeFileSystemSizeInBytes floatValue];
        NSLog(@"Memory Capacity of %.2f MiB with %.2f MiB Free memory available.", ((totalSpace/1024)/1024), ((totalFreeSpace/1024)/1024));
    } else {
        NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %ld", [error domain], (long)[error code]);
    }
    return totalFreeSpace;
}

+ (CGFloat)getAppUsageSpace {
    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    kern_return_t kerr = task_info(mach_task_self(),
                                   TASK_BASIC_INFO,
                                   (task_info_t)&info,
                                   &size);
    if( kerr == KERN_SUCCESS ) {
        NSLog(@"Memory in use (in bytes): %u", info.resident_size);
    } else {
        NSLog(@"Error with task_info(): %s", mach_error_string(kerr));
    }
    return  info.resident_size;
}


+ (UIColor *)getUIColorObjectFromHexString:(NSString *)hexStr alpha:(CGFloat)alpha
{
    // Convert hex string to an integer
    unsigned int hexint = [self intFromHexString:hexStr];
    
    // Create color object, specifying alpha as well
    UIColor *color =
    [UIColor colorWithRed:((CGFloat) ((hexint & 0xFF0000) >> 16))/255
                    green:((CGFloat) ((hexint & 0xFF00) >> 8))/255
                     blue:((CGFloat) (hexint & 0xFF))/255
                    alpha:alpha];
    
    return color;
}

+ (unsigned int)intFromHexString:(NSString *)hexStr
{
    unsigned int hexInt = 0;
    
    // Create scanner
    NSScanner *scanner = [NSScanner scannerWithString:hexStr];
    
    // Tell scanner to skip the # character
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
    
    // Scan hex value
    [scanner scanHexInt:&hexInt];
    
    return hexInt;
}


+(BOOL) offlineCheck {
//    if(isOFFLINE) {
//        return YES;
//    }
//    return NO;
    return NO;
}


+(void)showAlert:(NSString*)msg{
    NSString *titleStr = @"Alert";
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:titleStr message:msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

+(void)dismissAlert:(NSString*)msg{
    
}

+(void)showAlertMessage:(NSString*)msg{
    NSString *titleStr = @"Thanks";
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:titleStr message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alert show];
    
    [self performSelector:@selector(dismiss:) withObject:alert afterDelay:3];

}



+(void)showToastMessageAlert:(NSString*)message{
//    NSString *titleString;
//    
//    if ([[[UIDevice currentDevice] systemVersion] doubleValue] < 7) {
//        titleString = [NSString stringWithFormat:@"\n\n%@",FORMS_PAGE_TITLE];
//    }else{
//        titleString = FORMS_PAGE_TITLE;
//    }
//
//    
//	UIAlertView *toastMsgAlert= [[UIAlertView alloc] initWithTitle:titleString
//                                                           message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
//	[toastMsgAlert setMessage:message];
//	[toastMsgAlert setDelegate:self];
//	[toastMsgAlert show];
//    
//  
//    
//    [self performSelector:@selector(dismiss:) withObject:toastMsgAlert afterDelay:1.5];
}

+(void)dismiss:(UIAlertView*)alertView
{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}



+ (NSString *) base64StringFromData: (NSData *)data length: (int)length {
    unsigned long ixtext, lentext;
    long ctremaining;
    unsigned char input[3], output[4];
    short i, charsonline = 0, ctcopy;
    const unsigned char *raw;
    NSMutableString *result;
    
    lentext = [data length];
    if (lentext < 1)
        return @"";
    result = [NSMutableString stringWithCapacity: lentext];
    raw = [data bytes];
    ixtext = 0;
    
    while (true) {
        ctremaining = lentext - ixtext;
        if (ctremaining <= 0)
            break;
        for (i = 0; i < 3; i++) {
            unsigned long ix = ixtext + i;
            if (ix < lentext)
                input[i] = raw[ix];
            else
                input[i] = 0;
        }
        output[0] = (input[0] & 0xFC) >> 2;
        output[1] = ((input[0] & 0x03) << 4) | ((input[1] & 0xF0) >> 4);
        output[2] = ((input[1] & 0x0F) << 2) | ((input[2] & 0xC0) >> 6);
        output[3] = input[2] & 0x3F;
        ctcopy = 4;
        switch (ctremaining) {
            case 1:
                ctcopy = 2;
                break;
            case 2:
                ctcopy = 3;
                break;
        }
        
        for (i = 0; i < ctcopy; i++)
            [result appendString: [NSString stringWithFormat: @"%c",base64EncodingTable[output[i]]]];
        
        for (i = ctcopy; i < 4; i++)
            [result appendString: @"="];
        
        ixtext += 3;
        charsonline += 4;
        
        if ((length > 0) && (charsonline >= length))
            charsonline = 0;
    }
    return result;
}
+ (NSData *)base64DataFromString: (NSString *)string{
    unsigned long ixtext, lentext;
    unsigned char ch, inbuf[4], outbuf[3];
    short i, ixinbuf;
    Boolean flignore, flendtext = false;
    const unsigned char *tempcstring;
    NSMutableData *theData;
    
    if (string == nil)
    {
        return [NSData data];
    }
    
    ixtext = 0;
    
    tempcstring = (const unsigned char *)[string UTF8String];
    
    lentext = [string length];
    
    theData = [NSMutableData dataWithCapacity: lentext];
    
    ixinbuf = 0;
    
    while (true)
    {
        if (ixtext >= lentext)
        {
            break;
        }
        
        ch = tempcstring [ixtext++];
        
        flignore = false;
        
        if ((ch >= 'A') && (ch <= 'Z'))
        {
            ch = ch - 'A';
        }
        else if ((ch >= 'a') && (ch <= 'z'))
        {
            ch = ch - 'a' + 26;
        }
        else if ((ch >= '0') && (ch <= '9'))
        {
            ch = ch - '0' + 52;
        }
        else if (ch == '+')
        {
            ch = 62;
        }
        else if (ch == '=')
        {
            flendtext = true;
        }
        else if (ch == '/')
        {
            ch = 63;
        }
        else
        {
            flignore = true;
        }
        
        if (!flignore)
        {
            short ctcharsinbuf = 3;
            Boolean flbreak = false;
            
            if (flendtext)
            {
                if (ixinbuf == 0)
                {
                    break;
                }
                
                if ((ixinbuf == 1) || (ixinbuf == 2))
                {
                    ctcharsinbuf = 1;
                }
                else
                {
                    ctcharsinbuf = 2;
                }
                
                ixinbuf = 3;
                
                flbreak = true;
            }
            
            inbuf [ixinbuf++] = ch;
            
            if (ixinbuf == 4)
            {
                ixinbuf = 0;
                
                outbuf[0] = (inbuf[0] << 2) | ((inbuf[1] & 0x30) >> 4);
                outbuf[1] = ((inbuf[1] & 0x0F) << 4) | ((inbuf[2] & 0x3C) >> 2);
                outbuf[2] = ((inbuf[2] & 0x03) << 6) | (inbuf[3] & 0x3F);
                
                for (i = 0; i < ctcharsinbuf; i++)
                {
                    [theData appendBytes: &outbuf[i] length: 1];
                }
            }
            
            if (flbreak)
            {
                break;
            }
        }
    }
    
    return theData;
}


+ (void)addSkipBackupAttributeToPath:(NSString*)path {
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    
    BOOL result = setxattr([path fileSystemRepresentation], attrName, &attrValue, sizeof(attrValue), 0, 0);
    NSLog(@"result %d",result);
    
}


+(UIView *)loadCustomServiceAlertView:(UIView *)parentView Message:(NSString *)alertMsg{
    UIView  *customView = [[UIView alloc]init];
    customView.tag = 501;
    
    
    CGRect textViewFrame;
    CGRect cancelBtnFrame;
    CGRect emailBtnFrame;
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        if(UIInterfaceOrientationIsLandscape(STATUSBAR_ORIENTATION)){
            customView.frame = CGRectMake(262, 159, 500, 450);
        }else if(UIInterfaceOrientationIsPortrait(STATUSBAR_ORIENTATION)){
            customView.frame = CGRectMake(134, 287-50, 500, 450);
        }
        
        textViewFrame = CGRectMake(20, 10, 460, 350);
        cancelBtnFrame = CGRectMake(140, 380, 100, 40);
        emailBtnFrame = CGRectMake(cancelBtnFrame.origin.x+cancelBtnFrame.size.width+10, 380, 100, 40);
        
    }else{
        if ([UIScreen mainScreen].bounds.size.height == 568) {  // iphone 4 inch
            customView.frame = CGRectMake(18, 98, 320-36, 250+4+50);
        }else{
            customView.frame = CGRectMake(18, 78, 320-36, 250+4+50);
        }
        
        textViewFrame = CGRectMake(10, 10, 264, 224);
        cancelBtnFrame = CGRectMake(70, 250, 70, 30);
        emailBtnFrame = CGRectMake(cancelBtnFrame.origin.x+cancelBtnFrame.size.width+5, 250, 70, 30);
        
    }
    
    
    
    customView.layer.borderColor = [[UIColor grayColor]CGColor];
    customView.layer.borderWidth = 2;
    customView.layer.cornerRadius = 6;
    
    customView.backgroundColor = [FAUtilities getUIColorObjectFromHexString:@"ECDDEC" alpha:1];
    
    UITextView *requestTextView = [[UITextView alloc]initWithFrame:textViewFrame];
    requestTextView.text = alertMsg;
    
    [customView addSubview:requestTextView];
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:cancelBtnFrame];
    [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelBtn setTintColor:[UIColor blueColor]];
    cancelBtn.tag = 5004;
    
    
    [self setBackgroundImagesForButton:cancelBtn];

    
    [customView addSubview:cancelBtn];
    
    
    UIButton *emailBtn = [[UIButton alloc]initWithFrame:emailBtnFrame];
    [emailBtn setTitle:@"Email" forState:UIControlStateNormal];
    [emailBtn setTintColor:[UIColor blueColor]];
    emailBtn.tag = 5005;
   
    [self setBackgroundImagesForButton:emailBtn];

    [customView addSubview:emailBtn];
    
    
    [parentView addSubview:customView];
 
    return customView;
}



+(CGSize)getHeightFromString:(NSString *)string AndWidth:(float)width AndFont:(UIFont *)font{
    
    NSAttributedString *attributedText =
    [[NSAttributedString alloc]
     initWithString:string
     attributes:@
     {
     NSFontAttributeName: font
     }];
    
    CGRect rect = [attributedText boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize stringSize = rect.size;
    
    return stringSize;
    
}


+(NSString *)formatJSONStr:(NSString *)string{
 
    NSString *formattedStr;
    
   formattedStr = [string stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
   formattedStr = [formattedStr stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
   formattedStr = [formattedStr stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
   formattedStr = [formattedStr stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];

    
    return formattedStr;
}

+(void)showAlert:(NSString*)msg withHeading:(NSString *)heading{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:heading message:msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}


+(void)setBackgroundImagesForButton:(UIButton *)button{
    [button setBackgroundImage:[UIImage imageNamed:@"pgm_rounded_Button_Normal.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"pgm_rounded_Button_Active.png"] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageNamed:@"pgm_rounded_Button_Active.png"] forState:UIControlStateSelected];
}



+(UIView *)customAlert:(NSString *)heading withStr:(NSString *)message withColor:(NSString *)color withFrame:(CGRect)rect withNumberOfButtons:(int)buttons withOnlyCancelBtnMessage:(NSString *)onlyCancelBtnMsg WithCancelBtnMessage:(NSString *)cancelBtnMsg WithDoneBtnMessage:(NSString *)doneBtnMsg{

    CGRect headingViewPlaceholderFrame;
    CGRect headingViewFrame;
    CGRect headingLabelFrame;
    CGRect messageLabelFrame;
    CGRect seeHoursBtnFrame;
    
    CGRect customAlertFrame;
    
    UIFont *headingLabelFont;
    UIFont *valuesFont;
    UIFont *msgLabelFont;
    UIFont *btnFonts;

    
    CGRect cancelBtnFrame;
    CGRect doneBtnFrame;
    CGRect onlyCancelBtnFrame;
   
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){

        headingLabelFont = [UIFont fontWithName:@"Thonburi" size:32];
        valuesFont = [UIFont fontWithName:@"Thonburi" size:28];
        msgLabelFont = [UIFont fontWithName:@"Thonburi" size:22];
        btnFonts = [UIFont fontWithName:@"Verdana" size:30];

        CGSize messageSize = [self getHeightFromString:message AndWidth:rect.size.width AndFont:msgLabelFont];
        
        
        
        customAlertFrame = rect;
        headingViewPlaceholderFrame = CGRectMake(0, 0, customAlertFrame.size.width-4, 10);
        headingViewFrame = CGRectMake(0, 8, customAlertFrame.size.width-4, 45);
        headingLabelFrame = CGRectMake(12, 0, headingViewFrame.size.width-24, 45);
        messageLabelFrame = CGRectMake(20, headingViewFrame.origin.y + headingViewFrame.size.height +8, customAlertFrame.size.width-40, messageSize.height+30);//30
        seeHoursBtnFrame=CGRectMake(messageLabelFrame.origin.x,messageLabelFrame.origin.y+messageLabelFrame.size.height-10, 150, 30);
        
        cancelBtnFrame = CGRectMake(60, messageLabelFrame.origin.y + messageLabelFrame.size.height +10, 180, 60);
        
        doneBtnFrame = CGRectMake(cancelBtnFrame.origin.x+cancelBtnFrame.size.width+20, messageLabelFrame.origin.y + messageLabelFrame.size.height +10, 180, 60);
  
        if ([heading isEqualToString:@"Restaurant Operating Hours"]) {
             onlyCancelBtnFrame = CGRectMake(160, messageLabelFrame.origin.y + messageLabelFrame.size.height +10+seeHoursBtnFrame.size.height, 180, 60);
        }
        else
        {
             onlyCancelBtnFrame = CGRectMake(160, messageLabelFrame.origin.y + messageLabelFrame.size.height +10, 180, 60);
        }
        
       

        
    }else{
        headingLabelFont = [UIFont fontWithName:@"Thonburi" size:18];
        valuesFont = [UIFont fontWithName:@"Thonburi" size:14];
        msgLabelFont = [UIFont fontWithName:@"Thonburi" size:12];
        btnFonts = [UIFont fontWithName:@"Verdana" size:20];
        
        CGSize messageSize = [self getHeightFromString:message AndWidth:rect.size.width AndFont:msgLabelFont];

        
        customAlertFrame = rect;


        
        headingViewPlaceholderFrame = CGRectMake(0, 0, customAlertFrame.size.width-4, 10);
        headingViewFrame = CGRectMake(0, 8, customAlertFrame.size.width-4, 35);
        headingLabelFrame = CGRectMake(8, 0, headingViewFrame.size.width-16, 35);

        messageLabelFrame = CGRectMake(20, headingViewFrame.origin.y + headingViewFrame.size.height +8, customAlertFrame.size.width-40, messageSize.height+20);
seeHoursBtnFrame=CGRectMake(messageLabelFrame.origin.x, messageLabelFrame.origin.y+messageLabelFrame.size.height-10, 80, 15);
        cancelBtnFrame = CGRectMake(20, messageLabelFrame.origin.y + messageLabelFrame.size.height +4, 110, 36);
        
        doneBtnFrame = CGRectMake(cancelBtnFrame.origin.x+cancelBtnFrame.size.width+20, messageLabelFrame.origin.y + messageLabelFrame.size.height +4, 110, 36);
        
        if ([heading isEqualToString:@"Restaurant Operating Hours"]) {
             onlyCancelBtnFrame = CGRectMake(85, messageLabelFrame.origin.y + messageLabelFrame.size.height +4+seeHoursBtnFrame.size.height, 110, 36);
        }
        else
        {
             onlyCancelBtnFrame = CGRectMake(85, messageLabelFrame.origin.y + messageLabelFrame.size.height +4, 110, 36);
        }
        
   

    }
  
    
    UIView *customAlert1 = [[UIView alloc]initWithFrame:customAlertFrame];
    customAlert1.backgroundColor = [UIColor whiteColor];
    customAlert1.layer.cornerRadius = 8;
    
    UIView *customAlert = [[UIView alloc]initWithFrame:CGRectMake(2, 2, customAlert1.frame.size.width-4, customAlert1.frame.size.height-4)];
    customAlert.backgroundColor = [FAUtilities getUIColorObjectFromHexString:@"EFF0F2" alpha:1];
    customAlert.layer.borderColor = [[UIColor grayColor]CGColor];
    customAlert.layer.borderWidth = 2;
    customAlert.layer.cornerRadius = 8;


    
    UIView *headingViewPlaceholder = [[UIView alloc]initWithFrame:headingViewPlaceholderFrame];
    headingViewPlaceholder.backgroundColor = [FAUtilities getUIColorObjectFromHexString:APP_HEADER_COLOR alpha:1];
    headingViewPlaceholder.layer.cornerRadius = 8;
    
    UIView *headingView = [[UIView alloc]initWithFrame:headingViewFrame];
    headingView.backgroundColor = [FAUtilities getUIColorObjectFromHexString:APP_HEADER_COLOR alpha:1];
    
    UILabel *headingLabel = [[UILabel alloc]initWithFrame:headingLabelFrame];
    headingLabel.textColor = [UIColor whiteColor];
    headingLabel.text = heading;
    headingLabel.font = headingLabelFont;
    headingLabel.textAlignment = NSTextAlignmentCenter;
    

    UILabel *messageLabel = [[UILabel alloc]initWithFrame:messageLabelFrame];
    messageLabel.text = message;
    messageLabel.font = msgLabelFont;
    messageLabel.numberOfLines = 0;
 //  messageLabel.layer.borderWidth = 2;
  // messageLabel.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    
    
    if ([heading isEqualToString:@"Restaurant Operating Hours"]) {
        if ([message isEqualToString:@"Unfortunately, we dont have a delivery to that address. You can change this order to PICKUP or provide a different delivery location."]) {
            messageLabel.textAlignment = NSTextAlignmentLeft;

        }else if ([message rangeOfString:@"Thanks for visiting our restaurant. Unfortunately, we are closed at this time."].location !=NSNotFound)
        {
            messageLabel.textAlignment = NSTextAlignmentLeft;

        }
        else
        {
              messageLabel.textAlignment = NSTextAlignmentCenter;
        }
        
        UIButton *seeHoursButton = [[UIButton alloc]initWithFrame:seeHoursBtnFrame];
        //  [self setBackgroundImagesForButton:seeHoursButton];
        [seeHoursButton setTitle:@"See Hours" forState:UIControlStateNormal];
        seeHoursButton.titleLabel.textAlignment=NSTextAlignmentLeft;
        
        [seeHoursButton.titleLabel setFont:msgLabelFont];
      //  seeHoursButton.layer.borderWidth = 2;
      //  seeHoursButton.layer.borderColor = [[UIColor lightGrayColor]CGColor];
        seeHoursButton.userInteractionEnabled=YES;
        [seeHoursButton setTitleColor:[FAUtilities getUIColorObjectFromHexString:APP_HEADER_COLOR alpha:1.0] forState:UIControlStateNormal];
        
        seeHoursButton.tag = 1002;
        
        [customAlert addSubview:seeHoursButton];

        
        
        
    }else{
        messageLabel.textAlignment = NSTextAlignmentCenter;
    }
    
//    UIButton *seeHoursButton = [[UIButton alloc]initWithFrame:seeHoursBtnFrame];
//  //  [self setBackgroundImagesForButton:seeHoursButton];
//    [seeHoursButton setTitle:@"see Hours" forState:UIControlStateNormal];
//    seeHoursButton.titleLabel.textAlignment=NSTextAlignmentLeft;
//    
//    [seeHoursButton.titleLabel setFont:msgLabelFont];
//    seeHoursButton.layer.borderWidth = 2;
//    seeHoursButton.layer.borderColor = [[UIColor lightGrayColor]CGColor];
//    seeHoursButton.userInteractionEnabled=YES;
//    [seeHoursButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    
//    seeHoursButton.tag = 1002;
    
    UIButton *cancelButton = [[UIButton alloc]initWithFrame:cancelBtnFrame];
    [self setBackgroundImagesForButton:cancelButton];
    [cancelButton setTitle:cancelBtnMsg forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:btnFonts];
    cancelButton.tag = 1002;

    UIButton *doneButton = [[UIButton alloc]initWithFrame:doneBtnFrame];
    [self setBackgroundImagesForButton:doneButton];
    [doneButton setTitle:doneBtnMsg forState:UIControlStateNormal];
    [doneButton.titleLabel setFont:btnFonts];
    doneButton.tag = 1003;

    
    UIButton *onlyCancelButton = [[UIButton alloc]initWithFrame:onlyCancelBtnFrame];
    [self setBackgroundImagesForButton:onlyCancelButton];
    [onlyCancelButton setTitle:onlyCancelBtnMsg forState:UIControlStateNormal];
    [onlyCancelButton.titleLabel setFont:btnFonts];
    onlyCancelButton.tag = 1001;
    
    if (buttons ==1) {
        [customAlert addSubview:onlyCancelButton];
}else if(buttons == 2){
        [customAlert addSubview:cancelButton];
        [customAlert addSubview:doneButton];
    }
    [headingView addSubview:headingLabel];
    [customAlert addSubview:headingView];
    [customAlert addSubview:headingViewPlaceholder];

    
    [customAlert addSubview:messageLabel];
    [customAlert1 addSubview:customAlert];

    return customAlert1;
}

+(UIView *)customAlert:(NSString *)heading withStr:(NSString *)message withColor:(NSString *)color withFrame:(CGRect)rect withNumberOfButtons:(int)buttons withOnlyCancelBtnMessage:(NSString *)onlyCancelBtnMsg WithCancelBtnMessage:(NSString *)cancelBtnMsg WithDoneBtnMessage:(NSString *)doneBtnMsg withMenuMsg:(NSString *)menuMsg numOfMenus:(float)menusCount numOfColums:(int)colums menuLabelName:(NSMutableArray *)menuTypeArr thumNailPathArr:(NSMutableArray *)thumPathArr fileNameArr:(NSMutableArray *)fileNameArr{
    
    CGRect headingViewPlaceholderFrame;
    CGRect headingViewFrame;
    CGRect headingLabelFrame;
    CGRect messageLabelFrame;
    CGRect customAlertFrame;
    
    UIFont *headingLabelFont;
    UIFont *valuesFont;
    UIFont *msgLabelFont;
    UIFont *btnFonts;
    
    
   // CGRect cancelBtnFrame;
  //  CGRect doneBtnFrame;
    CGRect onlyCancelBtnFrame;
    
    CGRect checkMenuMsgFrame;
    CGRect checkMenuBtnFrame;
    CGRect menuViewFrame;
    CGRect menuImageFrame;
    
    
    
    CGRect menuItemBtnsFrame;
    CGRect menuLabelNameFrame;
    CGRect seeHoursFrame;

    int count =menusCount;

    int width;
    int height;
    int origionX;
    int origionY;
    int xGap;
    int yGap;
    int numOfColumns   = colums;
    

    UIView *customAlert1 = [[UIView alloc]initWithFrame:rect];
    customAlert1.backgroundColor = [UIColor whiteColor];
    customAlert1.layer.cornerRadius = 8;
    
    UIView *customAlert = [[UIView alloc]initWithFrame:CGRectMake(2, 2, customAlert1.frame.size.width-4, customAlert1.frame.size.height-4)];
    customAlert.backgroundColor = [FAUtilities getUIColorObjectFromHexString:@"EFF0F2" alpha:1];
    customAlert.layer.borderColor = [[UIColor grayColor]CGColor];
    customAlert.layer.borderWidth = 2;
    customAlert.layer.cornerRadius = 8;
    UIView *menuView;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        
        headingLabelFont = [UIFont fontWithName:@"Thonburi" size:32];
        valuesFont = [UIFont fontWithName:@"Thonburi" size:28];
        msgLabelFont = [UIFont fontWithName:@"Thonburi" size:22];
        btnFonts = [UIFont fontWithName:@"Verdana" size:30];
        
        CGSize messageSize = [self getHeightFromString:message AndWidth:rect.size.width AndFont:msgLabelFont];
        
        
        
        customAlertFrame = rect;
        headingViewPlaceholderFrame = CGRectMake(0, 0, customAlertFrame.size.width-4, 10);
        headingViewFrame = CGRectMake(0, 8, customAlertFrame.size.width-4, 45);
        headingLabelFrame = CGRectMake(12, 0, headingViewFrame.size.width-24, 45);
        messageLabelFrame = CGRectMake(20, headingViewFrame.origin.y + headingViewFrame.size.height +8, customAlertFrame.size.width-40, messageSize.height+30);
        
        
        if ([menuMsg isEqualToString:@"Yes"]) {
            
            
         //    seeHoursFrame= CGRectMake(messageLabelFrame.origin.x, checkMenuMsgFrame.origin.y+checkMenuMsgFrame.size.height+10, 310, 40);
            
            seeHoursFrame = CGRectMake(messageLabelFrame.origin.x, messageLabelFrame.origin.y+messageLabelFrame.size.height+10, 150, 30);
            
              checkMenuMsgFrame = CGRectMake(messageLabelFrame.origin.x, seeHoursFrame.origin.y+seeHoursFrame.size.height+10, 310, 40);
           
            checkMenuBtnFrame = CGRectMake(checkMenuMsgFrame.origin.x+checkMenuMsgFrame.size.width+4, checkMenuMsgFrame.origin.y+2, 100, 40);
        }else{
            
            checkMenuMsgFrame = CGRectMake(messageLabelFrame.origin.x, messageLabelFrame.origin.y+10, messageLabelFrame.size.width+10, 0);
        }
        
        
        
    //    menuViewFrame=CGRectMake(checkMenuMsgFrame.origin.x+checkMenuMsgFrame.size.height+4, checkMenuMsgFrame.origin.y+checkMenuMsgFrame.size.height, 80, 80);
        
        width    =100;
        height    =100;
        origionX =40;
        origionY = checkMenuMsgFrame.origin.y+checkMenuMsgFrame.size.height;
        xGap     =     10;
        yGap     =     10;
        
        
    }else{
        headingLabelFont = [UIFont fontWithName:@"Thonburi" size:18];
        valuesFont = [UIFont fontWithName:@"Thonburi" size:14];
        msgLabelFont = [UIFont fontWithName:@"Thonburi" size:12];
        btnFonts = [UIFont fontWithName:@"Verdana" size:20];
        
        CGSize messageSize = [self getHeightFromString:message AndWidth:rect.size.width AndFont:msgLabelFont];
        
        
        customAlertFrame = rect;
        
        
        
        headingViewPlaceholderFrame = CGRectMake(0, 0, customAlertFrame.size.width-4, 10);
        headingViewFrame = CGRectMake(0, 8, customAlertFrame.size.width-4, 35);
        headingLabelFrame = CGRectMake(8, 0, headingViewFrame.size.width-16, 35);
        
        messageLabelFrame = CGRectMake(20, headingViewFrame.origin.y + headingViewFrame.size.height +8, customAlertFrame.size.width-40, messageSize.height+20);
        
        
        if ([menuMsg isEqualToString:@"Yes"]) {
            
            seeHoursFrame = CGRectMake(messageLabelFrame.origin.x, messageLabelFrame.origin.y+messageLabelFrame.size.height+10, 80, 15);
            
            checkMenuMsgFrame = CGRectMake(messageLabelFrame.origin.x, seeHoursFrame.origin.y+seeHoursFrame.size.height+10,  messageLabelFrame.size.width-60, 30);
            
            
            
    //    checkMenuMsgFrame = CGRectMake(messageLabelFrame.origin.x, messageLabelFrame.origin.y+messageLabelFrame.size.height+10, messageLabelFrame.size.width-60, 30);
            
        checkMenuBtnFrame = CGRectMake(checkMenuMsgFrame.origin.x+checkMenuMsgFrame.size.width+4, checkMenuMsgFrame.origin.y, 80, 30);

        }else{
            checkMenuMsgFrame = CGRectMake(messageLabelFrame.origin.x, messageLabelFrame.origin.y+10, messageLabelFrame.size.width+10, 0);
        }
        
        width    =50;
        height    =50;
        origionX =20;
        origionY = checkMenuMsgFrame.origin.y+checkMenuMsgFrame.size.height;
        xGap     =     10;
        yGap     =     10;
       
    
    }
    

    
    
    
    UIView *headingViewPlaceholder = [[UIView alloc]initWithFrame:headingViewPlaceholderFrame];
    headingViewPlaceholder.backgroundColor = [FAUtilities getUIColorObjectFromHexString:APP_HEADER_COLOR alpha:1];
    headingViewPlaceholder.layer.cornerRadius = 8;
    
    UIView *headingView = [[UIView alloc]initWithFrame:headingViewFrame];
    headingView.backgroundColor = [FAUtilities getUIColorObjectFromHexString:APP_HEADER_COLOR alpha:1];
    
    UILabel *headingLabel = [[UILabel alloc]initWithFrame:headingLabelFrame];
    headingLabel.textColor = [UIColor whiteColor];
    headingLabel.text = heading;
    headingLabel.font = headingLabelFont;
    headingLabel.textAlignment = NSTextAlignmentCenter;
    
    
    UILabel *messageLabel = [[UILabel alloc]initWithFrame:messageLabelFrame];
    messageLabel.text = message;
    messageLabel.font = msgLabelFont;
    messageLabel.numberOfLines = 0;
    //    messageLabel.layer.borderWidth = 2;
    //    messageLabel.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    messageLabel.textAlignment = NSTextAlignmentLeft;
    
    if ([menuMsg isEqualToString:@"Yes"]) {
        messageLabel.textAlignment = NSTextAlignmentLeft;
       
        [self borderForBottomLayer:messageLabel withHexColor:nil borderWidth:4];

        UILabel *checkMenuMsgLabel = [[UILabel alloc]initWithFrame:checkMenuMsgFrame];
        
        if (count>1) {
            checkMenuMsgLabel.text = @"Please checkout our menu(s)";

        }
        else
        {
        
        checkMenuMsgLabel.text = @"Please checkout our menu";
        }
      //  checkMenuMsgLabel.textAlignment = NSTextAlignmentRight;
        checkMenuMsgLabel.textAlignment = NSTextAlignmentLeft;

        checkMenuMsgLabel.font = msgLabelFont;
      // checkMenuMsgLabel.layer.borderColor=[[UIColor grayColor]CGColor];
       // checkMenuMsgLabel.layer.borderWidth=2;
    
        
        UIButton *seeHoursButton = [[UIButton alloc]initWithFrame:seeHoursFrame];
        //  [self setBackgroundImagesForButton:seeHoursButton];
        [seeHoursButton setTitle:@"See Hours" forState:UIControlStateNormal];
        seeHoursButton.titleLabel.textAlignment=NSTextAlignmentLeft;
        
        [seeHoursButton.titleLabel setFont:msgLabelFont];
        //  seeHoursButton.layer.borderWidth = 2;
        //  seeHoursButton.layer.borderColor = [[UIColor lightGrayColor]CGColor];
        seeHoursButton.userInteractionEnabled=YES;
        [seeHoursButton setTitleColor:[FAUtilities getUIColorObjectFromHexString:APP_HEADER_COLOR alpha:1.0] forState:UIControlStateNormal];
        
        seeHoursButton.tag = 1002;
        
        [customAlert addSubview:seeHoursButton];
        
        
        for (int i=1; i<count+1; i++) {
            
            
            menuViewFrame=CGRectMake(origionX, origionY, width, height);
            menuItemBtnsFrame=CGRectMake(0,0, menuViewFrame.size.width,menuViewFrame.size.height);
            
            if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
                menuImageFrame=CGRectMake(0, 0, menuViewFrame.size.width, menuViewFrame.size.height-40);
                menuLabelNameFrame=CGRectMake(0, menuImageFrame.origin.y+menuImageFrame.size.height, menuViewFrame.size.width, menuViewFrame.size.height-menuImageFrame.size.height);
            }
            else
            {
                menuImageFrame=CGRectMake(0, 0, menuViewFrame.size.width, menuViewFrame.size.height-15);
                menuLabelNameFrame=CGRectMake(0, menuImageFrame.origin.y+menuImageFrame.size.height, menuViewFrame.size.width, menuViewFrame.size.height-menuImageFrame.size.height);
            }
            
            
            origionX = origionX+width+xGap;
            
            if (i%numOfColumns == 0) {
                origionY = origionY+height+yGap;
                if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
                    origionX = 40;
                    
                }
                else{
                    origionX = 20;
                    
                }
            }

            menuView=[[UIView alloc]initWithFrame:menuViewFrame];
          //  menuView.backgroundColor=[UIColor grayColor];
           // menuView.layer.borderColor=[[UIColor blueColor] CGColor];
           // menuView.layer.borderWidth=2.0f;
            menuView.tag=6001;
            
            
            UIButton *MenuBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            
            MenuBtn = [[UIButton alloc]initWithFrame:menuItemBtnsFrame];
            [MenuBtn.titleLabel setFont:msgLabelFont];
            MenuBtn.tag = i;
        //    MenuBtn.layer.borderColor = [[UIColor greenColor]CGColor];
         //   MenuBtn.layer.borderWidth = 2;
            MenuBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            
            
            
            
            UIImageView *menuImage=[[UIImageView alloc]initWithFrame:menuImageFrame];
         //   menuImage.layer.backgroundColor=[[UIColor greenColor]CGColor];
         //   menuImage.layer.borderWidth=2;
        //    menuImage.image=[UIImage imageNamed:@"RBLogo.png"];
            menuImage.contentMode =UIViewContentModeScaleAspectFit;

            
            NSString *thumbNailImgPath = [NSString stringWithFormat:@"%@%@",REQ_URL,[thumPathArr objectAtIndex:i-1]];

            NSString *imageName;
            
            if ([[fileNameArr objectAtIndex:i-1] rangeOfString:@".pdf"].location != NSNotFound) {
                imageName = @"PdfLogo.png";
                menuImage.image = [UIImage imageNamed:imageName];
                
            }
            else{
                
                menuImage.animationImages = [NSArray arrayWithObjects:
                                                     [UIImage imageNamed:@"Loading_1.png"],
                                                     [UIImage imageNamed:@"Loading_2.png"],
                                                     [UIImage imageNamed:@"Loading_3.png"],
                                                     [UIImage imageNamed:@"Loading_4.png"],
                                                     [UIImage imageNamed:@"Loading_5.png"],
                                                     [UIImage imageNamed:@"Loading_6.png"],
                                                     [UIImage imageNamed:@"Loading_7.png"],
                                                     [UIImage imageNamed:@"Loading_8.png"],
                                                     [UIImage imageNamed:@"Loading_9.png"],
                                                     [UIImage imageNamed:@"Loading_10.png"],
                                                     [UIImage imageNamed:@"Loading_11.png"],nil];
                menuImage.animationDuration = 1.0f;
                menuImage.animationRepeatCount = 0;
                [menuImage startAnimating];
                
                
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_async(queue, ^{
                    // the slow stuff to be done in the background
                    
                    NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:thumbNailImgPath]];
                    if (imgData) {
                        UIImage *image = [UIImage imageWithData:imgData];
                        if (image) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                //                                            updateCell = (id)[tableView cellForRowAtIndexPath:indexPath];
                                //                                            if (updateCell){
                                [menuImage stopAnimating];
                                menuImage.image = image;
                                //                                           }
                            });
                        }
                        
                    }
                });
            }
           // menuImage.image=[UIImage imageNamed:]
            
            
            [menuView addSubview:menuImage];
            
            
            
            
            UILabel *menuitemNameLabel=[[UILabel alloc]initWithFrame:menuLabelNameFrame];
            
            
            
            
            menuitemNameLabel.text=[menuTypeArr objectAtIndex:i-1];
            menuitemNameLabel.font=msgLabelFont;
           // menuitemNameLabel.backgroundColor=[UIColor whiteColor];
            menuitemNameLabel.textColor=[UIColor blackColor];
            menuitemNameLabel.textAlignment=NSTextAlignmentCenter;
            menuitemNameLabel.adjustsFontSizeToFitWidth = YES;
            menuitemNameLabel.numberOfLines=0;
            menuitemNameLabel.layer.borderColor=[[UIColor darkGrayColor]CGColor];
           // menuitemNameLabel.layer.borderWidth=2.0f;
            

            
//            CALayer *rightBorder = [CALayer layer];
//            rightBorder.borderColor = [UIColor darkGrayColor].CGColor;
//            rightBorder.borderWidth = 1;
//            rightBorder.frame = CGRectMake(-1, -1, CGRectGetWidth(menuitemNameLabel.frame), CGRectGetHeight(menuitemNameLabel.frame)+2);
//            
//            [menuitemNameLabel.layer addSublayer:rightBorder];
            
            
            [menuView addSubview:menuitemNameLabel];
       
            

            [menuView addSubview:menuImage];
            [menuView addSubview:MenuBtn];
            [customAlert addSubview:menuView];
            
        }
     
        
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
            onlyCancelBtnFrame = CGRectMake(160, menuViewFrame.origin.y + menuViewFrame.size.height +20, 180, 60);

            
//            if (count==0) {
//                
//                [checkMenuMsgLabel removeFromSuperview];
//                checkMenuMsgLabel.text=nil;
//                
//                onlyCancelBtnFrame = CGRectMake(160,  messageLabelFrame.origin.y+messageLabelFrame.size.height+10, 180, 60);
//
//            }
//            else
//            {
//            }
        }
        else{
            onlyCancelBtnFrame = CGRectMake(85, menuViewFrame.origin.y + menuViewFrame.size.height +10, 110, 36);

//            if (count == 0) {
//                [checkMenuMsgLabel removeFromSuperview];
//                checkMenuMsgLabel.text=nil;
//
//                onlyCancelBtnFrame = CGRectMake(85, messageLabelFrame.origin.y+messageLabelFrame.size.height+10, 110, 36);
//
//            }
//            else
//            {
//            }
        }
 
       [customAlert addSubview:checkMenuMsgLabel];

    }
    


    
    
    UIButton *onlyCancelButton = [[UIButton alloc]initWithFrame:onlyCancelBtnFrame];
    [self setBackgroundImagesForButton:onlyCancelButton];
   // onlyCancelButton.layer.backgroundColor=[[UIColor blackColor]CGColor];
  //  onlyCancelButton.layer.borderWidth=2;
    [onlyCancelButton setTitle:onlyCancelBtnMsg forState:UIControlStateNormal];
    [onlyCancelButton.titleLabel setFont:btnFonts];
    onlyCancelButton.tag = 1001;
    
    if (buttons ==1) {
        [customAlert addSubview:onlyCancelButton];
    }else if(buttons == 2){
    //    [customAlert addSubview:cancelButton];
    //    [customAlert addSubview:doneButton];
    }
    [headingView addSubview:headingLabel];
    [customAlert addSubview:headingView];
    [customAlert addSubview:headingViewPlaceholder];
    
    
    [customAlert addSubview:messageLabel];
    [customAlert1 addSubview:customAlert];
    
    return customAlert1;
}

+(void)borderForBottomLayer:(UIView *)view withHexColor:(NSString *)hexColor borderWidth:(int)width{
    CALayer *bottomLayer = [CALayer layer];
    bottomLayer.frame = CGRectMake(0, view.layer.frame.size.height - width, view.layer.frame.size.width, width);
    bottomLayer.backgroundColor = [[FAUtilities getUIColorObjectFromHexString:hexColor alpha:1]CGColor];
    bottomLayer.backgroundColor = [[UIColor colorWithPatternImage:[UIImage imageNamed:@"pgm_dottedLine.png"]] CGColor];
    [view.layer addSublayer:bottomLayer];
}



+(void)borderForTopLineLayer:(UIView *)view withHexColor:(NSString *)hexColor borderWidth:(float)width{
    CALayer *topLayer = [CALayer layer];
    topLayer.frame = CGRectMake(0, 0, view.layer.frame.size.width, width);
    topLayer.backgroundColor = [[FAUtilities getUIColorObjectFromHexString:hexColor alpha:1]CGColor];
    [view.layer addSublayer:topLayer];
}

+(void)borderForBottomLineLayer:(UIView *)view withHexColor:(NSString *)hexColor borderWidth:(float)width{
    CALayer *bottomLayer = [CALayer layer];
    bottomLayer.frame = CGRectMake(0, view.layer.frame.size.height - width, view.layer.frame.size.width, width);
    bottomLayer.backgroundColor = [[FAUtilities getUIColorObjectFromHexString:hexColor alpha:1]CGColor];
    [view.layer addSublayer:bottomLayer];

}


@end
