//
//  MAKRSingleAirportAnnotationView.m
//  MapKitDemo
//
//  Created by Alexander Repty on 14.03.14.
//  Copyright (c) 2014 alexrepty. All rights reserved.
//

#import "MAKRAirportAnnotationView.h"

// Map Model Layer
#import "MAKRAirportAnnotation.h"

NSString *const MAKRSingleAirportAnnotationViewReuseIdentifier = @"MAKRSingleAirportAnnotationViewReuseIdentifier";

static void *MAKRAirportAnnotationViewContainedAnnotationChangeContext = (void *)0xcafebabe;

@implementation MAKRAirportAnnotationView

#pragma mark -
#pragma mark MAKRSingleAirportAnnotationView Construction & Destruction Methods

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
	if (self) {
		self.backgroundColor = [UIColor clearColor];
		[self sizeToFit];
		
		self.airportAnnotation = annotation;
		
		[self.airportAnnotation addObserver:self forKeyPath:NSStringFromSelector(@selector(containedAnnotations)) options:0 context:MAKRAirportAnnotationViewContainedAnnotationChangeContext];
	}
	return self;
}

#pragma mark -
#pragma mark MAKRSingleAirportAnnotationView KVO Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if (context == MAKRAirportAnnotationViewContainedAnnotationChangeContext) {
		[self setNeedsDisplay];
	}
}

#pragma mark -
#pragma mark MKAnnotationView Methods

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	// Do not forward to super since we don't want the system-provided callout to be shown.
}

#pragma mark -
#pragma mark UIView Methods

- (void)drawRect:(CGRect)rect {
	if (self.airportAnnotation.containedAnnotations.count == 0) {
		//// General Declarations
		CGContextRef context = UIGraphicsGetCurrentContext();
		
		//// Image Declarations
		UIImage* big_airport = self.airportAnnotation.icon;
		UIColor* big_airportPattern = [UIColor colorWithPatternImage: big_airport];
		
		//// Abstracted Attributes
		NSString* titleContent = self.airportAnnotation.code;
		
		//// Rounded Rectangle Drawing
		UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0.5, 0.5, 31, 31) cornerRadius: 4];
		[[UIColor whiteColor] setFill];
		[roundedRectanglePath fill];
		[[UIColor blackColor] setStroke];
		roundedRectanglePath.lineWidth = 1;
		[roundedRectanglePath stroke];
		
		//// big_airport 2 Drawing
		UIBezierPath* big_airport2Path = [UIBezierPath bezierPathWithRect: CGRectMake(5, 1, 22, 22)];
		CGContextSaveGState(context);
		CGContextSetPatternPhase(context, CGSizeMake(5, 1));
		[big_airportPattern setFill];
		[big_airport2Path fill];
		CGContextRestoreGState(context);
		
		//// Title Drawing
		CGRect titleRect = CGRectMake(4, 22, 24, 11);
		NSMutableParagraphStyle* titleStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
		[titleStyle setAlignment: NSTextAlignmentCenter];
		
		NSDictionary* titleFontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"Helvetica-Bold" size: 7.5], NSForegroundColorAttributeName: [UIColor blackColor], NSParagraphStyleAttributeName: titleStyle};
		
		[titleContent drawInRect: titleRect withAttributes: titleFontAttributes];
	} else {
		//// General Declarations
		CGContextRef context = UIGraphicsGetCurrentContext();
		
		//// Image Declarations
		UIImage* small_airport = [UIImage imageNamed: @"x_small_airport"];
		UIImage* big_airport = [UIImage imageNamed: @"x_big_airport"];
		UIImage* heliport = [UIImage imageNamed: @"x_heliport"];
		UIImage* seaplane_base = [UIImage imageNamed: @"x_seaplane_base"];
		
		//// Abstracted Attributes
		NSString* titleContent = [NSString stringWithFormat:@"%@", @(self.airportAnnotation.containedAnnotations.count + 1)];
		
		//// Rounded Rectangle Drawing
		UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0.5, 0.5, 31, 31) cornerRadius: 4];
		
		CGFloat greenBluePart = 1.0;
