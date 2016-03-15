//
//  CustomAnnotationView.m
//  RBashGenericRestaurantApp
//
//  Created by Ramesh on 4/18/15.
//  Copyright (c) 2015 Manulogix. All rights reserved.
//

#import "CustomAnnotationView.h"

@implementation CustomAnnotationView
@synthesize calloutView;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];

    if(selected){
        [self.calloutView setFrame:CGRectMake(30, 130, 250, 135)];
        [self.calloutView sizeToFit];
        self.calloutView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"popup.png"]];
        [self addSubview:self.calloutView];
        
    }else{
        [self.calloutView removeFromSuperview];
    }
}

-(void)didAddSubview:(UIView *)subview{
    
    if([[[subview class]description]isEqualToString:@"UICalloutView"]){
        [subview removeFromSuperview];
    }
}

@end
