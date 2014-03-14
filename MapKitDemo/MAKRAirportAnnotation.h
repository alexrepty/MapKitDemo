//
//  MAKRAirportAnnotation.h
//  MapKitDemo
//
//  Created by Alexander Repty on 14.03.14.
//  Copyright (c) 2014 alexrepty. All rights reserved.
//

#import "ARClusteredAnnotation.h"

extern NSString *const MAKRAirportAnnotationIconSmallAirport;
extern NSString *const MAKRAirportAnnotationIconHeliport;
extern NSString *const MAKRAirportAnnotationIconBigAirport;
extern NSString *const MAKRAirportAnnotationIconSeaplaneBase;
extern NSString *const MAKRAirportAnnotationIconClosed;

@interface MAKRAirportAnnotation : ARClusteredAnnotation

/*!
 @property city
 @abstract The name of the city where this airport is located.
 */
@property(copy, nonatomic) NSString *city;

/*!
 @property code
 @abstract The code for this airport.
 */
@property(copy, nonatomic) NSString *code;

/*!
 @property icon
 @abstract The icon for this kind of airport.
 */
@property(strong, nonatomic) UIImage *icon;

/*!
 @property type
 @abstract An NSString containing the type of this airport.
 */
@property(copy, nonatomic) NSString *type;

/*!
 *  Designated initializer. Creates a new MAKRAirportAnnotation object configured with the given parameters.
 *
 *  @param code      Code for the airport.
 *  @param city      City the airport is located in.
 *  @param latitude  Geographical latitude.
 *  @param longitude Geographical longitude.
 *  @param type      The type of the airport (see MAKRAirportAnnotationIcon* constants).
 *
 *  @return A newly configured MAKRAirportAnnotation object with the supplied values.
 */
- (id)initWithCode:(NSString *)code city:(NSString *)city latitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude type:(NSString *)type;

/*!
 *  Determines whether this annotation either is of a given type or contains a given type.
 *
 *  @param type Any given airport type (see MAKRAirportAnnotationIcon* constants).
 *
 *  @return YES if this annotation is of the given type or contains an annotation of the given type.
 */
- (BOOL)hasContainedAnnotationsOfType:(NSString *)type;

@end
