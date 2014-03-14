//
//  MAKRAirportAnnotation.m
//  MapKitDemo
//
//  Created by Alexander Repty on 14.03.14.
//  Copyright (c) 2014 alexrepty. All rights reserved.
//

#import "MAKRAirportAnnotation.h"

static NSDictionary *_airportAnnotationIcons = nil;

NSString *const MAKRAirportAnnotationIconSmallAirport = @"small_airport";
NSString *const MAKRAirportAnnotationIconHeliport = @"heliport";
NSString *const MAKRAirportAnnotationIconBigAirport = @"big_airport";
NSString *const MAKRAirportAnnotationIconSeaplaneBase = @"seaplane_base";
NSString *const MAKRAirportAnnotationIconClosed = @"closed";

@implementation MAKRAirportAnnotation

#pragma mark -
#pragma mark MAKRAirportAnnotation Construction & Destruction Methods

- (id)initWithCode:(NSString *)code city:(NSString *)city latitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude type:(NSString *)type {
	NSParameterAssert(code);
	NSParameterAssert(city);
	NSParameterAssert(type);
	
    if ((self = [super init])) {
		self.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        
        self.code = code;
        self.city = city;
        
		self.type = type;
        self.icon = [_airportAnnotationIcons objectForKey:self.type];
        if (!self.icon) {
			self.type = MAKRAirportAnnotationIconBigAirport;
			self.icon = [_airportAnnotationIcons objectForKey:MAKRAirportAnnotationIconBigAirport];
		}
    }
    return self;
}

#pragma mark -
#pragma mark MAKRAirportAnnotation Public Methods

- (BOOL)hasContainedAnnotationsOfType:(NSString *)type {
	if ([type isEqualToString:self.type]) {
		return YES;
	}
	
	BOOL hasType = NO;
	
	for (MAKRAirportAnnotation *subAnnotation in self.containedAnnotations) {
		hasType = [subAnnotation hasContainedAnnotationsOfType:type];
		if (hasType) {
			return hasType;
		}
	}
	
	return hasType;
}

#pragma mark -
#pragma mark MAKRAirportAnnotation Class Methods

+ (void)initialize {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_airportAnnotationIcons = [[NSDictionary alloc] initWithObjectsAndKeys:
								   [UIImage imageNamed:@"small_airport"], MAKRAirportAnnotationIconSmallAirport,
								   [UIImage imageNamed:@"heliport.png"], MAKRAirportAnnotationIconHeliport,
								   [UIImage imageNamed:@"big_airport.png"], MAKRAirportAnnotationIconBigAirport,
								   [UIImage imageNamed:@"seaplane_base.png"], MAKRAirportAnnotationIconSeaplaneBase,
								   [UIImage imageNamed:@"closed.png"], MAKRAirportAnnotationIconClosed,
								   nil];
	});
}

@end
