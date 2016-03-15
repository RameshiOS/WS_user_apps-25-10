//
//  MultiRowCalloutCell.m
//  Created by Greg Combs on 11/29/11.
//
//  based on work at https://github.com/grgcombs/MultiRowCalloutAnnotationView
//
//  This work is licensed under the Creative Commons Attribution 3.0 Unported License. 
//  To view a copy of this license, visit http://creativecommons.org/licenses/by/3.0/
//  or send a letter to Creative Commons, 444 Castro Street, Suite 900, Mountain View, California, 94041, USA.
//
//

#import "MultiRowCalloutCell.h"
#import <QuartzCore/QuartzCore.h>
#import "FAUtilities.h"
CGSize const kMultiRowCalloutCellSize = {265,44};

@interface MultiRowCalloutCell()
- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title subtitle:(NSString *)subtitle userData:(NSDictionary *)userData onCalloutAccessoryTapped:(MultiRowAccessoryTappedBlock)block;
- (IBAction)calloutAccessoryTapped:(id)sender;
@end

@implementation MultiRowCalloutCell

+ (instancetype)cellWithImage:(UIImage *)image title:(NSString *)title subtitle:(NSString *)subtitle userData:(NSDictionary *)userData onCalloutAccessoryTapped:(MultiRowAccessoryTappedBlock)block
{
    return [[MultiRowCalloutCell alloc] initWithImage:image title:title subtitle:subtitle userData:userData onCalloutAccessoryTapped:block];
}

+ (instancetype)cellWithImage:(UIImage *)image title:(NSString *)title subtitle:(NSString *)subtitle userData:(NSDictionary *)userData
{
    return [MultiRowCalloutCell cellWithImage:image title:title subtitle:subtitle userData:userData onCalloutAccessoryTapped:nil];
}

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title subtitle:(NSString *)subtitle userData:(NSDictionary *)userData onCalloutAccessoryTapped:(MultiRowAccessoryTappedBlock)block {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    if (self)
    {
        _onCalloutAccessoryTapped = block;
        _userData = userData;
        self.title = title;
        self.subtitle = subtitle;
        self.image = image;
        self.opaque = YES;
      //  self.backgroundColor = [UIColor colorWithRed:116/255.f green:174/255.f blue:165/255.f alpha:1];
          self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIButton *accessory = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        
        
    //    UIButton*accessory = [UIButton buttonWithType:UIButtonTypeSystem];
        [accessory setImage:[UIImage imageNamed:@"rightArrowBtn.png"] forState:UIControlStateNormal];
      //  [accessory setTintColor:[UIColor redColor]];
        accessory.tintColor = [FAUtilities getUIColorObjectFromHexString:APP_HEADER_COLOR alpha:1];
      //  [accessory setTitle:annotation.title forState:UIControlStateNormal];
        accessory.userInteractionEnabled=YES;
      //  accessory.layer.borderColor=[[UIColor blackColor]CGColor];
      //  accessory.layer.borderWidth=1.0f;
       //accessory.exclusiveTouch = YES;
        accessory.enabled = YES;
        [accessory addTarget: self action:@selector(calloutAccessoryTapped:) forControlEvents: UIControlEventTouchUpInside];
        self.accessoryView = accessory;
        self.textLabel.backgroundColor = self.backgroundColor;
        self.textLabel.textColor = [UIColor colorWithRed:70/255.f green:69/255.f blue:68/255.f alpha:1];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            self.textLabel.font = [UIFont boldSystemFontOfSize:16];
            [   self.textLabel setMinimumScaleFactor:14.0/[UIFont labelFontSize]];
            self.detailTextLabel.font =	[UIFont boldSystemFontOfSize:16];

        }
        else
        {
            self.textLabel.font = [UIFont boldSystemFontOfSize:12];
            [   self.textLabel setMinimumScaleFactor:10.0/[UIFont labelFontSize]];
            self.detailTextLabel.font =	[UIFont boldSystemFontOfSize:12];
}
        

        
        
        self.textLabel.shadowColor = [UIColor lightTextColor];
        self.textLabel.shadowOffset = CGSizeMake(0, 1);
        self.textLabel.adjustsFontSizeToFitWidth = YES;
        self.detailTextLabel.textColor = [UIColor darkGrayColor];
       // self.detailTextLabel.font =	[UIFont boldSystemFontOfSize:10];
        self.detailTextLabel.adjustsFontSizeToFitWidth = YES;
        self.detailTextLabel.backgroundColor = self.backgroundColor;
     //   self.detailTextLabel.shadowColor = [UIColor darkTextColor];
      //  self.detailTextLabel.shadowOffset = CGSizeMake(0, -1);
       // self.layer.cornerRadius = 5;
    }
    return self;
}

- (IBAction)calloutAccessoryTapped:(id)sender
{
    if (_onCalloutAccessoryTapped)
    {
        _onCalloutAccessoryTapped(self, sender, _userData);
    }
}

#pragma mark - Convenience Accessors

- (UIImage *)image
{
    return self.imageView.image;
}

- (void)setImage:(UIImage *)image
{
    self.imageView.image = image;
}

- (NSString *)title
{
    return self.textLabel.text;
}

- (void)setTitle:(NSString *)title
{
    self.textLabel.text = title;
}

- (NSString *)subtitle
{
    return self.detailTextLabel.text;
}

- (void)setSubtitle:(NSString *)subtitle
{
    self.detailTextLabel.text = subtitle;
}

@end

