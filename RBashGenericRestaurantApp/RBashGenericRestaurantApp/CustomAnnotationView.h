//
//  CustomAnnotationView.h
//  RBashGenericRestaurantApp
//
//  Created by Ramesh on 4/18/15.
//  Copyright (c) 2015 Manulogix. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface CustomAnnotationView : MKAnnotationView
{
    
}
@property (strong, nonatomic) UIView *calloutView;

-(void)setSelected:(BOOL)selected animated:(BOOL)animated;



@end
