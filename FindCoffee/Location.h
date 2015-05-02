//
//  Location.h
//  FindCoffee
//
/*
    This class is the Location data model and provides
    the mapping
 */
//
//  Created by Amy Wold on 4/25/15.
//  Copyright (c) 2015 Amy Wold. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Location : NSObject

@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *crossStreet;
@property (nonatomic, strong) NSString *postalCode;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSNumber *distance;
@property (nonatomic, strong) NSNumber *lat;
@property (nonatomic, strong) NSNumber *lng;

@end
