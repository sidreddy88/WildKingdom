//
//  MapViewController.m
//  WildKingdomActualGame
//
//  Created by Siddharth Sukumar on 1/25/14.
//  Copyright (c) 2014 Josef Hilbert. All rights reserved.
//

#import "MapViewController.h"
#import "OtherArtworkViewController.h"

@interface MapViewController () <MKMapViewDelegate>
{
    
    IBOutlet MKMapView *mapView;
}

@end

@implementation MapViewController

@synthesize latitude, longitude;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    MKPointAnnotation* annotation = [MKPointAnnotation new];
    annotation.title = @"Mobile Makers";
    annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    [mapView addAnnotation:annotation];
    
    
    MKCoordinateSpan span = MKCoordinateSpanMake(5.0, 5.0);
    MKCoordinateRegion region = MKCoordinateRegionMake( CLLocationCoordinate2DMake(latitude, longitude), span);
    [mapView setRegion:region animated:YES];
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id<MKAnnotation>)annotation {
    MKAnnotationView *annotationView = [mV dequeueReusableAnnotationViewWithIdentifier:@"Don Bora"];
    
    if (annotationView == nil){
        annotationView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"Don Bora"];
        
    } else {
        annotationView.annotation = annotation;
        
    }
    annotationView.canShowCallout = YES;
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return annotationView;

}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
        
        
        OtherArtworkViewController *vc = segue.destinationViewController;
        
    
    vc.stringWithTheUserID = self.stringWhichHoldsTheUserID;
    
    }

    
    
    




@end
