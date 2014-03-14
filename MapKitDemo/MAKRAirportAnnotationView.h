//
//  MAKRSingleAirportAnnotationView.h
//  MapKitDemo
//
//  Created by Alexander Repty on 14.03.14.
//  Copyright (c) 2014 alexrepty. All rights reserved.
//

#import <MapKit/MapKit.h>

@class MAKRAirportAnnotation;

extern NSString *const MAKRSingleAirportAnnotationViewReuseIdentifier;

@interface MAKRAirportAnnotationView : MKAnnotationView

/*!
 @property airportAnnotation
 @abstract A reference to the airport annotation for this view.
 */
@property(strong, nonatomic) MAKRAirportAnnotation *airportAnnotation;

@end
