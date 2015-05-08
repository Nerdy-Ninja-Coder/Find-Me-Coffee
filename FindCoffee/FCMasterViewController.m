//
//  FCMasterViewController.m
//  FindCoffee
//
//  Created by Amy Wold on 4/24/15.
//  Copyright (c) 2015 Amy Wold. All rights reserved.
//

#import "FCMasterViewController.h"
#import "FCDetailViewController.h"
#import "Venue.h"
#import "Location.h"
#import <Mapkit/Mapkit.h>
#import <RestKit/RestKit.h>

#define kCLIENTID @"GX3SPTTUI44ACJXYJLPATFAKFDDDUXIJ00EJD22CDPPRERDA"
#define kCLIENTSECRET @"PUNMSQ1BKQHKDDVT3NKA2XZ2DIBGETK3IRUQPX0MIM0SD2LX"

@interface FCMasterViewController () <CLLocationManagerDelegate, MKMapViewDelegate>
{
    CLLocation *userCurrentLocation;
}

@property (nonatomic, strong) NSArray *venues;
@property (nonatomic, strong) FCDetailViewController *detailViewController;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation FCMasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUp];
    
    // set colors
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:141.0f/255.0f green:84.0f/255.0f blue:33.0f/255.0f alpha:1.0f];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:242.0f/255.0f green:204.0f/255.0f blue:155.0f/255.0f alpha:1.0f]}];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:242.0f/255.0f green:204.0f/255.0f blue:155.0f/255.0f alpha:0.7f] } forState:UIControlStateNormal];
    self.navigationController.navigationBar.translucent = NO;
/*
    changed the back arrow chevron tint color in the app
    delegate
 */

}

-(void)currentLocationIdentifier {
    _locationManager = [[CLLocationManager alloc]init];
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.delegate = self;
    if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined ) {
            // We never ask for authorization. Let's request it.
            [_locationManager requestWhenInUseAuthorization];
        } else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse ||
                   [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways) {
            // We have authorization. Let's update location.
            [_locationManager startUpdatingLocation];
        } else {
            // If we are here we have no pormissions.
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No athorization"
                                                                message:@"Please, enable access to your location"
                                                               delegate:self
                                                      cancelButtonTitle:@"Cancel"
                                                      otherButtonTitles:nil, nil];
            [alertView show];
        }
    } else {
        // This is iOS 7 case.
        [_locationManager startUpdatingLocation];
    }
}

-(void) setUp {
    [self currentLocationIdentifier];
}

- (void)configureRestKit {
    // initialize AFNetworking HTTPClient
    NSURL *baseURL = [NSURL URLWithString:@"https://api.foursquare.com"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    // initialize RestKit
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    // setup object mappings
    RKObjectMapping *venueMapping = [RKObjectMapping mappingForClass:[Venue class]];
    [venueMapping addAttributeMappingsFromArray:@[@"name"]];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:venueMapping
                            method:RKRequestMethodGET
                            pathPattern:@"/v2/venues/search"
                            keyPath:@"response.venues"
                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    // define location object mapping
    RKObjectMapping *locationMapping = [RKObjectMapping mappingForClass:[Location class]];
    [locationMapping addAttributeMappingsFromArray:@[@"address", @"city", @"country", @"crossStreet", @"postalCode", @"state", @"distance", @"lat", @"lng"]];
    
    // define relationship mapping
    [venueMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"location" toKeyPath:@"location" withMapping:locationMapping]];
    
    
    [objectManager addResponseDescriptor:responseDescriptor];
}

- (void)loadVenues {
    // gets the user location for use in search
    NSString *latlng = [NSString stringWithFormat:@"%f,%f", userCurrentLocation.coordinate.latitude, userCurrentLocation.coordinate.longitude];
    NSString *clientID = kCLIENTID;
    NSString *clientSecret = kCLIENTSECRET;
    
    NSDictionary *queryParams = @{@"ll" : latlng,
                                  @"client_id" : clientID,
                                  @"client_secret" : clientSecret,
                                  @"categoryId" : @"4bf58dd8d48988d1e0931735",
                                  @"v" : @"20140118",
                                  @"limit" : @"20",
                                  @"radius" : @"8050" };
    
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/v2/venues/search"
        parameters:queryParams
        success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                _venues = mappingResult.array;
                [self.tableView reloadData];
            }
        failure:^(RKObjectRequestOperation *operation, NSError *error) {
                NSLog(@"What do you mean by 'there is no coffee?': %@", error);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        FCDetailViewController *detailView = (FCDetailViewController *)segue.destinationViewController;
        
        Venue *venue = _venues[indexPath.row];
        NSString *venueString = [NSString stringWithFormat:@"%@\n%@\n%@, %@",venue.name, venue.location.address, venue.location.city, venue.location.state];
        
        // set the FCDetail items to the venue info
        detailView.detailItem = venueString;
        detailView.detailLat = venue.location.lat;
        detailView.detailLong = venue.location.lng;
        
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _venues.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    Venue *venue = _venues[indexPath.row];
    cell.textLabel.text = venue.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.0f meters", venue.location.distance.floatValue];
    
    cell.textLabel.textColor = [UIColor colorWithRed:90.0f/255.0f green:55.0/255.0f blue:22.0f/255.0f alpha:1.0f];
    cell.detailTextLabel.textColor = [UIColor colorWithRed:90.0f/255.0f green:55.0/255.0f blue:22.0f/255.0f alpha:0.7f];
    
    return cell;
}

#pragma mark - Location delegate

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"There was an error retrieving your location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [errorAlert show];
    NSLog(@"Error: %@",error.description);
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    userCurrentLocation = [locations objectAtIndex:0];
//    [_locationManager stopUpdatingLocation];
    self->userCurrentLocation = [[CLLocation alloc]initWithLatitude:userCurrentLocation.coordinate.latitude longitude:userCurrentLocation.coordinate.longitude];
    
    [self configureRestKit];
    [self loadVenues];
}

@end
