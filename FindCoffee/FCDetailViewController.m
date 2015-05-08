//
//  FCDetailViewController.m
//  FindCoffee
//
//  Created by Amy Wold on 4/24/15.
//  Copyright (c) 2015 Amy Wold. All rights reserved.
//

#import "FCDetailViewController.h"
#import "Venue.h"
#import "MyAnnotationView.h"
@import MapKit;

#define METERS_PER_MILE 1609.344

@interface FCDetailViewController ()<MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation FCDetailViewController

#pragma mark - Managing the detail item

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
        // disable user interaction
        self.mapView.zoomEnabled = NO;
//        self.mapView.scrollEnabled = NO;
//        self.mapView.userInteractionEnabled = NO;

        // set coffee shop location
        CLLocationCoordinate2D zoomLocation;
        zoomLocation.latitude = (CLLocationDegrees)[_detailLat doubleValue];
        zoomLocation.longitude= (CLLocationDegrees)[_detailLong doubleValue];
        
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5 * METERS_PER_MILE, 0.5 * METERS_PER_MILE);
        
        [_mapView setRegion:viewRegion animated:YES];
        
        // set point
        MKPointAnnotation *myAnnotation = [[MKPointAnnotation alloc]init];
        // make the coordinate the coffee shop
        myAnnotation.coordinate = CLLocationCoordinate2DMake(zoomLocation.latitude, zoomLocation.longitude  );
        myAnnotation.title = self.detailItem;
        
        [self.mapView addAnnotation:myAnnotation];
        
        // set description label
        self.detailDescriptionLabel.text = [self.detailItem description];
        [self.detailDescriptionLabel setFont:[UIFont fontWithName:[NSString stringWithUTF8String:"HelveticaNeue-Bold"] size:30]];
        self.detailDescriptionLabel.textColor = [UIColor colorWithRed:90.0f/255.0f green:55.0/255.0f blue:22.0f/255.0f alpha:1.0f];
        self.detailDescriptionLabel.backgroundColor = [UIColor colorWithRed:242.0f/255.0f green:204.0f/255.0f blue:155.0f/255.0f alpha:1.0f];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    
    self.view.backgroundColor = [UIColor colorWithRed:242.0f/255.0f green:204.0f/255.0f blue:155.0f/255.0f alpha:1.0f];
    
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
    // if annotation is the user location, return nil to get default blue-dot...
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // create pin view for all other annotations...
    static NSString *reuseId = @"coffee";
    
    MyAnnotationView *pinView = (MyAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseId];

    if (!pinView) {
        // set pin view to coffee1.png
        pinView = [[MyAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:reuseId];
    }
    else
    {
        // if re-using view from another annotation, point view to current annotation...
        pinView.annotation = annotation;
    }
    
    return pinView;
}

@end
