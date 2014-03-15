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

@interface MAKRViewController ()

@property(nonatomic, strong) UIView *selectedView;

@end

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

- (void)deselectSelectedView {
	[UIView animateWithDuration:0.25
					 animations:^() {
						 self.selectedView.layer.zPosition = 1.0;
						 self.selectedView.transform = CGAffineTransformIdentity;
					 }];
}

#pragma mark -
#pragma mark MAKRViewController Interface Actions

- (IBAction)showRouteToSelectedAirport:(id)sender {
	[self deselectSelectedView];
	
	MAKRAirportAnnotation *selectedAnnotation = self.mapView.selectedAnnotations.firstObject;
	if (![selectedAnnotation isKindOfClass:[MAKRAirportAnnotation class]]) {
		return;
	}
	
	NSString *latitude = [[NSString stringWithFormat:@"%@", @(selectedAnnotation.coordinate.latitude)] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString *longitude = [[NSString stringWithFormat:@"%@", @(selectedAnnotation.coordinate.longitude)] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString *routingURLString = [NSString stringWithFormat:@"http://maps.apple.com/?daddr=%@,%@", latitude, longitude];
	NSURL *routingURL = [NSURL URLWithString:routingURLString];
	
	[[UIApplication sharedApplication] openURL:routingURL];
}

- (IBAction)focusOnSelectedAirportCluster:(id)sender {
	[self deselectSelectedView];
	
	MAKRAirportAnnotation *selectedAnnotation = self.mapView.selectedAnnotations.firstObject;
	if (![selectedAnnotation isKindOfClass:[MAKRAirportAnnotation class]]) {
		return;
	}
	
	MKMapPoint selectedAnnotationMapPoint = MKMapPointForCoordinate(selectedAnnotation.coordinate);
	MKMapRect mapRect = MKMapRectMake(selectedAnnotationMapPoint.x, selectedAnnotationMapPoint.y, 32.0, 32.0);
	
	for (MAKRAirportAnnotation *subAnnotation in selectedAnnotation.containedAnnotations) {
		MKMapPoint subAnnotationMapPoint = MKMapPointForCoordinate(subAnnotation.coordinate);
		MKMapRect subAnnotationMapRect = MKMapRectMake(subAnnotationMapPoint.x, subAnnotationMapPoint.y, 32.0, 32.0);
		
		mapRect = MKMapRectUnion(mapRect, subAnnotationMapRect);
	}
	
	mapRect = [self.mapView mapRectThatFits:mapRect edgePadding:UIEdgeInsetsMake(16.0, 16.0, 16.0, 16.0)];
	[self.mapView setVisibleMapRect:mapRect animated:YES];
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

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
	if (![view isKindOfClass:[MAKRAirportAnnotationView class]]) {
		return;
	}
	
	MAKRAirportAnnotationView *annotationView = (id)view;
	MAKRAirportAnnotation *annotation = annotationView.airportAnnotation;
	
	NSMutableArray *toolbarIcons = [NSMutableArray array];
	UIBarButtonItem *flexibleSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
	
	if (annotation.containedAnnotations.count == 0) {
		[toolbarIcons addObject:flexibleSpaceItem];
		[toolbarIcons addObject:[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Route", nil) style:UIBarButtonItemStylePlain target:self action:@selector(showRouteToSelectedAirport:)]];
		[toolbarIcons addObject:flexibleSpaceItem];
	} else {
		[toolbarIcons addObject:flexibleSpaceItem];
		[toolbarIcons addObject:[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Focus", nil) style:UIBarButtonItemStylePlain target:self action:@selector(focusOnSelectedAirportCluster:)]];
		[toolbarIcons addObject:flexibleSpaceItem];
	}
	
	[self.toolbar setItems:toolbarIcons animated:YES];

	[self deselectSelectedView];
	[UIView animateWithDuration:0.25
						  delay:0.01
						options:0
					 animations:^() {
						 view.layer.zPosition = DBL_MAX;
						 view.transform = CGAffineTransformMakeScale(1.5, 1.5);
					 }
					 completion:^(BOOL finished) {
						 self.selectedView = view;
					 }];
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
	[self.toolbar setItems:@[] animated:YES];
	[self deselectSelectedView];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
	[self.mapView updateClustering];
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
	// Make sure that the newly added annotation views are all animated into place from their previous cluster location.
	[self.mapView animateAnnotationViews:views];
}

@end
