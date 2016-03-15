//
//  AppDelegate.h
//  ThinkingCup
//
//  Created by Manulogix on 01/09/14.
//  Copyright (c) 2014 Manulogix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

//#import "CustomIOS7AlertView.h"

@interface FAUtilities : NSObject<MFMailComposeViewControllerDelegate>

@property UIAlertView *alterWithCancelBtn;

+ (void)setBorderWithColor:(UIColor *)color toView:(UIView *)view  withRadius:(CGFloat)radius;
+ (UIBarButtonItem *)customButtonWithTitle:(NSString*)title style:(UIButtonType)buttonStyle target:(id)target action:(SEL)sel width:(CGFloat)width;
+ (UIBarButtonItem *)customBackButtonWithtarget:(id)target action:(SEL)sel width:(CGFloat)width;
+ (UIBarButtonItem *)customBackButtonWithtarget:(id)target action:(SEL)sel width:(CGFloat)width title:(NSString *)title;
+ (UIBarButtonItem *)customInfoButtonWithtarget:(id)target action:(SEL)sel width:(CGFloat)width;

+ (UIBarButtonItem *)customButtonWithImage:(NSString*)bgImage target:(id)target action:(SEL)sel width:(CGFloat)width;
+ (CGFloat)getFreeDiskspace;
+ (CGFloat)getTotalDiskspace;
+ (CGFloat)getAppUsageSpace;
+ (CGFloat)convertBytesToMB:(CGFloat)bytes;
+ (NSData*)getImageDataFromView:(UIView*)view;



+ (UIColor *)getUIColorObjectFromHexString:(NSString *)hexStr alpha:(CGFloat)alpha;
+ (unsigned int)intFromHexString:(NSString *)hexStr;

+(BOOL) offlineCheck;

+(void)showToastMessageAlert:(NSString*)message;
+(void)dismiss:(UIAlertView*)alertView;

+(void)showAlert:(NSString*)msg;
+(void)dismissAlert:(NSString*)msg;

+(void)showAlertMessage:(NSString*)msg;

+(NSString *)base64StringFromData:(NSData *)data length:(int)length;
+(NSData *)base64DataFromString:(NSString *)string;

+ (void)addSkipBackupAttributeToPath:(NSString*)path;

+(UIView *)loadCustomServiceAlertView:(UIView *)parentView Message:(NSString *)alertMsg;


+(CGSize)getHeightFromString:(NSString *)string AndWidth:(float)width AndFont:(UIFont *)font;
+(NSString *)formatJSONStr:(NSString *)string;
+(void)showAlert:(NSString*)msg withHeading:(NSString *)heading;

+(UIView *)customAlert:(NSString *)heading withStr:(NSString *)message withColor:(NSString *)color withFrame:(CGRect)rect withNumberOfButtons:(int)buttons withOnlyCancelBtnMessage:(NSString *)onlyCancelBtnMsg WithCancelBtnMessage:(NSString *)cancelBtnMsg WithDoneBtnMessage:(NSString *)doneBtnMsg;

+(UIView *)customAlert:(NSString *)heading withStr:(NSString *)message withColor:(NSString *)color withFrame:(CGRect)rect withNumberOfButtons:(int)buttons withOnlyCancelBtnMessage:(NSString *)onlyCancelBtnMsg WithCancelBtnMessage:(NSString *)cancelBtnMsg WithDoneBtnMessage:(NSString *)doneBtnMsg withMenuMsg:(NSString *)menuMsg numOfMenus:(float)menusCount numOfColums:(int)colums menuLabelName:(NSMutableArray *)menuTypeArr thumNailPathArr:(NSMutableArray *)thumPathArr fileNameArr:(NSMutableArray *)fileNameArr;

//+(UIView *)customAlertCancel:(UIView *)customAlertView;

+(void)setBackgroundImagesForButton:(UIButton *)button;

+(void)borderForBottomLayer:(UIView *)view withHexColor:(NSString *)hexColor borderWidth:(int)width;

+(void)borderForTopLineLayer:(UIView *)view withHexColor:(NSString *)hexColor borderWidth:(float)width;
+(void)borderForBottomLineLayer:(UIView *)view withHexColor:(NSString *)hexColor borderWidth:(float)width;

@end
