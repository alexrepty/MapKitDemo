//
//  MAKRViewController.m
//  MapKitDemo
//
//  Created by Alexander Repty on 14.03.14.
//  Copyright (c) 2014 alexrepty. All rights reserved.
//

#import "MAKRViewController.h"

// 3rd Party Frameworks
#import "ARClusteredMapView.h"

// Map Model Layer
#import "MAKRAirportAnnotation.h"

// Views
#import "MAKRAirportAnnotationView.h"

@implementation MAKRViewController

#pragma mark -
#pragma mark UIViewController Methods

- (void)viewDidLoad {
	[super viewDidLoad];
	
	NSArray *airports = [self loadAllAirports];
	[self.mapView addAnnotations:airports];
	
	// Center the map on Europe
	MKMapRect mapRect = {{120172028.1, 69686420.2}, {32729926.7, 47049268.1}};
	[self.mapView setVisibleMapRect:mapRect];
}

#pragma mark -
#pragma mark MAKRViewController Private Methods

- (NSArray *)loadAllAirports {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Airports" ofType:@"plist"];
    NSArray *deserializedDataSets = [NSPropertyListSerialization propertyListFromData:[NSData dataWithContentsOfFile:path]
																	 mutabilityOption:NSPropertyListImmutable
																			   format:NULL
																	 errorDescription:NULL];
    NSMutableArray* result = [NSMutableArray array];
    for (NSDictionary* currentDataSet in deserializedDataSets) {
		NSString *country = [currentDataSet objectForKey:@"Country"];
		
		// For this demo, we're only using airports located in some European countries as this approach to clustering cannot handle very large amount of data.
		if (![country isEqualToString:@"GB"] &&
			![country isEqualToString:@"DE"] &&
			![country isEqualToString:@"FR"]) {
			continue;
		}
		
        CLLocationDegrees latitude = [[currentDataSet objectForKey:@"Latitude"] doubleValue];
        CLLocationDegrees longitude = [[currentDataSet objectForKey:@"Longitude"] doubleValue];
		
		NSString *code = [currentDataSet objectForKey:@"Code"];
		NSString *city = [currentDataSet objectForKey:@"City"];
		NSString *type = [currentDataSet objectForKey:@"Type"];
		
		@try {
			MAKRAirportAnnotation *annotation = [[MAKRAirportAnnotation alloc] initWithCode:code
																					   city:city
																				   latitude:latitude
																				  longitude:longitude
																					   type:type];
			[result addObject:annotation];
		}
		@catch (NSException *exception) {
			// silently dismiss this entry and move on to the next one
			continue;
		}
    }
    return result;
}

#pragma mark -
#pragma mark MKMapViewDelegate Methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
	if (![annotation isKindOfClass:[MAKRAirportAnnotation class]]) {
		return nil;
	}
	
	MKAnnotationView *view = [[MAKRAirportAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:MAKRSingleAirportAnnotationViewReuseIdentifier];
	return view;
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
	[self.mapView updateClustering];
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
	// Make sure that the newly added annotation views are all animated into place from their previous cluster location.
	[self.mapView animateAnnotationViews:views];
}

@end
