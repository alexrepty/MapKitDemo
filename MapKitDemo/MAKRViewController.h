//
//  MAKRViewController.h
//  MapKitDemo
//
//  Created by Alexander Repty on 14.03.14.
//  Copyright (c) 2014 alexrepty. All rights reserved.
//

@import UIKit;
@import MapKit;

@class ARClusteredMapView;

@interface MAKRViewController : UIViewController <MKMapViewDelegate>

/*!
 @property mapView
 @abstract The ARClusteredMapView instance where all the magic happens.
 */
@property(strong, nonatomic) IBOutlet ARClusteredMapView *mapView;

/*!
 @property toolbar
 @abstract A toolbar that contains buttons for actions relating to the current state of the map view.
 */
@property(strong, nonatomic) IBOutlet UIToolbar *toolbar;

@end
