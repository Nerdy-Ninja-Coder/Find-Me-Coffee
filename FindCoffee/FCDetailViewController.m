//
//  DetailViewController.m
//  FindCoffee
//
//  Created by Amy Wold on 4/24/15.
//  Copyright (c) 2015 Amy Wold. All rights reserved.
//

#import "FCDetailViewController.h"
#import "Venue.h"
@import MapKit;

#define METERS_PER_MILE 1609.344

@interface FCDetailViewController ()<MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation FCDetailViewController

#pragma mark - Managing the details

- (void)setDetailItem:(id)newDetailItem setDetailLat:(NSNumber*)newDetailLat setDetailLong:(NSNumber *) newDetailLong {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        if (_detailLat != newDetailLat) {
            _detailLat = newDetailLat;
        }
        
        if (_detailLong != newDetailLong) {
            _detailLong = newDetailLong;
        }
            
        // Update the view.
        [self configureView];
    }
}


- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        
        // set up mapView
        self.mapView.mapType = MKMapTypeHybrid;
        [self.mapView setShowsUserLocation:YES];

        // set zoom
        CLLocationCoordinate2D zoomLocation;
        zoomLocation.latitude = (CLLocationDegrees)[_detailLat doubleValue];
        zoomLocation.longitude= (CLLocationDegrees)[_detailLong doubleValue];
        
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5 * METERS_PER_MILE, 0.5 * METERS_PER_MILE);
        
        [_mapView setRegion:viewRegion animated:YES];
        
        // set point
        MKPointAnnotation *myAnnotation = [[MKPointAnnotation alloc]init];
        // make the coordinate the coffee shop! ***
        myAnnotation.coordinate = CLLocationCoordinate2DMake(zoomLocation.latitude, zoomLocation.longitude  );
        myAnnotation.title = self.detailItem;
        
        [self.mapView addAnnotation:myAnnotation];
        
        // set description label
        self.detailDescriptionLabel.text = [self.detailItem description];

    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Managing the delegates

- (id<MKAnnotation>)addAnnotationWithTitle:(NSString *)title coordinate:(CLLocationCoordinate2D)coordinate imageName:(NSString *)imageName {
    
    CLLocationCoordinate2D annLocation;
    annLocation.latitude = (CLLocationDegrees)[_detailLat doubleValue];
    annLocation.longitude= (CLLocationDegrees)[_detailLong doubleValue];
    MKPointAnnotation *myAnnotation = [[MKPointAnnotation alloc]init];
    myAnnotation.coordinate = CLLocationCoordinate2DMake(annLocation.latitude, annLocation.longitude  );
    myAnnotation.title = self.detailItem;
    
    [self.mapView addAnnotation:myAnnotation];
    return myAnnotation;
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    //if annotation is the user location, return nil to get default blue-dot...
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    //create purple pin view for all other annotations...
    static NSString *reuseId = @"hello";
    
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseId];
    if (pinView == nil)
    {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseId];
        pinView.pinColor = MKPinAnnotationColorGreen;
        pinView.canShowCallout = YES;
        
        UIImageView *coffeeIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"coffee.png"]];
        [coffeeIconView setFrame:CGRectMake(0, 0, 30, 30)];

        pinView.leftCalloutAccessoryView = coffeeIconView;
    }
    else
    {
        //if re-using view from another annotation, point view to current annotation...
        pinView.annotation = annotation;
    }
    
    return pinView;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    id <MKAnnotation> annotation = [view annotation];
    if ([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        NSLog(@"Clicked Coffee Shop Details");
    }
    [self.detailItem description];
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Disclosure Pressed" message:@"Click Cancel to Go Back" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
//    [alertView show];
}

@end