//		CGFloat minGreenBluePart = 0.25;
//		CGFloat greenBlueReduction = (self.airportAnnotation.containedAnnotations.count + 1) * 0.01;
//		greenBluePart -= greenBlueReduction;
//		if (greenBluePart < minGreenBluePart) {
//			greenBluePart = minGreenBluePart;
//		}
		UIColor *fillColor = [UIColor colorWithRed:1.0 green:greenBluePart blue:greenBluePart alpha:1.0];
		[fillColor setFill];
		[roundedRectanglePath fill];

		[[UIColor blackColor] setStroke];
		roundedRectanglePath.lineWidth = 1;
		[roundedRectanglePath stroke];
		
		//// Title Drawing
		CGRect titleRect = CGRectMake(4, 1, 24, 11);
		NSMutableParagraphStyle* titleStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
		[titleStyle setAlignment: NSTextAlignmentCenter];
		
		NSDictionary* titleFontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"Helvetica-Bold" size: 7.5], NSForegroundColorAttributeName: [UIColor blackColor], NSParagraphStyleAttributeName: titleStyle};
		
		[titleContent drawInRect: titleRect withAttributes: titleFontAttributes];
		
		//// big_airport 2 Drawing
		UIBezierPath* big_airport2Path = [UIBezierPath bezierPathWithRect: CGRectMake(5, 12, 8, 8)];
		CGContextSaveGState(context);
		[big_airport2Path addClip];
		[small_airport drawInRect: CGRectMake(5, 12, small_airport.size.width, small_airport.size.height) blendMode:kCGBlendModeNormal alpha:[self.airportAnnotation hasContainedAnnotationsOfType:MAKRAirportAnnotationIconSmallAirport] ? 1.0 : 0.33];
		CGContextRestoreGState(context);
		
		//// big_airport 3 Drawing
		UIBezierPath* big_airport3Path = [UIBezierPath bezierPathWithRect: CGRectMake(19, 12, 8, 8)];
		CGContextSaveGState(context);
		[big_airport3Path addClip];
		[big_airport drawInRect: CGRectMake(19, 12, big_airport.size.width, big_airport.size.height) blendMode:kCGBlendModeNormal alpha:[self.airportAnnotation hasContainedAnnotationsOfType:MAKRAirportAnnotationIconBigAirport] ? 1.0 : 0.33];
		CGContextRestoreGState(context);
		
		//// big_airport 4 Drawing
		UIBezierPath* big_airport4Path = [UIBezierPath bezierPathWithRect: CGRectMake(5, 22, 8, 8)];
		CGContextSaveGState(context);
		[big_airport4Path addClip];
		[heliport drawInRect: CGRectMake(5, 22, heliport.size.width, heliport.size.height) blendMode:kCGBlendModeNormal alpha:[self.airportAnnotation hasContainedAnnotationsOfType:MAKRAirportAnnotationIconHeliport] ? 1.0 : 0.33];
		CGContextRestoreGState(context);
		
		//// big_airport 5 Drawing
		UIBezierPath* big_airport5Path = [UIBezierPath bezierPathWithRect: CGRectMake(19, 22, 8, 8)];
		CGContextSaveGState(context);
		[big_airport5Path addClip];
		[seaplane_base drawInRect: CGRectMake(19, 22, seaplane_base.size.width, seaplane_base.size.height) blendMode:kCGBlendModeNormal alpha:[self.airportAnnotation hasContainedAnnotationsOfType:MAKRAirportAnnotationIconSeaplaneBase] ? 1.0 : 0.33];
		CGContextRestoreGState(context);
	}
}

- (void)sizeToFit {
	self.bounds = ({
		CGRect bounds = self.bounds;
		bounds.size = CGSizeMake(32.0, 32.0);
		bounds;
	});
}

@end
